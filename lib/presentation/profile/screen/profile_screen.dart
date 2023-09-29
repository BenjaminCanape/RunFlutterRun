import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:run_flutter_run/domain/entities/user.dart';
import 'package:run_flutter_run/presentation/common/core/widgets/activity_list.dart';

import '../view_model/profile_view_model.dart';

/// The screen that displays the profile of a specific user.
class ProfileScreen extends HookConsumerWidget {
  final User user;

  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.read(profileViewModelProvider.notifier);
    var state = ref.read(profileViewModelProvider);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 0, top: 12),
              child: Text(
                this.user.username,
                style: const TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(),
            ActivityList(activities: state.activities)
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal.shade800,
        elevation: 4.0,
        child: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
