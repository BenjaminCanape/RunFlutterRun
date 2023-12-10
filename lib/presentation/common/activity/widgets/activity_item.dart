import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'activty_like.dart';

import '../../../../domain/entities/activity.dart';
import '../../core/utils/activity_utils.dart';
import '../../core/utils/color_utils.dart';
import '../../core/utils/ui_utils.dart';
import '../../core/utils/user_utils.dart';
import '../view_model/activity_item_view_model.dart';
import 'activity_comments.dart';

class ActivityItem extends HookConsumerWidget {
  final int index;
  final Activity activity;
  final bool displayUserName;
  final bool canOpenActivity;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ActivityItem({
    super.key,
    required this.activity,
    required this.index,
    this.displayUserName = false,
    this.canOpenActivity = true,
  });

  final futureDataProvider =
      FutureProvider.family<Uint8List?, Activity>((ref, activity) async {
    final provider =
        ref.read(activityItemViewModelProvider(activity.id).notifier);
    String userId = activity.user.id;
    return provider.getProfilePicture(userId);
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider =
        ref.read(activityItemViewModelProvider(activity.id).notifier);
    final state = ref.watch(activityItemViewModelProvider(activity.id));
    final futureProvider = ref.watch(futureDataProvider(activity));
    final appLocalizations = AppLocalizations.of(context)!;
    final formattedDate =
        DateFormat('dd/MM/yyyy').format(activity.startDatetime);
    final formattedTime = DateFormat('HH:mm').format(activity.startDatetime);

    final List<Color> colors = ColorUtils.generateColorTupleFromIndex(index);
    final startColor = colors.first;
    final endColor = colors.last;
    const double borderRadius = 24;

    Activity currentActivity = state.activity ?? activity;

    return InkWell(
      onTap: () async {
        if (canOpenActivity) {
          final activityDetails = await provider.getActivityDetails(activity);
          provider.goToActivity(activityDetails);
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        elevation: 0.25,
        margin: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              children: [
                if (!displayUserName)
                  Container(
                    width: 120,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(borderRadius),
                        bottomLeft: Radius.circular(borderRadius),
                      ),
                      gradient: LinearGradient(
                        colors: [startColor, endColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: endColor,
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        ActivityUtils.getActivityTypeIcon(activity.type),
                        color: ColorUtils.white,
                        size: 40,
                      ),
                    ),
                  ),
                if (!displayUserName) const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (displayUserName)
                        _buildUserInformation(context, futureProvider),
                      Padding(
                        padding:
                            EdgeInsets.only(left: displayUserName ? 30 : 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                ActivityUtils.translateActivityTypeValue(
                                  appLocalizations,
                                  activity.type,
                                ).toUpperCase(),
                                style: TextStyle(
                                  color: startColor,
                                  fontFamily: 'Avenir',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: displayUserName ? 30 : 0,
                          bottom: displayUserName ? 30 : 0,
                        ),
                        child: _buildActivityDetails(context, appLocalizations,
                            formattedDate, formattedTime),
                      ),
                    ],
                  ),
                ),
                if (canOpenActivity)
                  Icon(
                    Icons.navigate_next,
                    color: ColorUtils.black,
                    size: 30,
                  ),
              ],
            ),
            if (displayUserName)
              _buildLikeAndCommentsSection(
                  ref, provider, currentActivity, state.displayComments),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInformation(
      BuildContext context, AsyncValue<Uint8List?> futureProvider) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: ColorUtils.greyLight,
              width: 0.5,
            ),
          ),
        ),
        child: TextButton(
          onPressed: () {
            UserUtils.goToProfile(activity.user);
          },
          child: Row(
            children: [
              futureProvider.when(
                data: (profilePicture) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      alignment: Alignment.center,
                      width: 50,
                      height: 50,
                      child: profilePicture != null
                          ? Image.memory(
                              profilePicture,
                              fit: BoxFit.cover,
                            )
                          : Icon(
                              Icons.person,
                              size: 50,
                              color: ColorUtils.black,
                            ),
                    ),
                  );
                },
                loading: () {
                  return Center(child: UIUtils.loader);
                },
                error: (error, stackTrace) {
                  return Icon(
                    Icons.person,
                    size: 50,
                    color: ColorUtils.black,
                  );
                },
              ),
              const SizedBox(
                width: 20,
              ),
              Flexible(
                child: Text(
                  activity.user.firstname != null &&
                          activity.user.lastname != null
                      ? '${activity.user.firstname} ${activity.user.lastname}'
                      : activity.user.username,
                  style: TextStyle(color: ColorUtils.black),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityDetails(
    BuildContext context,
    AppLocalizations appLocalizations,
    String formattedDate,
    String formattedTime,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${appLocalizations.date_pronoun} $formattedDate ${appLocalizations.hours_pronoun} $formattedTime',
          style: TextStyle(
            color: ColorUtils.greyDarker,
            fontFamily: 'Avenir',
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              Icons.location_on,
              color: ColorUtils.grey,
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              '${activity.distance.toStringAsFixed(2)} km',
              style: TextStyle(
                color: ColorUtils.grey,
                fontFamily: 'Avenir',
              ),
            ),
          ],
        ),
        Row(
          children: [
            Icon(
              Icons.speed,
              color: ColorUtils.grey,
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              '${activity.speed.toStringAsFixed(2)} km/h',
              style: TextStyle(
                color: ColorUtils.grey,
                fontFamily: 'Avenir',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLikeAndCommentsSection(
      WidgetRef ref,
      ActivityItemViewModel provider,
      Activity currentActivity,
      bool displayComments) {
    return Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  IconButton(
                    icon: Icon(
                      Icons.comment_outlined,
                      color: ColorUtils.black,
                      size: 24,
                    ),
                    onPressed: () {
                      provider.toggleComments();
                    },
                  ),
                  Text(currentActivity.comments.length.toString()),
                ]),
                ActivityLike(
                    currentActivity: currentActivity,
                    likeFunction: provider.like,
                    dislikeFunction: provider.dislike)
              ],
            ),
            if (displayComments)
              ActivityComments(
                currentActivity: currentActivity,
                formKey: formKey,
              ),
          ],
        ));
  }
}
