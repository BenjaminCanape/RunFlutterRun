import '../../../data/models/enum/activity_type.dart';

class SumUpState {
  final bool isSaving;
  final ActivityType type;

  const SumUpState({required this.type, required this.isSaving});

  factory SumUpState.initial() {
    return const SumUpState(isSaving: false, type: ActivityType.running);
  }

  SumUpState copyWith({bool? isSaving, ActivityType? type}) {
    return SumUpState(
        isSaving: isSaving ?? this.isSaving, type: type ?? this.type);
  }
}
