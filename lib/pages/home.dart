import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:camera/camera.dart';
import 'package:logger/logger.dart';
import '../widgets/custom_list_tile.dart';
import '../widgets/custom_text.dart';
import '../l18n.dart';
import '../locator.dart';
import '../services/camera_service.dart';
import '../constants/app_colors.dart';
import 'login.dart';
import 'court_order.dart';
import 'image_carousel.dart';
import 'digital_consensus.dart';

class HomePage extends StatelessWidget {
  final CameraService cameraService = locator<CameraService>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Logger _logger = Logger();

  final SharedPreferences _prefs;

  HomePage(this._prefs);

  Future<void> _signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen(this._prefs)),
      );
    } catch (e) {
      _logger.e("Error during sign-out: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final labels = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: CustomText(
            text: '${labels?.translate('welcome_screen.title')}',
            color: const Color.fromARGB(255, 251, 251, 251),
            fontSize: 22,
            fontWeight: FontWeight.bold),
        backgroundColor: AppColors.appBarBackground,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: AppColors.drawerHeaderBackground,
              ),
              child: CustomText(
                text: labels?.translate('app.name') ?? '_Suc Sex_',
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            CustomListTile(
                title: labels?.translate('selfie.request') ?? 'Court Order',
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => CourtOrderPage(this._prefs)));
                }),
            CustomListTile(
                title: labels?.translate('selfie.recognition') ??
                    'Recognition Phase',
                onTap: () async {
                  CameraDescription? frontCamera =
                      await cameraService.getFrontCameraDescription();

                  if (frontCamera != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            DigitalConsensus(this._prefs, camera: frontCamera),
                      ),
                    );
                  }
                }),
            CustomListTile(
                title: labels?.translate('selfie.list') ?? 'Selfie List',
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ImageCarouselPage(this._prefs)));
                }),
            CustomListTile(
              title: labels?.translate('profile.logout') ?? 'Logout',
              onTap: () => _signOut(context),
            ),
          ],
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                  child: Image.asset(
                    'assets/images/handshake.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
