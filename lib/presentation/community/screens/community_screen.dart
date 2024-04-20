import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domain/entities/activity.dart';
import '../../../domain/entities/page.dart';
import '../../../domain/entities/user.dart';
import '../../common/activity/widgets/activity_list.dart';
import '../../common/core/enums/infinite_scroll_list.enum.dart';
import '../../common/core/utils/color_utils.dart';
import '../../common/core/utils/ui_utils.dart';
import '../view_model/community_view_model.dart';
import '../view_model/pending_request_view_model.dart';
import '../widgets/search_widget.dart';
import 'pending_requests_screen.dart';

/// The screen that displays community infos
class CommunityScreen extends HookConsumerWidget {
  final TextEditingController _searchController = TextEditingController();

  CommunityScreen({super.key});

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey();

  final pendingRequestsDataFutureProvider = FutureProvider<int>((ref) async {
    final pendingRequestsProvider =
        ref.watch(pendingRequestsViewModelProvider.notifier);
    EntityPage<User> users =
        await pendingRequestsProvider.fetchPendingRequests();
    return users.total;
  });

  final communityDataFutureProvider =
      FutureProvider<EntityPage<Activity>>((ref) async {
    final communityProvider = ref.read(communityViewModelProvider.notifier);
    return await communityProvider.getInitialMyAndMyFriendsActivities();
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.read(communityViewModelProvider.notifier);
    var pendingRequestsStateProvider =
        ref.watch(pendingRequestsDataFutureProvider);
    var communityStateProvider = ref.watch(communityDataFutureProvider);

    return Scaffold(
        appBar: SearchWidget(
          searchController: _searchController,
          onSearchChanged: (String query) {
            return provider.search(query);
          },
        ),
        body: Column(children: [
          Expanded(
            child: RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: () async {
                  provider.refreshList();
                  return ref.refresh(communityDataFutureProvider);
                },
                child: Column(children: [
                  communityStateProvider.when(
                    data: (initialData) {
                      return ActivityList(
                        id: InfiniteScrollListEnum.community.toString(),
                        activities: initialData.list,
                        total: initialData.total,
                        displayUserName: true,
                        canOpenActivity: false,
                        bottomListScrollFct:
                            provider.getInitialMyAndMyFriendsActivities,
                      );
                    },
                    loading: () {
                      return Expanded(child: Center(child: UIUtils.loader));
                    },
                    error: (error, stackTrace) {
                      return Text('$error');
                    },
                  )
                ])),
          ),
        ]),
        floatingActionButton: pendingRequestsStateProvider.when(
          data: (total) {
            return total > 0
                ? FloatingActionButton(
                    backgroundColor: ColorUtils.main,
                    elevation: 4.0,
                    child: Badge.count(
                      count: total,
                      textColor: ColorUtils.black,
                      backgroundColor: ColorUtils.white,
                      child: Icon(
                        Icons.people,
                        color: ColorUtils.white,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 500),
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(1.0, 0.0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: PendingRequestsScreen(),
                          ),
                        ),
                      );
                    },
                  )
                : Container();
          },
          loading: () {
            return Container();
          },
          error: (error, stackTrace) {
            return Container();
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat);
  }
}
