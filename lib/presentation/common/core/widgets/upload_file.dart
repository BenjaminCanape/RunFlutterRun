import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

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
  UploadFileWidget({Key? key, required this.image, required this.callbackFunc})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(children: [
      Container(
        alignment: Alignment.center,
        width: 200,
        height: 200,
        color: Colors.grey[300],
        child: image != null
            ? Image.memory(image!, fit: BoxFit.cover)
            : Text(AppLocalizations.of(context)!.profile_picture_select_please),
      ),
      ElevatedButton(
        onPressed: () async {
          final XFile? pickedImage =
              await _picker.pickImage(source: ImageSource.gallery);

          if (pickedImage != null) {
            Uint8List file = await pickedImage.readAsBytes();

            callbackFunc(file);
          }
        },
        child: Text(AppLocalizations.of(context)!.profile_picture_select),
      )
    ]);
  }
}
