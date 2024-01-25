import '../../../../../domain/entities/activity.dart';

/// The state class for activity list.
class ActivityListWidgetState {
  final double scrollPosition;
  final int pageNumber;
  final int total;
  final int nbOfElements;
  final bool isLoading;
  final List<List<Activity>> groupedActivities;

  const ActivityListWidgetState(
      {required this.scrollPosition,
      required this.pageNumber,
      required this.total,
      required this.nbOfElements,
      required this.isLoading,
      required this.groupedActivities});

  /// Factory method to create the initial state.
  factory ActivityListWidgetState.initial() {
    return const ActivityListWidgetState(
        scrollPosition: 0,
        pageNumber: 0,
        total: 0,
        nbOfElements: 0,
        isLoading: false,
        groupedActivities: []);
  }

  ActivityListWidgetState copyWith(
      {double? position,
      int? pageNumber,
      int? total,
      int? nbOfElements,
      bool? isLoading,
      List<List<Activity>>? groupedActivities}) {
    return ActivityListWidgetState(
        scrollPosition: position ?? scrollPosition,
        isLoading: isLoading ?? this.isLoading,
        pageNumber: pageNumber ?? this.pageNumber,
        total: total ?? this.total,
        nbOfElements: nbOfElements ?? this.nbOfElements,
        groupedActivities: groupedActivities ?? this.groupedActivities);
  }
}
