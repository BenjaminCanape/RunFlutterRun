import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../domain/entities/page.dart';
import '../../common/core/utils/user_utils.dart';
import '../../../domain/entities/user.dart';
import '../../common/core/widgets/infinite_scroll_list.dart';
import '../../common/friendship/widgets/accept_refuse.dart';

class PendingRequestsListWidget extends HookConsumerWidget {
  final List<User> users;
  final int total;
  final Function(String) onAccept;
  final Function(String) onReject;
  final Future<EntityPage<User>> Function({int pageNumber}) bottomListScrollFct;

  final ScrollController _scrollController = ScrollController();

  PendingRequestsListWidget(
      {super.key,
      required this.users,
      required this.total,
      required this.onAccept,
      required this.onReject,
      required this.bottomListScrollFct});

  void onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {}
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _scrollController.addListener(onScroll);
    /*return ListView.builder(
      controller: _scrollController,
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return ListTile(
          title: Text(
            UserUtils.getNameOrUsername(user),
          ),
          trailing: AcceptRefuseWidget(
            userId: user.id,
            onAccept: onAccept,
            onReject: onReject,
          ),
        );
      },
    );*/
    return Expanded(
        child: InfiniteScrollList(
      listId: 'PENDING_REQUESTS',
      initialData: users,
      total: total,
      loadData: (int pageNumber) async {
        return await bottomListScrollFct(pageNumber: pageNumber);
      },
      hasMoreData: (data, total) {
        return data.length < total;
      },
      itemBuildFunction: (context, users, index) {
        return ListTile(
          title: Text(
            UserUtils.getNameOrUsername(users[index]),
          ),
          trailing: AcceptRefuseWidget(
            userId: users[index].id,
            onAccept: onAccept,
            onReject: onReject,
          ),
        );
      },
    ));
  }
}
