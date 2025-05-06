import 'package:flutter/material.dart';
import 'package:devpaul_todo_app/presentation/ui/screens/home/tabs/tabs.dart';
import 'package:devpaul_todo_app/presentation/ui/screens/home/tabs/projects/project_management_tab.dart';

class BottomBarItem {
  final String label;
  final IconData icon;
  final Widget widget;

  const BottomBarItem({
    required this.label,
    required this.icon,
    required this.widget,
  });

  NavigationDestination get navigationDestination =>
      NavigationDestination(icon: Icon(icon), label: label);
}

List<BottomBarItem> getBottombarListAdmin() => [
      const BottomBarItem(
        label: 'Tareas',
        icon: Icons.checklist_outlined,
        widget: TaskManagementTab(),
      ),
      const BottomBarItem(
        label: 'Proyectos',
        icon: Icons.assignment_outlined, // Or any other suitable icon
        widget: ProjectManagementTab(),
      ),
      const BottomBarItem(
        label: 'Usuarios',
        icon: Icons.people_outline_rounded,
        widget: OperatorsTab(),
      ),
      const BottomBarItem(
        label: 'Perfil',
        icon: Icons.person_outline_rounded,
        widget: ProfileTab(),
      ),
    ];

List<BottomBarItem> getBottombarList() => [
      const BottomBarItem(
        label: 'Tareas',
        icon: Icons.checklist_outlined,
        widget: TaskManagementTab(),
      ),
      const BottomBarItem(
        label: 'Proyectos',
        icon: Icons.assignment_outlined, // Or any other suitable icon
        widget: ProjectManagementTab(),
      ),
      const BottomBarItem(
        label: 'Perfil',
        icon: Icons.person_outline_rounded,
        widget: ProfileTab(),
      ),
    ];
