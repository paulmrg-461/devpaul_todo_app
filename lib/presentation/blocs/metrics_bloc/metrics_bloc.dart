import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:devpaul_todo_app/domain/entities/task_metrics_entity.dart';
import 'package:devpaul_todo_app/domain/usecases/tasks/calculate_metrics.dart';
import 'package:equatable/equatable.dart';
part 'metrics_event.dart';
part 'metrics_state.dart';

class MetricsBloc extends Bloc<MetricsEvent, MetricsState> {
  final CalculateMetrics calculateMetrics;

  MetricsBloc({required this.calculateMetrics})
      : super(MetricsInitial()) {
    on<LoadMetricsEvent>(_onLoadMetrics);
  }

  Future<void> _onLoadMetrics(
    LoadMetricsEvent event,
    Emitter<MetricsState> emit,
  ) async {
    emit(MetricsLoading());
    try {
      final metrics = await calculateMetrics();
      emit(MetricsLoaded(metrics));
    } catch (e) {
      emit(MetricsError(e.toString()));
    }
  }
}
