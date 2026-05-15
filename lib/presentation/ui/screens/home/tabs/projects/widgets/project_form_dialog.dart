import 'package:devpaul_todo_app/config/themes/design_tokens.dart';
import 'package:devpaul_todo_app/domain/entities/group_entity.dart';
import 'package:devpaul_todo_app/domain/entities/project_entity.dart';
import 'package:devpaul_todo_app/domain/entities/task_entity.dart';
import 'package:devpaul_todo_app/presentation/blocs/group_bloc/group_bloc.dart';
import 'package:devpaul_todo_app/presentation/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:devpaul_todo_app/core/validators/input_validators.dart';

class ProjectFormDialog extends StatefulWidget {
  final Project? project;
  final Function(Project) onSave;

  const ProjectFormDialog({super.key, this.project, required this.onSave});

  @override
  State<ProjectFormDialog> createState() => _ProjectFormDialogState();
}

class _ProjectFormDialogState extends State<ProjectFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  TaskStatus _selectedStatus = TaskStatus.pending;
  String? _selectedGroupId;

  bool get isEditing => widget.project != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.project?.name ?? '');
    _descriptionController =
        TextEditingController(text: widget.project?.description ?? '');
    _selectedStatus = widget.project?.status ?? TaskStatus.pending;
    _selectedGroupId = widget.project?.groupId;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<GroupBloc>().add(const GetGroupsEvent());
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (!_formKey.currentState!.validate()) return;

    final projectToSave = Project(
      id: widget.project?.id ?? '',
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      status: _selectedStatus,
      userIds: widget.project?.userIds ?? [],
      taskIds: widget.project?.taskIds ?? [],
      createdAt: widget.project?.createdAt ?? DateTime.now(),
      groupId: _selectedGroupId,
      ownerId: widget.project?.ownerId,
    );

    widget.onSave(projectToSave);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      title: Text(isEditing ? 'Edit project' : 'New project',
          style: textTheme.titleLarge),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomInput(
                  width: 400,
                  hintText: "Project name",
                  icon: Icons.folder_special_outlined,
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
                const Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Divider(),
                ),
                // Group selector
                _buildGroupSelector(context),
                const SizedBox(height: AppSpacing.md),
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

  Widget _buildGroupSelector(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<GroupBloc, GroupState>(
      builder: (context, state) {
        if (state is GroupLoaded) {
          return StreamBuilder<List<Group>>(
            stream: state.groups,
            builder: (context, snapshot) {
              final groups = snapshot.data ?? [];
              return DropdownButtonFormField<String?>(
                value: _selectedGroupId,
                decoration: InputDecoration(
                  labelText: 'Group (optional)',
                  prefixIcon:
                      const Icon(Icons.folder_outlined, size: 20),
                  contentPadding: AppSpacing.inputPadding,
                ),
                style: textTheme.bodyLarge,
                items: [
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text('No group'),
                  ),
                  ...groups.map((g) => DropdownMenuItem<String?>(
                        value: g.id,
                        child: Text(g.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      )),
                ],
                onChanged: (val) =>
                    setState(() => _selectedGroupId = val),
                isExpanded: true,
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
