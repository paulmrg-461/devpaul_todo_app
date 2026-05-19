part of 'metrics_bloc.dart';

abstract class MetricsEvent extends Equatable {
  const MetricsEvent();

  @override
  List<Object?> get props => [];
}

class LoadMetricsEvent extends MetricsEvent {
  const LoadMetricsEvent();
}
