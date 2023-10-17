import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:run_flutter_run/presentation/community/screens/pending_requests_screen.dart';
import 'package:run_flutter_run/presentation/community/view_model/community_view_model.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
//import 'package:run_flutter_run/presentation/community/view_model/pending_request_view_model.dart';
import '../../../domain/entities/user.dart';
import '../../common/core/utils/form_utils.dart';
import '../../common/activity/widgets/activity_list.dart';
import '../../common/core/utils/ui_utils.dart';
import '../view_model/pending_request_view_model.dart';
import '../widgets/search_widget.dart';

/// The screen that displays community infos
class CommunityScreen extends HookConsumerWidget {
  final TextEditingController _searchController = TextEditingController();

  CommunityScreen({Key? key}) : super(key: key);

  final pendingRequestsDataFutureProvider =
      FutureProvider<List<User>>((ref) async {
    final pendingRequestsProvider =
        ref.read(pendingRequestsViewModelProvider.notifier);
    final requests = await pendingRequestsProvider.getPendingRequests();
    return requests;
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.read(communityViewModelProvider.notifier);
    var state = ref.read(communityViewModelProvider);
    //var pendingRequestsState = ref.read(pendingRequestsViewModelProvider);

    var pendingRequestsStateProvider =
        ref.watch(pendingRequestsDataFutureProvider);

    return Scaffold(
        appBar: SearchWidget(
          searchController: _searchController,
          onSearchChanged: (String query) {
            return provider.search(query);
          },
        ),
        body: Column(children: [
          pendingRequestsStateProvider.when(
            data: (requests) {
              return requests.isNotEmpty
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
                                child: PendingRequestsScreen(users: requests),
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
                                  "${"${AppLocalizations.of(context).see_pending_requests} (${requests.length}"})"),
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
          state.isLoading
              ? const Center(child: UIUtils.loader)
              : ActivityList(activities: state.activities)
        ]));
  }
}
