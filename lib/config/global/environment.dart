class Environment {
  static final List<String> adminEmails = [
    'co.devpaul@gmail.com',
  ];

  static const String backendApiUrl = String.fromEnvironment(
    'BACKEND_API_URL',
    defaultValue: 'http://localhost:3000',
  );

  static const String deepseekApiUrl = String.fromEnvironment(
    'DEEPSEEK_API_URL',
    defaultValue: '',
  );
  static const String deepseekApiKey = String.fromEnvironment(
    'DEEPSEEK_API_KEY',
    defaultValue: '',
  );
}
