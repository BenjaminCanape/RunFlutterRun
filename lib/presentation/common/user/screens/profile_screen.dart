import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:run_flutter_run/domain/entities/user.dart';
import 'package:run_flutter_run/presentation/common/activity/widgets/activity_list.dart';
import 'package:run_flutter_run/presentation/common/user/widgets/friend_request.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../core/utils/ui_utils.dart';
import '../view_model/profile_view_model.dart';

/// The screen that displays the profile of a specific user.
class ProfileScreen extends HookConsumerWidget {
  final User user;

  ProfileScreen({Key? key, required this.user}) : super(key: key);

  final friendShipStatusDataProvider =
      FutureProvider.family<void, User>((ref, user) async {
    final userId = user.id;
    final pendingRequestsProvider = ref.read(profileViewModelProvider.notifier);
    pendingRequestsProvider.getFriendshipStatus(userId);
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var state = ref.watch(profileViewModelProvider);
    final friendShipStatusProvider =
        ref.watch(friendShipStatusDataProvider(user));

    return state.isLoading
        ? const Center(child: UIUtils.loader)
        : Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 0, top: 12),
                    child: Text(
                      user.username,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  friendShipStatusProvider.when(
                    data: (_) {
                      return FriendRequestWidget(userId: user.id);
                    },
                    loading: () {
                      return const Center(child: UIUtils.loader);
                    },
                    error: (error, stackTrace) {
                      return Text('$error');
                    },
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 20,
                  ),
                  ActivityList(
                    activities: state.activities,
                    canOpenActivity: false,
                  )
                ],
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
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
