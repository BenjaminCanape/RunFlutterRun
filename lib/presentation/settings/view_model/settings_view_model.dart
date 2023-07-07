import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/repositories/user_repository_impl.dart';
import '../../../main.dart';
import 'settings_state.dart';

final settingsViewModelProvider =
    StateNotifierProvider.autoDispose<SettingsViewModel, SettingsState>(
  (ref) => SettingsViewModel(ref),
);

class SettingsViewModel extends StateNotifier<SettingsState> {
  Ref ref;

  /// Manages the state and logic of the settings screen.
  ///
  /// [ref] - The reference to the hooks riverpod container.
  SettingsViewModel(this.ref) : super(SettingsState.initial());

  /// Logs out the user.
  Future<void> logoutUser() async {
    try {
      await ref.read(userRepositoryProvider).logout();
      navigatorKey.currentState?.pushReplacementNamed("/login");
    } catch (error) {
      // Handle logout error
    }
  }

  /// Deletes the user account.
  Future<void> deleteUserAccount() async {
    try {
      await ref.read(userRepositoryProvider).delete();
      await clearStorage();
      navigatorKey.currentState?.pushReplacementNamed("/login");
    } catch (error) {
      // Handle account deletion error
    }
  }

  /// Clears the local storage.
  Future<void> clearStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
