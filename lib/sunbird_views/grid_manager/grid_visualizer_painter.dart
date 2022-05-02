import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter_google_ml_kit/functions/simple_paint/simple_paint.dart';
import 'package:flutter_google_ml_kit/global_values/barcode_colors.dart';
import 'package:flutter_google_ml_kit/isar_database/container_entry/container_entry.dart';
import 'package:flutter_google_ml_kit/isar_database/container_relationship/container_relationship.dart';
import 'package:flutter_google_ml_kit/functions/isar_functions/isar_functions.dart';

import 'package:flutter_google_ml_kit/objects/display/display_point.dart';
import 'package:flutter_google_ml_kit/objects/navigation/grid_object.dart';

import 'package:isar/isar.dart';
import 'package:flutter_google_ml_kit/isar_database/marker/marker.dart';

class GridVisualizerPainter extends CustomPainter {
  GridVisualizerPainter({
    required this.containerEntry,
    required this.barcodesToDraw,
    required this.markersToDraw,
  });

  ContainerEntry containerEntry;
  List<String> barcodesToDraw;
  List<String> markersToDraw;

  @override
  paint(Canvas canvas, Size size) async {
    GridObject grid = GridObject(originContainer: containerEntry);

    grid.gridPositions;
    grid.getBarcodes;

    List<DisplayPoint> myPoints = grid.displayPoints(size);
    List<Offset> markers = [];
    List<Offset> boxes = [];
    List<Offset> other = [];
    Offset? parent;
    Offset? currentBarcode;

    ContainerEntry currentContainer = isarDatabase!.containerEntrys
        .filter()
        .containerUIDMatches(containerEntry.containerUID)
        .findFirstSync()!;

    ContainerEntry? parentContainerEntry;
    ContainerRelationship? relationship;
    relationship = isarDatabase!.containerRelationships
        .filter()
        .containerUIDMatches(containerEntry.containerUID)
        .findFirstSync();

    if (relationship != null) {
      parentContainerEntry = isarDatabase!.containerEntrys
          .filter()
          .containerUIDMatches(relationship.parentUID!)
          .findFirstSync();
    }

    markersToDraw = [];
    markersToDraw.addAll(isarDatabase!.markers
        .filter()
        .parentContainerUIDMatches(containerEntry.containerUID)
        .barcodeUIDProperty()
        .findAllSync());

    List<ContainerRelationship> relationships = [];
    relationships.addAll(isarDatabase!.containerRelationships
        .filter()
        .parentUIDMatches(containerEntry.containerUID)
        .findAllSync());

    List<ContainerEntry> children = [];
    if (relationships.isNotEmpty) {
      children.addAll(isarDatabase!.containerEntrys
          .filter()
          .repeat(
              relationships,
              (q, ContainerRelationship element) =>
                  q.containerUIDMatches(element.containerUID))
          .findAllSync());
    }

    barcodesToDraw = [];
    barcodesToDraw.addAll(children.map((e) => e.barcodeUID!));

    //log('Children: ' + children.toString());
    for (DisplayPoint point in myPoints) {
      if (barcodesToDraw.contains(point.barcodeID)) {
        boxes.add(point.barcodePosition);
      } else if (markersToDraw.contains(point.barcodeID)) {
        markers.add(point.barcodePosition);
      } else if (parentContainerEntry != null &&
          point.barcodeID == parentContainerEntry.barcodeUID) {
        parent = point.barcodePosition;
      } else {
        other.add(point.barcodePosition);
      }
      if (point.barcodeID == currentContainer.barcodeUID) {
        currentBarcode = point.barcodePosition;
      }
    }

    canvas.drawPoints(PointMode.points, boxes,
        paintEasy(barcodeChildren.withOpacity(0.8), 4));

    canvas.drawPoints(PointMode.points, markers,
        paintEasy(barcodeMarkerColor.withOpacity(0.8), 4));

    canvas.drawPoints(PointMode.points, other,
        paintEasy(barcodeUnkownColor.withOpacity(0.25), 4));

    if (currentBarcode != null) {
      canvas.drawPoints(PointMode.points, [currentBarcode],
          paintEasy(barcodeFocusColor.withOpacity(1), 2));
    }
    if (parent != null) {
      canvas.drawPoints(PointMode.points, [parent],
          paintEasy(barcodeParentColor.withOpacity(1), 2));
    }

    for (DisplayPoint point in myPoints) {
      final textSpan = TextSpan(
          text: point.barcodeID +
              '\n x: ' +
              point.realBarcodePosition[0].toString() +
              '\n y: ' +
              point.realBarcodePosition[1].toString() +
              '\n z: ' +
              point.realBarcodePosition[2].toString(),
          style: TextStyle(
              color: Colors.red[500],
              fontSize: 1.5,
              fontWeight: FontWeight.bold));
      final textPainter = TextPainter(
        textAlign: TextAlign.justify,
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(
        minWidth: 0,
        maxWidth: size.width,
      );

      textPainter.paint(canvas, (point.barcodePosition));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}