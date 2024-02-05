import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/utils/storage_utils.dart';
import '../../../data/repositories/user_repository_impl.dart';
import '../../../domain/entities/user.dart';
import '../../../main.dart';
import '../../common/core/enums/infinite_scroll_list.enum.dart';
import '../../common/core/utils/color_utils.dart';
import '../../common/core/widgets/view_model/infinite_scroll_list_view_model.dart';
import 'state/settings_state.dart';

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
      state = state.copyWith(isLoading: true);
      await ref.read(userRepositoryProvider).logout();
      await clearStorage();
      await resetInfiniteLists();
      navigatorKey.currentState?.pushReplacementNamed("/login");
    } catch (error) {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Deletes the user account.
  Future<void> deleteUserAccount() async {
    try {
      state = state.copyWith(isLoading: true);
      await ref.read(userRepositoryProvider).delete();
      await clearStorage();
      await resetInfiniteLists();
      navigatorKey.currentState?.pushReplacementNamed("/login");
    } catch (error) {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Display an alert to confirm or cancel the deletion of the account
  void showDeleteAccountAlert(BuildContext context, String title,
      String confirmBtnText, String cancelBtnText) {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.confirm,
        title: title,
        confirmBtnText: confirmBtnText,
        cancelBtnText: cancelBtnText,
        confirmBtnColor: ColorUtils.red,
        onCancelBtnTap: () => Navigator.of(context).pop(),
        onConfirmBtnTap: () {
          Navigator.of(context).pop();
          deleteUserAccount();
        });
  }

  /// Clears the local storage.
  Future<void> clearStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  /// reset infinite lists
  Future<void> resetInfiniteLists() async {
    ref
        .read(infiniteScrollListViewModelProvider(
                InfiniteScrollListEnum.myActivities.toString())
            .notifier)
        .reset();
    ref
        .read(infiniteScrollListViewModelProvider(
                InfiniteScrollListEnum.community.toString())
            .notifier)
        .reset();
    User? currentUser = await StorageUtils.getUser();
    if (currentUser != null) {
      ref
          .read(infiniteScrollListViewModelProvider(
                  '${InfiniteScrollListEnum.profile}_${currentUser.id}')
              .notifier)
          .reset();
    }
  }
}
