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

List<BottomBarItem> getBottombarListAdmin() => const [
      BottomBarItem(
        label: 'Tasks',
        icon: Icons.checklist_outlined,
        widget: TaskManagementTab(),
      ),
      BottomBarItem(
        label: 'Groups',
        icon: Icons.folder_rounded,
        widget: GroupManagementTab(),
      ),
      BottomBarItem(
        label: 'Projects',
        icon: Icons.assignment_outlined,
        widget: ProjectManagementTab(),
      ),
      BottomBarItem(
        label: 'Users',
        icon: Icons.people_outline_rounded,
        widget: OperatorsTab(),
      ),
      BottomBarItem(
        label: 'Profile',
        icon: Icons.person_outline_rounded,
        widget: ProfileTab(),
      ),
    ];

List<BottomBarItem> getBottombarList() => const [
      BottomBarItem(
        label: 'Tasks',
        icon: Icons.checklist_outlined,
        widget: TaskManagementTab(),
      ),
      BottomBarItem(
        label: 'Groups',
        icon: Icons.folder_rounded,
        widget: GroupManagementTab(),
      ),
      BottomBarItem(
        label: 'Projects',
        icon: Icons.assignment_outlined,
        widget: ProjectManagementTab(),
      ),
      BottomBarItem(
        label: 'Profile',
        icon: Icons.person_outline_rounded,
        widget: ProfileTab(),
      ),
    ];
