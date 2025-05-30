import 'package:flutter/material.dart';
import '../activity_history_screen.dart';
import '../relax_screen.dart';
import '../change_password_screen.dart';
import '../main.dart';

class BottomNavigation extends StatelessWidget {
  final int? selectedIndex;
  const BottomNavigation({super.key, this.selectedIndex});

  static const List<Map<String, dynamic>> items = [
    {'route': '/', 'icon': Icons.home, 'label': 'Home'},
    {'route': '/notifications', 'icon': Icons.notifications_active, 'label': 'Notificações'},
    {'route': '/relax', 'icon': Icons.rocket_launch, 'label': 'Relaxar'},
    {'route': '/settings', 'icon': Icons.settings, 'label': 'Configurações'},
  ];

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    final currentIndex = currentRoute != null
        ? items.indexWhere((item) => item['route'] == currentRoute)
        : (selectedIndex ?? 0);
    return BottomNavigationBar(
      currentIndex: currentIndex < 0 ? 0 : currentIndex,
      backgroundColor: Colors.transparent,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: (index) {
        final route = items[index]['route'];
        if (route != currentRoute) {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  _getScreenForRoute(route!),
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
      items: items.map((item) {
        final index = items.indexOf(item);
        final isSelected = currentRoute != null
            ? (item['route'] == currentRoute)
            : (index == (selectedIndex ?? 0));
        final iconColor = isSelected ? Colors.red : Colors.black;
        return BottomNavigationBarItem(
          icon: Icon(item['icon'], size: 30, color: iconColor),
          label: item['label'],
          backgroundColor: Colors.transparent,
        );
      }).toList(),
    );
  }

  Widget _getScreenForRoute(String route) {
    switch (route) {
      case '/':
        return const ActivityHistoryScreen();
      case '/notifications':
        return const PlaceholderScreen(title: 'Notificações');
      case '/relax':
        return const RelaxScreen();
      case '/settings':
        return const ChangePasswordScreen();
      default:
        return const ActivityHistoryScreen();
    }
  }
}