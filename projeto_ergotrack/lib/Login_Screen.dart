import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB4CEAA),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Imagem do Logo
            Center(
              child: Image.asset(
                'assets/pic1.png',
                height: 100,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Ergotrack',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'E-mail',
                labelStyle: TextStyle(color: Colors.teal),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Senha',
                labelStyle: TextStyle(color: Colors.teal),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String email = _emailController.text;
                String password = _passwordController.text;
                
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                final navigator = Navigator.of(context);
                
                try {
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email, password: password);
                  
                  if (!mounted) return;
                  
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(content: Text('Login realizado com sucesso')),
                  );
                  
                  navigator.pushReplacementNamed('/activity');
                } catch (e) {
                  if (!mounted) return;
                  
                  scaffoldMessenger.showSnackBar(
                    SnackBar(content: Text('Erro no login: ${e.toString()}')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Entrar',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/recover');
              },
              child: const Text(
                'Recuperar senha',
                style: TextStyle(decoration: TextDecoration.underline),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/create');
              },
              child: const Text(
                'Criar conta',
                style: TextStyle(decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
      ),
    );
  }
}