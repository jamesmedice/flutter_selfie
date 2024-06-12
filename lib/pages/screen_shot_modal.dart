import 'package:flutter/material.dart';
import 'dart:typed_data';
import '../l18n.dart';
import '../services/image_upload_service.dart';
import '../constants/app_colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text.dart';

class ScreenshotModalContent extends StatefulWidget {
  final double screenHeight;
  final AppLocalizations? labels;
  final Uint8List imageBytes;

  ScreenshotModalContent({
    required this.screenHeight,
    required this.labels,
    required this.imageBytes,
  });

  @override
  _ScreenshotModalContentState createState() => _ScreenshotModalContentState();
}

class _ScreenshotModalContentState extends State<ScreenshotModalContent> {
  late String modalMessage;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    modalMessage =
        widget.labels?.translate('selfie.uploading') ?? 'Uploading...';
    _uploadImage();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.screenHeight * 0.95,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.gradientStart,
            AppColors.gradientEnd, // Bottom color of the gradient
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.memory(
            widget.imageBytes,
            width: MediaQuery.of(context).size.width,
            height: widget.screenHeight * 0.7,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 8.0),
          isLoading ? CircularProgressIndicator() : Container(),
          SizedBox(height: 8.0),
          CustomText(
            text: modalMessage,
            color: const Color.fromARGB(255, 251, 251, 251),
          ),
          SizedBox(height: 16.0),
          CustomButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            text: widget.labels?.translate('close') ?? 'Close',
          ),
        ],
      ),
    );
  }

  void _uploadImage() async {
    ImageUploadService uploadService = ImageUploadService();

    try {
      String? downloadUrl =
          await uploadService.uploadImageToStorage(widget.imageBytes);

      if (downloadUrl != null) {
        setState(() {
          modalMessage = widget.labels?.translate('selfie.uploaded') ??
              'Image uploaded successfully!';
        });
      } else {
        setState(() {
          modalMessage = widget.labels?.translate('selfie.uploadFailed') ??
              'Failed to upload image to cloud storage';
        });
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
