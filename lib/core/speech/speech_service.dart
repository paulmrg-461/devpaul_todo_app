import 'dart:async';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

enum SttStatus { idle, listening, error, unavailable }

extension SttStatusExtension on SttStatus {
  bool get isActive => this == SttStatus.listening;

  String get label {
    switch (this) {
      case SttStatus.listening:
        return 'Listening...';
      case SttStatus.error:
        return 'Error';
      case SttStatus.unavailable:
        return 'Not available';
      case SttStatus.idle:
        return '';
    }
  }
}

class SpeechService {
  final stt.SpeechToText _speech = stt.SpeechToText();

  bool _initialized = false;
  bool _isListening = false;
  bool _isAvailable = false;
  Timer? _timeoutTimer;
  final StreamController<SttStatus> _statusController =
      StreamController<SttStatus>.broadcast();

  Stream<SttStatus> get statusStream => _statusController.stream;
  bool get isListening => _isListening;
  bool get isAvailable => _isAvailable;

  Future<bool> initialize() async {
    if (_initialized) return _isAvailable;

    try {
      _initialized = await _speech.initialize(
        onError: (error) {
          _statusController.add(SttStatus.error);
        },
        onStatus: (status) {
          if (status == 'done' || status == 'notListening') {
            _cancelTimer();
            _isListening = false;
            _statusController.add(SttStatus.idle);
          }
        },
      );
      _isAvailable = _initialized;
    } catch (_) {
      _initialized = true;
      _isAvailable = false;
    }

    if (!_isAvailable) {
      _statusController.add(SttStatus.unavailable);
    }

    return _isAvailable;
  }

  Future<bool> requestPermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  Future<bool> hasPermission() async {
    final status = await Permission.microphone.status;
    if (status.isDenied || status.isRestricted) {
      return false;
    }
    if (status.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }
    return status.isGranted;
  }

  Future<bool> startListening({required void Function(String) onResult}) async {
    if (_isListening) return false;

    if (!_initialized) {
      await initialize();
    }

    if (!_isAvailable) {
      _statusController.add(SttStatus.unavailable);
      return false;
    }

    final hasMic = await hasPermission();
    if (!hasMic) {
      final granted = await requestPermission();
      if (!granted) {
        _statusController.add(SttStatus.error);
        return false;
      }
    }

    _isListening = true;
    _statusController.add(SttStatus.listening);
    _startTimeout(() {
      if (_isListening) {
        _isListening = false;
        _speech.stop();
        _statusController.add(SttStatus.error);
      }
    });

    try {
      final localeId = await _preferredLocale();

      await _speech.listen(
        onResult: (result) {
          final text = result.recognizedWords;
          if (result.finalResult) {
            _cancelTimer();
            _isListening = false;
            _statusController.add(SttStatus.idle);
            onResult(text);
          }
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 2),
        localeId: localeId,
        listenOptions: stt.SpeechListenOptions(
          partialResults: false,
          cancelOnError: true,
        ),
      );
      return true;
    } catch (e) {
      _cancelTimer();
      _isListening = false;
      _statusController.add(SttStatus.error);
      return false;
    }
  }

  Future<void> stopListening() async {
    _cancelTimer();
    if (!_isListening) return;
    _isListening = false;
    await _speech.stop();
    _statusController.add(SttStatus.idle);
  }

  void dispose() {
    _cancelTimer();
    _speech.cancel();
    _statusController.close();
  }

  void _startTimeout(void Function() onTimeout) {
    _cancelTimer();
    _timeoutTimer = Timer(const Duration(seconds: 35), onTimeout);
  }

  void _cancelTimer() {
    _timeoutTimer?.cancel();
    _timeoutTimer = null;
  }

  Future<String> _preferredLocale() async {
    try {
      final locales = await _speech.locales();
      if (locales.isEmpty) return 'en_US';

      for (final locale in locales) {
        if (locale.localeId.startsWith('es_')) return locale.localeId;
      }
      return locales.first.localeId;
    } catch (_) {
      return 'en_US';
    }
  }
}
