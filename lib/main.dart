// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_ml_kit/database/calibration_data_adapter.dart';
import 'package:flutter_google_ml_kit/database/consolidated_data_adapter.dart';
import 'package:flutter_google_ml_kit/qr_scanning_tools_view%20copy.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'camera_calibration_view.dart';
import 'database/accelerometer_data_adapter.dart';
import 'database/matched_calibration_data_adapter.dart';
import 'database/raw_data_adapter.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();
  //await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(const MyApp());

  var status = await Permission.storage.status;
  if (status.isDenied) {
    Permission.storage.request();
  }
  final directory = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(directory.path);
  Hive.registerAdapter(RelativeQrCodesAdapter());
  Hive.registerAdapter(ConsolidatedDataAdapter());
  Hive.registerAdapter(CalibrationDataAdapter());
  Hive.registerAdapter(AccelerometerDataAdapter());
  Hive.registerAdapter(LinearCalibrationDataAdapter());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.deepOrange[500],
          appBarTheme: AppBarTheme(
            //foregroundColor: Colors.deepOrange[900],
            backgroundColor: Colors.deepOrange[500],
          ),
          buttonTheme: const ButtonThemeData(
            buttonColor: Colors.deepOrangeAccent,
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
              foregroundColor: Colors.black,
              backgroundColor: Colors.deepOrange)),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
//TODO: Implement navigator 2.0 => This is acceptable for now @Spodeopieter

class Home extends StatelessWidget {
  @override
  build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sunbird',
          style: TextStyle(fontSize: 25),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: GridView.count(
          padding: EdgeInsets.all(16),
          mainAxisSpacing: 8,
          crossAxisSpacing: 16,
          crossAxisCount: 2,
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            CustomCard('Qr Code Tools', QrCodeScanningView(), Icons.qr_code,
                featureCompleted: true),
            CustomCard('Camera Calibration Tools', CameraCalibrationView(),
                Icons.camera_alt,
                featureCompleted: true),
          ],
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final String _label;
  final Widget _viewPage;
  final bool featureCompleted;
  final IconData _icon;

  // ignore: use_key_in_widget_constructors
  const CustomCard(this._label, this._viewPage, this._icon,
      {this.featureCompleted = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: Colors.transparent,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        tileColor: Theme.of(context).primaryColor,
        title: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _label,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Icon(
                  _icon,
                  color: Colors.white,
                  size: 45,
                ),
              )
            ],
          ),
        ),
        onTap: () {
          if (Platform.isIOS && !featureCompleted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content:
                    Text('This feature has not been implemented for iOS yet')));
          } else {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => _viewPage));
          }
        },
      ),
    );
  }
}
// CustomCard(
//   //Possible use
//   ' Image Label Detector',
//   ImageLabelView(),
//   featureCompleted: true,
// ),
// CustomCard(
//   ' Text Detector',
//   TextDetectorView(),
//   featureCompleted: true,
// ),
// CustomCard(
//   ' Object Detector',
//   ObjectDetectorView(),
// ),
// CustomCard(
//   ' Remote Model Manager',
//   RemoteModelView(),
//   featureCompleted: true,
// ),
