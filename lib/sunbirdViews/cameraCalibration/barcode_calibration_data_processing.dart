import 'package:flutter/material.dart';
import 'package:flutter_google_ml_kit/databaseAdapters/calibrationAdapters/matched_calibration_data_adapter.dart';
import 'package:flutter_google_ml_kit/globalValues/global_colours.dart';
import 'package:flutter_google_ml_kit/globalValues/global_hive_databases.dart';
import 'package:flutter_google_ml_kit/objects/calibration/accelerometer_data_objects.dart';
import 'package:flutter_google_ml_kit/objects/calibration/barcode_size_objects.dart';
import 'package:hive/hive.dart';

import 'calibration_data_visualizer_view.dart';

class BarcodeCalibrationDataProcessingView extends StatefulWidget {
  const BarcodeCalibrationDataProcessingView(
      {Key? key,
      required this.rawBarcodeData,
      required this.rawAccelerometerData})
      : super(key: key);

  final List<BarcodeData> rawBarcodeData;
  final List<RawAccelerometerData> rawAccelerometerData;

  @override
  _BarcodeCalibrationDataProcessingViewState createState() =>
      _BarcodeCalibrationDataProcessingViewState();
}

class _BarcodeCalibrationDataProcessingViewState
    extends State<BarcodeCalibrationDataProcessingView> {
  List<MatchedCalibrationDataHiveObject> displayList = [];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
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
                    builder: (context) => const CalibrationDataVisualizerView()));
              },
              child: const Icon(Icons.check_circle_outline_rounded),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Processing Calibration Data'),
      ),
      body: Center(
        child: FutureBuilder<List>(
          future:
              processData(widget.rawBarcodeData, widget.rawAccelerometerData),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            } else {
              List myList = snapshot.data!;
              return ListView.builder(
                  itemCount: myList.length,
                  itemBuilder: (context, index) {
                    MatchedCalibrationDataHiveObject data = myList[index];

                    if (index == 0) {
                      return Column(
                        children: <Widget>[
                          displayDataHeader(
                              ['Barcode Size', 'Distance from Camera']),
                          const SizedBox(
                            height: 5,
                          ),
                          displayDataPoint(data),
                        ],
                      );
                    } else {
                      return displayDataPoint(data);
                    }
                  });
            }
          },
        ),
      ),
    );
  }

  Future<List<MatchedCalibrationDataHiveObject>> processData(
      List<BarcodeData> rawBarcodesData,
      List<RawAccelerometerData> rawAccelerometData) async {
    if (rawAccelerometData.isNotEmpty && rawBarcodesData.isNotEmpty) {
      //Box to store valid calibration Data
      Box matchedDataHiveBox = await Hive.openBox(matchedDataHiveBoxName);

      //A list of all barcode Sizes captured.
      List<OnImageBarcodeSize> onImageBarcodeSizes =
          getOnImageBarcodeSizes(rawBarcodesData);

      //Get range of relevant rawAccelerometer data
      List<RawAccelerometerData> relevantRawAccelerometData =
          getRelevantRawAccelerometerData(
              rawAccelerometData,
              onImageBarcodeSizes.first.timestamp,
              onImageBarcodeSizes.last.timestamp);

      //List that contains processed accelerometer data.
      List<ProcessedAccelerometerData> processedAccelerometerData = [];

      //Set the starting distance as 0
      processedAccelerometerData.add(ProcessedAccelerometerData(
          timestamp: rawAccelerometData.first.timestamp,
          barcodeDistanceFromCamera: 0));

      //Used to keep track of total distance from barcode.
      double totalDistanceMoved = 0;

      //ListA(distanceMoved,timestamp) , ListB(Barcode,timestamp) 

      //Processing rawAccelerometer Data.
      //Take backward direction as positive
      for (int i = 1; i < relevantRawAccelerometData.length; i++) {
        int deltaT = relevantRawAccelerometData[i].timestamp -
            relevantRawAccelerometData[i - 1].timestamp;

        if (checkMovementDirection(
            totalDistanceMoved, relevantRawAccelerometData, i, deltaT)) {
          totalDistanceMoved = totalDistanceMoved +
              (-relevantRawAccelerometData[i].rawAcceleration * deltaT);

          processedAccelerometerData.add(ProcessedAccelerometerData(
              timestamp: rawAccelerometData[i].timestamp,
              barcodeDistanceFromCamera: totalDistanceMoved));
        }
      }

      //Matches OnImageBarcodeSize and DistanceFromCamera using timestamps and writes to Hive Database
      for (OnImageBarcodeSize onImageBarcodeSize in onImageBarcodeSizes) {
        //Find the firts accelerometer data where the timestamp is >= to the OnImageBarcodeSize timestamp
        int distanceFromCameraIndex = processedAccelerometerData.indexWhere(
            (element) => onImageBarcodeSize.timestamp <= element.timestamp);

        //Checks that entry exists
        if (distanceFromCameraIndex != -1) {
          //Creates an entry in the Hive Database.
          MatchedCalibrationDataHiveObject matchedCalibrationDataHiveObject =
              MatchedCalibrationDataHiveObject(
                  objectSize: onImageBarcodeSize.averageBarcodeDiagonalLength,
                  distance: processedAccelerometerData[distanceFromCameraIndex]
                      .barcodeDistanceFromCamera);
          matchedDataHiveBox.put(onImageBarcodeSize.timestamp.toString(),
              matchedCalibrationDataHiveObject);

          displayList.add(matchedCalibrationDataHiveObject);
        }
      }
      matchedDataHiveBox.close();
    }
    return displayList;
  }
}

