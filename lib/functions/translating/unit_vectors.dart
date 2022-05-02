import 'package:flutter_google_ml_kit/objects/navigation/grid_position.dart';

List<double> unitVectors(
    {required List<GridPosition> realBarcodePositions,
    required double width,
    required double height}) {
  double sX = 0;
  double bX = 0;
  double sY = 0;
  double bY = 0;

  for (var i = 0; i < realBarcodePositions.length; i++) {
    GridPosition realBarcodePosition = realBarcodePositions.elementAt(i);
    if (realBarcodePosition.position != null) {
      if (realBarcodePosition.position != null) {
        double xDistance = realBarcodePosition.position!.x;
        double yDistance = realBarcodePosition.position!.y;
        if (xDistance < sX) {
          sX = xDistance;
        }
        if (xDistance > bX) {
          bX = xDistance;
        }
        if (yDistance < sY) {
          sY = yDistance;
        }
        if (yDistance > bY) {
          bY = yDistance;
        }
      } else {
        return [0, 0];
      }
    }
  }

  double totalXdistance = (sX - bX).abs() + 500;
  double totalYdistance = (sY - bY).abs() + 500;

  double unitX = width / 2 / totalXdistance;
  double unitY = height / 2 / totalYdistance;

  return [unitX, unitY];
}