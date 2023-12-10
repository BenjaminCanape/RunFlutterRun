import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../domain/entities/activity.dart';
import '../../../../main.dart';
import '../../timer/viewmodel/timer_view_model.dart';
import '../utils/activity_utils.dart';
import '../utils/color_utils.dart';
import '../utils/image_utils.dart';
import '../utils/share_utils.dart';

/// A widget that displays the share map button
class ShareMapButton extends HookConsumerWidget {
  final GlobalKey boundaryKey;
  final Activity activity;

  /// Creates a [ShareMapButton] widget.
  ///
  /// The [boundaryKey] is the key of the widget to capture and share
  const ShareMapButton(
      {super.key, required this.boundaryKey, required this.activity});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = AppLocalizations.of(context)!;
    final timerViewModel = ref.read(timerViewModelProvider.notifier);

    Future<void> shareImageWithText(Uint8List image) async {
      String duration =
          "${appLocalizations.duration}: ${timerViewModel.getFormattedTime(activity.time.toInt())}";
      String distance =
          "${appLocalizations.distance}: ${activity.distance.toStringAsFixed(2)} km";
      String speed =
          "${appLocalizations.speed}: ${activity.speed.toStringAsFixed(2)} km/h";

      Uint8List? imageEdited = await ImageUtils.addTextToImage(
        image,
        ActivityUtils.translateActivityTypeValue(
            appLocalizations, activity.type),
        "$duration - $distance - $speed",
      );

      if (imageEdited != null) {
        await ShareUtils.shareImage(navigatorKey.currentContext!, imageEdited);
      } else {
        throw Exception();
      }
    }

    return FloatingActionButton(
      onPressed: () async {
        try {
          Uint8List? image = await ImageUtils.captureWidgetToImage(boundaryKey);
          if (image == null) throw Exception();

          await shareImageWithText(image);
        } catch (e) {
          ShareUtils.showShareFailureSnackBar(context);
        }
      },
      backgroundColor: ColorUtils.main,
      elevation: 4.0,
      child: Icon(
        Icons.share,
        color: ColorUtils.white,
      ),
    );
  }
}
