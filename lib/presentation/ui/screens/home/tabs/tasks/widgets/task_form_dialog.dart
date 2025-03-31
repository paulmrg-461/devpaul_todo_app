// lib/presentation/ui/tabs/tasks/widgets/task_form_dialog.dart
import 'package:devpaul_todo_app/domain/entities/task_entity.dart';
import 'package:devpaul_todo_app/presentation/ui/screens/home/tabs/tasks/widgets/task_card.dart';
import 'package:devpaul_todo_app/presentation/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:devpaul_todo_app/core/validators/input_validators.dart';

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
  bool _isCompleted = false;

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
    _isCompleted = widget.task?.isCompleted ?? false;
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
          const SnackBar(content: Text('Select start and due dates')));
      return;
    }
    final task = Task(
      id: widget.task?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      priority: _selectedPriority,
      type: _selectedType,
      startDate: _startDate!,
      dueDate: _dueDate!,
      isCompleted: _isCompleted,
    );
    widget.onSave(task);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.task == null ? 'New Task' : 'Edit Task'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomInput(
                width: _inputsWidth,
                hintText: "Task Name",
                icon: Icons.task,
                controller: _nameController,
                validator: (value) => InputValidator.emptyValidator(
                    value: value, minCharacters: 3),
              ),
              CustomInput(
                width: _inputsWidth,
                hintText: "Description",
                icon: Icons.description,
                controller: _descriptionController,
                validator: (value) => InputValidator.emptyValidator(
                    value: value, minCharacters: 3),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Divider(),
              ),
              CustomDropdownPriority(
                labelText: 'Priority',
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
                labelText: 'Type',
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
                hintText: 'Initial Date',
                initialDateTime: _startDate, // variable definida en tu State
                width: _inputsWidth,
                icon: Icons.access_time, // opcional, puede ser cualquier icono
                onDateTimeChanged: (newDateTime) {
                  setState(() {
                    _startDate = newDateTime;
                  });
                },
              ),
              CustomDateTimePicker(
                hintText: 'Due Date',
                initialDateTime: _dueDate, // variable definida en tu State
                width: _inputsWidth,
                icon: Icons.access_time, // opcional, puede ser cualquier icono
                onDateTimeChanged: (newDateTime) {
                  setState(() {
                    _dueDate = newDateTime;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Completed'),
                value: _isCompleted,
                onChanged: (value) {
                  setState(() {
                    _isCompleted = value ?? false;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
        FilledButton.icon(
          onPressed: _saveForm,
          label: const Text('Save'),
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
