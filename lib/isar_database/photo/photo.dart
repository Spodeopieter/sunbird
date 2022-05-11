import 'package:isar/isar.dart';
part 'photo.g.dart';

@Collection()
class Photo {
  ///ID.
  int id = Isar.autoIncrement;

  ///ContainerUID.
  late String containerUID;

  ///PhotoPath.
  late String photoPath;

  ///PhotoThumbnailPath.
  late String thumbnailPath;

  @override
  String toString() {
    return '\nphotoPath: $photoPath, ';
  }

  // Map toJson() => {
  //       'id': id,
  //       'photoPath': photoPath,
  //     };

  // PhotoTag fromJson(Map<String, dynamic> json) {
  //   return PhotoTag()
  //     ..id = json['id']
  //     ..photoPath = json['photoPath']
  //     ..tagUID = json['tagUID'] as int;
  // }
}