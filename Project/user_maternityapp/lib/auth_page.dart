import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:user_maternityapp/components/form_validation.dart';
import 'package:user_maternityapp/homepage.dart';
import 'package:user_maternityapp/main.dart';
import 'package:user_maternityapp/pregnency_date.dart';

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
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              tabs: const [
                Tab(text: "Login"),
                Tab(text: "Register"),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  const LoginForm(),
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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  Future<void> login() async {
    try {
      final response = await supabase.auth.signInWithPassword(
          password: _passController.text, email: _emailController.text);
      if (response == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Something went wrong")));
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      print("Error logining user: $e");
    }
  }

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
                _buildTextField(
                    label: 'Email',
                    validator: _validateEmail,
                    controller: _emailController),
                const SizedBox(height: 20),
                _buildTextField(
                    label: 'Password',
                    obscureText: true,
                    validator: _validatePassword,
                    controller: _passController),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: _buttonStyle(),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      login();
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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _cpassController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  Future<void> register() async {
    try {
      final response = await supabase.auth
          .signUp(password: _passController.text, email: _emailController.text);
      String userid = response.user!.id;
      storeData(userid);
    } catch (e) {
      print("Error registering user: $e");
    }
  }

  Future<void> storeData(String uid) async {
    try {
      await supabase.from("tbl_user").insert({
        'id': uid,
        'user_name': _nameController.text,
        'user_email': _emailController.text,
        'user_password': _passController.text,
        'user_contact': _contactController.text,
        'user_dob': _dobController.text,
      });
      _nameController.clear();
      _emailController.clear();
      _passController.clear();
      _cpassController.clear();
      _contactController.clear();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Registration Successfull")));
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PregnancyDatePicker(),
          ));
    } catch (e) {
      print("Error storing data:$e");
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime eighteenYearsAgo =
        DateTime.now().subtract(Duration(days: 18 * 365));

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: eighteenYearsAgo, // 18 years ago
      firstDate: DateTime(1900), // Earliest date possible
      lastDate: eighteenYearsAgo, // Ensures only 18+ users can select their DOB
    );

    if (picked != null) {
      _dobController.text = "${picked.toLocal()}".split(' ')[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Color.fromARGB(255, 170, 200, 252),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTextField(
                      label: 'Name',
                      validator: (p0) => FormValidation.validateName(p0),
                      controller: _nameController),
                  const SizedBox(height: 10),
                  _buildTextField(
                      label: 'Email',
                      validator: (p0) => FormValidation.validateEmail(p0),
                      controller: _emailController),
                  const SizedBox(height: 10),
                  _buildTextField(
                      label: 'Contact',
                      validator: (p0) => FormValidation.validateContact(p0),
                      controller: _contactController),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _dobController,
                    readOnly: true,
                    decoration: InputDecoration(
                        labelText: 'Date of Birth',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () => _selectDate(context),
                        ),
                        labelStyle: TextStyle(color: Colors.black),
                        border: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: const Color.fromARGB(255, 98, 100, 245),
                                width: 1)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: const Color.fromARGB(255, 48, 49, 138),
                                width: 1.5))),
                    validator: _validateDOB,
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                      label: 'Password',
                      obscureText: true,
                      validator: (p0) => FormValidation.validatePassword(p0),
                      controller: _passController),
                  const SizedBox(height: 10),
                  _buildTextField(
                      label: 'Confirm Password',
                      obscureText: true,
                      validator: (p0) => FormValidation.validateConfirmPassword(
                          p0, _passController.text),
                      controller: _cpassController),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: _buttonStyle(),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        register();
                      }
                    },
                    child: const Text("Register"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Common Text Field Widget with Validation
Widget _buildTextField({
  required TextEditingController controller,
  required String label,
  bool obscureText = false,
  String? Function(String?)? validator,
}) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.black),
        border: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: const Color.fromARGB(255, 98, 100, 245), width: 1)),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: const Color.fromARGB(255, 48, 49, 138), width: 1.5))),
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
  return null;
}

String? _validatePassword(String? value) {
  if (value == null || value.length < 6) {
    return 'Password must be at least 6 characters';
  }
  return null;
}

String? _validateContact(String? value) {
  if (value == null || value.length < 10) {
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

String? _validateDOB(String? value) {
  if (value == null || value.isEmpty) {
    return 'Date of Birth is required';
  }
  DateTime dob = DateTime.parse(value);
  DateTime today = DateTime.now();
  int age = today.year - dob.year;
  if (today.month < dob.month ||
      (today.month == dob.month && today.day < dob.day)) {
    age--;
  }
  if (age < 18) {
    return 'You must be at least 18 years old';
  }
  return null;
}
