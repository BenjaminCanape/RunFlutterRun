import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

/// A widget that displays a formatted date.
class Date extends HookConsumerWidget {
  /// The date to display.
  final DateTime date;

  /// Creates a [Date] widget.
  ///
  /// The [date] is the date to display.
  const Date({Key? key, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = AppLocalizations.of(context);
    final formattedDateTime =
        DateFormat('dd/MM/yyyy ${appLocalizations.hours_pronoun} HH:mm')
            .format(date);

    return Text(
      '${appLocalizations.date_pronoun} $formattedDateTime',
    );
  }
}
