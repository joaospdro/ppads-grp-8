import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projeto_ergotrack/services/notification_service.dart';
import 'firebase_options.dart';
import 'activity_history_screen.dart';
import 'login_screen.dart';
import 'change_password_screen.dart';
import 'RecoverPassword.dart';
import 'create_account.dart';
import 'relax_screen.dart';
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
  await NotificationService().initialize();
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
        '/relax': (context) => RelaxScreen(),
        '/activity': (context) => ActivityHistoryScreen(),
        '/login': (context) => LoginScreen(),
        '/settings': (context) => ChangePasswordScreen(),
        '/notifications': (context) => const PlaceholderScreen(title: 'Notificações'),
        '/recover': (context) => RecoverPassword(),
        '/create': (context) => CreateAccount(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});
  
  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    return user != null ? const ActivityHistoryScreen() : const LoginScreen();
  }
}
