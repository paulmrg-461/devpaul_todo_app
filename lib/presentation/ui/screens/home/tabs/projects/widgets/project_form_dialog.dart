// lib/presentation/ui/tabs/projects/widgets/project_form_dialog.dart
import 'package:devpaul_todo_app/domain/entities/project_entity.dart';
import 'package:devpaul_todo_app/data/models/project_model.dart';
import 'package:devpaul_todo_app/domain/entities/task_entity.dart';
import 'package:devpaul_todo_app/presentation/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:devpaul_todo_app/core/validators/input_validators.dart';

class ProjectFormDialog extends StatefulWidget {
  final Project? project; // Changed to Project
  final Function(Project) onSave; // Changed to Project

  const ProjectFormDialog({super.key, this.project, required this.onSave});

  @override
  _ProjectFormDialogState createState() => _ProjectFormDialogState();
}

class _ProjectFormDialogState extends State<ProjectFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  // Removed date controllers as they are not in Project

  TaskStatus _selectedStatus =
      TaskStatus.pending; // Assuming TaskStatus enum exists

  static const double _inputsWidth = 420;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.project?.name ?? '');
    _descriptionController =
        TextEditingController(text: widget.project?.description ?? '');
    _selectedStatus = widget.project?.status ?? TaskStatus.pending;
  }

  void _saveForm() {
    if (!_formKey.currentState!.validate()) return;

    final projectToSave = ProjectModel(
      // Changed to ProjectModel
      id: widget.project?.id ?? '',
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      status: _selectedStatus,
      userIds: widget.project?.userIds ?? [],
      taskIds: widget.project?.taskIds ?? [],
      createdAt: widget.project?.createdAt ?? DateTime.now(),
      // Removed priority, type, startDate, dueDate as they are not in Project/Model
    );

    widget
        .onSave(projectToSave); // Pass the ProjectModel to the onSave callback
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.project == null
          ? 'Nuevo Proyecto'
          : 'Editar Proyecto'), // Changed text
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomInput(
                width: _inputsWidth,
                hintText: "Nombre del proyecto", // Changed text
                icon: Icons.folder_special_outlined, // Changed icon
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
              // Removed priority, type, and date pickers
              if (widget.project != null)
                CustomDropdownStatus(
                  // Assuming a generic CustomDropdownStatus or similar widget exists
                  labelText: 'Estado',
                  statuses: TaskStatus.values,
                  value: _selectedStatus,

                  width: _inputsWidth,
                  icon: Icons.check_circle_outline,
                  onChanged: (status) {
                    setState(() {
                      _selectedStatus = status! as TaskStatus;
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
    super.dispose();
  }
}
