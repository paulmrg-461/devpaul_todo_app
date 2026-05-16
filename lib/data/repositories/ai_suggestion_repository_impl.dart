import 'dart:convert';
import 'package:devpaul_todo_app/domain/entities/ai_suggestion_entity.dart';
import 'package:devpaul_todo_app/domain/entities/task_entity.dart';
import 'package:devpaul_todo_app/domain/entities/task_improvement_entity.dart';
import 'package:devpaul_todo_app/domain/repositories/ai_suggestion_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AiSuggestionRepositoryImpl implements AiSuggestionRepository {
  static const _deepseekApiUrl = String.fromEnvironment(
    'DEEPSEEK_API_URL',
    defaultValue: '',
  );
  static const _deepseekApiKey = String.fromEnvironment(
    'DEEPSEEK_API_KEY',
    defaultValue: '',
  );
  static const _backendApiUrl = 'http://localhost:3000';

  String get _apiUrl {
    try {
      final envUrl = dotenv.env['DEEPSEEK_API_URL'];
      if (envUrl != null && envUrl.isNotEmpty) return envUrl;
    } catch (_) {}
    return _deepseekApiUrl.isNotEmpty ? _deepseekApiUrl : _backendApiUrl;
  }

  String get _apiKey {
    try {
      final envKey = dotenv.env['DEEPSEEK_API_KEY'];
      if (envKey != null && envKey.isNotEmpty) return envKey;
    } catch (_) {}
    return _deepseekApiKey;
  }

  bool get _isProxy => _apiUrl == _backendApiUrl || _apiKey.isEmpty;

  @override
  Future<AiSuggestion> getTaskSuggestion(Task task, {String? technology}) async {
    final techContext = technology != null && technology.isNotEmpty
        ? '\nTecnología del proyecto: $technology. Proporciona sugerencias específicas para este stack tecnológico.'
        : '';

    return _callAi(
      systemPrompt: 'Eres un asistente experto en gestión de tareas y desarrollo de software. Proporcionas sugerencias prácticas y específicas adaptadas a la tecnología del proyecto. Tus respuestas deben ser: 1. Prácticas y específicas 2. En español con acentos y caracteres especiales correctos 3. Numeradas y bien estructuradas 4. Concisas y directas 5. Con ejemplos de código si aplica al stack tecnológico',
      userPrompt: 'Tarea: ${task.name}\nDescripción: ${task.description}\nPrioridad: ${task.priority}\nTipo: ${task.type}\nFecha límite: ${task.dueDate}$techContext\n\nPor favor, proporciona 3 sugerencias prácticas y específicas para resolver esta tarea. Si hay una tecnología especificada, da ejemplos de código o herramientas específicas de ese stack. Asegúrate de que las sugerencias estén numeradas y sean fáciles de entender y en formato MarkDown.',
      maxTokens: 2500,
    );
  }

  @override
  Future<AiSuggestion> improveDescription(String description) async {
    return _callAi(
      systemPrompt: 'Eres un asistente experto en redacción que mejora descripciones de tareas en español. Tus respuestas deben ser: 1. Solo la descripción mejorada, sin prefacios ni explicaciones 2. Clara, detallada y accionable 3. En español con acentos y caracteres especiales correctos 4. Máximo 3-4 líneas',
      userPrompt: 'Mejora la siguiente descripción de tarea para que sea más clara, detallada y accionable. Responde ÚNICAMENTE con la descripción mejorada, sin texto adicional:\n\n$description',
      maxTokens: 600,
      temperature: 0.5,
    );
  }

  @override
  Future<TaskImprovement> improveTask(String name, String description) async {
    final response = await _callTaskImprovement(
      systemPrompt: 'Eres un asistente experto en gestión de tareas y redacción en español. Corriges ortografía, gramática y expandes textos para hacerlos más detallados y accionables. IMPORTANTE: Siempre respondes ÚNICAMENTE con un objeto JSON válido con la estructura {"name": "nombre mejorado", "description": "descripción mejorada"}. No incluyas texto antes ni después del JSON. No uses markdown ni comillas triples. Solo el JSON puro.',
      userPrompt: 'Analiza la siguiente tarea y mejórala:\n\nNombre: $name\nDescripción: $description\n\nInstrucciones:\n1. Corrige la ortografía y gramática del nombre y la descripción.\n2. Mejora el nombre para que sea más descriptivo y específico (máximo 100 caracteres).\n3. Expande la descripción para que sea más larga, detallada y mejor explicada, añadiendo contexto útil, pasos accionables y criterios de aceptación si aplica.\n4. Responde ÚNICAMENTE con un JSON: {"name": "...", "description": "..."}',
      maxTokens: 1200,
      temperature: 0.5,
    );

    final data = jsonDecode(response) as Map<String, dynamic>;
    return TaskImprovement(
      name: (data['name'] as String).trim(),
      description: (data['description'] as String).trim(),
    );
  }

  Future<String> _callTaskImprovement({
    required String systemPrompt,
    required String userPrompt,
    int maxTokens = 1200,
    double temperature = 0.5,
  }) async {
    final http.Response response;

    if (_isProxy) {
      response = await http.post(
        Uri.parse('$_apiUrl/api/suggestions'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: utf8.encode(jsonEncode({
          'systemPrompt': systemPrompt,
          'userPrompt': userPrompt,
          'temperature': temperature,
          'maxTokens': maxTokens,
        })),
      );
    } else {
      response = await http.post(
        Uri.parse('$_apiUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $_apiKey',
        },
        body: utf8.encode(jsonEncode({
          'model': 'deepseek-chat',
          'messages': [
            {'role': 'system', 'content': systemPrompt},
            {'role': 'user', 'content': userPrompt},
          ],
          'temperature': temperature,
          'max_tokens': maxTokens,
        })),
      );
    }

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      if (_isProxy) {
        return data['suggestion'] as String;
      } else {
        return data['choices'][0]['message']['content'] as String;
      }
    } else {
      throw Exception(
          'Error al mejorar la tarea: ${response.statusCode} - ${utf8.decode(response.bodyBytes)}');
    }
  }

  Future<AiSuggestion> _callAi({
    required String systemPrompt,
    required String userPrompt,
    int maxTokens = 1300,
    double temperature = 0.7,
  }) async {
    try {
      final http.Response response;

      if (_isProxy) {
        response = await http.post(
          Uri.parse('$_apiUrl/api/suggestions'),
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: utf8.encode(jsonEncode({
            'systemPrompt': systemPrompt,
            'userPrompt': userPrompt,
            'temperature': temperature,
            'maxTokens': maxTokens,
          })),
        );
      } else {
        response = await http.post(
          Uri.parse('$_apiUrl/chat/completions'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $_apiKey',
          },
          body: utf8.encode(jsonEncode({
            'model': 'deepseek-chat',
            'messages': [
              {'role': 'system', 'content': systemPrompt},
              {'role': 'user', 'content': userPrompt},
            ],
            'temperature': temperature,
            'max_tokens': maxTokens,
          })),
        );
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));

        final String suggestion;
        if (_isProxy) {
          suggestion = data['suggestion'] as String;
        } else {
          suggestion = data['choices'][0]['message']['content'] as String;
        }

        return AiSuggestion(
          suggestion: suggestion.trim(),
          createdAt: DateTime.now(),
        );
      } else {
        throw Exception(
            'Error al obtener sugerencias: ${response.statusCode} - ${utf8.decode(response.bodyBytes)}');
      }
    } catch (e) {
      throw Exception('Error al conectar con la API: $e');
    }
  }
}
