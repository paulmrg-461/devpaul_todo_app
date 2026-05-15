import 'package:shared_preferences/shared_preferences.dart';
import 'package:devpaul_todo_app/domain/repositories/theme_repository.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  final SharedPreferences prefs;

  ThemeRepositoryImpl(this.prefs);

  @override
  Future<bool> getThemeMode() async => prefs.getBool('isDarkMode') ?? false;

  @override
  Future<void> saveThemeMode(bool isDarkMode) async =>
      await prefs.setBool('isDarkMode', isDarkMode);
}
