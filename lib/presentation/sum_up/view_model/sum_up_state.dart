import '../../../domain/entities/enum/activity_type.dart';

/// Represents the state of the SumUpScreen.
class SumUpState {
  final bool isSaving;
  final ActivityType type;

  /// Creates a new instance of SumUpState.
  const SumUpState({
    required this.type,
    required this.isSaving,
  });

  /// Creates an initial state with default values.
  factory SumUpState.initial() {
    return const SumUpState(
      isSaving: false,
      type: ActivityType.running,
    );
  }

  /// Creates a copy of the state with optional updates.
  SumUpState copyWith({
    bool? isSaving,
    ActivityType? type,
  }) {
    return SumUpState(
      isSaving: isSaving ?? this.isSaving,
      type: type ?? this.type,
    );
  }
}
