import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/entities/activity.dart';
import '../../domain/repository/activity_repository.dart';
import '../api/activity_api.dart';
import '../models/request/activity_request.dart';

final activityRepositoryProvider = Provider<ActivityRepository>(
    (ref) => ActivityRepositoryImpl(ref.read(activityApiProvider)));

class ActivityRepositoryImpl extends ActivityRepository {
  final ActivityApi _remoteApi;

  ActivityRepositoryImpl(this._remoteApi);

  @override
  Future<List<Activity>> getActivities() async {
    final activityResponses = await _remoteApi.getActivities();
    return activityResponses.map((response) => response.toEntity()).toList();
  }

  @override
  Future<Activity> getActivityById({required String id}) async {
    final activityResponse = await _remoteApi.getActivityById(id);
    return activityResponse.toEntity();
  }

  @override
  Future<String?> removeActivity({required String id}) async {
    return await _remoteApi.removeActivity(id);
  }

  @override
  Future<Activity?> addActivity(ActivityRequest request) async {
    final activityResponse = await _remoteApi.addActivity(request);
    return activityResponse?.toEntity();
  }

  @override
  Future<Activity> editActivity(ActivityRequest request) async {
    final activityResponse = await _remoteApi.editActivity(request);
    return activityResponse.toEntity();
  }
}
