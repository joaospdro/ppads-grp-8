import 'package:flutter/material.dart';
import '../activity_history_screen.dart';
import '../relax_screen.dart';
import '../change_password_screen.dart';
import '../main.dart';

class BottomNavigation extends StatelessWidget {
  final int selectedIndex;
  const BottomNavigation({super.key, required this.selectedIndex});

  static const List<Map<String, dynamic>> items = [
    {'route': '/', 'icon': Icons.home, 'label': 'Home'},
    {'route': '/notifications', 'icon': Icons.notifications_active, 'label': 'Notificações'},
    {'route': '/relax', 'icon': Icons.rocket_launch, 'label': 'Relaxar'},
    {'route': '/settings', 'icon': Icons.settings, 'label': 'Configurações'},
  ];

  @override
  Widget build(BuildContext context) {
    final int safeIndex = (selectedIndex >= 0 && selectedIndex < items.length) ? selectedIndex : 0;
    return BottomNavigationBar(
      currentIndex: safeIndex,
      backgroundColor: Colors.transparent,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: (index) {
        if (index != selectedIndex) {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  _getScreenForRoute(index),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              transitionDuration: const Duration(milliseconds: 300),
            ),
          );
        }
      },
      items: items.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        final iconColor = index == selectedIndex ? Colors.red : Colors.black;
        return BottomNavigationBarItem(
          icon: Icon(item['icon'], size: 30, color: iconColor),
          label: item['label'],
          backgroundColor: Colors.transparent,
        );
      }).toList(),
    );
  }

  Widget _getScreenForRoute(int index) {
    switch (index) {
      case 0:
        return const ActivityHistoryScreen();
      case 1:
        return const PlaceholderScreen(title: 'Notificações');
      case 2:
        return const RelaxScreen();
      case 3:
        return const ChangePasswordScreen();
      default:
        return const ActivityHistoryScreen();
    }
  }
}