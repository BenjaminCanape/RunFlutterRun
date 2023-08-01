import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as img;

/// Utility class for image editing operations.
///
class ImageUtils {
  /// Create an image from a widget
  static Future<Uint8List?> captureWidgetToImage(GlobalKey boundaryKey) async {
    try {
      RenderRepaintBoundary boundary = boundaryKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
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
        color: Colors.black,
        fontSize: 26,
        fontWeight: FontWeight.bold,
        shadows: [
          const Shadow(
            blurRadius: 2,
            color: Colors.white, // Add a white shadow for better readability
            offset: Offset(1, 1),
          ),
        ],
      );
      final titleParagraphBuilder = ui.ParagraphBuilder(ui.ParagraphStyle())
        ..pushStyle(titleStyle)
        ..addText(title.toUpperCase());
      final titleParagraph = titleParagraphBuilder.build();
      titleParagraph
          .layout(ui.ParagraphConstraints(width: image!.width.toDouble()));

      canvas.drawParagraph(titleParagraph, const Offset(10, 10));

      // Create a paragraph with the given text
      final textStyle = ui.TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.bold,
        shadows: [
          const Shadow(
            blurRadius: 2,
            color: Colors.white, // Add a white shadow for better readability
            offset: Offset(1, 1),
          ),
        ],
      );
      final textParagraphBuilder = ui.ParagraphBuilder(ui.ParagraphStyle())
        ..pushStyle(textStyle)
        ..addText(text);
      final textParagraph = textParagraphBuilder.build();
      textParagraph
          .layout(ui.ParagraphConstraints(width: image.width.toDouble()));

      canvas.drawParagraph(textParagraph, const Offset(10, 40));

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

  /// Resize an image
  static Future<Uint8List?> resizeImage(
      Uint8List imageBytes, int width, int height) async {
    try {
      img.Image? image = img.decodeImage(imageBytes);
      img.Image resizedImage =
          img.copyResize(image!, width: width, height: height);

      Uint8List resizedImageBytes =
          Uint8List.fromList(img.encodePng(resizedImage));
      return resizedImageBytes;
    } catch (e) {
      return null;
    }
  }
}
