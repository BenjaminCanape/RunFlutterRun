import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/jwt_storage.dart';
import '../../../data/repository/user_repository_impl.dart';
import '../../../main.dart';
import 'settings_state.dart';

final settingsViewModelProvider =
    StateNotifierProvider.autoDispose<SettingsViewModel, SettingsState>(
  (ref) => SettingsViewModel(ref),
);

class SettingsViewModel extends StateNotifier<SettingsState> {
  Ref ref;

  SettingsViewModel(this.ref) : super(SettingsState.initial());

  void logout() async {
    await ref.read(userRepositoryProvider).logout();
    await JwtUtils.removeJwt();
    navigatorKey.currentState?.pushReplacementNamed("/login");
  }

  void deleteAccount() async {
    await ref.read(userRepositoryProvider).delete();
    await clearStorage();
    navigatorKey.currentState?.pushReplacementNamed("/login");
  }

  Future<void> clearStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
