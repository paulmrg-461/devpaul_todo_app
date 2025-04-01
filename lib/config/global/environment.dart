import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static final List<String> adminEmails = [
    'co.devpaul@gmail.com',
  ];

  static final String deepseekApiUrl = dotenv.env['DEEPSEEK_API_URL'] ?? '';
  static final String deepseekApiKey = dotenv.env['DEEPSEEK_API_KEY'] ?? '';
}
