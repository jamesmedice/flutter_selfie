import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import '../widgets/custom_text.dart';
import '../l18n.dart';
import '../locator.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';
import '../constants/app_colors.dart';

class ImageCarouselPage extends StatefulWidget {
  final SharedPreferences _prefs;

  ImageCarouselPage(this._prefs);

  @override
  _ImageCarouselPageState createState() => _ImageCarouselPageState();
}

class _ImageCarouselPageState extends State<ImageCarouselPage> {
  FireStoreService _fireStoreService = locator<FireStoreService>();

  late AuthService _authService;

  final Logger _logger = Logger();

  List<String> imageUrls = [];
  bool isLoading = true;
  int selectedImageIndex = 0;

  late AppLocalizations labels;

  @override
  void initState() {
    super.initState();
    _authService = AuthService(widget._prefs);
    _getImageUrls();
  }

  Future<void> _getImageUrls() async {
    try {
      User? user = await _authService.getCurrentUser();

      if (user != null) {
        String userEmail = user.email ?? '';

        List<String> urls = await _fireStoreService.getUrls(userEmail);

        setState(() {
          imageUrls = urls;
          isLoading = false;
        });
      }
    } catch (e) {
      _logger.e("Error fetching image URLs: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _deleteImage(BuildContext context, String imageUrl) async {
    try {
      bool confirmDelete = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.warning,
                  size: 50,
                  color: Colors.orange,
                ),
                SizedBox(height: 16),
                Text(labels?.translate('confirmation.delete_message') ??
                    'Are you sure you want to delete this image?'),
              ],
            ),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.cancel),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        },
      );

      if (confirmDelete == true) {
        await _fireStoreService.deleteImage(imageUrl);

        setState(() {
          _getImageUrls();
        });
      }
    } catch (e) {
      _logger.e("Error deleting image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    labels = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: labels?.translate('selfie.obfocus') ?? 'Obfuscated images  ',
          color: AppColors.appBarText,
        ),
        backgroundColor: AppColors.appBarBackground,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.gradientStart,
              AppColors.gradientEnd
            ],
          ),
        ),
        child: Stack(
          children: [
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (imageUrls.isEmpty)
              Center(
                  child: Text(labels?.translate('selfie.list.empty') ??
                      'No images available.'))
            else
              _buildImageCarousel(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCarousel() {
    return PageView.builder(
      itemCount: imageUrls.length,
      itemBuilder: (BuildContext context, int index) {
        String imageUrl = imageUrls[index];
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                padding: EdgeInsets.all(4),
                child: IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _deleteImage(context, imageUrls[index]);
                  },
                ),
              ),
            ),
          ],
        );
      },
      scrollDirection: Axis.horizontal,
    );
  }
}
