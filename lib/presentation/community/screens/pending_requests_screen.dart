import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domain/entities/page.dart';
import '../../../domain/entities/user.dart';
import '../../common/core/utils/ui_utils.dart';
import '../view_model/pending_request_view_model.dart';
import '../widgets/pending_request_list.dart';

/// The screen that displays pending requests
class PendingRequestsScreen extends HookConsumerWidget {
  PendingRequestsScreen({super.key});

  final pendingRequestsDataFutureProvider =
      FutureProvider<EntityPage<User>>((ref) async {
    final provider = ref.read(pendingRequestsViewModelProvider.notifier);
    return await provider.fetchPendingRequests();
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var state = ref.watch(pendingRequestsViewModelProvider);
    var provider = ref.read(pendingRequestsViewModelProvider.notifier);

    var pendingRequestsStateProvider =
        ref.watch(pendingRequestsDataFutureProvider);

    return state.isLoading
        ? Center(child: UIUtils.loader)
        : Scaffold(
            body: SafeArea(
                child: Column(children: [
              UIUtils.createHeader(
                  AppLocalizations.of(context)!.pending_requests_title),
              const SizedBox(height: 40),
              Expanded(
                  child: pendingRequestsStateProvider.when(
                data: (initialData) {
                  return PendingRequestsListWidget(
                    users: initialData.list,
                    total: initialData.total,
                    onAccept: (userId) => provider.acceptRequest(userId),
                    onReject: (userId) => provider.rejectRequest(userId),
                    bottomListScrollFct: provider.fetchPendingRequests,
                  );
                },
                loading: () {
                  return Center(child: UIUtils.loader);
                },
                error: (error, stackTrace) {
                  return Text('$error');
                },
              ))
            ])),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: UIUtils.createBackButton(context),
          );
  }
}
