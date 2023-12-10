import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as img;

import 'color_utils.dart';

/// Utility class for image editing operations.
///
class ImageUtils {
  /// Create an image from a widget
  static Future<Uint8List?> captureWidgetToImage(GlobalKey boundaryKey,
      {int size = 1500}) async {
    try {
      RenderRepaintBoundary boundary = boundaryKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) return null;

      Uint8List originalImageBytes = byteData.buffer.asUint8List();
      Uint8List? croppedImageBytes = await cropImage(originalImageBytes, size);

      return croppedImageBytes;
    } catch (e) {
      return null;
    }
  }

  /// crop the image passed in parameter with the size also passed
  static Future<Uint8List?> cropImage(Uint8List imageBytes, int size) async {
    try {
      img.Image? originalImage = img.decodeImage(imageBytes);
      if (originalImage == null) return null;

      int cropSize;
      int offsetX = 0;
      int offsetY = 0;

      if (originalImage.width > originalImage.height) {
        // Crop vertically to get a square
        cropSize = originalImage.height;
        offsetX = (originalImage.width - cropSize) ~/ 2;
      } else {
        // Crop horizontally to get a square
        cropSize = originalImage.width;
        offsetY = (originalImage.height - cropSize) ~/ 2;
      }

      // Crop the image
      img.Image croppedImage = img.copyCrop(originalImage,
          x: offsetX, y: offsetY, width: cropSize, height: cropSize);
      img.Image resizedCroppedImage =
          img.copyResize(croppedImage, width: size, height: size);
      Uint8List croppedImageBytes =
          Uint8List.fromList(img.encodePng(resizedCroppedImage));

      return croppedImageBytes;
    } catch (e) {
      return null;
    }
  }

  /// Add title and text to the image passed in parameter
  static Future<Uint8List?> addTextToImage(
      Uint8List imageBytes, String title, String text) async {
    try {
      // Load the image using the flutter_image package
      img.Image? image = img.decodeImage(imageBytes);

      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);

      final imgCodec = await ui.instantiateImageCodec(imageBytes);
      final frame = await imgCodec.getNextFrame();

      // Paint the image on the canvas
      canvas.drawImage(
        frame.image,
        const Offset(0, 0),
        Paint(),
      );

      // Create a paragraph with the given title
      final titleStyle = ui.TextStyle(
        color: ColorUtils.black,
        fontSize: 100,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(
            blurRadius: 2,
            color:
                ColorUtils.white, // Add a white shadow for better readability
            offset: const Offset(1, 1),
          ),
        ],
      );
      final titleParagraphBuilder = ui.ParagraphBuilder(ui.ParagraphStyle())
        ..pushStyle(titleStyle)
        ..addText(title.toUpperCase());
      final titleParagraph = titleParagraphBuilder.build();
      titleParagraph
          .layout(ui.ParagraphConstraints(width: image!.width.toDouble()));

      canvas.drawParagraph(titleParagraph, const Offset(40, 40));

      // Create a paragraph with the given text
      final textStyle = ui.TextStyle(
        color: ColorUtils.white,
        fontSize: 50,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(
            blurRadius: 2,
            color:
                ColorUtils.white, // Add a white shadow for better readability
            offset: const Offset(1, 1),
          ),
        ],
      );
      final textParagraphBuilder = ui.ParagraphBuilder(ui.ParagraphStyle())
        ..pushStyle(textStyle)
        ..addText(text);
      final textParagraph = textParagraphBuilder.build();
      textParagraph
          .layout(ui.ParagraphConstraints(width: image.width.toDouble()));

      canvas.drawParagraph(textParagraph, const Offset(40, 160));

      // End recording and convert the canvas to an image
      final imgData = await recorder.endRecording().toImage(
            image.width,
            image.height,
          );
      final byteData = await imgData.toByteData(format: ui.ImageByteFormat.png);

      // Convert the image back to Uint8List
      Uint8List imageWithTextBytes = byteData!.buffer.asUint8List();
      return imageWithTextBytes;
    } catch (e) {
      return null;
    }
  }
}
