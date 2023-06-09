import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/entities/activity.dart';
import '../../domain/repository/activity_repository.dart';
import '../api/activity_api.dart';
import '../models/request/ActivityRequest.dart';

final activityRepositoryProvider = Provider<ActivityRepository>(
    (ref) => ActivityRepositoryImpl(ref.read(activityApiProvider)));

class ActivityRepositoryImpl extends ActivityRepository {
  final ActivityApi _remoteApi;

  ActivityRepositoryImpl(this._remoteApi);

  @override
  Future<List<Activity>> getActivities() {
    return _remoteApi
        .getActivities()
        .then((value) => value.map((e) => e.toEntity()).toList());
  }

  @override
  Future<Activity> getActivityById({required String id}) {
    return _remoteApi.getActivityById(id).then((value) => value.toEntity());
  }

  @override
  Future<String> removeActivity({required String id}) {
    return _remoteApi.removeActivity(id).then((value) => value);
  }

  @override
  Future<Activity> addActivity(ActivityRequest request) {
    return _remoteApi.addActivity(request).then((value) => value.toEntity());
  }

  @override
  Future<Activity> editActivity(ActivityRequest request) {
    return _remoteApi.editActivity(request).then((value) => value.toEntity());
  }
}
