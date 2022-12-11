import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:run_run_run/presentation/sum_up/view_model/sum_up_view_model.dart';

class SaveButton extends HookConsumerWidget {
  const SaveButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(sumUpViewModel);

    return FloatingActionButton(
      elevation: 4.0,
      child: Icon(Icons.save),
      onPressed: () {
        provider.save(context);
      },
    );
  }
}
