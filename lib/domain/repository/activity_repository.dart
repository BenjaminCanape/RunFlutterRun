import '../../data/models/request/ActivityRequest.dart';
import '../entities/activity.dart';

abstract class ActivityRepository {
  Future<List<Activity>> getActivities();
  Future<Activity> getActivityById({required String id});
  Future<String?> removeActivity({required String id});
  Future<Activity> addActivity(ActivityRequest request);
  Future<Activity> editActivity(ActivityRequest request);
}
