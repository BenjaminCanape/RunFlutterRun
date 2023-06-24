import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:run_flutter_run/presentation/settings/view_model/settings_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/jwt_storage.dart';
import '../../../data/repository/user_repository_impl.dart';

final settingsViewModelProvider =
    StateNotifierProvider.autoDispose<SettingsViewModel, SettingsState>(
  (ref) => SettingsViewModel(ref),
);

class SettingsViewModel extends StateNotifier<SettingsState> {
  Ref ref;

  SettingsViewModel(this.ref) : super(SettingsState.initial());

  void logout(BuildContext context) async {
    await ref.read(userRepositoryProvider).logout();
    await JwtUtils.removeJwt();
    Navigator.pushReplacementNamed(context, "/login");
  }

  void deleteAccount(BuildContext context) async {
    await ref.read(userRepositoryProvider).delete();
    await clearStorage();
    Navigator.pushReplacementNamed(context, "/login");
  }

  Future<void> clearStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
