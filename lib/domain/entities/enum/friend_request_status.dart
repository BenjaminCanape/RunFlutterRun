import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Enum representing different status of friend requests.
enum FriendRequestStatus { pending, accepted, rejected, canceled }

/// Extension on FriendRequestStatus to provide translated names based on the given localization.
extension FriendRequestStatusExtension on FriendRequestStatus {
  /// Retrieves the translated name of the friend request status based on the provided localization.
  String getTranslatedName(AppLocalizations localization) {
    switch (this) {
      case FriendRequestStatus.pending:
        return localization.pending;
      case FriendRequestStatus.accepted:
        return localization.accepted;
      case FriendRequestStatus.rejected:
        return localization.rejected;
      case FriendRequestStatus.canceled:
        return localization.canceled;
      default:
        return '';
    }
  }
}
