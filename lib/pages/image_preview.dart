import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/custom_text.dart';
import '../widgets/custom_button.dart';
import '../l18n.dart';
import '../utils/date_utils.dart';
import '../constants/app_colors.dart';
import 'screen_shot_modal.dart';
import 'home.dart';

class CenteredImageScreenx extends StatefulWidget {
  final String imagePath;

  final SharedPreferences _prefs;

  CenteredImageScreenx(this._prefs, {Key? key, required this.imagePath})
      : super(key: key);

  @override
  _CenteredImageScreenStatex createState() => _CenteredImageScreenStatex();
}

class _CenteredImageScreenStatex extends State<CenteredImageScreenx> {
  late String _currentImagePath;
  final _screenshotController = ScreenshotController();
  bool _isTakingScreenshot = false;

  String currentDate = StandardDateUtils.getCurrentDate();

  @override
  void initState() {
    super.initState();
    _currentImagePath = widget.imagePath;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    final labels = AppLocalizations.of(context);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.gradientStart,
                  AppColors.gradientEnd,
                ],
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              AppBar(
                backgroundColor: AppColors.appBarBackground,
                iconTheme: IconThemeData(color: Colors.white),
                title: CustomText(text: ''),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Expanded(
                child: Screenshot(
                  controller: _screenshotController,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CustomText(
                            text: labels?.translate('selfie.text') ?? '',
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontSize: 16.0,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(2.0),
                          child: CustomText(
                            text: currentDate,
                            fontSize: 14.0,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.ovalContainer,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          width: 300.0,
                          height: 400.0,
                          //color: AppColors.ovalContainer,
                          child: Center(
                            child: Image.file(
                              File(_currentImagePath),
                              width: 280.0,
                              height: 380.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    SizedBox(
                      width: 230.0,
                      child: ElevatedButton(
                        onPressed: _isTakingScreenshot
                            ? null
                            : () async {
                                setState(() {
                                  _isTakingScreenshot = true;
                                });

                                Uint8List? imageBytes =
                                    await _screenshotController.capture();

                                setState(() {
                                  _isTakingScreenshot = false;
                                });

                                if (imageBytes != null) {
                                  _showScreenshotModal(context, imageBytes);
                                }
                              },
                        child: _isTakingScreenshot
                            ? CircularProgressIndicator()
                            : CustomText(
                                text: labels?.translate('selfie.save') ??
                                    'Save Picture',
                                color: const Color.fromARGB(255, 246, 246, 248),
                              ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.elevatedButtonStart,
                          shadowColor: AppColors.elevatedButtonShadowEnd,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    SizedBox(
                      width: 230.0,
                      child: CustomButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(widget._prefs),
                            ),
                          );
                        },
                        text: labels?.translate('cancel') ?? 'Cancel',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showScreenshotModal(BuildContext context, Uint8List imageBytes) {
    double screenHeight = MediaQuery.of(context).size.height;
    final labels = AppLocalizations.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return ScreenshotModalContent(
          screenHeight: screenHeight,
          labels: labels,
          imageBytes: imageBytes,
        );
      },
    );
  }
}
