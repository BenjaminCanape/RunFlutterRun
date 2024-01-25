import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../view_model/activity_item_like_view_model.dart';
import '../../../../domain/entities/activity.dart';
import '../../core/utils/color_utils.dart';

class ActivityLike extends HookConsumerWidget {
  final Activity currentActivity;

  const ActivityLike({super.key, required this.currentActivity});

  @override
  Widget build(BuildContext buildContext, WidgetRef ref) {
    bool hasCurrentUserLiked = ref
        .watch(activityItemLikeViewModelProvider(currentActivity.id))
        .hasUserLiked;

    double likesCount =
        ref.watch(activityItemLikeViewModelProvider(currentActivity.id)).likes;

    final provider = ref
        .read(activityItemLikeViewModelProvider(currentActivity.id).notifier);

    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(
                  hasCurrentUserLiked ? Icons.favorite : Icons.favorite_border,
                  color:
                      hasCurrentUserLiked ? ColorUtils.red : ColorUtils.black,
                ),
                onPressed: () {
                  if (hasCurrentUserLiked) {
                    provider.dislike(currentActivity);
                  } else {
                    provider.like(currentActivity);
                  }
                },
              ),
              Text(
                '${likesCount.ceil()}',
                style: TextStyle(
                  color: ColorUtils.grey,
                  fontFamily: 'Avenir',
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
