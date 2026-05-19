import 'package:devpaul_todo_app/config/themes/design_tokens.dart';
import 'package:devpaul_todo_app/domain/entities/group_entity.dart';
import 'package:devpaul_todo_app/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupFormDialog extends StatefulWidget {
  final Group? group;
  final Function(Group) onSave;

  const GroupFormDialog({
    super.key,
    this.group,
    required this.onSave,
  });

  @override
  State<GroupFormDialog> createState() => _GroupFormDialogState();
}

class _GroupFormDialogState extends State<GroupFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;

  bool get isEditing => widget.group != null;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.group?.name ?? '');
    _descCtrl = TextEditingController(
        text: widget.group?.description ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final userIds = List<String>.from(widget.group?.userIds ?? []);
    String? ownerId = widget.group?.ownerId;

    if (!isEditing) {
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthAuthenticated) {
        ownerId = authState.user.uid;
        if (!userIds.contains(ownerId)) {
          userIds.add(ownerId);
        }
      }
    }

    final group = Group(
      id: widget.group?.id ?? '',
      name: _nameCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      userIds: userIds,
      projectIds: widget.group?.projectIds ?? [],
      createdAt: widget.group?.createdAt ?? DateTime.now(),
      ownerId: ownerId,
    );

    widget.onSave(group);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      title: Text(isEditing ? 'Edit group' : 'New group',
          style: textTheme.titleLarge),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 400,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    prefixIcon:
                        Icon(Icons.folder_rounded, size: 20),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Required'
                      : null,
                  autofocus: true,
                ),
                const SizedBox(height: AppSpacing.lg),
                TextFormField(
                  controller: _descCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    prefixIcon:
                        Icon(Icons.description_outlined, size: 20),
                  ),
                  maxLines: 3,
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
          onPressed: _save,
          icon: const Icon(Icons.save_outlined, size: 18),
          label: Text(isEditing ? 'Save' : 'Create'),
        ),
      ],
    );
  }
}
