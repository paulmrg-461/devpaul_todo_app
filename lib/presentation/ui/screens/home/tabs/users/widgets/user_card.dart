import 'package:flutter/material.dart';
import 'package:devpaul_todo_app/presentation/blocs/user_bloc/user_bloc.dart';
import 'package:devpaul_todo_app/presentation/ui/widgets/widgets.dart';
import 'package:devpaul_todo_app/domain/entities/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserCard extends StatelessWidget {
  const UserCard({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          // Opcional: Añade sombra para mejorar la visibilidad
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // Cambia la posición de la sombra
          ),
        ],
      ),
      child: InkWell(
        onTap: () => print('User seleccionado: ${user.name}'),
        child: Row(
          children: [
            if (user.photoUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  user.photoUrl,
                  width: MediaQuery.of(context).size.width * 0.275,
                  height: 60,
                  fit: BoxFit.fitWidth, // Ajusta el fit según tus necesidades
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 136,
                      height: 60,
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(width: 22),
            // Información del user
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 4),
                  TrailingWidget(
                    text: user.email,
                    icon: Icons.person_outline_rounded,
                  ),
                  TrailingWidget(
                    text: 'UID: ${user.uid}',
                    icon: Icons.badge_outlined,
                  ),
                ],
              ),
            ),
            // PopupMenuButton con opciones Editar y Eliminar
            PopupMenuButton<String>(
              onSelected: (String choice) {
                if (choice == 'Editar') {
                  _onEdit(context);
                } else if (choice == 'Eliminar') {
                  _showDeleteConfirmationDialog(context);
                }
              },
              itemBuilder: (BuildContext context) {
                return {'Editar', 'Eliminar'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
              icon: const Icon(Icons.more_vert),
            ),
          ],
        ),
      ),
    );
  }

  /// Acción a realizar al seleccionar Editar
  void _onEdit(BuildContext context) {
    // Implementa la lógica de edición, por ejemplo, navegar a una pantalla de edición
    print('Editar user: ${user.name}');
    // Ejemplo de navegación:
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => EditOperatorScreen(user: user)),
    // );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirmar Eliminación'),
          content: Text(
            '¿Estás seguro de que deseas eliminar al user ${user.name}? Esta acción no se puede deshacer.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                context.read<UserBloc>().add(
                      DeleteUserEvent(user.id),
                    );

                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'User ${user.name} eliminado exitosamente',
                    ),
                  ),
                );
              },
              child: const Text(
                'Eliminar',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
