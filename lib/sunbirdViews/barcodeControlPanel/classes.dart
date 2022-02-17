import 'package:flutter/material.dart';
import 'package:flutter_google_ml_kit/databaseAdapters/tagAdapters/barcode_tag_entry.dart';
import 'package:flutter_google_ml_kit/globalValues/global_hive_databases.dart';
import 'package:hive/hive.dart';

class Tags extends ChangeNotifier {
  Tags(this.assignedTags, this.unassignedTags);
  List<String> assignedTags;
  List<String> unassignedTags;

  Future<void> deleteTag(String tag, int barcodeID) async {
    Box<BarcodeTagEntry> currentTagsBox =
        await Hive.openBox(barcodeTagsBoxName);

    currentTagsBox.delete('${barcodeID}_$tag');

    assignedTags.remove(tag);
    unassignedTags.add(tag);

    notifyListeners();
  }

  Future<void> addTag(String tag, int barcodeID) async {
    Box<BarcodeTagEntry> currentTagsBox =
        await Hive.openBox(barcodeTagsBoxName);

    currentTagsBox.put(
        '${barcodeID}_$tag', BarcodeTagEntry(barcodeID: barcodeID, tag: tag));

    unassignedTags.remove(tag);
    assignedTags.add(tag);
    notifyListeners();
  }

  Future<void> addNewTag(String enteredKeyword) async {
    if (!assignedTags.contains(enteredKeyword) &&
        !unassignedTags.contains(enteredKeyword)) {
      Box<String> tagsBox = await Hive.openBox(tagsBoxName);
      //tagsBox.clear();
      tagsBox.put(enteredKeyword, enteredKeyword);

      unassignedTags.add(enteredKeyword);

      notifyListeners();
    }
  }

  List<String> filter(String enteredKeyword) {
    List<String> filteredUnassignedTags = [];
    if (enteredKeyword.isNotEmpty) {
      filteredUnassignedTags = unassignedTags
          .where((element) =>
              element.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      if (filteredUnassignedTags.isEmpty) {
        return ['+'];
      } else {
        return filteredUnassignedTags;
      }
    } else {
      if (unassignedTags.isEmpty) {
        return ['+'];
      } else {
        return unassignedTags;
      }
    }
  }
}