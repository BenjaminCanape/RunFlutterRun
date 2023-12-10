import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/color_utils.dart';

/// A widget that allow to upload a file
class UploadFileWidget extends HookConsumerWidget {
  /// The image to display.
  final Uint8List? image;

  /// The function to call after we chose the picture
  final Function callbackFunc;

  final _picker = ImagePicker();

  /// Creates a [UploadFileWidget] widget.
  ///
  /// The [image] is the image to display.
  UploadFileWidget(
      {super.key, required this.image, required this.callbackFunc});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Container(
          alignment: Alignment.center,
          width: 200,
          height: 200,
          color: ColorUtils.greyLight,
          child: image != null
              ? Image.memory(image!, fit: BoxFit.cover)
              : Text(
                  AppLocalizations.of(context)!.profile_picture_select_please),
        ),
      ),
      ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(ColorUtils.main),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        onPressed: () async {
          final XFile? pickedImage =
              await _picker.pickImage(source: ImageSource.gallery);

          if (pickedImage != null) {
            Uint8List file = await pickedImage.readAsBytes();

            callbackFunc(file);
          }
        },
        child: Text(AppLocalizations.of(context)!.profile_picture_select,
            style: TextStyle(
              color: ColorUtils.white,
            )),
      )
    ]);
  }
}
