import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final int? selectedIndex;
  const BottomNavigation({Key? key, this.selectedIndex}) : super(key: key);

  static const List<Map<String, dynamic>> items = [
    {'route': '/activity', 'icon': Icons.home, 'label': 'Home'},
    {'route': '/notifications', 'icon': Icons.notifications, 'label': 'Notificações'},
    {'route': '/alarm', 'icon': Icons.rocket_launch, 'label': 'Alarmes'},
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
          Navigator.pushReplacementNamed(
            context, 
            route,
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
}
