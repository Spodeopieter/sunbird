import 'package:flutter/material.dart';
import 'package:flutter_google_ml_kit/VisionDetectorViews/camera_view.dart';
import 'package:flutter_google_ml_kit/databaseAdapters/scanningAdapters/real_barocode_position_entry.dart';
import 'package:flutter_google_ml_kit/globalValues/global_colours.dart';
import 'package:flutter_google_ml_kit/globalValues/global_hive_databases.dart';
import 'package:flutter_google_ml_kit/sunbirdViews/barcodeNavigation/painter/barcode_navigation_painter.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:hive/hive.dart';

class BarcodeCameraNavigatorView extends StatefulWidget {
  final String qrcodeID;
  const BarcodeCameraNavigatorView({Key? key, required this.qrcodeID})
      : super(key: key);

  @override
  _BarcodeCameraNavigatorViewState createState() =>
      _BarcodeCameraNavigatorViewState();
}

class _BarcodeCameraNavigatorViewState
    extends State<BarcodeCameraNavigatorView> {
  BarcodeScanner barcodeScanner =
      GoogleMlKit.vision.barcodeScanner([BarcodeFormat.qrCode]);

  bool isBusy = false;
  CustomPaint? customPaint;

  Map<String, Offset> consolidatedData = {};

  @override
  void initState() {
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
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [],
          ),
        ),
        body: CameraView(
          color: limeGreenMuted,
          title: 'Barcode Finder',
          customPaint: customPaint,
          onImage: (inputImage) {
            processImage(inputImage);
          },
        ));
  }

  Future<void> processImage(InputImage inputImage) async {
    Box<RealBarcodePostionEntry> consolidatedDataBox =
        await Hive.openBox(realPositionDataBoxName);
    if (consolidatedDataBox.isNotEmpty) {
      consolidatedData = getConsolidatedData(consolidatedDataBox);

      if (isBusy) return;
      isBusy = true;
      final barcodes = await barcodeScanner.processImage(inputImage);

      if (inputImage.inputImageData?.size != null &&
          inputImage.inputImageData?.imageRotation != null) {
        final painter = BarcodeDetectorPainterNavigation(
            barcodes,
            inputImage.inputImageData!.size,
            inputImage.inputImageData!.imageRotation,
            consolidatedData,
            widget.qrcodeID);
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

  Map<String, Offset> getConsolidatedData(Box consolidatedData) {
    Map map = consolidatedData.toMap();
    Map<String, Offset> mapConsolidated = {};
    map.forEach((key, value) {
      RealBarcodePostionEntry data = value;
      mapConsolidated.update(
        key,
        (value) => Offset(data.offset.x, data.offset.y),
        ifAbsent: () => Offset(data.offset.x, data.offset.y),
      );
    });
    return mapConsolidated;
  }
}