import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'home_state.dart';

final homeViewModelProvider =
    StateNotifierProvider.autoDispose<HomeViewModel, HomeState>(
  (ref) => HomeViewModel(ref),
);

class HomeViewModel extends StateNotifier<HomeState> {
  final Ref ref;

  HomeViewModel(this.ref) : super(HomeState.initial());

  int getCurrentIndex() {
    return state.currentIndex;
  }

  void setCurrentIndex(int index) {
    state = state.copyWith(currentIndex: index);
  }
}
