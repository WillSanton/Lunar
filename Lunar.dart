

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(LunarCalendarApp());
}

class LunarCalendarApp extends StatelessWidget {
  const LunarCalendarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LunarCalendarScreen()),
      );
    } catch (e) {
      print("Erro ao fazer login: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: InputDecoration(labelText: 'E-mail')),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: 'Senha'), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(onPressed: login, child: Text('Entrar')),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              child: Text('Criar conta'),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController birthTimeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void register() async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': nameController.text,
        'city': cityController.text,
        'birthDate': birthDateController.text,
        'birthTime': birthTimeController.text,
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LunarCalendarScreen()),
      );
    } catch (e) {
      print("Erro ao cadastrar: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastro')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: 'Nome')),
            TextField(controller: cityController, decoration: InputDecoration(labelText: 'Cidade')),
            TextField(controller: birthDateController, decoration: InputDecoration(labelText: 'Data de Nascimento')),
            TextField(controller: birthTimeController, decoration: InputDecoration(labelText: 'Hora de Nascimento')),
            TextField(controller: emailController, decoration: InputDecoration(labelText: 'E-mail')),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: 'Senha'), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(onPressed: register, child: Text('Cadastrar')),
          ],
        ),
      ),
    );
  }
}

class LunarCalendarScreen extends StatelessWidget {
  const LunarCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calendário Lunar e Signos')),
      body: Center(child: Text('Bem-vindo ao Calendário Lunar!')),
    );
  }
}

