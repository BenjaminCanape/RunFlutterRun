import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class Date extends HookConsumerWidget {
  final DateTime date;

  const Date({Key? key, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = AppLocalizations.of(context);
    final formattedDateTime = DateFormat('dd/MM/yyyy HH:mm').format(date);

    return Text(
      '${appLocalizations.date_pronoun} $formattedDateTime',
    );
  }
}
