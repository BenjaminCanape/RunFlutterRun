import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:run_flutter_run/domain/entities/enum/friend_request_status.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:run_flutter_run/presentation/common/user/view_model/profile_view_model.dart';

class FriendRequestWidget extends HookConsumerWidget {
  final String userId;

  const FriendRequestWidget({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(profileViewModelProvider.notifier);
    final state = ref.watch(profileViewModelProvider);

    if (state.friendshipStatus == FriendRequestStatus.pending) {
      return _buildStatusWidget(
        context,
        Icons.access_time,
        Colors.orange,
        AppLocalizations.of(context)!.pending,
        Colors.orange,
      );
    } else if (state.friendshipStatus == FriendRequestStatus.accepted) {
      return _buildStatusWidget(
        context,
        Icons.check,
        Colors.green,
        AppLocalizations.of(context)!.followed,
        Colors.green,
      );
    } else if (state.friendshipStatus == FriendRequestStatus.rejected) {
      return Container();
    } else {
      return ElevatedButton(
        onPressed: () {
          provider.sendFriendRequest(userId);
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.teal.shade800,
        ),
        child: _buildStatusWidget(
          context,
          Icons.person_add,
          Colors.white,
          AppLocalizations.of(context)!.follow,
          Colors.white,
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
