import 'package:hive/hive.dart';
part 'calibration_data_adapter.g.dart';

@HiveType(typeId: 2)
class CalibrationData extends HiveObject {
  CalibrationData({
    required this.X,
    required this.Y,
    required this.AccelerometerDataZ,
    required this.timestamp,
  });

  @HiveField(0)
  late double X;

  @HiveField(1)
  late double Y;

  @HiveField(2)
  late double AccelerometerDataZ;

  @HiveField(3)
  late int timestamp;

  getList() {
    return [X, Y, AccelerometerDataZ, timestamp];
  }

  @override
  String toString() {
    return '$X, $Y, $AccelerometerDataZ, $timestamp';
  }
}
