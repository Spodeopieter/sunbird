import 'package:flutter/material.dart';
import 'package:flutter_google_ml_kit/globalValues/isar_dir.dart';
import 'package:flutter_google_ml_kit/isar_database/barcode_generation_entry/barcode_generation_entry.dart';
import 'package:flutter_google_ml_kit/isar_database/barcode_property/barcode_property.dart';
import 'package:flutter_google_ml_kit/isar_database/barcode_size_distance_entry/barcode_size_distance_entry.dart';
import 'package:flutter_google_ml_kit/isar_database/container_photo/container_photo.dart';
import 'package:flutter_google_ml_kit/isar_database/container_photo_thumbnail/container_photo_thumbnail.dart';
import 'package:flutter_google_ml_kit/isar_database/container_relationship/container_relationship.dart';
import 'package:flutter_google_ml_kit/isar_database/container_tag/container_tag.dart';
import 'package:flutter_google_ml_kit/isar_database/container_type/container_type.dart';
import 'package:flutter_google_ml_kit/isar_database/marker/marker.dart';
import 'package:flutter_google_ml_kit/isar_database/ml_tag/ml_tag.dart';
import 'package:flutter_google_ml_kit/isar_database/photo_tag/photo_tag.dart';
import 'package:flutter_google_ml_kit/isar_database/real_interbarcode_vector_entry/real_interbarcode_vector_entry.dart';
import 'package:flutter_google_ml_kit/isar_database/tag/tag.dart';
import 'package:isar/isar.dart';
import '../container_entry/container_entry.dart';

Isar? isarDatabase;

Isar openIsar() {
  Isar isar = Isar.openSync(
    schemas: [
      ContainerEntrySchema,
      ContainerRelationshipSchema,
      ContainerTypeSchema,
      MarkerSchema,
      TagSchema,
      ContainerTagSchema,
      ContainerPhotoSchema,
      BarcodePropertySchema,
      BarcodeGenerationEntrySchema,
      MlTagSchema,
      PhotoTagSchema,
      RealInterBarcodeVectorEntrySchema,
      BarcodeSizeDistanceEntrySchema,
      ContainerPhotoThumbnailSchema,
    ],
    directory: isarDirectory!.path,
    inspector: true,
  );
  return isar;
}

void createBasicContainerTypes() {
  isarDatabase!.writeTxnSync(
    (database) {
      database.containerTypes.putSync(
          ContainerType()
            ..id = 1
            ..containerType = 'area'
            ..canContain = ['shelf', 'box', 'drawer']
            ..structured = false
            ..containerColor = const Color(0xFFff420e).value.toString()
            ..canBeOrigin = true,
          replaceOnConflict: true);

      database.containerTypes.putSync(
          ContainerType()
            ..id = 2
            ..containerType = 'shelf'
            ..canContain = ['box', 'drawer']
            ..structured = true
            ..containerColor = const Color(0xFF89da59).value.toString()
            ..canBeOrigin = true,
          replaceOnConflict: true);

      database.containerTypes.putSync(
          ContainerType()
            ..id = 3
            ..containerType = 'drawer'
            ..canContain = ['box', 'shelf']
            ..structured = false
            ..containerColor = Colors.blue.value.toString()
            ..canBeOrigin = false,
          replaceOnConflict: true);

      database.containerTypes.putSync(
          ContainerType()
            ..id = 4
            ..containerType = 'box'
            ..canContain = ['box', 'shelf']
            ..structured = false
            ..containerColor = Color(0xFFF98866).value.toString()
            ..canBeOrigin = false,
          replaceOnConflict: true);
    },
  );
}

Isar? closeIsar(Isar? database) {
  if (database != null) {
    //   if (database.isOpen) {
    database.close();
    return null;
    //   }
  }
  return null;
}

///Get containerTypeColor from containerUID.
Color getContainerColor({required String containerUID}) {
  String containerType = isarDatabase!.containerEntrys
      .filter()
      .containerUIDMatches(containerUID)
      .findFirstSync()!
      .containerType;

  Color containerTypeColor = Color(int.parse(isarDatabase!.containerTypes
          .filter()
          .containerTypeMatches(containerType)
          .findFirstSync()!
          .containerColor))
      .withOpacity(1);

  return containerTypeColor;
}

///Get containerEntry from containerUID
ContainerEntry getContainerEntry({required String containerUID}) {
  return isarDatabase!.containerEntrys
      .filter()
      .containerUIDMatches(containerUID)
      .findFirstSync()!;
}
