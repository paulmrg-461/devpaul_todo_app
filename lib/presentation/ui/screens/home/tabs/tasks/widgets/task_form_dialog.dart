import 'package:devpaul_todo_app/config/themes/design_tokens.dart';
import 'package:devpaul_todo_app/domain/entities/project_entity.dart';
import 'package:devpaul_todo_app/domain/entities/task_entity.dart';
import 'package:devpaul_todo_app/presentation/blocs/ai_suggestion_bloc/ai_suggestion_bloc.dart';
import 'package:devpaul_todo_app/presentation/blocs/project_bloc/project_bloc.dart';
import 'package:devpaul_todo_app/presentation/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:devpaul_todo_app/core/validators/input_validators.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:devpaul_todo_app/presentation/blocs/task_bloc/task_bloc.dart';

class TaskFormDialog extends StatefulWidget {
  final Task? task;
  final Function(Task) onSave;

  const TaskFormDialog({super.key, this.task, required this.onSave});

  @override
  State<TaskFormDialog> createState() => _TaskFormDialogState();
}

class _TaskFormDialogState extends State<TaskFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _startDateController;
  late TextEditingController _dueDateController;

  TaskPriority _selectedPriority = TaskPriority.medium;
  TaskType _selectedType = TaskType.work;
  TaskStatus _selectedStatus = TaskStatus.pending;
  String? _selectedProjectId;

  DateTime? _startDate;
  DateTime? _dueDate;
  bool _isImprovingDescription = false;

  bool get isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.task?.name ?? '');
    _descriptionController =
        TextEditingController(text: widget.task?.description ?? '');
    _startDateController = TextEditingController(
        text: widget.task != null
            ? widget.task!.startDate.toLocal().toString().split(' ')[0]
            : '');
    _dueDateController = TextEditingController(
        text: widget.task != null
            ? widget.task!.dueDate.toLocal().toString().split(' ')[0]
            : '');
    _selectedPriority = widget.task?.priority ?? TaskPriority.medium;
    _selectedType = widget.task?.type ?? TaskType.work;
    _selectedStatus = widget.task?.status ?? TaskStatus.pending;
    _selectedProjectId = widget.task?.projectId;
    _startDate = widget.task?.startDate;
    _dueDate = widget.task?.dueDate;

    _nameController.addListener(_onTextChanged);
    _descriptionController.addListener(_onTextChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ProjectBloc>().add(const GetProjectsEvent());
      }
    });
  }

  void _onTextChanged() {
    setState(() {});
  }

  void _saveForm() {
    if (!_formKey.currentState!.validate()) return;
    if (_startDate == null || _dueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select start and due dates'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final task = Task(
      id: widget.task?.id ?? '',
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      priority: _selectedPriority,
      type: _selectedType,
      startDate: _startDate!,
      dueDate: _dueDate!,
      status: _selectedStatus,
      projectId: _selectedProjectId,
    );

    widget.onSave(task);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      title: Text(isEditing ? 'Edit task' : 'New task',
          style: textTheme.titleLarge),
      content: BlocListener<AiSuggestionBloc, AiSuggestionState>(
        listener: (context, state) {
          if (state is AiSuggestionLoaded) {
            _descriptionController.text = state.suggestion.suggestion;
            _descriptionController.selection = TextSelection.fromPosition(
              TextPosition(offset: _descriptionController.text.length),
            );
            setState(() => _isImprovingDescription = false);
          }
          if (state is TaskImprovementLoaded) {
            _nameController.text = state.improvement.name;
            _nameController.selection = TextSelection.fromPosition(
              TextPosition(offset: _nameController.text.length),
            );
            _descriptionController.text = state.improvement.description;
            _descriptionController.selection = TextSelection.fromPosition(
              TextPosition(offset: _descriptionController.text.length),
            );
            setState(() => _isImprovingDescription = false);
          }
          if (state is AiSuggestionError) {
            setState(() => _isImprovingDescription = false);
          }
        },
        child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomInput(
                  width: 400,
                  hintText: "Task name",
                  icon: Icons.task,
                  controller: _nameController,
                  validator: (value) => InputValidator.emptyValidator(
                      value: value, minCharacters: 3),
                ),
                CustomInput(
                  width: 400,
                  hintText: "Description",
                  icon: Icons.description,
                  controller: _descriptionController,
                  minLines: 3,
                  maxLines: 5,
                  validator: (value) => InputValidator.emptyValidator(
                      value: value, minCharacters: 3),
                ),
                _buildAiImproveButton(context),
                const Divider(),
                _buildProjectSelector(context),
                const SizedBox(height: AppSpacing.md),
                CustomDropdownPriority(
                  labelText: 'Priority',
                  priorities: TaskPriority.values,
                  value: _selectedPriority,
                  width: 400,
                  icon: Icons.priority_high_rounded,
                  onChanged: (priority) {
                    setState(() => _selectedPriority = priority!);
                  },
                ),
                CustomDropdownType(
                  labelText: 'Type',
                  types: TaskType.values,
                  value: _selectedType,
                  icon: Icons.category,
                  onChanged: (value) {
                    setState(() => _selectedType = value!);
                  },
                  width: 400,
                ),
                const Divider(),
                CustomDateTimePicker(
                  hintText: 'Start date',
                  initialDateTime: _startDate,
                  width: 400,
                  icon: Icons.calendar_today,
                  onDateTimeChanged: (date) {
                    setState(() => _startDate = date);
                  },
                ),
                CustomDateTimePicker(
                  hintText: 'Due date',
                  initialDateTime: _dueDate,
                  width: 400,
                  icon: Icons.event,
                  onDateTimeChanged: (date) {
                    setState(() => _dueDate = date);
                  },
                ),
                if (isEditing)
                  CustomDropdownStatus(
                    labelText: 'Status',
                    statuses: TaskStatus.values,
                    value: _selectedStatus,
                    width: 400,
                    icon: Icons.check_circle_outline,
                    onChanged: (status) {
                      setState(() => _selectedStatus = status!);
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: _saveForm,
          icon: const Icon(Icons.save, size: 18),
          label: Text(isEditing ? 'Save' : 'Create'),
        ),
      ],
    );
  }

  Widget _buildAiImproveButton(BuildContext context) {
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    if (name.isEmpty && description.isEmpty) return const SizedBox.shrink();

    final hasMinContent = name.length + description.length >= 10;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Align(
        alignment: Alignment.centerRight,
        child: _isImprovingDescription
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : TextButton.icon(
                onPressed: () {
                  if (!hasMinContent) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Escribe al menos 10 caracteres entre nombre y descripción para mejorar con IA'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    return;
                  }
                  setState(() => _isImprovingDescription = true);
                  context
                      .read<AiSuggestionBloc>()
                      .add(ImproveTaskEvent(name, description));
                },
                icon: const Icon(Icons.auto_awesome, size: 16),
                label: const Text('Mejorar con IA'),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  textStyle: Theme.of(context).textTheme.labelSmall,
                ),
              ),
      ),
    );
  }

  Widget _buildProjectSelector(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<ProjectBloc, ProjectState>(
      builder: (context, state) {
        if (state is ProjectLoaded) {
          return StreamBuilder<List<Project>>(
            stream: state.projects,
            builder: (context, snapshot) {
              final projects = snapshot.data ?? [];
              return DropdownButtonFormField<String?>(
                value: _selectedProjectId,
                decoration: InputDecoration(
                  labelText: 'Project (optional)',
                  prefixIcon:
                      const Icon(Icons.folder_outlined, size: 20),
                  contentPadding: AppSpacing.inputPadding,
                ),
                style: textTheme.bodyLarge,
                items: [
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text('No project'),
                  ),
                  ...projects.map((p) => DropdownMenuItem<String?>(
                        value: p.id,
                        child: Text(p.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      )),
                ],
                onChanged: (val) =>
                    setState(() => _selectedProjectId = val),
                isExpanded: true,
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  @override
  void dispose() {
    _nameController.removeListener(_onTextChanged);
    _descriptionController.removeListener(_onTextChanged);
    _nameController.dispose();
    _descriptionController.dispose();
    _startDateController.dispose();
    _dueDateController.dispose();
    super.dispose();
  }
}
