import 'package:flutter/material.dart';

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
      backgroundColor: Color(0xFFB4CEAA), // Cor de fundo #B4CEAA
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Imagem do Logo
            Center(
              child: Image.asset(
                'assets/pic1.png', // Caminho para a imagem pic1.png
                height: 100, // Ajuste o tamanho da imagem conforme necessário
              ),
            ),
            const SizedBox(height: 20),
            // Nome do Aplicativo
            const Text(
              'Ergotrack',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            const SizedBox(height: 40),
            // Campo de E-mail
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'E-mail',
                labelStyle: TextStyle(color: Colors.teal),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Campo de Senha
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Senha',
                labelStyle: TextStyle(color: Colors.teal),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Botão de Login
            ElevatedButton(
              onPressed: () {
                // Aqui você pode adicionar a lógica de login
                String email = _emailController.text;
                String password = _passwordController.text;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('E-mail: $email, Senha: $password')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal, // Cor teal no botão
                minimumSize: const Size(double.infinity, 50), // Largura ocupando toda a tela
              ),
              child: const Text(
                'Entrar',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}