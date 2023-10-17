import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'state/home_state.dart';

final homeViewModelProvider =
    StateNotifierProvider.autoDispose<HomeViewModel, HomeState>(
  (ref) => HomeViewModel(ref),
);

class HomeViewModel extends StateNotifier<HomeState> {
  final Ref ref;

  /// Constructs a `HomeViewModel` with the provided [ref] and an initial [HomeState].
  HomeViewModel(this.ref) : super(HomeState.initial());

  /// Returns the current index value from the state.
  int getCurrentIndex() {
    return state.currentIndex;
  }

  /// Sets the current index value to the specified [index].
  void setCurrentIndex(int index) {
    state = state.copyWith(currentIndex: index);
  }
}
