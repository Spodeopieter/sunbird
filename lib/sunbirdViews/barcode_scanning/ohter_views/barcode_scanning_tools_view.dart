import 'package:flutter/material.dart';
import 'package:flutter_google_ml_kit/sunbirdViews/barcode_scanning/barcode_value_scanning/barcode_marker_scanner_view.dart';
import 'package:hive/hive.dart';
import '../../../widgets/card_widgets/custom_card_widget.dart';
import '../barcode_position_scanning/real_barcode_position_database_view.dart';

///Displays all barcode scanning tools.
class BarcodeScanningToolsView extends StatefulWidget {
  const BarcodeScanningToolsView({Key? key}) : super(key: key);

  @override
  _BarcodeScanningToolsViewState createState() =>
      _BarcodeScanningToolsViewState();
}

class _BarcodeScanningToolsViewState extends State<BarcodeScanningToolsView> {
  @override
  void initState() {
    Hive.close();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Barcode Scanning Tools',
          style: TextStyle(fontSize: 25),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: GridView.count(
          padding: const EdgeInsets.all(16),
          mainAxisSpacing: 8,
          crossAxisSpacing: 16,
          crossAxisCount: 2,
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            const CustomCard(
              'Select Fixed Barcodes',
              BarcodeMarkerScannerView(),
              Icons.map_outlined,
              featureCompleted: true,
              tileColor: Colors.deepOrange,
            ),
            // const CustomCard(
            //   'Barcode Scanner',
            //   BarcodeScannerView(),
            //   Icons.camera,
            //   featureCompleted: true,
            //   tileColor: Colors.deepOrange,
            // ),
            const CustomCard(
              'Real Barcode Positions',
              RealBarcodePositionDatabaseView(),
              Icons.view_array,
              featureCompleted: true,
              tileColor: Colors.deepOrange,
            ),
            // const CustomCard(
            //   'Visual Data Viewer',
            //   RealBarcodePositionDatabaseVisualizationView(),
            //   Icons.map_outlined,
            //   featureCompleted: true,
            //   tileColor: Colors.deepOrange,
            // ),
          ],
        ),
      ),
    );
  }
}