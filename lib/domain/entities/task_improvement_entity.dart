import 'package:equatable/equatable.dart';

class TaskImprovement extends Equatable {
  final String name;
  final String description;

  const TaskImprovement({
    required this.name,
    required this.description,
  });

  @override
  List<Object?> get props => [name, description];
}
