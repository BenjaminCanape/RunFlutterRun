import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'home_state.dart';

final homeViewModelProvider =
    StateNotifierProvider.autoDispose<HomeViewModel, HomeState>(
        (ref) => HomeViewModel(ref));

class HomeViewModel extends StateNotifier<HomeState> {
  Ref ref;

  HomeViewModel(this.ref) : super(HomeState.initial());

  getCurrentIndex() {
    return state.currentIndex;
  }

  setCurrentIndex(int index) {
    state = state.copyWith(currentIndex: index);
  }
}
