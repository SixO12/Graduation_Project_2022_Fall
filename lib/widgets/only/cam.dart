import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class CameraApp extends StatefulWidget {
  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  CameraController controller;

  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (controller != null) {
        // onNewCameraSelected(controller.description);
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    controller.startImageStream((CameraImage image) {
      if (mounted) {
        setState(() {});
      }
    });
    if (!controller.value.isInitialized) {
      return Container();
    }
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Center(
              child: SizedBox(
                height: 224,
                width: 224,
                child: CameraPreview(controller,),
              ),
            ),
            Positioned(
              left: 200,
              top: 300,
              child: Container(
                color: Colors.white,
                width: 200,
                height: 200,
              ),
            )
          ],
        ),
      ),
    );
  }
}
