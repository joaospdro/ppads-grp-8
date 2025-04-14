import 'package:flutter/material.dart';
import 'widgets/bottom_navigation.dart';
import 'AlarmSettingsScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RelaxScreen(),
    );
  }
}

class RelaxScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFB4CEAA),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Icon(Icons.account_circle, size: 50, color: Colors.black),
            const SizedBox(height: 20),
            Icon(Icons.self_improvement, size: 80, color: Colors.black),
            const SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.yellow.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "Esse momento é seu!",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            RelaxButton(text: "Ajustar postura"),
            RelaxButton(text: "Alongamento"),
            RelaxButton(text: "Beber água"),
            RelaxButton(text: "Faça uma pausa"),
            Spacer(),
            const BottomNavigation(),
          ],
        ),
      ),
    );
  }
}

class RelaxButton extends StatelessWidget {
  final String text;

  const RelaxButton({required this.text});

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
        icon: Icon(Icons.calendar_today, color: Colors.black),
        label: Text(
          text,
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          minimumSize: Size(double.infinity, 50),
        ),
      ),
    );
  }
}