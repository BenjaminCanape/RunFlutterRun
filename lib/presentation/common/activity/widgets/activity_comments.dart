import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:run_flutter_run/domain/entities/activity.dart';
import 'package:run_flutter_run/domain/entities/activity_comment.dart';

import '../../../../core/utils/storage_utils.dart';
import '../../../../domain/entities/user.dart';
import '../view_model/activity_item_view_model.dart';

class ActivityComments extends HookConsumerWidget {
  final Activity currentActivity;
  final GlobalKey<FormState> formKey;

  final currentUserPictureDataProvider =
      FutureProvider.family<Uint8List?, Activity>((ref, activity) async {
    User? user = await StorageUtils.getUser();
    if (user != null) {
      final provider =
          ref.read(activityItemViewModelProvider(activity.id).notifier);
      return provider.getProfilePicture(user.id);
    }
    return null;
  });

  final commentUserPictureDataProvider =
      FutureProvider.family<Uint8List?, User>((ref, user) async {
    final provider = ref.read(activityItemViewModelProvider(user.id).notifier);
    return provider.getProfilePicture(user.id);
  });

  ActivityComments({
    super.key,
    required this.currentActivity,
    required this.formKey,
  });

  Widget buildList(WidgetRef ref, List<ActivityComment> data) {
    return Expanded(
        child: ListView(
      children: [
        for (var i = 0; i < data.length; i++)
          Padding(
            padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
            child: ListTile(
              leading: GestureDetector(
                child: Container(
                  height: 50.0,
                  width: 50.0,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                  child: ref
                      .watch(commentUserPictureDataProvider(data[i].user))
                      .when(
                    data: (pic) {
                      return pic != null
                          ? CircleAvatar(
                              radius: 50, backgroundImage: MemoryImage(pic))
                          : const Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.black,
                            );
                    },
                    loading: () {
                      return const Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.black,
                      );
                    },
                    error: (error, stackTrace) {
                      return const Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.black,
                      );
                    },
                  ),
                ),
              ),
              title: Text(
                data[i].user.firstname != null && data[i].user.lastname != null
                    ? '${data[i].user.firstname!} ${data[i].user.lastname!}'
                    : data[i].user.username,
                style: const TextStyle(),
              ),
              subtitle: Text(data[i].content),
            ),
          )
      ],
    ));
  }

  Widget commentChild(WidgetRef ref, ActivityItemViewModel provider,
      List<ActivityComment> data, bool displayPreviousComments) {
    final lastComment = data.isNotEmpty ? data.last : null;

    return Column(
      children: [
        if (data.length > 1 && !displayPreviousComments)
          GestureDetector(
            onTap: () {
              provider.togglePreviousComments();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'View ${data.length - 1} previous comments',
                style: TextStyle(
                  color: Colors.teal.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        if (lastComment != null && !displayPreviousComments)
          ListTile(
            leading: GestureDetector(
              child: Container(
                height: 50.0,
                width: 50.0,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
                child: ref
                    .watch(commentUserPictureDataProvider(lastComment.user))
                    .when(
                  data: (pic) {
                    return pic != null
                        ? CircleAvatar(
                            radius: 50, backgroundImage: MemoryImage(pic))
                        : const Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.black,
                          );
                  },
                  loading: () {
                    return const Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.black,
                    );
                  },
                  error: (error, stackTrace) {
                    return const Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.black,
                    );
                  },
                ),
              ),
            ),
            title: Text(
              '${lastComment.user.firstname}${lastComment.user.lastname}',
              style: const TextStyle(),
            ),
            subtitle: Text(lastComment.content),
          ),
        if (displayPreviousComments) buildList(ref, data)
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserPictureProvider =
        ref.watch(currentUserPictureDataProvider(currentActivity));
    final provider =
        ref.read(activityItemViewModelProvider(currentActivity.id).notifier);
    final state = ref.read(activityItemViewModelProvider(currentActivity.id));

    return Container(
      height: currentActivity.comments.isNotEmpty ? 210 : 80,
      child: CommentBox(
        userImage: currentUserPictureProvider.when(
          data: (pic) {
            return pic != null ? MemoryImage(pic) : null;
          },
          loading: () {
            return null;
          },
          error: (error, stackTrace) {
            return null;
          },
        ),
        sendButtonMethod: () => provider.comment(currentActivity),
        formKey: formKey,
        commentController: provider.commentController,
        backgroundColor: Colors.white,
        textColor: Colors.teal.shade700,
        sendWidget:
            Icon(Icons.send_sharp, size: 30, color: Colors.teal.shade800),
        child: commentChild(ref, provider, currentActivity.comments.toList(),
            state.displayPreviousComments),
      ),
    );
  }
}
