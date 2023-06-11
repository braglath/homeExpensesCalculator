
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

class CaptureSaveImage {
  CaptureSaveImage._instance();
  factory CaptureSaveImage() => _singleton;
  static final CaptureSaveImage _singleton = CaptureSaveImage._instance();

  static Future<void> saveWidget(
    Uint8List capturedImage,
    String homeName,
    ScreenshotController screenshotController,
  ) async {
    final String directory = (await getApplicationDocumentsDirectory()).path;
    final String fileName =
        '${DateTime.now().millisecondsSinceEpoch.toString()}.png';
    final String path = '$directory/${homeName.replaceAll(" ", "_")}';
    final String? savedLoc = await screenshotController.captureAndSave(
        path, //set path where screenshot will be saved
        fileName: fileName);
    if (savedLoc == null) return;
    // final File image = File(savedLoc);
    // await imagePath.writeAsBytes(image);
    await ImageGallerySaver.saveFile(savedLoc);
  }
}
