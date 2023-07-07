import '../../data/model/request/activity_request.dart';
import '../entities/activity.dart';

/// Abstract class representing the activity repository.
abstract class ActivityRepository {
  /// Retrieves a list of activities.
  Future<List<Activity>> getActivities();

  /// Retrieves an activity by its ID.
  Future<Activity> getActivityById({required String id});

  /// Removes an activity by its ID.
  Future<String?> removeActivity({required String id});

  /// Adds a new activity.
  Future<Activity?> addActivity(ActivityRequest request);

  /// Edits an existing activity.
  Future<Activity> editActivity(ActivityRequest request);
}
