abstract class ThemeRepository {
  Future<bool> getThemeMode();
  Future<void> saveThemeMode(bool isDarkMode);
}
