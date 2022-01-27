import 'dart:io';
import 'dart:ui';
import 'package:google_ml_kit/google_ml_kit.dart';

double translateXOnimage(
    double x, InputImageRotation rotation, Size absoluteImageSize) {
  switch (rotation) {
    case InputImageRotation.Rotation_90deg:
      return x * 1 / absoluteImageSize.width;
    case InputImageRotation.Rotation_270deg:
      return 1 -
          x *
              1 /
              (Platform.isIOS
                  ? absoluteImageSize.width
                  : absoluteImageSize.height);
    default:
      return x * 1 / absoluteImageSize.height;
  }
}

double translateYOnImage(
    double y, InputImageRotation rotation, Size absoluteImageSize) {
  switch (rotation) {
    case InputImageRotation.Rotation_90deg:
    case InputImageRotation.Rotation_270deg:
      return -y * 1 / absoluteImageSize.width;
    default:
      return y * 1 / absoluteImageSize.height;
  }
}