///Check that the movement is away from the barcode
bool checkMovementDirection(double totalDistanceMoved,
    List<RawAccelerometerData> relevantRawAccelerometData, int i, int deltaT) {
  return totalDistanceMoved <=
      totalDistanceMoved +
          (-relevantRawAccelerometData[i].rawAcceleration * deltaT);
}

//Get rawAccelerationData that falls in the timerange of the scanned Barcodes
List<RawAccelerometerData> getRelevantRawAccelerometerData(
    List<RawAccelerometerData> allRawAccelerometData,
    int timeRangeStart,
    int timeRangeEnd) {
  //Sort rawAccelerometerData by timestamp descending.
  allRawAccelerometData.sort((a, b) => a.timestamp.compareTo(b.timestamp));

  //The +10 includes a couple of extra measurements.
  return allRawAccelerometData
      .where((element) =>
          element.timestamp >= timeRangeStart &&
          element.timestamp + 10 <= timeRangeEnd)
      .toList();
}

//Returns all OnImageBarcodeSizes (timestamp, averageBarcodeDiagonalLength)
List<OnImageBarcodeSize> getOnImageBarcodeSizes(
    List<BarcodeData> rawBarcodesData) {
  List<OnImageBarcodeSize> onImageBarcodeSizes = [];
  for (BarcodeData rawBarcodeData in rawBarcodesData) {
    onImageBarcodeSizes.add(OnImageBarcodeSize(
        timestamp: rawBarcodeData.timestamp,
        averageBarcodeDiagonalLength:
            rawBarcodeData.averageBarcodeDiagonalLength));
  }

  return onImageBarcodeSizes;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//TODO: make this a object so that you can pass different things into it
displayDataPoint(MatchedCalibrationDataHiveObject dataObject) {
  return Center(
    child: Container(
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(color: deepSpaceSparkle),
              top: BorderSide(color: deepSpaceSparkle),
              left: BorderSide(color: deepSpaceSparkle),
              right: BorderSide(color: deepSpaceSparkle))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
                border: Border(right: BorderSide(color: deepSpaceSparkle))),
            child: Padding(
              padding: const EdgeInsets.only(right: 10, left: 10),
              child: SizedBox(
                child: Text(dataObject.objectSize.toString(),
                    textAlign: TextAlign.start),
                width: 150,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: SizedBox(
              child: Text(dataObject.distance.toString(),
                  textAlign: TextAlign.start),
              width: 150,
            ),
          ),
        ],
      ),
    ),
  );
}

displayDataHeader(List dataObject) {
  return Center(
    child: Container(
      decoration: const BoxDecoration(
          color: deepSpaceSparkle,
          border: Border(
              bottom: BorderSide(color: deepSpaceSparkle),
              top: BorderSide(color: deepSpaceSparkle),
              left: BorderSide(color: deepSpaceSparkle),
              right: BorderSide(color: deepSpaceSparkle))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
                border: Border(right: BorderSide(color: Colors.white))),
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: SizedBox(
                child: Text(dataObject[0], textAlign: TextAlign.start),
                width: 150,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: SizedBox(
              child: Text(dataObject[1], textAlign: TextAlign.start),
              width: 150,
            ),
          ),
        ],
      ),
    ),
  );
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////