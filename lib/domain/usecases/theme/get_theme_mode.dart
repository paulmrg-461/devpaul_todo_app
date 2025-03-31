import 'package:devpaul_todo_app/domain/repositories/theme_repository.dart';

class GetThemeModeUseCase {
  final ThemeRepository repository;

  GetThemeModeUseCase(this.repository);

  Future<bool> call() => repository.getThemeMode();
}

// domain/usecases/save_theme_mode.dart
class SaveThemeModeUseCase {
  final ThemeRepository repository;

  SaveThemeModeUseCase(this.repository);

  Future<void> call(bool isDarkMode) => repository.saveThemeMode(isDarkMode);
}
