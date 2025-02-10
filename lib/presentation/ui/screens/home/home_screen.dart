import 'package:devpaul_todo_app/config/global/environment.dart';
import 'package:devpaul_todo_app/data/models/user_model.dart';
import 'package:devpaul_todo_app/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:devpaul_todo_app/presentation/ui/screens/home/widgets/bottom_bar_item.dart';
import 'package:devpaul_todo_app/presentation/ui/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  static const String name = 'home_screen';

  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.go('/login');
        }
      },
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          final isAdmin = Environment.adminEmails.contains(state.user.email);

          return Scaffold(
            appBar: AppBar(
              actions: [
                if ((isAdmin) &&
                    (currentPageIndex == 0 || currentPageIndex == 1))
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      // TODO: add search functionality
                    },
                    tooltip: 'Buscar...',
                  ),
                if (currentPageIndex == 1)
                  IconButton(
                    icon: const Icon(Icons.date_range),
                    onPressed: _selectDateRange,
                    tooltip: 'Seleccionar Rango de Fechas',
                  ),
              ],
            ),
            drawer: Drawer(
              child: _buildDrawerContent(
                context,
                state.user,
                isAdmin, // Se pasa la condición si el usuario es admin
              ),
            ),
            body: isAdmin
                ? bottombarListAdmin[currentPageIndex].widget
                : bottombarList[currentPageIndex].widget,
            bottomNavigationBar: NavigationBar(
              onDestinationSelected: (int index) {
                setState(() {
                  currentPageIndex = index;
                });
              },
              selectedIndex: currentPageIndex,
              destinations: (isAdmin ? bottombarListAdmin : bottombarList)
                  .map(
                    (e) => NavigationDestination(
                      icon: Icon(e.icon),
                      label: e.label,
                    ),
                  )
                  .toList(),
            ),
            floatingActionButton: currentPageIndex == 0 || currentPageIndex == 2
                ? FloatingActionButton(
                    onPressed: () => currentPageIndex == 0
                        ? context.pushNamed(
                            UserRegisterScreen.name,
                          )
                        : context.pushNamed(
                            UserRegisterScreen.name,
                          ),
                    child: const Icon(Icons.add),
                  )
                : null,
          );
        } else if (state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          return const Scaffold(body: Center(child: Text('Algo salió mal')));
        }
      },
    );
  }

  Widget _buildDrawerContent(
    BuildContext context,
    UserModel user,
    bool isAdmin,
  ) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // Drawer Header
        DrawerHeader(
          decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 8, bottom: 6),
                    width: 60,
                    child: Image.asset(
                      'assets/logo.png',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Text(
                    'DevPaul ToDo',
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: Colors.white),
                  ),
                ],
              ),
              Text(
                user.email,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
        // Drawer Items
        ..._buildDrawerItems(context, isAdmin),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.developer_mode_rounded),
          title: const Text('Acerca de'),
          onTap: () => context.pushNamed(DeveloperInformationScreen.name),
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Cerrar sesión'),
          onTap: () {
            Navigator.pop(context); // Cerrar el Drawer
            context.read<AuthBloc>().add(AuthLogoutEvent());
          },
        ),
      ],
    );
  }

  List<Widget> _buildDrawerItems(BuildContext context, bool isAdmin) {
    List<BottomBarItem> items = isAdmin ? bottombarListAdmin : bottombarList;

    return List.generate(items.length, (index) {
      final item = items[index];
      return ListTile(
        leading: Icon(item.icon),
        title: Text(item.label),
        selected: currentPageIndex == index,
        onTap: () {
          setState(() {
            currentPageIndex = index;
          });
          Navigator.pop(context);
        },
      );
    });
  }

  Future<void> _selectDateRange() async {
    final DateTime now = DateTime.now();
    final DateTime firstDate = now.subtract(const Duration(days: 15));
    final DateTime lastDate = now;

    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(
        start: DateTime(now.year, now.month, now.day, 0, 0, 0),
        end: DateTime(now.year, now.month, now.day, 23, 59, 59, 999),
      ),
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor, // Color del encabezado
              onPrimary: Colors.white, // Color del texto en el encabezado
              onSurface: Colors.black87, // Color del texto en el cuerpo
            ),
            dialogBackgroundColor: Colors.white, // Color de fondo del diálogo
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final difference = picked.end.difference(picked.start).inDays;
      if (difference > 15) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('El rango de fechas no puede exceder los 15 días.'),
          ),
        );
        return;
      }

      // TODO: Emitir el evento con el rango de fechas seleccionado
    }
  }
}
