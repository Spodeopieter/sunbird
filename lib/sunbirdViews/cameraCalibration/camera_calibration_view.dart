import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_google_ml_kit/databaseAdapters/calibrationAdapters/calibration_accelerometer_data_adapter.dart';
import 'package:flutter_google_ml_kit/functions/dataInjectors/barcode_calibration_data_injector.dart';
import 'package:flutter_google_ml_kit/VisionDetectorViews/camera_view.dart';
import 'package:flutter_google_ml_kit/functions/mathfunctions/round_to_double.dart';
import 'package:flutter_google_ml_kit/globalValues/global_hive_databases.dart';
import 'package:flutter_google_ml_kit/sunbirdViews/cameraCalibration/painter/barcode_calibration_painter.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sensors_plus/sensors_plus.dart';

class CameraCalibration extends StatefulWidget {
  const CameraCalibration({Key? key}) : super(key: key);

  @override
  _CameraCalibrationState createState() => _CameraCalibrationState();
}

class _CameraCalibrationState extends State<CameraCalibration> {
  BarcodeScanner barcodeScanner =
      GoogleMlKit.vision.barcodeScanner([BarcodeFormat.qrCode]);

  bool isBusy = false;
  CustomPaint? customPaint;
  int timestamp = DateTime.now().millisecondsSinceEpoch;
  double zAcceleration = 0;
  double distanceMoved = 0;
  int deltaT = 0;
  late StreamSubscription<UserAccelerometerEvent> subscription;

  @override
  void initState() {
    distanceMoved = 0;
    subscription =
        userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      deltaT = DateTime.now().millisecondsSinceEpoch - timestamp;
      if (zAcceleration <= 0) {
        distanceMoved = deltaT * 1000 * zAcceleration / 10000 + distanceMoved;
      }

      zAcceleration = roundDouble(event.z, 4);
    });
    super.initState();
  }

  @override
  void dispose() {
    barcodeScanner.close();
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FloatingActionButton(
                heroTag: null,
                onPressed: () async {
                  var calibrationDataBox =
                      await Hive.openBox(calibrationDataHiveBox);
                  calibrationDataBox.clear();
                  setState(() {});
                },
                child: const Icon(Icons.delete),
              ),
              FloatingActionButton(
                heroTag: null,
                onPressed: () async {
                  setState(() {});
                },
                child: const Icon(Icons.refresh),
              ),
            ],
          ),
        ),
        body: CameraView(
          title: 'Camera Calibration',
          customPaint: customPaint,
          onImage: (inputImage) {
            processImage(inputImage);
          },
        ));
  }

  Future<void> processImage(InputImage inputImage) async {
    if (isBusy) return;
    isBusy = true;
    final barcodes = await barcodeScanner.processImage(inputImage);
    var calibrationDataBox = await Hive.openBox(calibrationDataHiveBox);
    var accelerometerDataBox = await Hive.openBox(accelerometerDataHiveBox);

    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      final painter = BarcodeDetectorPainterCalibration(
          barcodes,
          inputImage.inputImageData!.size,
          inputImage.inputImageData!.imageRotation);

      customPaint = CustomPaint(painter: painter);

      timestamp = DateTime.now().millisecondsSinceEpoch;
      CalibrationAccelerometerDataHiveObject accelerometerDataInstance =
          CalibrationAccelerometerDataHiveObject(
              timestamp: timestamp,
              deltaT: deltaT,
              accelerometerData: zAcceleration,
              distanceMoved: roundDouble(distanceMoved, 5).abs());

      accelerometerDataBox.put(timestamp.toString(), accelerometerDataInstance);
    } else {
      customPaint = null;
    }
    isBusy = false;
    if (mounted) {
      setState(() {
        injectBarcodeSizeData(
          context,
          barcodes,
          inputImage.inputImageData!.size,
          inputImage.inputImageData!.imageRotation,
          calibrationDataBox,
        );
      });
    }
  }
}