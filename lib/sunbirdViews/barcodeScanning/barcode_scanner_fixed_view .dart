import 'package:flutter_google_ml_kit/globalValues/global_colours.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:hive/hive.dart';

import '../../databaseAdapters/allBarcodes/barcode_data_entry.dart';
import '../../functions/dataProccessing/barcode_scanner_data_processing_functions.dart';
import '../../globalValues/global_hive_databases.dart';
import 'cameraView/camera_view_fixed_barcode_scanning.dart';
import 'painter/fixed_barcode_detector_painter.dart';

class BarcodeScannerFixedBarcodesView extends StatefulWidget {
  const BarcodeScannerFixedBarcodesView({Key? key}) : super(key: key);

  @override
  _BarcodeScannerFixedBarcodesViewState createState() =>
      _BarcodeScannerFixedBarcodesViewState();
}

class _BarcodeScannerFixedBarcodesViewState
    extends State<BarcodeScannerFixedBarcodesView> {
  BarcodeScanner barcodeScanner =
      GoogleMlKit.vision.barcodeScanner([BarcodeFormat.qrCode]);

  bool isBusy = false;
  CustomPaint? customPaint;
  int? barcodeID;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Builder(
                builder: (context) {
                  barcodeID ??= 0;
                  return FloatingActionButton(
                    heroTag: null,
                    onPressed: () async {
                      //Ensure list has been fetched.
                      if (allBarcodes != null) {
                        //Get the index of the current barcode.
                        int index = allBarcodes!
                            .indexWhere((element) => element.uid == barcodeID);
                        if (index != -1) {
                          //Get the genrated barcodeData.
                          Box<BarcodeDataEntry> generatedBarcodeData =
                              await Hive.openBox(allBarcodesBoxName);

                          if (allBarcodes![index].isFixed == false) {
                            //Change the isFixed bool to true.
                            allBarcodes![index].isFixed = true;
                            BarcodeDataEntry currentBarcode =
                                generatedBarcodeData.get(barcodeID)!;
                            currentBarcode.isFixed = true;
                            generatedBarcodeData.put(barcodeID, currentBarcode);
                          } else {
                            //Change the isFixed bool to false.
                            allBarcodes![index].isFixed = false;
                            BarcodeDataEntry currentBarcode =
                                generatedBarcodeData.get(barcodeID)!;
                            currentBarcode.isFixed = false;
                            generatedBarcodeData.put(barcodeID, currentBarcode);
                          }
                        }
                      }
                    },
                    child: Text(barcodeID.toString()),
                  );
                },
              ),
              const SizedBox(
                height: 25,
              ),
              FloatingActionButton(
                heroTag: null,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.check_circle_outline_rounded),
              ),
            ],
          ),
        ),
        body: CameraFixedBarcodeScanningView(
          color: brightOrange,
          title: 'Fixed Barcode Scanner',
          customPaint: customPaint,
          onImage: (inputImage) {
            processImage(inputImage);
          },
        ));
  }

  List<BarcodeDataEntry>? allBarcodes;
  Future<void> processImage(InputImage inputImage) async {
    if (isBusy) return;
    isBusy = true;

    //Get the list of generated barcodes.
    allBarcodes ??= await getAllExistingBarcodes();

    final List<Barcode> barcodes =
        await barcodeScanner.processImage(inputImage);

    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null &&
        allBarcodes != null) {
      if (barcodes.isNotEmpty &&
          barcodes.first.value.displayValue != null &&
          mounted) {
        setState(() {
          barcodeID = int.parse(barcodes.first.value.displayValue!);
        });
      }

      //Paint square on screen around barcode.
      final painter = FixedBarcodeDetectorPainter(
          barcodes,
          inputImage.inputImageData!.size,
          inputImage.inputImageData!.imageRotation,
          allBarcodes!);

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
