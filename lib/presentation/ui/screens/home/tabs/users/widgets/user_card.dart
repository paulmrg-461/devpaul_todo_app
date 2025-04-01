import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:devpaul_todo_app/domain/entities/user.dart';
import 'package:devpaul_todo_app/presentation/blocs/user_bloc/user_bloc.dart';

class UserCard extends StatelessWidget {
  const UserCard({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: _buildUserAvatar(context),
        title: Text(
          user.name,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            _buildInfoRow(context, Icons.email_outlined, user.email),
            _buildInfoRow(context, Icons.badge_outlined, 'UID: ${user.uid}'),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (String choice) => _handleMenuSelection(choice, context),
          itemBuilder: (BuildContext context) => [
            _buildPopupMenuItem(context, 'Editar', Icons.edit_outlined),
            _buildPopupMenuItem(context, 'Eliminar', Icons.delete_outlined,
                isDestructive: true),
          ],
          icon: Icon(Icons.more_vert, color: colorScheme.onSurfaceVariant),
        ),
        onTap: () => _showUserDetails(context),
      ),
    );
  }

  Widget _buildUserAvatar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        user.photoUrl,
        width: 48,
        height: 48,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child:
              Icon(Icons.person_outline, color: colorScheme.onSurfaceVariant),
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon,
              size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.8),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem(
      BuildContext context, String text, IconData icon,
      {bool isDestructive = false}) {
    final colorScheme = Theme.of(context).colorScheme;

    return PopupMenuItem<String>(
      value: text,
      child: Row(
        children: [
          Icon(icon,
              color: isDestructive ? colorScheme.error : colorScheme.onSurface),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              color: isDestructive ? colorScheme.error : colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  void _handleMenuSelection(String choice, BuildContext context) {
    switch (choice) {
      case 'Editar':
        _onEdit(context);
        break;
      case 'Eliminar':
        _showDeleteConfirmationDialog(context);
        break;
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar eliminación',
            style: TextStyle(color: colorScheme.onSurface)),
        content: Text(
          '¿Eliminar al usuario ${user.name}? Esta acción no se puede deshacer.',
          style: TextStyle(color: colorScheme.onSurface.withOpacity(0.8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                Text('Cancelar', style: TextStyle(color: colorScheme.primary)),
          ),
          TextButton(
            onPressed: () {
              context.read<UserBloc>().add(DeleteUserEvent(user.id));
              Navigator.pop(context);
              _showConfirmationSnackbar(context);
            },
            child: Text('Eliminar', style: TextStyle(color: colorScheme.error)),
          ),
        ],
      ),
    );
  }

  void _showConfirmationSnackbar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: colorScheme.surfaceContainerHighest,
        content: Text(
          'Usuario eliminado: ${user.name}',
          style: TextStyle(color: colorScheme.onSurfaceVariant),
        ),
      ),
    );
  }

  void _onEdit(BuildContext context) {
    // Implementar lógica de edición similar a StudentFormDialog
    showDialog(
      context: context,
      builder: (context) => _UserEditDialog(user: user),
    );
  }

  void _showUserDetails(BuildContext context) {
    // Implementar vista de detalles si es necesario
  }
}

class _UserEditDialog extends StatefulWidget {
  final User user;

  const _UserEditDialog({required this.user});

  @override
  _UserEditDialogState createState() => _UserEditDialogState();
}

class _UserEditDialogState extends State<_UserEditDialog> {
  // Implementar lógica de formulario similar a StudentFormDialog
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Editar usuario',
          style: Theme.of(context).textTheme.titleMedium),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Agregar CustomInputs similares al StudentFormDialog
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar',
              style: TextStyle(color: Theme.of(context).colorScheme.primary)),
        ),
        FilledButton.icon(
          icon: const Icon(Icons.save_outlined),
          label: const Text('Guardar cambios'),
          onPressed: () => _saveChanges(),
        ),
      ],
    );
  }

  void _saveChanges() {
    // Lógica para guardar cambios
  }
}
