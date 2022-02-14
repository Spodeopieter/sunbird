import 'dart:async';
import 'package:vector_math/vector_math.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_ml_kit/functions/dataInjectors/single_image_inter_barcode_data_extractor.dart';
import 'package:flutter_google_ml_kit/objects/raw_on_image_barcode_data.dart';
import 'package:flutter_google_ml_kit/sunbirdViews/barcodeScanning/barcode_scanner_data_processing.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../../VisionDetectorViews/camera_view.dart';
import 'painter/barcode_detector_painter.dart';
import 'package:provider/provider.dart';

class BarcodeScannerView extends StatefulWidget {
  const BarcodeScannerView({Key? key}) : super(key: key);

  @override
  _BarcodeScannerViewState createState() => _BarcodeScannerViewState();
}

class _BarcodeScannerViewState extends State<BarcodeScannerView> {
  BarcodeScanner barcodeScanner =
      GoogleMlKit.vision.barcodeScanner([BarcodeFormat.qrCode]);

  List<RawOnImageInterBarcodeData> allInterBarcodeData = [];
  bool isBusy = false;
  CustomPaint? customPaint;

  Vector3 accelerometerEvent = Vector3(0, 0, 0);
  Vector3 userAccelerometerEvent = Vector3(0, 0, 0);

  @override
  void initState() {
    accelerometerEvents.listen((AccelerometerEvent event) {
      accelerometerEvent = Vector3(event.x, event.y, event.z);
    });
    userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      userAccelerometerEvent = Vector3(event.x, event.y, event.z);
    });

    super.initState();
  }

  @override
  void dispose() {
    barcodeScanner.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                heroTag: null,
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => BarcodeScannerDataProcessingView(
                          allInterBarcodeData: allInterBarcodeData)));
                },
                child: const Icon(Icons.check_circle_outline_rounded),
              ),
            ],
          ),
        ),
        body: CameraView(
          title: 'Barcode Scanner',
          customPaint: customPaint,
          onImage: (inputImage) {
            processImage(inputImage);
          },
        ));
  }

  phoneAngle() {
    const snackBar = SnackBar(
      content: Text('Yay! A SnackBar!'),
      duration: Duration(milliseconds: 100),
    );

    Vector3 gravityDirection = accelerometerEvent - userAccelerometerEvent;
    print(gravityDirection);

    Vector3 up = Vector3(1, 1, 1);
    double angle = gravityDirection.angleTo(up);
    if ((angle < 0.9 || angle > 1.1)) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  int time = DateTime.now().millisecondsSinceEpoch;

  Future<void> processImage(InputImage inputImage) async {
    if (isBusy) return;
    isBusy = true;
    final List<Barcode> barcodes =
        await barcodeScanner.processImage(inputImage);

    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      //Dont bother if we haven't detected more than one barcode on a image.
      if (barcodes.length >= 2) {
        allInterBarcodeData
            .addAll((singeImageInterBarcodeDataExtractor(barcodes)));
      }
      //Paint square on screen around barcode.
      final painter = BarcodeDetectorPainter(
          barcodes,
          inputImage.inputImageData!.size,
          inputImage.inputImageData!.imageRotation);

      customPaint = CustomPaint(painter: painter);
    } else {
      customPaint = null;
    }
    isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}
