import '../../data/model/request/activity_request.dart';
import '../entities/activity.dart';
import '../entities/activity_comment.dart';
import '../entities/page.dart';

/// Abstract class representing the activity repository.
abstract class ActivityRepository {
  /// Retrieves a page of activities.
  Future<EntityPage<Activity>> getActivities({int pageNumber});

  /// Retrieves a page of my activities and my friends.
  Future<EntityPage<Activity>> getMyAndMyFriendsActivities({int pageNumber});

  /// Retrieves a page of a user activities.
  Future<EntityPage<Activity>> getUserActivities(String userId,
      {int pageNumber});

  /// Retrieves an activity by its ID.
  Future<Activity> getActivityById({required String id});

  /// Removes an activity by its ID.
  Future<String?> removeActivity({required String id});

  /// Adds a new activity.
  Future<Activity?> addActivity(ActivityRequest request);

  /// Edits an existing activity.
  Future<Activity> editActivity(ActivityRequest request);

  /// Like the activity
  Future<void> like(String id);

  /// Dislike the activity
  Future<void> dislike(String id);

  /// Removes a comment by its ID.
  Future<String?> removeComment({required String id});

  /// Adds a new comment.
  Future<ActivityComment?> createComment(String activityId, String comment);

  /// Edits an existing comment.
  Future<ActivityComment> editComment(String id, String comment);
}
