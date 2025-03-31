import 'package:bloc/bloc.dart';
import 'package:devpaul_todo_app/domain/usecases/theme/get_theme_mode.dart';
import 'package:equatable/equatable.dart';
part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final GetThemeModeUseCase getThemeModeUseCase;
  final SaveThemeModeUseCase saveThemeModeUseCase;

  ThemeBloc(
      {required this.getThemeModeUseCase, required this.saveThemeModeUseCase})
      : super(const ThemeState(isDarkMode: false)) {
    on<ThemeChanged>(_onThemeChanged);
    _loadSavedTheme();
  }

  void _loadSavedTheme() async {
    final isDarkMode = await getThemeModeUseCase();
    emit(state.copyWith(isDarkMode: isDarkMode));
  }

  void _onThemeChanged(ThemeChanged event, Emitter<ThemeState> emit) async {
    await saveThemeModeUseCase(event.isDarkMode);
    emit(state.copyWith(isDarkMode: event.isDarkMode));
  }
}
