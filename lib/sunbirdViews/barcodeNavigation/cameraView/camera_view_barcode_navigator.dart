// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
//import 'package:image_picker/image_picker.dart';

import '../../../sunbird_views/app_settings/app_settings.dart';
import '../../../main.dart';

enum ScreenMode { liveFeed, gallery }

class CameraBarcodeNavigationView extends StatefulWidget {
  const CameraBarcodeNavigationView(
      {Key? key,
      required this.title,
      required this.customPaint,
      required this.onImage,
      this.initialDirection = CameraLensDirection.back})
      : super(key: key);

  final String title;
  final CustomPaint? customPaint;
  final Function(InputImage inputImage) onImage;
  final CameraLensDirection initialDirection;

  @override
  _CameraBarcodeNavigationViewState createState() =>
      _CameraBarcodeNavigationViewState();
}

class _CameraBarcodeNavigationViewState
    extends State<CameraBarcodeNavigationView> {
  CameraController? _controller;
  int _cameraIndex = 0;
  double zoomLevel = 0.0, minZoomLevel = 0.0, maxZoomLevel = 0.0;
  bool flash = false;

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < cameras.length; i++) {
      if (cameras[i].lensDirection == widget.initialDirection) {
        _cameraIndex = i;
      }
    }
    _startLiveFeed();
  }

  @override
  void dispose() {
    _stopLiveFeed();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.deepOrange,
      ),
      body: _body(),
      floatingActionButton: _floatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  Widget? _floatingActionButton() {
    if (cameras.length == 1) return null;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        FloatingActionButton(
          backgroundColor: Colors.deepOrange,
          heroTag: 'flash',
          child: Icon(
            Platform.isIOS
                ? Icons.flip_camera_ios_outlined
                : Icons.flash_on_rounded,
          ),
          onPressed: () {
            if (flash == true) {
              _controller!.setFlashMode(FlashMode.off);
              flash = false;
            } else {
              flash = true;
              _controller!.setFlashMode(FlashMode.torch);
            }
          },
        ),
        // Padding(
        //   padding: const EdgeInsets.only(left: 16, right: 16),
        //   child: SizedBox(
        //     height: 70.0,
        //     width: 70.0,
        //     child: FloatingActionButton(
        //       backgroundColor: limeGreen,
        //       heroTag: 'camera selection',
        //       child: Icon(
        //         Platform.isIOS
        //             ? Icons.flip_camera_ios_outlined
        //             : Icons.flip_camera_android_outlined,
        //         size: 30,
        //       ),
        //       onPressed: _switchLiveCamera,
        //     ),
        //   ),
        // ),
        // const SizedBox(
        //   width: 86,
        // ),
      ],
    );
  }

  Widget _body() {
    Widget body;

    body = _liveFeedBody();

    return body;
  }

  Widget _liveFeedBody() {
    if (_controller?.value.isInitialized == false) {
      return Container();
    }
    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          CameraPreview(_controller!),
          if (widget.customPaint != null) widget.customPaint!,
        ],
      ),
    );
  }

  Future _startLiveFeed() async {
    final camera = cameras[_cameraIndex];
    _controller = CameraController(
      camera,
      cameraResolution!,
      enableAudio: false,
    );
    await _controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      _controller?.getMinZoomLevel().then((value) {
        zoomLevel = value;
        minZoomLevel = value;
      });
      _controller?.getMaxZoomLevel().then((value) {
        maxZoomLevel = value;
      });
      _controller?.startImageStream(_processCameraImage);
      setState(() {});
    });
  }

  Future _stopLiveFeed() async {
    await _controller?.stopImageStream();
    await _controller?.dispose();
    _controller = null;
  }

  Future _processCameraImage(CameraImage image) async {
    final WriteBuffer allBytes = WriteBuffer();
    for (Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize =
        Size(image.width.toDouble(), image.height.toDouble());

    final camera = cameras[_cameraIndex];
    final imageRotation =
        InputImageRotationMethods.fromRawValue(camera.sensorOrientation) ??
            InputImageRotation.Rotation_0deg;
    //print(camera.sensorOrientation);

    final inputImageFormat =
        InputImageFormatMethods.fromRawValue(image.format.raw) ??
            InputImageFormat.NV21;

    final planeData = image.planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );

    final inputImage =
        InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);

    widget.onImage(inputImage);
  }
}
