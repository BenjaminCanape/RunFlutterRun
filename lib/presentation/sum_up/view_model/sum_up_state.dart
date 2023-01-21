class SumUpState {
  final bool isSaving;

  const SumUpState({required this.isSaving});

  factory SumUpState.initial() {
    return const SumUpState(isSaving: false);
  }

  SumUpState copyWith({bool? isSaving}) {
    return SumUpState(isSaving: isSaving ?? this.isSaving);
  }
}
