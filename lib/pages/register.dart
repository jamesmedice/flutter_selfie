import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/input_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text.dart';
import '../constants/app_colors.dart';
import '../l18n.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String _registrationStatus = '';

  Future<void> _register() async {
    try {
      if (_passwordController.text == _confirmPasswordController.text) {
        if (isPasswordValid(_passwordController.text)) {
          await _auth.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
          setState(() {
            _registrationStatus = 'Registration successful!';
          });
          _showSuccessModal();
        } else {
          setState(() {
            _registrationStatus =
                'Password must contain letters, numbers, and special characters.';
          });
        }
      } else {
        setState(() {
          _registrationStatus = 'Passwords do not match!';
        });
      }
    } catch (e) {
      setState(() {
        _registrationStatus = 'Error during registration: $e';
      });
    }
  }

  bool isPasswordValid(String password) {
    // Regex pattern : requires at least one uppercase letter, one lowercase letter, one digit, and one special character
    // It also enforces a minimum length of 8 characters
    RegExp regex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_])[A-Za-z\d\W_]{8,}$',
    );

    return regex.hasMatch(password);
  }

  void _showSuccessModal() {
    final labels = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(labels?.translate('register.success') ?? 'Success!!!'),
          content: Text(labels?.translate('register.text') ??
              'User has been successfully registered.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text(labels?.translate('register.ok') ?? 'OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final labels = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appBarBackground,
        title: CustomText(
          text: labels?.translate('app.name') ?? 'Authentication',
          color: const Color.fromARGB(255, 255, 255, 255),
          fontSize: 26,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.gradientStart,
              AppColors.gradientEnd,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InputField(
                controller: _emailController,
                label: labels?.translate('login.email') ?? 'Email*',
              ),
              InputField(
                controller: _passwordController,
                label: labels?.translate('login.psw') ?? 'Password*',
                obscureText: true,
              ),
              InputField(
                controller: _confirmPasswordController,
                label: labels?.translate('login.rpsw') ?? 'Repeat Password*',
                obscureText: true,
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 250.0,
                child: CustomButton(
                  onPressed: _register,
                  text: labels?.translate('login.signup') ?? 'Register',
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 250.0,
                child: CustomButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  text:
                      labels?.translate('login.back2login') ?? 'Back to Login',
                ),
              ),
              SizedBox(height: 20),
              CustomText(
                text: _registrationStatus,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
