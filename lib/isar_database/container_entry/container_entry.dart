import 'package:isar/isar.dart';
part 'container_entry.g.dart';

@Collection()
class ContainerEntry {
  int id = Isar.autoIncrement;

  late String containerUID;

  late String containerType;

  late String? name;

  late String? description;

  late String? barcodeUID;

  @override
  String toString() {
    return 'UID: $containerUID,\nType: $containerType,\nName: $name,\nDescription: $description,\nBarcodeUID $barcodeUID\n';
  }

  Map toJson() => {
        'id': id,
        'containerUID': containerUID,
        'containerType': containerType,
        'name': name,
        'description': description,
        'barcodeUID': barcodeUID,
      };

  ContainerEntry fromJson(Map<String, dynamic> json) {
    return ContainerEntry()
      ..id = json['id']
      ..containerUID = json['containerUID']
      ..containerType = json['containerType']
      ..name = json['name']
      ..containerType = json['containerType']
      ..description = json['description']
      ..barcodeUID = json['barcodeUID'];
  }
}
