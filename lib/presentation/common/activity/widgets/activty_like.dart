import 'package:flutter/material.dart';
import 'package:run_flutter_run/domain/entities/activity.dart';

class ActivityLike extends StatelessWidget {
  final Activity currentActivity;
  final Function likeFunction;
  final Function dislikeFunction;

  const ActivityLike(
      {super.key,
      required this.currentActivity,
      required this.likeFunction,
      required this.dislikeFunction});

  @override
  Widget build(BuildContext buildContext) {
    bool hasCurrentUserLiked = currentActivity.hasCurrentUserLiked;

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
                  color: hasCurrentUserLiked ? Colors.red : Colors.black,
                ),
                onPressed: () {
                  if (hasCurrentUserLiked) {
                    dislikeFunction(currentActivity);
                  } else {
                    likeFunction(currentActivity);
                  }
                },
              ),
              Text(
                '${currentActivity.likesCount.ceil()}',
                style: TextStyle(
                  color: Colors.grey.shade600,
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
