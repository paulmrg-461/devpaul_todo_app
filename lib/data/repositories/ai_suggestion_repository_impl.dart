import 'dart:convert';
import 'package:devpaul_todo_app/config/global/environment.dart';
import 'package:devpaul_todo_app/data/models/ai_suggestion_model.dart';
import 'package:devpaul_todo_app/domain/entities/task_entity.dart';
import 'package:devpaul_todo_app/domain/repositories/ai_suggestion_repository.dart';
import 'package:http/http.dart' as http;

class AiSuggestionRepositoryImpl implements AiSuggestionRepository {
  @override
  Future<AiSuggestionModel> getTaskSuggestion(Task task) async {
    try {
      final response = await http.post(
        Uri.parse('${Environment.deepseekApiUrl}/chat/completions'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${Environment.deepseekApiKey}',
        },
        body: utf8.encode(jsonEncode({
          'model': 'deepseek-chat',
          'messages': [
            {
              'role': 'system',
              'content': '''
                Eres un asistente experto en gestión de tareas que proporciona sugerencias en español.
                Tus respuestas deben ser:
                1. Prácticas y específicas
                2. En español con acentos y caracteres especiales correctos
                3. Numeradas y bien estructuradas
                4. Concisas y directas
              ''',
            },
            {
              'role': 'user',
              'content': '''
                Tarea: ${task.name}
                Descripción: ${task.description}
                Prioridad: ${task.priority}
                Tipo: ${task.type}
                Fecha límite: ${task.dueDate}
                
                Por favor, proporciona 3 sugerencias prácticas y específicas para resolver esta tarea.
                Asegúrate de que las sugerencias estén numeradas y sean fáciles de entender y en formato MarkDown.
              ''',
            },
          ],
          'temperature': 0.7,
          'max_tokens': 1300,
        })),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final suggestion = data['choices'][0]['message']['content'];

        return AiSuggestionModel(
          suggestion: suggestion,
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
