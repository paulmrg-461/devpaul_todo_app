import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:devpaul_todo_app/domain/entities/task_entity.dart';

class NotificationService {
  final FirebaseMessaging _fcm;
  final FlutterLocalNotificationsPlugin _localNotifications;

  static const _dailyChannelId = 'daily_pending_tasks';
  static const _dailyChannelName = 'Tareas pendientes diarias';
  static const _urgentChannelId = 'urgent_due_soon';
  static const _urgentChannelName = 'Tareas por vencer';
  static const _fcmChannelId = 'fcm_general';
  static const _fcmChannelName = 'Notificaciones generales';

  String? _fcmToken;

  String? get fcmToken => _fcmToken;

  NotificationService({
    required FirebaseMessaging fcm,
    required FlutterLocalNotificationsPlugin localNotifications,
  })  : _fcm = fcm,
        _localNotifications = localNotifications;

  Future<void> initialize() async {
    await _initLocalNotifications();
    await _initFirebaseMessaging();
  }

  Future<void> _initLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/launcher_icon');
    final iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _localNotifications.initialize(
      InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    if (Platform.isAndroid) {
      await _createAndroidChannels();
    }
  }

  Future<void> _createAndroidChannels() async {
    final androidPlugin =
        _localNotifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin == null) return;

    await androidPlugin.createNotificationChannel(
      AndroidNotificationChannel(
        _dailyChannelId,
        _dailyChannelName,
        description: 'Resumen diario de tareas pendientes a las 7am',
        importance: Importance.high,
      ),
    );

    await androidPlugin.createNotificationChannel(
      AndroidNotificationChannel(
        _urgentChannelId,
        _urgentChannelName,
        description: 'Aviso cuando una tarea está a 1 hora de vencer',
        importance: Importance.max,
      ),
    );

    await androidPlugin.createNotificationChannel(
      AndroidNotificationChannel(
        _fcmChannelId,
        _fcmChannelName,
        description: 'Notificaciones generales recibidas por Firebase',
        importance: Importance.high,
      ),
    );
  }

  Future<void> _initFirebaseMessaging() async {
    if (!kIsWeb) {
      final settings = await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        _fcmToken = await _fcm.getToken();
        debugPrint('[FCM] Token: $_fcmToken');
      }
    }

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onNotificationTapFromFcm);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    final initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      _onNotificationTapFromFcm(initialMessage);
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    _localNotifications.show(
      message.messageId?.hashCode ?? DateTime.now().millisecondsSinceEpoch ~/ 1000,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _fcmChannelId,
          _fcmChannelName,
          icon: '@mipmap/launcher_icon',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(presentSound: true),
      ),
    );
  }

  void _onNotificationTap(NotificationResponse response) {
    debugPrint('[Notifications] Tap on notification: ${response.payload}');
  }

  void _onNotificationTapFromFcm(RemoteMessage message) {
    debugPrint('[FCM] Notification opened: ${message.messageId}');
  }

  Future<void> showDailyPendingTasks(List<Task> tasks) async {
    if (tasks.isEmpty) return;

    final highPriority = tasks.where((t) => t.priority == TaskPriority.high).length;
    final mediumPriority = tasks.where((t) => t.priority == TaskPriority.medium).length;
    final lowPriority = tasks.where((t) => t.priority == TaskPriority.low).length;

    final parts = <String>[];
    if (highPriority > 0) parts.add('$highPriority urgentes');
    if (mediumPriority > 0) parts.add('$mediumPriority medias');
    if (lowPriority > 0) parts.add('$lowPriority bajas');

    await _localNotifications.show(
      1000,
      'Tienes ${tasks.length} tareas pendientes',
      'Prioridad: ${parts.join(", ")}. ¡A organizar tu día!',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _dailyChannelId,
          _dailyChannelName,
          channelDescription: 'Resumen diario de tareas pendientes',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/launcher_icon',
        ),
        iOS: DarwinNotificationDetails(presentSound: true, presentBadge: true),
      ),
      payload: 'daily_summary',
    );
  }

  Future<void> showTaskDueSoon(Task task) async {
    final minutesLeft = task.dueDate.difference(DateTime.now()).inMinutes;
    final message = minutesLeft <= 0
        ? '¡Esta tarea ya venció!'
        : 'Faltan $minutesLeft minutos para el vencimiento';

    await _localNotifications.show(
      task.id.hashCode,
      '⏰ ${task.name}',
      message,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _urgentChannelId,
          _urgentChannelName,
          channelDescription: 'Aviso de tarea por vencer',
          importance: Importance.max,
          priority: Priority.max,
          icon: '@mipmap/launcher_icon',
        ),
        iOS: const DarwinNotificationDetails(
          presentSound: true,
          presentBadge: true,
        ),
      ),
      payload: 'task:${task.id}',
    );
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('[FCM Background] Message received: ${message.messageId}');
}
