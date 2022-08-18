import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter_archive/flutter_archive.dart';
import 'package:image/image.dart' as img;

Future<void> restoreBackupIsolate(List init) async {
  log('Create backup isolate running');
  //1. InitalMessage.
  SendPort sendPort = init[0]; //[0] SendPort.
  String isarDirectory = init[1]; //[1] Isar Directory.
  String temporaryDirectoryPath = init[2]; //[2] Backup folder.
  String isarVersion = init[3]; //[3] isarVersion.
  String photoDirectoryPath = init[4]; //[4] photoDirectory.
  String selectedFilePath = init[5]; //[5] selectedFilePath.
  String externalStoragePath = init[6]; //[6] externalStoragePath

  //2. Check if database versions match.
  File restoreFile = File(selectedFilePath);

  log(restoreFile.path);
  if (restoreFile.path.split('/').last.split('.').last == 'zip') {
    log('is.zip');
    if (restoreFile.path.split('/').last.split('.').first.split('_').last ==
        'v$isarVersion') {
      log('restoring');

      //Unzip selectedfile.
      Directory temporaryDirectory = Directory(temporaryDirectoryPath);

      Directory unzippedDirectory = Directory(
          '${temporaryDirectory.path}/${restoreFile.path.split('/').last.split('.').first}');

      if (unzippedDirectory.existsSync()) {
        unzippedDirectory.deleteSync(recursive: true);
        unzippedDirectory.createSync();
      } else {
        unzippedDirectory.create();
      }

      final zipFile = restoreFile;
      final destinationDir = unzippedDirectory;
      try {
        await ZipFile.extractToDirectory(
            zipFile: zipFile, destinationDir: destinationDir);
      } catch (e) {
        log(e.toString());
      }

      File restoreDAT = File('${unzippedDirectory.path}/isar/mdbx.dat');
      File restorelLCK = File('${unzippedDirectory.path}/isar/mdbx.lck');

      if (restoreDAT.existsSync() && restorelLCK.existsSync()) {
        log('restoreDAT && restorelLCK');
        //PROCEED

        Directory isarDataFolder = Directory('$isarDirectory/isar');

        Directory photoDirectory = Directory(photoDirectoryPath);

        //Delete these files.
        File('${isarDataFolder.path}/mdbx.dat').deleteSync();
        File('${isarDataFolder.path}/mdbx.lck').deleteSync();

        //Copy restored Files over
        restoreDAT.copySync('${isarDataFolder.path}/mdbx.dat');
        restorelLCK.copySync('${isarDataFolder.path}/mdbx.lck');

        //Delete all photo files.
        photoDirectory.deleteSync(recursive: true);
        String storagePath = '$externalStoragePath/photos';
        photoDirectory = await Directory(storagePath).create();

        //Unzipped Photos.
        Directory unzippedPhotos =
            Directory('${unzippedDirectory.path}/photos');
        var files =
            unzippedPhotos.listSync(recursive: true, followLinks: false);

        //Restore Photos and thumbnails.
        for (var file in files) {
          File photoFile = File(file.path);
          log(photoDirectory.path);
          photoFile.copySync(
              '${photoDirectory.path}/${photoFile.path.split('/').last}');

          String photoName = photoFile.path.split('/').last.split('.').first;
          String extention = photoFile.path.split('/').last.split('.').last;
          String photoThumbnailPath =
              '${photoDirectory.path}/${photoName}_thumbnail.$extention';
          img.Image referenceImage =
              img.decodeJpg(photoFile.readAsBytesSync())!;
          img.Image thumbnailImage = img.copyResize(referenceImage, width: 120);
          File(photoThumbnailPath)
              .writeAsBytesSync(img.encodePng(thumbnailImage));
        }

        sendPort.send([
          'done',
        ]);
      } else {
        sendPort.send([
          'error',
          'file_error',
        ]);
      }
    } else {
      sendPort.send([
        'error',
        'version_error',
      ]);
    }
  } else {
    sendPort.send([
      'error',
      'file_error',
    ]);
  }
}