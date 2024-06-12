import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/camera_header.dart';
import '../widgets/camera_preview.dart';
import '../widgets/capture_button.dart';
import 'image_preview.dart';
import 'home.dart';
import '../l18n.dart';

class DigitalConsensus extends StatefulWidget {
  final SharedPreferences _prefs;

  const DigitalConsensus(
    this._prefs, {
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;

  @override
  DigitalConsensusState createState() => DigitalConsensusState();
}

class DigitalConsensusState extends State<DigitalConsensus> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  final Logger _logger = Logger();

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _onBackPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage(widget._prefs)),
    );
  }

  _takePicture() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();

      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String savedImagePath =
          '${appDocDir.path}/image_${DateTime.now().millisecondsSinceEpoch}.jpg';

      await File(image.path).copy(savedImagePath);

      if (!context.mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CenteredImageScreenx(
            widget._prefs,
            imagePath: savedImagePath,
          ),
        ),
      );
    } catch (e) {
      _logger.e(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final labels = AppLocalizations.of(context);

    Widget header = CameraHeader(
      labels?.translate('rules') ?? 'Do you agree witht the terms of this app?',
      onBackPressed: _onBackPressed,
    );

    Widget? fab = CaptureButton(onTap: _takePicture);

    Widget body = CameraPreviewWidget(
      initializeControllerFuture: _initializeControllerFuture,
      controller: _controller,
    );

    return Scaffold(
      body: Stack(
        children: [body, header],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: fab,
    );
  }
}
