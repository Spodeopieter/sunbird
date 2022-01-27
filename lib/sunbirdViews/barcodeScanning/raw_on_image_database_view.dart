import 'package:flutter/material.dart';
import 'package:flutter_google_ml_kit/databaseAdapters/on_image_inter_barcode_data.dart';
import 'package:flutter_google_ml_kit/functions/dataManipulation/process_raw_data.dart';
import 'package:flutter_google_ml_kit/functions/round_to_double.dart';
import 'package:hive/hive.dart';

class RawOnImageDatabaseView extends StatefulWidget {
  const RawOnImageDatabaseView({Key? key}) : super(key: key);

  @override
  _RawOnImageDatabaseViewState createState() => _RawOnImageDatabaseViewState();
}

class _RawOnImageDatabaseViewState extends State<RawOnImageDatabaseView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hive Database'),
        centerTitle: true,
        elevation: 0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              heroTag: null,
              onPressed: () async {
                var processedDataBox = await Hive.openBox('processedDataBox');
                var rawDataBox = await Hive.openBox('rawDataBox');
                processedDataBox.clear();
                rawDataBox.clear();

                setState(() {});
              },
              child: const Icon(Icons.delete),
            ),
          ],
        ),
      ),
      body: FutureBuilder<List>(
        future: loadData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          } else {
            List myList = snapshot.data ?? [];
            return ListView.builder(
                itemCount: myList.length,
                itemBuilder: (context, index) {
                  var text = myList[index]
                      .toString()
                      .replaceAll(RegExp(r'\[|\]'), '')
                      .replaceAll(' ', '')
                      .split(',')
                      .toList();

                  if (index == 0) {
                    return Column(
                      children: <Widget>[
                        displayDataPoint(
                            ['UID 1', 'UID 2', 'X', 'Y', 'Timestamp']),
                        const SizedBox(
                          height: 5,
                        ),
                        displayDataPoint(text),
                      ],
                    );
                  } else {
                    return displayDataPoint(text);
                  }
                });
          }
        },
      ),
    );
  }

  Future<List> loadData() async {
    var rawOnImageDataBox = await Hive.openBox('rawDataBox');
    var consolidatedDataBox = await Hive.openBox('consolidatedDataBox');
    var lookupTable = await Hive.openBox('matchedDataBox');
    print(lookupTable.toMap());
    Map rawOnImageDataMap = rawOnImageDataBox.toMap();

    processRawOnImageData(rawOnImageDataMap, consolidatedDataBox, lookupTable);

    return _displayList(rawOnImageDataBox);
  }
}

List _displayList(Box onImageDataBox) {
  var displayList = [];
  var rawDataMap = onImageDataBox.toMap();
  rawDataMap.forEach((key, value) {
    OnImageInterBarcodeData data = value;
    List vectorData = [
      value.uidStart,
      value.uidEnd,
      roundDouble(data.interBarcodeOffset.x, 4),
      roundDouble(data.interBarcodeOffset.y, 4),
      value.timestamp
    ];
    displayList.add(vectorData);
  });
  return displayList;
}

displayDataPoint(var myText) {
  return Column(
    children: [
      const SizedBox(
        height: 3,
      ),
      Container(
        decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Colors.deepOrange),
                top: BorderSide(color: Colors.deepOrange),
                left: BorderSide(color: Colors.deepOrange),
                right: BorderSide(color: Colors.deepOrange))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          textDirection: TextDirection.ltr,
          children: [
            Container(
              decoration: const BoxDecoration(
                  border: Border(right: BorderSide(color: Colors.deepOrange))),
              child: SizedBox(
                child: Text(myText[0], textAlign: TextAlign.center),
                width: 35,
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                  border: Border(right: BorderSide(color: Colors.deepOrange))),
              child: SizedBox(
                child: Text(myText[1], textAlign: TextAlign.center),
                width: 35,
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                  border: Border(right: BorderSide(color: Colors.deepOrange))),
              child: SizedBox(
                child: Text(myText[2], textAlign: TextAlign.center),
                width: 75,
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                  border: Border(right: BorderSide(color: Colors.deepOrange))),
              child: SizedBox(
                child: Text(myText[3], textAlign: TextAlign.center),
                width: 75,
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                  border: Border(right: BorderSide(color: Colors.deepOrange))),
              child: SizedBox(
                child: Text(myText[4], textAlign: TextAlign.center),
                width: 125,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}