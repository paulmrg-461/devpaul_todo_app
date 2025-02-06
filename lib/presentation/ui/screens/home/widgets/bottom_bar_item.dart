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

const List<BottomBarItem> bottombarListAdmin = [
  BottomBarItem(
    label: 'Users',
    icon: Icons.engineering_outlined,
    widget: OperatorsTab(),
  ),
  BottomBarItem(
    label: 'Perfil',
    icon: Icons.person_outline_rounded,
    widget: ProfileTab(),
  ),
  BottomBarItem(
    label: 'Perfil',
    icon: Icons.person_outline_rounded,
    widget: ProfileTab(),
  ),
];

const List<BottomBarItem> bottombarList = [
  BottomBarItem(
    label: 'Perfil',
    icon: Icons.person_outline_rounded,
    widget: ProfileTab(),
  ),
  BottomBarItem(
    label: 'Perfil',
    icon: Icons.person_outline_rounded,
    widget: ProfileTab(),
  ),
  BottomBarItem(
    label: 'Perfil',
    icon: Icons.person_outline_rounded,
    widget: ProfileTab(),
  ),
];
