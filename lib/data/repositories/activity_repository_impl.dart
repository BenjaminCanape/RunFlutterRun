import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/entities/activity.dart';
import '../../domain/repositories/activity_repository.dart';
import '../api/activity_api.dart';
import '../model/request/activity_request.dart';

/// Provider for the ActivityRepository implementation.
final activityRepositoryProvider =
    Provider<ActivityRepository>((ref) => ActivityRepositoryImpl());

/// Implementation of the ActivityRepository.
class ActivityRepositoryImpl extends ActivityRepository {
  ActivityRepositoryImpl();

  @override
  Future<List<Activity>> getActivities() async {
    final activityResponses = await ActivityApi.getActivities();
    return activityResponses.map((response) => response.toEntity()).toList();
  }

  @override
  Future<List<Activity>> getMyAndMyFriendsActivities() async {
    final activityResponses = await ActivityApi.getMyAndMyFriendsActivities();
    return activityResponses.map((response) => response.toEntity()).toList();
  }

  @override
  Future<List<Activity>> getUserActivities(String userId) async {
    final activityResponses = await ActivityApi.getUserActivities(userId);
    return activityResponses.map((response) => response.toEntity()).toList();
  }

  @override
  Future<Activity> getActivityById({required String id}) async {
    final activityResponse = await ActivityApi.getActivityById(id);
    return activityResponse.toEntity();
  }

  @override
  Future<String?> removeActivity({required String id}) async {
    return await ActivityApi.removeActivity(id);
  }

  @override
  Future<Activity?> addActivity(ActivityRequest request) async {
    final activityResponse = await ActivityApi.addActivity(request);
    return activityResponse?.toEntity();
  }

  @override
  Future<Activity> editActivity(ActivityRequest request) async {
    final activityResponse = await ActivityApi.editActivity(request);
    return activityResponse.toEntity();
  }
}
