import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 170, 200, 252),
        body: Column(
          children: [
            const SizedBox(height: 50),
            Center(child: Lottie.asset('assets/strock.json', height: 250)),
            TabBar(
              labelColor: const Color.fromARGB(255, 66, 68, 202),
              unselectedLabelColor: Colors.blueGrey,
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold
              ),
              tabs: const [
                Tab(text: "Login"),
                Tab(text: "Register"),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: const [
                  LoginForm(),
                  RegisterForm(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Login Form
class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 170, 200, 252),
      child: Padding(
        padding: const EdgeInsets.all(45.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextField(label: 'Email', validator: _validateEmail),
                const SizedBox(height: 20),
                _buildTextField(label: 'Password', obscureText: true, validator: _validatePassword),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: _buttonStyle(),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Proceed with login
                    }
                  },
                  child: const Text("Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Register Form
class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 170, 200, 252),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextField(label: 'Name', validator: _validateNotEmpty),
                const SizedBox(height: 10),
                _buildTextField(label: 'Email', validator: _validateEmail),
                const SizedBox(height: 10),
                _buildTextField(label: 'Password', obscureText: true, validator: _validatePassword),
                const SizedBox(height: 10),
                _buildTextField(label: 'Confirm Password', obscureText: true, validator: _validatePassword),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: _buttonStyle(),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Proceed with registration
                    }
                  },
                  child: const Text("Register"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Common Text Field Widget with Validation
Widget _buildTextField({
  required String label,
  bool obscureText = false,
  String? Function(String?)? validator,
}) {
  return TextFormField(
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.black),
      border: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: const Color.fromARGB(255, 98, 100, 245),
          width: 1
        )
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: const Color.fromARGB(255, 48, 49, 138),
          width: 1.5
        )
      )
    ),
    obscureText: obscureText,
    validator: validator,
  );
}

// Button Style
ButtonStyle _buttonStyle() {
  return ElevatedButton.styleFrom(
    backgroundColor: Color(0xFF4A90E2),
    foregroundColor: Colors.white,
    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  );
}

// Validation Functions
String? _validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email is required';
  }
  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+\$').hasMatch(value)) {
    return 'Enter a valid email';
  }
  return null;
}

String? _validatePassword(String? value) {
  if (value == null || value.length < 6) {
    return 'Password must be at least 6 characters';
  }
  return null;
}

String? _validateNotEmpty(String? value) {
  if (value == null || value.isEmpty) {
    return 'This field is required';
  }
  return null;
}
