import 'package:flutter_google_ml_kit/functions/isar_functions/isar_functions.dart';
import 'package:flutter_google_ml_kit/isar_database/tags/tag_text/tag_text.dart';
import 'package:isar/isar.dart';
part 'ml_tag.g.dart';

@Collection()
class MlTag {
  int id = Isar.autoIncrement;

  ///MlTagID.
  late int photoID;

  ///TextTagID.
  late int textID;

  ///Tag Confidence.
  late double confidence;

  ///Blacklisted?
  late bool blackListed;

  ///TagID
  @MlTagTypeConverter()
  late mlTagType tagType;

  @override
  String toString() {
    return '\ntag: ${isarDatabase!.tagTexts.getSync(textID)?.text}, confidence: $confidence, blacklisted: $blackListed, photoID: $photoID';
  }

  Map toJson() => {
        // 'id': id,
        // 'tagID': textTagID,
        // 'tagType': tagType.name,
      };

  // MlTag fromJson(Map<String, dynamic> json) {
  //   return MlTag()
  //     ..id = json['id']
  //     ..textTagID = json['tag']
  //     ..tagType = mlTagType.values.byName(json['tagType']);
  // }
}

enum mlTagType {
  objectLabel,
  imageLabel,
  text,
}

class MlTagTypeConverter extends TypeConverter<mlTagType, int> {
  const MlTagTypeConverter();

  @override
  mlTagType fromIsar(int object) {
    return mlTagType.values[object];
  }

  @override
  int toIsar(mlTagType object) {
    return object.index;
  }
}
