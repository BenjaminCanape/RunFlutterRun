import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/core/utils/ui_utils.dart';
import '../view_model/pending_request_view_model.dart';
import '../widgets/pending_request_list.dart';

/// The screen that displays pending requests
class PendingRequestsScreen extends HookConsumerWidget {
  const PendingRequestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var state = ref.watch(pendingRequestsViewModelProvider);
    var provider = ref.read(pendingRequestsViewModelProvider.notifier);
    return state.isLoading
        ? Center(child: UIUtils.loader)
        : Scaffold(
            body: SafeArea(
                child: Column(children: [
              UIUtils.createHeader(
                  AppLocalizations.of(context)!.pending_requests_title),
              const SizedBox(height: 40),
              Expanded(
                  child: PendingRequestsListWidget(
                users: state.pendingRequests,
                onAccept: (userId) => provider.acceptRequest(userId),
                onReject: (userId) => provider.rejectRequest(userId),
              ))
            ])),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: UIUtils.createBackButton(context),
          );
  }
}
