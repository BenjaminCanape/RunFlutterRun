import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../domain/entities/activity.dart';
import '../../core/utils/color_utils.dart';
import '../view_model/activity_item_view_model.dart';
import 'activity_comments.dart';
import 'activty_like.dart';

class ActivityItemInteraction extends HookConsumerWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Activity currentActivity;
  final bool displayComments;

  ActivityItemInteraction({
    super.key,
    required this.currentActivity,
    required this.displayComments,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider =
        ref.read(activityItemViewModelProvider(currentActivity.id).notifier);
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.comment_outlined,
                        color: ColorUtils.black, size: 24),
                    onPressed: () => provider.toggleComments(),
                  ),
                  Text(currentActivity.comments.length.toString()),
                ],
              ),
              ActivityLike(
                currentActivity: currentActivity,
                likeFunction: provider.like,
                dislikeFunction: provider.dislike,
              ),
            ],
          ),
          if (displayComments)
            ActivityComments(
                currentActivity: currentActivity, formKey: formKey),
        ],
      ),
    );
  }
}
