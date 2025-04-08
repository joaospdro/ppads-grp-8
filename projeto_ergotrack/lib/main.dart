import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'ActivityHistoryScreen.dart';
import 'Login_Screen.dart';
import 'AlarmSettingsScreen.dart';
import 'ChangePasswordScreen.dart';
import 'RecoverPassword.dart';
import 'CreateAccount.dart';
import 'widgets/bottom_navigation.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title)),
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAuth.instance.signOut();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ergotrack',
      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: '/',
      routes: {
        '/': (context) => AuthWrapper(),
        '/activity': (context) => ActivityHistoryScreen(),
        '/login': (context) => LoginScreen(),
        '/alarm': (context) => AlarmSettingsScreen(),
        '/settings': (context) => ChangePasswordScreen(),
        '/notifications': (context) => const PlaceholderScreen(title: 'Notificações'),
        '/recover': (context) => RecoverPassword(),
        '/create': (context) => CreateAccount(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    return user != null ? ActivityHistoryScreen() : LoginScreen();
  }
}
