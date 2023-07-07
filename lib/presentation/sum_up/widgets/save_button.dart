import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../view_model/sum_up_view_model.dart';

/// Represents the Save button widget.
class SaveButton extends HookConsumerWidget {
  final bool disabled;

  /// Creates a new instance of [SaveButton] with the given [disabled] state.
  const SaveButton({Key? key, required this.disabled}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(sumUpViewModelProvider.notifier);

    return FloatingActionButton(
      backgroundColor: Colors.teal.shade800,
      elevation: 4.0,
      onPressed: disabled
          ? null
          : () {
              provider.save();
            },
      child: const Icon(Icons.save),
    );
  }
}
