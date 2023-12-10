import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../domain/entities/activity.dart';
import '../../../../domain/entities/activity_comment.dart';

import '../../../../core/utils/storage_utils.dart';
import '../../../../domain/entities/user.dart';
import '../../core/utils/color_utils.dart';
import '../view_model/activity_item_view_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  Widget buildCommentList(WidgetRef ref, List<ActivityComment> comments) {
    return Expanded(
      child: ListView(
        children: [
          for (var comment in comments) buildCommentItem(ref, comment),
        ],
      ),
    );
  }

  Widget buildCommentItem(WidgetRef ref, ActivityComment comment) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
      child: ListTile(
        leading: GestureDetector(
          child: Container(
            height: 50.0,
            width: 50.0,
            decoration: BoxDecoration(
              color: ColorUtils.white,
              borderRadius: const BorderRadius.all(Radius.circular(50)),
            ),
            child: ref.watch(commentUserPictureDataProvider(comment.user)).when(
              data: (pic) {
                return pic != null
                    ? CircleAvatar(
                        radius: 50, backgroundImage: MemoryImage(pic))
                    : Icon(
                        Icons.person,
                        size: 50,
                        color: ColorUtils.black,
                      );
              },
              loading: () {
                return Icon(
                  Icons.person,
                  size: 50,
                  color: ColorUtils.black,
                );
              },
              error: (error, stackTrace) {
                return Icon(
                  Icons.person,
                  size: 50,
                  color: ColorUtils.black,
                );
              },
            ),
          ),
        ),
        title: GestureDetector(
            child: Text(
          comment.user.firstname != null && comment.user.lastname != null
              ? '${comment.user.firstname} ${comment.user.lastname}'
              : comment.user.username,
          style: const TextStyle(),
        )),
        subtitle: Text(comment.content),
      ),
    );
  }

  Widget buildCommentChild(
      WidgetRef ref,
      AppLocalizations appLocalizations,
      ActivityItemViewModel provider,
      List<ActivityComment> comments,
      bool displayPreviousComments) {
    final lastComment = comments.isNotEmpty ? comments.last : null;

    return Column(
      children: [
        if (comments.length > 1 && !displayPreviousComments)
          GestureDetector(
            onTap: () {
              provider.togglePreviousComments();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                appLocalizations.view_previous_comments(
                  comments.length - 1,
                ),
                style: TextStyle(
                  color: ColorUtils.mainMedium,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        if (lastComment != null && !displayPreviousComments)
          buildCommentItem(ref, lastComment),
        if (displayPreviousComments) buildCommentList(ref, comments),
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

    final appLocalizations = AppLocalizations.of(context)!;

    return SizedBox(
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
        backgroundColor: ColorUtils.white,
        textColor: ColorUtils.mainMedium,
        sendWidget: Icon(Icons.send_sharp, size: 30, color: ColorUtils.main),
        child: buildCommentChild(ref, appLocalizations, provider,
            currentActivity.comments.toList(), state.displayPreviousComments),
      ),
    );
  }
}
