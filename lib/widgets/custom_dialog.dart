import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../l18n.dart';

class CustomDialogStyle {
  static Widget buildAlertDialog({
    required BuildContext context,
    required String title,
    required String content,
    required String buttonText,
    Color? backgroundColor,
    Color? titleColor,
    Color? contentColor,
    Color? buttonTextColor,
    VoidCallback? onPressed,
  }) {
    final labels = AppLocalizations.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        color: backgroundColor ?? AppColors.dialogBackground,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: titleColor ?? AppColors.dialogTitle,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                content,
                style: TextStyle(
                  color: contentColor ?? Colors.black87,
                ),
              ),
              SizedBox(height: 16.0),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: onPressed ?? () => Navigator.pop(context),
                  child: Text(
                    buttonText,
                    style: TextStyle(
                      color: buttonTextColor ?? AppColors.dialogButtonText,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
