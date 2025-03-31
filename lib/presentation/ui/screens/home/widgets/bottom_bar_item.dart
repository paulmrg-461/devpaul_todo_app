import 'package:flutter/material.dart';
import 'package:devpaul_todo_app/presentation/ui/screens/home/tabs/tabs.dart';

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
      BottomBarItem(
        label: 'Users',
        icon: Icons.engineering_outlined,
        widget: OperatorsTab(),
      ),
      BottomBarItem(
        label: 'Tasks',
        icon: Icons.checklist_outlined,
        widget: TaskManagementTab(),
      ),
      BottomBarItem(
        label: 'Perfil',
        icon: Icons.person_outline_rounded,
        widget: ProfileTab(),
      ),
    ];

List<BottomBarItem> getBottombarList() => [
      BottomBarItem(
        label: 'Perfil',
        icon: Icons.person_outline_rounded,
        widget: ProfileTab(),
      ),
      BottomBarItem(
        label: 'Tasks',
        icon: Icons.checklist_outlined,
        widget: TaskManagementTab(),
      ),
      BottomBarItem(
        label: 'Perfil',
        icon: Icons.person_outline_rounded,
        widget: ProfileTab(),
      ),
    ];
