// ignore_for_file: library_private_types_in_public_api

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'camera_view/object_dector_camera_view.dart';

///Displays the cameraView of the object Dectector.
class ObjectDetectorView extends StatefulWidget {
  const ObjectDetectorView({
    Key? key,
    this.customColor,
    required this.containerUID,
  }) : super(key: key);

  final Color? customColor;
  final String containerUID;

  @override
  _ObjectDetectorView createState() => _ObjectDetectorView();
}

class _ObjectDetectorView extends State<ObjectDetectorView> {
  @override
  void initState() {
    super.initState();
  }

  bool isBusy = false;
  CustomPaint? customPaint;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ObjectDetectorCameraView(
      color: widget.customColor ?? Colors.orange,
      title: 'Image Labeling',
      customPaint: customPaint,
      onImage: (inputImage) {},
      initialDirection: CameraLensDirection.back,
      containerUID: widget.containerUID,
    );
  }
}