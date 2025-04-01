// lib/presentation/ui/tabs/tasks/widgets/task_form_dialog.dart
import 'package:devpaul_todo_app/domain/entities/task_entity.dart';
import 'package:devpaul_todo_app/data/models/task_model.dart';
import 'package:devpaul_todo_app/presentation/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:devpaul_todo_app/core/validators/input_validators.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:devpaul_todo_app/presentation/blocs/blocs.dart';

class TaskFormDialog extends StatefulWidget {
  final Task? task;
  final Function(Task) onSave;

  const TaskFormDialog({super.key, this.task, required this.onSave});

  @override
  _TaskFormDialogState createState() => _TaskFormDialogState();
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

  DateTime? _startDate;
  DateTime? _dueDate;

  static const double _inputsWidth = 420;

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
    _startDate = widget.task?.startDate;
    _dueDate = widget.task?.dueDate;
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final initialDate = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: initialDate.subtract(const Duration(days: 365)),
      lastDate: initialDate.add(const Duration(days: 365)),
    );
    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = pickedDate;
          _startDateController.text =
              pickedDate.toLocal().toString().split(' ')[0];
        } else {
          _dueDate = pickedDate;
          _dueDateController.text =
              pickedDate.toLocal().toString().split(' ')[0];
        }
      });
    }
  }

  void _saveForm() {
    if (!_formKey.currentState!.validate()) return;

    if (_startDate == null || _dueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecciona las fechas de inicio y fin'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final task = TaskModel(
      id: widget.task?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      priority: _selectedPriority,
      type: _selectedType,
      startDate: _startDate!,
      dueDate: _dueDate!,
      status: _selectedStatus,
    );

    if (widget.task == null) {
      context.read<TaskBloc>().add(CreateTaskEvent(task));
    } else {
      context.read<TaskBloc>().add(UpdateTaskEvent(task));
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.task == null ? 'Nueva Tarea' : 'Editar Tarea'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomInput(
                width: _inputsWidth,
                hintText: "Nombre de la tarea",
                icon: Icons.task,
                controller: _nameController,
                validator: (value) => InputValidator.emptyValidator(
                    value: value, minCharacters: 3),
              ),
              CustomInput(
                width: _inputsWidth,
                hintText: "Descripción",
                icon: Icons.description,
                controller: _descriptionController,
                minLines: 3,
                maxLines: 5,
                validator: (value) => InputValidator.emptyValidator(
                    value: value, minCharacters: 3),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Divider(),
              ),
              CustomDropdownPriority(
                labelText: 'Prioridad',
                priorities: TaskPriority.values,
                value: _selectedPriority,
                width: _inputsWidth,
                icon: Icons.priority_high_rounded,
                onChanged: (priority) {
                  setState(() {
                    _selectedPriority = priority!;
                  });
                },
              ),
              CustomDropdownType(
                labelText: 'Tipo',
                types: TaskType.values,
                value: _selectedType,
                icon: Icons.category,
                onChanged: (value) {
                  setState(() {
                    _selectedType = value!;
                  });
                },
                width: _inputsWidth,
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: Divider(),
              ),
              CustomDateTimePicker(
                hintText: 'Fecha de inicio',
                initialDateTime: _startDate,
                width: _inputsWidth,
                icon: Icons.calendar_today,
                onDateTimeChanged: (newDateTime) {
                  setState(() {
                    _startDate = newDateTime;
                  });
                },
              ),
              CustomDateTimePicker(
                hintText: 'Fecha de vencimiento',
                initialDateTime: _dueDate,
                width: _inputsWidth,
                icon: Icons.event,
                onDateTimeChanged: (newDateTime) {
                  setState(() {
                    _dueDate = newDateTime;
                  });
                },
              ),
              if (widget.task != null)
                CustomDropdownStatus(
                  labelText: 'Estado',
                  statuses: TaskStatus.values,
                  value: _selectedStatus,
                  width: _inputsWidth,
                  icon: Icons.check_circle_outline,
                  onChanged: (status) {
                    setState(() {
                      _selectedStatus = status!;
                    });
                  },
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton.icon(
          onPressed: _saveForm,
          label: const Text('Guardar'),
          icon: const Icon(Icons.save),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _startDateController.dispose();
    _dueDateController.dispose();
    super.dispose();
  }
}
