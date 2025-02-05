import 'package:devpaul_todo_app/presentation/blocs/user_bloc/user_bloc.dart';
import 'package:devpaul_todo_app/presentation/ui/screens/home/tabs/operators/widgets/operator_card.dart';
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
    // Agregamos el evento para obtener los operadores al iniciar el widget
    context.read<OperatorBloc>().add(GetUsersEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OperatorBloc, OperatorState>(
      builder: (context, state) {
        if (state is OperatorLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is OperatorSuccess) {
          final operators = state.operators ?? [];
          if (operators.isEmpty) {
            return const Center(child: Text('No hay operadores disponibles.'));
          }
          return ListView.builder(
            itemCount: operators.length,
            itemBuilder: (context, index) {
              final user = operators[index];
              return OperatorCard(user: user);
            },
          );
        } else if (state is OperatorFailure) {
          return Center(child: Text(state.message));
        } else {
          return const Center(child: Text('No hay operadores disponibles.'));
        }
      },
    );
  }
}
