// domain/repositories/theme_repository.dart
import 'package:shared_preferences/shared_preferences.dart';

abstract class ThemeRepository {
  Future<bool> getThemeMode();
  Future<void> saveThemeMode(bool isDarkMode);
}

// data/repositories/theme_repository_impl.dart
class ThemeRepositoryImpl implements ThemeRepository {
  final SharedPreferences prefs;

  ThemeRepositoryImpl(this.prefs);

  @override
  Future<bool> getThemeMode() async => prefs.getBool('isDarkMode') ?? false;

  @override
  Future<void> saveThemeMode(bool isDarkMode) async =>
      await prefs.setBool('isDarkMode', isDarkMode);
}
