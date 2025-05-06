import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static final List<String> adminEmails = [
    'co.devpaul@gmail.com',
  ];

  // Use String.fromEnvironment for web compatibility
  static const String deepseekApiUrl = String.fromEnvironment(
    'DEEPSEEK_API_URL',
    defaultValue:
        'https://api.deepseek.com/v1', // Provide a default or handle appropriately
  );
  static const String deepseekApiKey = String.fromEnvironment(
    'DEEPSEEK_API_KEY',
    defaultValue:
        'YOUR_DEFAULT_KEY_IF_ANY', // Provide a default or handle appropriately
  );
}
