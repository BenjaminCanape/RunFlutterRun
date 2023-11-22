import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../view_model/activity_list_view_model.dart';

/// A floating action button widget that allows the user to navigate back to the home screen.
class BackToHomeButton extends HookConsumerWidget {
  const BackToHomeButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(activityListViewModelProvider.notifier);

    return FloatingActionButton(
      backgroundColor: Colors.teal.shade800,
      elevation: 4.0,
      child: const Icon(
        Icons.arrow_back,
        color: Colors.white,
      ),
      onPressed: () {
        provider.backToHome();
      },
    );
  }
}
