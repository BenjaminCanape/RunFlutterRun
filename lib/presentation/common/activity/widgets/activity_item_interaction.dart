import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../domain/entities/activity.dart';
import '../../core/utils/color_utils.dart';
import '../view_model/activity_item_comments_view_model.dart';
import '../view_model/activity_item_interaction_view_model.dart';
import 'activity_comments.dart';
import 'activty_like.dart';

class ActivityItemInteraction extends HookConsumerWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Activity currentActivity;

  ActivityItemInteraction({
    super.key,
    required this.currentActivity,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(
        activityItemInteractionViewModelProvider(currentActivity.id).notifier);

    final state =
        ref.watch(activityItemInteractionViewModelProvider(currentActivity.id));
    final commentsState =
        ref.watch(activityItemCommentsViewModelProvider(currentActivity.id));
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
                  Text(commentsState.comments.length.toString()),
                ],
              ),
              ActivityLike(currentActivity: currentActivity),
            ],
          ),
          if (state.displayComments)
            ActivityComments(
                currentActivity: currentActivity, formKey: formKey),
        ],
      ),
    );
  }
}
