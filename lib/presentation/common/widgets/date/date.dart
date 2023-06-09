import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class Date extends HookConsumerWidget {
  final DateTime date;

  const Date({Key? key, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text(
      '${AppLocalizations.of(context).date_pronoun} ${DateFormat('dd/MM/yyyy').format(date)} ${AppLocalizations.of(context).hours_pronoun} ${DateFormat('HH:mm').format(date)}',
    );
  }
}
