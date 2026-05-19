import 'dart:async';

import 'package:devpaul_todo_app/config/themes/custom_theme.dart';
import 'package:devpaul_todo_app/config/themes/design_tokens.dart';
import 'package:devpaul_todo_app/core/service_locator.dart';
import 'package:devpaul_todo_app/core/speech/speech_service.dart';
import 'package:devpaul_todo_app/domain/entities/project_entity.dart';
import 'package:devpaul_todo_app/domain/entities/task_entity.dart';
import 'package:devpaul_todo_app/presentation/blocs/ai_suggestion_bloc/ai_suggestion_bloc.dart';
import 'package:devpaul_todo_app/presentation/blocs/project_bloc/project_bloc.dart';
import 'package:devpaul_todo_app/presentation/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:devpaul_todo_app/core/validators/input_validators.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskFormDialog extends StatefulWidget {
  final Task? task;
  final String? initialProjectId;
  final Function(Task) onSave;

  const TaskFormDialog({
    super.key,
    this.task,
    this.initialProjectId,
    required this.onSave,
  });

  @override
  State<TaskFormDialog> createState() => _TaskFormDialogState();
}

class _TaskFormDialogState extends State<TaskFormDialog>
    with TickerProviderStateMixin {
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

  final SpeechService _speechService = sl<SpeechService>();
  bool _isSttListening = false;
  String _sttError = '';
  bool _sttAvailable = true;
  StreamSubscription<SttStatus>? _sttSubscription;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

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
            : DateTime.now().toLocal().toString().split(' ')[0]);
    _dueDateController = TextEditingController(
        text: widget.task != null
            ? widget.task!.dueDate.toLocal().toString().split(' ')[0]
            : DateTime.now()
                .add(const Duration(days: 1))
                .toLocal()
                .toString()
                .split(' ')[0]);
    _selectedPriority = widget.task?.priority ?? TaskPriority.medium;
    _selectedType = widget.task?.type ?? TaskType.work;
    _selectedStatus = widget.task?.status ?? TaskStatus.pending;
    _selectedProjectId = widget.task?.projectId ?? widget.initialProjectId;
    _startDate = widget.task?.startDate ?? DateTime.now();
    _dueDate =
        widget.task?.dueDate ?? DateTime.now().add(const Duration(days: 1));

    _nameController.addListener(_onTextChanged);
    _descriptionController.addListener(_onTextChanged);

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _sttSubscription = _speechService.statusStream.listen((status) {
      if (!mounted) return;
      switch (status) {
        case SttStatus.idle:
          setState(() {
            _isSttListening = false;
            _sttError = '';
          });
          break;
        case SttStatus.listening:
          setState(() {
            _isSttListening = true;
            _sttError = '';
          });
          break;
        case SttStatus.error:
          setState(() {
            _isSttListening = false;
            _sttError = 'Speech recognition error. Check microphone permissions.';
          });
          break;
        case SttStatus.unavailable:
          setState(() {
            _isSttListening = false;
            _sttAvailable = false;
          });
          break;
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ProjectBloc>().add(const GetProjectsEvent());
        _speechService.initialize();
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

  Future<void> _startDictation() async {
    if (!_speechService.isAvailable) {
      setState(() => _sttAvailable = false);
      return;
    }

    setState(() {
      _isSttListening = true;
      _sttError = '';
    });

    try {
      final ok = await _speechService.startListening(
        onResult: (text) {
          if (!mounted) return;
          if (text.isNotEmpty) {
            final current = _descriptionController.text;
            final separator = current.isEmpty ? '' : ' ';
            _descriptionController.text = '$current$separator$text';
            _descriptionController.selection = TextSelection.fromPosition(
              TextPosition(offset: _descriptionController.text.length),
            );
          }
        },
      );

      if (!ok && mounted) {
        setState(() => _isSttListening = false);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSttListening = false;
        _sttError = 'Speech recognition failed';
      });
    }
  }

  void _stopDictation() {
    _speechService.stopListening();
    setState(() => _isSttListening = false);
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
                  _buildActionButtons(context),
                  _buildProjectSelector(context),
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
                  const Divider(),
                  const SizedBox(height: AppSpacing.sm),
                  CustomDropdownType(
                    labelText: 'Type',
                    types: TaskType.values,
                    value: _selectedType,
                    icon: Icons.category,
                    onChanged: (value) {
                      setState(() => _selectedType = value!);
                    },
                    width: 394,
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

  Widget _buildActionButtons(BuildContext context) {
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    final hasAiContent = name.length + description.length >= 10;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          _buildSttButton(context),
          const Spacer(),
          if (_isImprovingDescription)
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else if (hasAiContent)
            TextButton.icon(
              onPressed: () {
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
        ],
      ),
    );
  }

  Widget _buildSttButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (!_sttAvailable) {
      return Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.mic_off, size: 16, color: colorScheme.onSurfaceVariant),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                'Speech not available on this device',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

    if (_sttError.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.mic_off, size: 16, color: colorScheme.error),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                _sttError,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: colorScheme.error,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

    if (_isSttListening) {
      return AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return TextButton.icon(
            onPressed: _stopDictation,
            icon: Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.priorityHigh.withAlpha(40),
                ),
                child: const Icon(Icons.mic, size: 16, color: AppColors.priorityHigh),
              ),
            ),
            label: const Text('Listening...',
                style: TextStyle(color: AppColors.priorityHigh)),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.priorityHigh,
              textStyle: Theme.of(context).textTheme.labelSmall,
            ),
          );
        },
      );
    }

    return TextButton.icon(
      onPressed: _startDictation,
      icon: const Icon(Icons.mic_outlined, size: 16),
      label: const Text('Dictate'),
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.onSurfaceVariant,
        textStyle: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }

  Widget _buildProjectSelector(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final effectiveBorderColor = colorScheme.primary.withValues(alpha: 0.4);

    return BlocBuilder<ProjectBloc, ProjectState>(
      builder: (context, state) {
        if (state is ProjectLoaded) {
          return StreamBuilder<List<Project>>(
            stream: state.projects,
            builder: (context, snapshot) {
              final projects = snapshot.data ?? [];
              return Container(
                width: 400,
                margin: const EdgeInsets.only(
                  left: 4,
                  top: 4,
                  right: 4,
                  bottom: 12,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: effectiveBorderColor, width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: DropdownButtonFormField<String?>(
                  initialValue: _selectedProjectId,
                  decoration: InputDecoration(
                    isCollapsed: true,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 12,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: effectiveBorderColor.withValues(alpha: 0.8),
                        width: 0.6,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: effectiveBorderColor.withValues(alpha: 0.4),
                        width: 0.2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: effectiveBorderColor.withValues(alpha: 0.4),
                        width: 0.2,
                      ),
                    ),
                    labelText: 'Project (optional)',
                    labelStyle: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.85),
                    ),
                    floatingLabelStyle: TextStyle(color: effectiveBorderColor),
                    hintStyle: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                    counterText: '',
                    fillColor: colorScheme.surface,
                    filled: true,
                  ),
                  items: [
                    DropdownMenuItem<String?>(
                      value: null,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Icon(
                              Icons.folder_outlined,
                              color: colorScheme.primary,
                              size: 20,
                            ),
                          ),
                          Text('No project',
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurface,
                                fontSize: 12,
                              )),
                        ],
                      ),
                    ),
                    ...projects.map((p) => DropdownMenuItem<String?>(
                          value: p.id,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Icon(
                                  Icons.folder_outlined,
                                  color: colorScheme.primary,
                                  size: 20,
                                ),
                              ),
                              Expanded(
                                child: Text(p.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onSurface,
                                      fontSize: 12,
                                    )),
                              ),
                            ],
                          ),
                        )),
                  ],
                  onChanged: (val) => setState(() => _selectedProjectId = val),
                  isExpanded: true,
                ),
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
    _pulseController.dispose();
    _sttSubscription?.cancel();
    super.dispose();
  }
}
