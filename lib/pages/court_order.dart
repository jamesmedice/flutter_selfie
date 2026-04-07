import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import '../widgets/custom_text.dart';
import '../widgets/custom_button.dart';
import '../l18n.dart';
import '../constants/app_colors.dart';
import '../services/real_time_db_service.dart';
import '../services/auth_service.dart';
import '../locator.dart';

class CourtOrderPage extends StatefulWidget {
  final SharedPreferences _prefs;

  CourtOrderPage(this._prefs);

  @override
  _CourtOrderPageState createState() => _CourtOrderPageState();
}

class _CourtOrderPageState extends State<CourtOrderPage> {
  CourtOrderService _courtOrderService = locator<CourtOrderService>();
  late AuthService _authService;

  final Logger _logger = Logger();

  bool? isCourtRequested;
  String? userEmail;
  String? uuid;

  @override
  void initState() {
    super.initState();
    _authService = AuthService(widget._prefs);
    _controllCourtOrderRequest();
  }

  Future<void> _controllCourtOrderRequest() async {
    _logger.i(">> Calling controllCourtOrderRequest");
    try {
      User? user = await _authService.getCurrentUser();

      if (user != null) {
        userEmail = user.email;
        uuid = user.uid;

        isCourtRequested =
            await _courtOrderService.findByUuid(uuid!);
      _logger.i(isCourtRequested);
      }
    } catch (e) {
      _logger.e("Error: $e");
      setState(() {
        isCourtRequested = false;
      });
    }
  }

  Future<void> _requestCourtOrder(BuildContext context) async {
    if (userEmail != null) {
      bool isSuccess = await _courtOrderService.save(
          uuid: uuid!, email: userEmail!, pictureSent: false);

      if (isSuccess) {
        setState(() {
          isCourtRequested = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final labels = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appBarBackground,
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
                text: labels?.translate('app.name') ?? 'Selfie',
                color: Colors.white,
                fontSize: 24,
              ),
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
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
            SizedBox(height: 4),
            isCourtRequested!
                ? CustomText(
                    text: labels?.translate('court.order.request') ?? '',
                    color: const Color.fromARGB(255, 255, 255, 255),
                    fontSize: 26,
                  )
                : CustomButton(
                    onPressed: () => _requestCourtOrder(context),
                    text:
                        labels?.translate('court.order.action') ?? 'New Order',
                  ),
          ],
        ),
      ),
    );
  }
}
