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
