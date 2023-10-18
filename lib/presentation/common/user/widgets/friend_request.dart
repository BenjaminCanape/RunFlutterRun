import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:run_flutter_run/domain/entities/enum/friend_request_status.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:run_flutter_run/presentation/common/user/view_model/profile_view_model.dart';

class FriendRequestWidget extends HookConsumerWidget {
  final String userId;

  const FriendRequestWidget({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.read(profileViewModelProvider.notifier);
    var state = ref.watch(profileViewModelProvider);

    if (state.friendshipStatus == FriendRequestStatus.pending) {
      return const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.follow_the_signs),
          SizedBox(width: 8),
          Text('En attente'),
        ],
      );
    } else if (state.friendshipStatus == FriendRequestStatus.accepted) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check),
          const SizedBox(width: 8),
          Text(AppLocalizations.of(context)!.followed),
        ],
      );
    } else if (state.friendshipStatus == FriendRequestStatus.rejected) {
      return Container();
    } else {
      return ElevatedButton(
        onPressed: () {
          provider.sendFriendRequest(userId);
        },
        child: Align(
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.follow_the_signs),
              const SizedBox(width: 8),
              Text(AppLocalizations.of(context)!.follow),
            ],
          ),
        ),
      );
    }
  }
}
