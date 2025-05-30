import 'package:flutter/material.dart';
import 'widgets/bottom_navigation.dart';
import 'alarm_settings_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const RelaxScreen(),
    );
  }
}

class RelaxScreen extends StatelessWidget {
  const RelaxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB4CEAA),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Icon(Icons.account_circle, size: 50, color: Colors.black),
            const SizedBox(height: 20),
            const Icon(Icons.self_improvement, size: 80, color: Colors.black),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.yellow.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "Esse momento é seu!",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            const RelaxButton(text: "Ajustar postura"),
            const RelaxButton(text: "Alongamento"),
            const RelaxButton(text: "Beber água"),
            const RelaxButton(text: "Faça uma pausa"),
            const Spacer(),
            BottomNavigation(selectedIndex: 2),
          ],
        ),
      ),
    );
  }
}

class RelaxButton extends StatelessWidget {
  final String text;

  const RelaxButton({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 40),
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AlarmSettingsScreen(notificationType: text)),
          );
        },
        icon: const Icon(Icons.calendar_today, color: Colors.black),
        label: Text(
          text,
          style: const TextStyle(fontSize: 16, color: Colors.black),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          minimumSize: const Size(double.infinity, 50),
        ),
      ),
    );
  }
}