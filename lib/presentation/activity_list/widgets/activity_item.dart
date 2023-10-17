import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/activity.dart';
import '../../common/core/utils/activity_utils.dart';
import '../../common/core/utils/color_utils.dart';
import '../view_model/activity_list_view_model.dart';

/// A widget representing an item in the activity list.
class ActivityItem extends HookConsumerWidget {
  final int index;
  final Activity activity;

  const ActivityItem({
    Key? key,
    required this.activity,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(activityListViewModelProvider.notifier);

    final appLocalizations = AppLocalizations.of(context)!;
    final formattedDateTime =
        DateFormat('dd/MM/yyyy ${appLocalizations.hours_pronoun} HH:mm')
            .format(activity.startDatetime);

    final List<Color> colors = ColorUtils.generateColorTupleFromIndex(index);
    final startColor = colors.first;
    final endColor = colors.last;
    const double borderRadius = 24;

    return InkWell(
      onTap: () async {
        final activityDetails = await provider.getActivityDetails(activity);
        provider.goToActivity(activityDetails);
      },
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: <Widget>[
              Container(
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  gradient: LinearGradient(
                    colors: [startColor, endColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: endColor,
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                top: 0,
                child: CustomPaint(
                  size: const Size(100, 150),
                  painter: CustomCardShapePainter(
                      borderRadius, startColor, endColor),
                ),
              ),
              Positioned.fill(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Transform.scale(
                        scale: 2.25,
                        child: Icon(
                          ActivityUtils.getActivityTypeIcon(activity.type),
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            ActivityUtils.translateActivityTypeValue(
                              AppLocalizations.of(context)!,
                              activity.type,
                            ).toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Avenir',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            '${appLocalizations.date_pronoun} $formattedDateTime',
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Avenir',
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: <Widget>[
                              const Icon(
                                Icons.location_on,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Flexible(
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                            '${activity.distance.toStringAsFixed(2)} km',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Avenir',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              const Icon(
                                Icons.speed,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Flexible(
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                            '${activity.speed.toStringAsFixed(2)} km/h',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Avenir',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            Icons.navigate_next,
                            color: Colors.black,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A custom painter to draw the shape of the card.
class CustomCardShapePainter extends CustomPainter {
  final double radius;
  final Color startColor;
  final Color endColor;

  CustomCardShapePainter(this.radius, this.startColor, this.endColor);

  @override
  void paint(Canvas canvas, Size size) {
    var radius = 24.0;

    var paint = Paint();
    paint.shader = ui.Gradient.linear(
        const Offset(0, 0), Offset(size.width, size.height), [
      HSLColor.fromColor(startColor).withLightness(0.8).toColor(),
      endColor
    ]);

    var path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width - radius, size.height)
      ..quadraticBezierTo(
          size.width, size.height, size.width, size.height - radius)
      ..lineTo(size.width, radius)
      ..quadraticBezierTo(size.width, 0, size.width - radius, 0)
      ..lineTo(size.width - 1.5 * radius, 0)
      ..quadraticBezierTo(-radius, 2 * radius, 0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
