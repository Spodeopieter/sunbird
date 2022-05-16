import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'camera_view/object_dector_camera_view.dart';

///Displays the cameraView of the object Dectector.
class ObjectDetectorView extends StatefulWidget {
  const ObjectDetectorView({
    Key? key,
    this.customColor,
    required this.containerID,
  }) : super(key: key);

  final Color? customColor;
  final int containerID;

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
      containerID: widget.containerID,
    );
  }
}
