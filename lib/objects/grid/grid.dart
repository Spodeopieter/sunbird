import 'package:flutter_google_ml_kit/functions/isar_functions/isar_functions.dart';
import 'package:flutter_google_ml_kit/isar_database/containers/container_entry/container_entry.dart';
import 'package:flutter_google_ml_kit/isar_database/containers/container_relationship/container_relationship.dart';
import 'package:flutter_google_ml_kit/objects/grid/positional_grid.dart';
import 'package:isar/isar.dart';

class Grid {
  ///Generate all Positional Grids.
  ///These are grids with more than 1 valid position.
  List<PositionalGrid> get positionalGrids {
    List<ContainerEntry> allContainers =
        isarDatabase!.containerEntrys.where().findAllSync();

    List<ContainerRelationship> containerRelationShips =
        isarDatabase!.containerRelationships.where().findAllSync();

    List<ContainerEntry> containerWithMoreThanOneChild = [];

    for (var container in allContainers) {
      if (containerRelationShips
          .where((element) => element.parentUID == container.containerUID)
          .isNotEmpty) {
        containerWithMoreThanOneChild.add(container);
      }
    }

    List<PositionalGrid> usefullGrids = [];

    for (var container in containerWithMoreThanOneChild) {
      PositionalGrid positionalGrid =
          PositionalGrid(originContainer: container);

      int markers = positionalGrid.markers.length;
      int usefull = 0;
      for (var position in positionalGrid.gridPositions) {
        if (position.position != null) {
          usefull++;
        }
      }
      if (usefull > markers) {
        usefullGrids.add(positionalGrid);
      }
    }

    return usefullGrids;
  }

  ///Identify HigherContainers.
  ///Parents containers are containers that dont have parents.
  List<ContainerEntry> parents() {
    //Higher containers are containers that dont have parents.
    List<ContainerEntry> allContainers =
        isarDatabase!.containerEntrys.where().findAllSync();

    List<ContainerRelationship> containerRelationShips =
        isarDatabase!.containerRelationships.where().findAllSync();

    List<ContainerEntry> higherContainers = [];
    for (var container in allContainers) {
      //Checks if a container has a parent.
      if (!containerRelationShips
          .any((element) => element.containerUID == container.containerUID)) {
        higherContainers.add(container);
      }
    }

    return higherContainers;
  }
}
