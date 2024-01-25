import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../domain/entities/enum/friend_request_status.dart';
import '../../core/utils/color_utils.dart';
import '../view_model/profile_view_model.dart';

class FriendRequestWidget extends HookConsumerWidget {
  final String userId;

  const FriendRequestWidget({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(profileViewModelProvider(userId).notifier);
    final state = ref.watch(profileViewModelProvider(userId));

    if (state.friendshipStatus == FriendRequestStatus.pending) {
      return _buildStatusWidget(context, Icons.access_time, ColorUtils.warning,
          AppLocalizations.of(context)!.pending, ColorUtils.warning);
    } else if (state.friendshipStatus == FriendRequestStatus.accepted) {
      return ElevatedButton(
        onPressed: () {
          provider.unfollow(userId);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorUtils.red,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: _buildStatusWidget(
          context,
          Icons.person_remove,
          ColorUtils.white,
          AppLocalizations.of(context)!.unfollow,
          ColorUtils.white,
        ),
      );
    } else {
      return ElevatedButton(
        onPressed: () {
          provider.sendFriendRequest(userId);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorUtils.main,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: _buildStatusWidget(
          context,
          Icons.person_add,
          ColorUtils.white,
          AppLocalizations.of(context)!.follow,
          ColorUtils.white,
        ),
      );
    }
  }

  Widget _buildStatusWidget(
    BuildContext context,
    IconData icon,
    Color iconColor,
    String text,
    Color textColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(color: textColor),
          ),
        ],
      ),
    );
  }
}
