import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:run_flutter_run/domain/entities/activity.dart';
import 'package:run_flutter_run/domain/entities/activity_comment.dart';

import '../../../../core/utils/storage_utils.dart';
import '../../../../domain/entities/user.dart';
import '../../core/utils/ui_utils.dart';
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

  ActivityComments({
    super.key,
    required this.currentActivity,
    required this.formKey,
  });

  Widget commentChild(
      AsyncValue<Uint8List?> futureProvider, List<ActivityComment> data) {
    return ListView(
      children: [
        for (var i = 0; i < data.length; i++)
          Padding(
            padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
            child: ListTile(
              leading: GestureDetector(
                onTap: () async {
                  // Display the image in large form.
                  print("Comment Clicked");
                },
                child: Container(
                  height: 50.0,
                  width: 50.0,
                  decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                  child: futureProvider.when(
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
                      return const Center(child: UIUtils.loader);
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
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserPictureProvider =
        ref.watch(currentUserPictureDataProvider(currentActivity));
    final provider =
        ref.read(activityItemViewModelProvider(currentActivity.id).notifier);

    return Container(
      height: currentActivity.comments.length > 0 ? 225 : 80,
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
        child: commentChild(
            currentUserPictureProvider, currentActivity.comments.toList()),
      ),
    );
  }
}
