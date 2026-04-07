import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/input_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text.dart';
import '../constants/app_colors.dart';
import 'package:logger/logger.dart';
import '../l18n.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final Logger _logger = Logger();

  Future<void> _resetPassword(
      BuildContext context, AppLocalizations? labels) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text,
      );

      String successMessage = labels?.translate('login.resetMessage') ??
          'Password reset email sent successfully. Check your email.';

      String button = labels?.translate('dialog.button') ?? 'OK';
      String title = labels?.translate('dialog.title') ?? 'Error';

      _showSuccessMessage(title, button, successMessage);
    } catch (e) {
      _logger.e('Error sending password reset email: $e');
    }
  }

  void _showSuccessMessage(String title, String button, String successMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: CustomText(text: title),
          content: CustomText(text: successMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: CustomText(text: button),
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
          text: labels?.translate('login.forgot') ?? 'Forgot Password',
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
                label: labels?.translate('login.email') ?? 'Email',
              ),
              SizedBox(height: 16.0),
              SizedBox(
                width: 250.0,
                child: CustomButton(
                  onPressed: () => _resetPassword(context, labels),
                  text:
                      labels?.translate('login.resetPass') ?? 'Reset Password',
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
            ],
          ),
        ),
      ),
    );
  }
}
