import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../domain/entities/activity.dart';
import '../../core/utils/color_utils.dart';
import '../../core/utils/ui_utils.dart';
import '../../core/utils/user_utils.dart';
import '../../user/view_model/profile_picture_view_model.dart';
import '../view_model/activity_item_view_model.dart';

class ActivityItemUserInformation extends HookConsumerWidget {
  final Activity activity;

  final futureDataProvider =
      FutureProvider.family<void, Activity>((ref, activity) async {
    final provider =
        ref.read(activityItemViewModelProvider(activity.id).notifier);
    String userId = activity.user.id;
    provider.getProfilePicture(userId);
  });

  ActivityItemUserInformation({super.key, required this.activity});

  Widget buildProfilePicture(
      AsyncValue<void> futureProvider, Uint8List? profilePicture) {
    return futureProvider.when(
      data: (_) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Container(
            alignment: Alignment.center,
            width: 50,
            height: 50,
            child: profilePicture != null
                ? Image.memory(profilePicture, fit: BoxFit.cover)
                : UserUtils.personIcon,
          ),
        );
      },
      loading: () => Center(child: UIUtils.loader),
      error: (_, __) => UserUtils.personIcon,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final futureProvider = ref.watch(futureDataProvider(activity));
    final profilePicture = ref
        .watch(profilePictureViewModelProvider(activity.user.id))
        .profilePicture;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: ColorUtils.greyLight,
              width: 0.5,
            ),
          ),
        ),
        child: TextButton(
          onPressed: () => UserUtils.goToProfile(activity.user),
          child: Row(
            children: [
              buildProfilePicture(futureProvider, profilePicture),
              const SizedBox(width: 20),
              Flexible(
                child: Text(
                  UserUtils.getNameOrUsername(activity.user),
                  style: TextStyle(color: ColorUtils.black),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
