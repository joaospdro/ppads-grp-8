import 'package:flutter/material.dart';
//import 'relax_screen.dart'; // Importando a tela principal
//import 'AlarmSettingsScreen.dart';
//import 'ChangePasswordScreen.dart';
//import 'CreateAccount.dart';
//import 'RecoverPassword.dart';
//import 'Abolut.dart';
import 'ActivityHistoryScreen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ergotrack',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: ActivityHistoryScreen(), // Chamando a tela principal
    );
  }
}
