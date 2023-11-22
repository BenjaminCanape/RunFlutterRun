import 'dart:typed_data';

import 'package:esys_flutter_share_plus/esys_flutter_share_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Utility class for sharing operations.
///
class ShareUtils {
  /// Open the sharing dialog
  static Future<void> shareImage(BuildContext context, Uint8List image) async {
    await Share.file('Run Flutter Run', 'run.png', image, 'image/png');
  }

  /// Display a snackbar when share image failed
  static void showShareFailureSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.share_failed),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: AppLocalizations.of(context)!.close,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
