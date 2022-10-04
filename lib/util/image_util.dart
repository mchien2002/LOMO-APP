import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:lomo/libraries/photo_manager/photo_provider.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:video_compress/video_compress.dart';

Future<Uint8List?> getUint8ListCompressImage(
    Uint8List u8List, int width, int height, int quality) async {
  final result = await FlutterImageCompress.compressWithList(u8List,
      quality: quality, minWidth: width, minHeight: height);
  return result;
}

Future<PhotoInfo> compressImageWithUint8List(Uint8List mU8List,
    {double maxWidth = 720, double maxHeight = 1080}) async {
  Completer<PhotoInfo> completer = new Completer<PhotoInfo>();
  final filePath = await destinationFileImage;
  await writeToFile(mU8List, filePath);
  File originalImage = File(filePath);
  final imageFile = FileImage(originalImage);
  final length = originalImage.lengthSync();
  print("originalLength: $length");
  imageFile
      .resolve(new ImageConfiguration())
      .addListener(ImageStreamListener((info, _) async {
        final isVertical = info.image.height > info.image.width ? true : false;
        final ratio = double.parse(
            (info.image.width / info.image.height).toStringAsFixed(2));
        if (!isVertical) {
          maxHeight = maxHeight != 1080 ? maxHeight : 720;
          maxWidth = maxHeight * (info.image.width / info.image.height);
        } else {
          maxWidth = maxWidth != 720 ? maxWidth : 720;
          maxHeight = maxWidth * (info.image.height / info.image.width);
        }
        Uint8List? u8List = await getUint8ListCompressImage(
            mU8List, maxWidth.toInt(), maxHeight.toInt(), getQuality(length));
        var photoInfo =
            PhotoInfo(u8List: u8List, isVertical: isVertical, ratio: ratio);
        completer.complete(photoInfo);
      }, onError: (exception, stackTrace) async {
        print("errorCompressed: $exception");
        Uint8List? u8List = await getUint8ListCompressImage(
            mU8List, maxWidth.toInt(), maxHeight.toInt(), getQuality(length));
        var photoInfo = PhotoInfo(u8List: u8List, isVertical: true, ratio: 1);
        completer.complete(photoInfo);
      }));
  return completer.future;
}

Future<PhotoInfo?> compressVideo(PhotoInfo? photo) async {
  if (photo == null) return null;
  final filePath = await destinationFileVideo;
  final pathFile = await writeToFile(photo.u8List!, filePath);
  final videoCompress = await VideoCompress.compressVideo(filePath,
      quality: VideoQuality.Res640x480Quality, deleteOrigin: true);
  photo.u8List = videoCompress?.file?.readAsBytesSync();
  pathFile.delete();
  return photo;
}

Future<String> get destinationFileVideo async {
  late String directory;
  final String videoName = '${DateTime.now().millisecondsSinceEpoch}.mp4';
  if (Platform.isAndroid) {
    final List<Directory>? dir = await path.getExternalStorageDirectories(
        type: path.StorageDirectory.movies);
    directory = dir!.first.path;
    return File('$directory/$videoName').path;
  } else {
    final Directory dir = await path.getLibraryDirectory();
    directory = dir.path;
    return File('$directory/$videoName').path;
  }
}

Future<String> get destinationFileImage async {
  late String directory;
  final String imageName = '${DateTime.now().millisecondsSinceEpoch}.jpeg';
  if (Platform.isAndroid) {
    final List<Directory>? dir = await path.getExternalStorageDirectories(
        type: path.StorageDirectory.movies);
    directory = dir!.first.path;
    return File('$directory/$imageName').path;
  } else {
    final Directory dir = await path.getLibraryDirectory();
    directory = dir.path;
    return File('$directory/$imageName').path;
  }
}

int getQuality(dynamic fileLength) {
  int quality = 0;
  if (fileLength < 500000) {
    quality = 100;
  } else if (fileLength < 2000000) {
    quality = 96;
  } else if (fileLength < 4000000) {
    quality = 86;
  } else if (fileLength < 6000000) {
    quality = 76;
  } else {
    quality = 100 ~/ (fileLength / 500000);
    if (quality < 50) quality = 50;
  }
  return quality;
}

Future<File> writeToFile(Uint8List data, String path) {
  final buffer = data.buffer;
  return new File(path)
      .writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
}

double getScaleRatio(BuildContext context) {
  var pixRatio = MediaQuery.of(context).devicePixelRatio;
  print("Corrected size W is ${MediaQuery.of(context).size.width * pixRatio}");
  print("Corrected size H is ${MediaQuery.of(context).size.height * pixRatio}");
  return 0.0;
}
