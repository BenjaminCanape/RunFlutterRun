import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:run_flutter_run/domain/entities/location.dart';
import 'package:run_flutter_run/presentation/common/core/utils/map_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../domain/entities/activity.dart';

/// The tab that displays a graph of speed of a specific activity.
class GraphTab extends StatelessWidget {
  final Activity activity;

  const GraphTab({Key? key, required this.activity}) : super(key: key);

  FlSpot getMaxSpeedSpot(List<FlSpot> spots) {
    double maxSpeed = 0;
    FlSpot maxSpeedSpot = const FlSpot(0, 0);

    for (final FlSpot spot in spots) {
      if (spot.y > maxSpeed) {
        maxSpeed = spot.y;
        maxSpeedSpot = spot;
      }
    }

    return maxSpeedSpot;
  }

  List<FlSpot> smoothData(List<FlSpot> inputSpots) {
    final List<FlSpot> smoothedSpots = [];

    final int windowSize =
        inputSpots.length > 100 ? inputSpots.length ~/ 10 : 5;

    for (int i = 0; i < inputSpots.length; i++) {
      double sum = 0;
      int count = 0;

      for (int j = i - (windowSize ~/ 2); j <= i + (windowSize ~/ 2); j++) {
        if (j >= 0 && j < inputSpots.length) {
          sum += inputSpots[j].y;
          count++;
        }
      }

      final double smoothedValue = count != 0 ? sum / count : 0;
      smoothedSpots.add(FlSpot(inputSpots[i].x, smoothedValue));
    }

    smoothedSpots.add(FlSpot(activity.distance, inputSpots.last.y));

    return smoothedSpots;
  }

  @override
  Widget build(BuildContext context) {
    final List<FlSpot> spots = [];

    if (activity.locations.length > 1) {
      final List<Location> locations = activity.locations.toList();
      double totalDistance = 0;
      for (int i = 1; i < locations.length; i++) {
        final Location currentLocation = locations[i];
        final Location previousLocation = locations[i - 1];

        final double distance = MapUtils.getDistance(
              LatLng(previousLocation.latitude, previousLocation.longitude),
              LatLng(currentLocation.latitude, currentLocation.longitude),
            ) /
            1000;

        totalDistance += distance;

        final Duration timeDifference =
            currentLocation.datetime.difference(previousLocation.datetime);

        double hoursDifference;

        timeDifference.inSeconds == 0
            ? hoursDifference = (timeDifference.inSeconds) / 3600
            : hoursDifference = (timeDifference.inMilliseconds) / 3600000;

        final double speed =
            hoursDifference > 0 ? distance / hoursDifference : 0;
        spots.add(FlSpot(totalDistance, speed));
      }
    }

    final smoothedData = spots.isNotEmpty ? smoothData(spots) : spots;
    final maxSpeedSpot =
        smoothedData.isNotEmpty ? getMaxSpeedSpot(smoothedData) : const FlSpot(0, 0);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
              child: smoothedData.isNotEmpty
                  ? SizedBox(
                      height: 200,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(
                              drawHorizontalLine: false,
                              drawVerticalLine: true,
                              verticalInterval:
                                  activity.distance > 2 ? 1 : 0.5),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              axisNameSize: 30,
                              axisNameWidget: const Text('km/h',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w900)),
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 30,
                                getTitlesWidget: (value, _) {
                                  if (value == 0 ||
                                      value ==
                                          getMaxSpeedSpot(smoothedData).y *
                                              1.25) {
                                    return const Text('');
                                  } else {
                                    return Text(value.toStringAsFixed(1));
                                  }
                                },
                              ),
                            ),
                            rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(
                                axisNameWidget: const Text('km',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w900)),
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: activity.distance > 2 ? 1 : 0.5,
                                  reservedSize: 30,
                                  getTitlesWidget: (value, _) {
                                    if (value == 0 ||
                                        (activity.distance > 0.5 &&
                                            value == activity.distance)) {
                                      return const Text('');
                                    } else {
                                      return Text(value.toStringAsFixed(1));
                                    }
                                  },
                                )),
                          ),
                          minX: 0,
                          maxX: activity.distance,
                          minY: 0,
                          maxY: getMaxSpeedSpot(smoothedData).y * 1.25,
                          showingTooltipIndicators: [],
                          lineTouchData: LineTouchData(touchTooltipData:
                              LineTouchTooltipData(
                                  getTooltipItems: (touchedSpots) {
                            return touchedSpots.map((LineBarSpot touchedSpot) {
                              const textStyle = TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              );
                              return LineTooltipItem(
                                '${smoothedData[touchedSpot.spotIndex].y.toStringAsFixed(2)} km/h',
                                textStyle,
                              );
                            }).toList();
                          })),
                          lineBarsData: [
                            LineChartBarData(
                              spots: smoothedData,
                              isCurved: true,
                              dotData: const FlDotData(show: false),
                              belowBarData: BarAreaData(show: false),
                            ),
                            LineChartBarData(
                              spots: [maxSpeedSpot],
                              isCurved: true,
                              dotData: const FlDotData(show: true),
                              belowBarData: BarAreaData(show: false),
                            ),
                          ],
                          extraLinesData: ExtraLinesData(
                            horizontalLines: [
                              HorizontalLine(
                                y: activity.speed,
                                color: Colors.blueGrey,
                                strokeWidth: 2,
                                dashArray: [5, 5],
                                label: HorizontalLineLabel(
                                    show: true,
                                    labelResolver: (_) =>
                                        AppLocalizations.of(context)
                                            .average_speed),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Text(AppLocalizations.of(context).no_data),
            ),
          ),
        ],
      ),
    );
  }
}
