import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../domain/entities/enum/friend_request_status.dart';

import '../../../../domain/entities/user.dart';
import '../../activity/widgets/activity_list.dart';
import '../../core/utils/color_utils.dart';
import '../../core/utils/ui_utils.dart';
import '../view_model/profile_view_model.dart';
import '../widgets/friend_request.dart';

class ProfileScreen extends HookConsumerWidget {
  final User user;

  ProfileScreen({super.key, required this.user});

  final futureDataProvider =
      FutureProvider.family<void, User>((ref, user) async {
    String userId = user.id;
    final profileProvider = ref.read(profileViewModelProvider.notifier);
    profileProvider.getFriendshipStatus(userId);
    profileProvider.getProfilePicture(userId);
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var state = ref.watch(profileViewModelProvider);
    final futureProvider = ref.watch(futureDataProvider(user));

    return state.isLoading
        ? Center(child: UIUtils.loader)
        : Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  Container(
                      padding:
                          const EdgeInsets.only(left: 16, top: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(150),
                            child: Container(
                              alignment: Alignment.center,
                              width: 150,
                              height: 150,
                              child: state.profilePicture != null
                                  ? Image.memory(
                                      state.profilePicture!,
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(Icons.person, size: 100),
                            ),
                          ),
                          Flexible(
                            child: Column(children: [
                              Text(
                                user.firstname != null && user.lastname != null
                                    ? '${user.firstname} ${user.lastname}'
                                    : user.username,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              const SizedBox(height: 10),
                              futureProvider.when(
                                data: (_) {
                                  Widget widget = Container();
                                  if (state.friendshipStatus !=
                                      FriendRequestStatus.noDisplay) {
                                    widget =
                                        FriendRequestWidget(userId: user.id);
                                  }
                                  return widget;
                                },
                                loading: () {
                                  return Center(child: UIUtils.loader);
                                },
                                error: (error, stackTrace) {
                                  return Text('$error');
                                },
                              )
                            ]),
                          ),
                        ],
                      )),
                  const Divider(),
                  const SizedBox(height: 20),
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
              backgroundColor: ColorUtils.main,
              elevation: 4.0,
              child: Icon(
                Icons.arrow_back,
                color: ColorUtils.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          );
  }
}
