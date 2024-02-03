import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/entities/activity.dart';
import '../../domain/entities/activity_comment.dart';
import '../../domain/entities/page.dart';
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
  Future<EntityPage<Activity>> getActivities({int pageNumber = 0}) async {
    final activityResponses = await ActivityApi.getActivities(pageNumber);
    List<Activity> activities =
        activityResponses.list.map((response) => response.toEntity()).toList();
    return EntityPage(list: activities, total: activityResponses.total);
  }

  @override
  Future<EntityPage<Activity>> getMyAndMyFriendsActivities(
      {int pageNumber = 0}) async {
    final activityResponses =
        await ActivityApi.getMyAndMyFriendsActivities(pageNumber);

    List<Activity> activities =
        activityResponses.list.map((response) => response.toEntity()).toList();
    return EntityPage(list: activities, total: activityResponses.total);
  }

  @override
  Future<EntityPage<Activity>> getUserActivities(String userId,
      {int pageNumber = 0}) async {
    final activityResponses =
        await ActivityApi.getUserActivities(userId, pageNumber);
    List<Activity> activities =
        activityResponses.list.map((response) => response.toEntity()).toList();
    return EntityPage(list: activities, total: activityResponses.total);
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

  @override
  Future<void> like(String id) async {
    await ActivityApi.like(id);
  }

  @override
  Future<void> dislike(String id) async {
    await ActivityApi.dislike(id);
  }

  @override
  Future<ActivityComment?> createComment(
      String activityId, String comment) async {
    final response = await ActivityApi.createComment(activityId, comment);
    return response.toEntity();
  }

  @override
  Future<ActivityComment> editComment(String id, String comment) async {
    final response = await ActivityApi.editComment(id, comment);
    return response.toEntity();
  }

  @override
  Future<String?> removeComment({required String id}) async {
    return await ActivityApi.removeComment(id);
  }
}
