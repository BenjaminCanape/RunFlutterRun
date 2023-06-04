import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../api/remote_api.dart';
import '../models/request/ActivityRequest.dart';
import '../../domain/entities/activity.dart';
import '../../domain/repository/activity_repository.dart';

final activityRepositoryProvider = Provider<ActivityRepository>(
    (ref) => ActivityRepositoryImpl(ref.read(remoteApiProvider)));

class ActivityRepositoryImpl extends ActivityRepository {
  final RemoteApi _remoteApi;

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
