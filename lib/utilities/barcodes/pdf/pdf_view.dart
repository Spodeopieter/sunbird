// ignore_for_file: library_private_types_in_public_api, depend_on_referenced_packages

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart' as pw;
import 'package:printing/printing.dart';
import 'package:tswiri_database_interface/functions/barcodes/barcode_pdf_generator.dart';

class PdfView extends StatefulWidget {
  const PdfView({
    Key? key,
    required this.barcodeUIDs,
    required this.size,
  }) : super(key: key);

  final List<String> barcodeUIDs;
  final double size;

  @override
  _PdfViewState createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {
  late Future<Uint8List> future = getPDF();
  Uint8List? path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Number : ${widget.barcodeUIDs.length}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder<Uint8List>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return PdfPreview(
              build: ((format) => snapshot.data!),
              pageFormats: const {'A4': pw.PdfPageFormat.a4},
              canChangeOrientation: false,
              canChangePageFormat: false,
              initialPageFormat: pw.PdfPageFormat.a4,
              canDebug: false,
              pdfFileName: 'barcodes_${widget.barcodeUIDs.length}.pdf',
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  ///Retrieve pdf.
  Future<Uint8List> getPDF() async {
    final filePath = await barcodePdfGenerator(
      barcodeUIDs: widget.barcodeUIDs,
      size: widget.size,
    );

    setState(() {
      path = filePath;
    });

    return filePath;
  }
}