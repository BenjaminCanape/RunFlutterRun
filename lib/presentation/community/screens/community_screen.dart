import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domain/entities/activity.dart';
import '../../common/activity/widgets/activity_list.dart';
import '../../common/core/utils/form_utils.dart';
import '../../common/core/utils/ui_utils.dart';
import '../view_model/community_view_model.dart';
import '../view_model/pending_request_view_model.dart';
import '../widgets/search_widget.dart';
import 'pending_requests_screen.dart';

/// The screen that displays community infos
class CommunityScreen extends HookConsumerWidget {
  final TextEditingController _searchController = TextEditingController();

  CommunityScreen({Key? key}) : super(key: key);

  final pendingRequestsDataFutureProvider = FutureProvider<void>((ref) async {
    final pendingRequestsProvider =
        ref.watch(pendingRequestsViewModelProvider.notifier);
    pendingRequestsProvider.getPendingRequests();
  });

  final communityDataFutureProvider =
      FutureProvider<List<Activity>>((ref) async {
    final communityProvider = ref.read(communityViewModelProvider.notifier);
    final activities = await communityProvider.getMyAndMyFriendsActivities();
    return activities;
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.read(communityViewModelProvider.notifier);
    var pendingRequestsStateProvider =
        ref.watch(pendingRequestsDataFutureProvider);
    var pendingRequestsState = ref.watch(pendingRequestsViewModelProvider);
    var communityStateProvider = ref.watch(communityDataFutureProvider);

    return Scaffold(
        appBar: SearchWidget(
          searchController: _searchController,
          onSearchChanged: (String query) {
            return provider.search(query);
          },
        ),
        body: Column(children: [
          pendingRequestsStateProvider.when(
            data: (_) {
              return pendingRequestsState.pendingRequests.isNotEmpty
                  ? Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 16.0),
                      child: ElevatedButton(
                        style: FormUtils.buttonStyle,
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration:
                                  const Duration(milliseconds: 500),
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(1.0, 0.0),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: const PendingRequestsScreen(),
                              ),
                            ),
                          );
                        },
                        child: Align(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.people),
                              const SizedBox(width: 8),
                              Text(
                                  "${"${AppLocalizations.of(context)!.see_pending_requests} (${pendingRequestsState.pendingRequests.length}"})"),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Container();
            },
            loading: () {
              return const Center(child: UIUtils.loader);
            },
            error: (error, stackTrace) {
              return Text('$error');
            },
          ),
          communityStateProvider.when(
            data: (activities) {
              return ActivityList(
                activities: activities,
                displayUserName: true,
                canOpenActivity: false,
              );
            },
            loading: () {
              return const Center(child: UIUtils.loader);
            },
            error: (error, stackTrace) {
              return Text('$error');
            },
          )
        ]));
  }
}
