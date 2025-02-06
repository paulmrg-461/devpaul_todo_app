import 'package:devpaul_todo_app/presentation/blocs/user_bloc/user_bloc.dart';
import 'package:devpaul_todo_app/presentation/ui/screens/home/tabs/users/widgets/user_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OperatorsTab extends StatefulWidget {
  const OperatorsTab({super.key});

  @override
  _OperatorsTabState createState() => _OperatorsTabState();
}

class _OperatorsTabState extends State<OperatorsTab> {
  @override
  void initState() {
    super.initState();
    // Agregamos el evento para obtener los users al iniciar el widget
    context.read<UserBloc>().add(GetUsersEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is OperatorLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is OperatorSuccess) {
          final users = state.users ?? [];
          if (users.isEmpty) {
            return const Center(child: Text('No hay users disponibles.'));
          }
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return UserCard(user: user);
            },
          );
        } else if (state is OperatorFailure) {
          return Center(child: Text(state.message));
        } else {
          return const Center(child: Text('No hay users disponibles.'));
        }
      },
    );
  }
}
