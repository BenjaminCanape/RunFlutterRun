import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:run_flutter_run/data/repositories/friend_request_repository_impl.dart';
import 'package:run_flutter_run/domain/entities/enum/friend_request_status.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FriendRequestWidget extends HookConsumerWidget {
  final String userId;
  final FriendRequestStatus? status;

  const FriendRequestWidget(
      {super.key, required this.userId, required this.status});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (status == FriendRequestStatus.pending) {
      return const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.follow_the_signs),
          SizedBox(width: 8),
          Text('En attente'),
        ],
      );
    } else if (status == FriendRequestStatus.accepted) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check),
          const SizedBox(width: 8),
          Text(AppLocalizations.of(context)!.followed),
        ],
      );
    } else if (status == FriendRequestStatus.rejected) {
      return Container();
    } else {
      return ElevatedButton(
        onPressed: () {
          ref
              .read(friendRequestRepositoryProvider)
              .sendRequest(userId)
              .then((value) {});
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
