import 'dart:typed_data';

import 'package:comment_box/comment/comment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/utils/storage_utils.dart';
import '../../../../domain/entities/activity.dart';
import '../../../../domain/entities/activity_comment.dart';
import '../../../../domain/entities/user.dart';
import '../../core/utils/color_utils.dart';
import '../../core/utils/user_utils.dart';
import '../../user/view_model/profile_picture_view_model.dart';
import '../view_model/activity_item_comments_view_model.dart';
import '../view_model/activity_item_view_model.dart';

class ActivityComments extends HookConsumerWidget {
  final Activity currentActivity;
  final GlobalKey<FormState> formKey;

  final currentUserPictureDataProvider =
      FutureProvider.family<String?, Activity>((ref, activity) async {
    final user = await StorageUtils.getUser();
    final provider =
        ref.read(activityItemViewModelProvider(activity.id).notifier);

    user != null ? provider.getProfilePicture(user.id) : null;
    return user?.id;
  });

  final commentUserPictureDataProvider =
      FutureProvider.family<void, User>((ref, user) async {
    final provider = ref.read(activityItemViewModelProvider(user.id).notifier);
    provider.getProfilePicture(user.id);
  });

  ActivityComments({
    super.key,
    required this.currentActivity,
    required this.formKey,
  });

  Widget buildCommentList(
    WidgetRef ref,
    List<ActivityComment> comments,
  ) {
    return Expanded(
      child: ListView.builder(
        itemCount: comments.length,
        itemBuilder: (context, index) => buildCommentItem(ref, comments[index]),
      ),
    );
  }

  Widget buildCommentItem(WidgetRef ref, ActivityComment comment) {
    final profilePicture = ref
        .watch(profilePictureViewModelProvider(comment.user.id))
        .profilePicture;
    return Padding(
      padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
      child: ListTile(
        leading: buildUserAvatar(ref, comment.user, profilePicture),
        title: GestureDetector(
          child: Text(
            UserUtils.getNameOrUsername(comment.user),
            style: const TextStyle(),
          ),
        ),
        subtitle: Text(comment.content),
      ),
    );
  }

  Widget buildViewPreviousComments(ActivityItemCommentsViewModel provider,
      AppLocalizations appLocalizations, List<ActivityComment> comments) {
    return GestureDetector(
      onTap: () => provider.togglePreviousComments(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          appLocalizations.view_previous_comments(comments.length - 1),
          style: TextStyle(
            color: ColorUtils.mainMedium,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget buildCommentChild(
      WidgetRef ref,
      AppLocalizations appLocalizations,
      ActivityItemCommentsViewModel provider,
      List<ActivityComment> comments,
      bool displayPreviousComments) {
    final lastComment = comments.isNotEmpty ? comments.last : null;

    return Column(
      children: [
        if (comments.length > 1 && !displayPreviousComments)
          buildViewPreviousComments(provider, appLocalizations, comments),
        if (lastComment != null && !displayPreviousComments)
          buildCommentItem(ref, lastComment),
        if (displayPreviousComments) buildCommentList(ref, comments),
      ],
    );
  }

  Widget buildUserAvatar(WidgetRef ref, User user, Uint8List? profilePicture) {
    return GestureDetector(
      child: Container(
        height: 50.0,
        width: 50.0,
        decoration: BoxDecoration(
          color: ColorUtils.white,
          borderRadius: const BorderRadius.all(Radius.circular(50)),
        ),
        child: ref.watch(commentUserPictureDataProvider(user)).when(
              data: (_) => profilePicture != null
                  ? CircleAvatar(
                      radius: 50, backgroundImage: MemoryImage(profilePicture))
                  : UserUtils.personIcon,
              loading: () => UserUtils.personIcon,
              error: (_, __) => UserUtils.personIcon,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserPictureProvider =
        ref.watch(currentUserPictureDataProvider(currentActivity));
    final commentsProvider = ref.read(
        activityItemCommentsViewModelProvider(currentActivity.id).notifier);
    final state =
        ref.watch(activityItemCommentsViewModelProvider(currentActivity.id));
    final appLocalizations = AppLocalizations.of(context)!;

    return SizedBox(
      height: state.comments.isNotEmpty ? 210 : 80,
      child: CommentBox(
        userImage: currentUserPictureProvider.when(
          data: (userId) {
            if (userId != null) {
              final profilePicture = ref
                  .watch(profilePictureViewModelProvider(userId))
                  .profilePicture;
              return profilePicture != null
                  ? MemoryImage(profilePicture)
                  : null;
            }
            return null;
          },
          loading: () => null,
          error: (_, __) => null,
        ),
        sendButtonMethod: () => commentsProvider.comment(currentActivity),
        formKey: formKey,
        commentController: commentsProvider.commentController,
        backgroundColor: ColorUtils.white,
        textColor: ColorUtils.mainMedium,
        sendWidget: Icon(Icons.send_sharp, size: 30, color: ColorUtils.main),
        child: buildCommentChild(ref, appLocalizations, commentsProvider,
            state.comments, state.displayPreviousComments),
      ),
    );
  }
}
