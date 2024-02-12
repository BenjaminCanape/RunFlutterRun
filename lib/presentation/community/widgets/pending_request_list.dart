import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domain/entities/page.dart';
import '../../../domain/entities/user.dart';
import '../../common/core/utils/user_utils.dart';
import '../../common/core/widgets/infinite_scroll_list.dart';
import '../../common/friendship/widgets/accept_refuse.dart';

class PendingRequestsListWidget extends HookConsumerWidget {
  final List<User> users;
  final int total;
  final Function(String) onAccept;
  final Function(String) onReject;
  final Future<EntityPage<User>> Function({int pageNumber}) bottomListScrollFct;

  const PendingRequestsListWidget(
      {super.key,
      required this.users,
      required this.total,
      required this.onAccept,
      required this.onReject,
      required this.bottomListScrollFct});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InfiniteScrollList(
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
    );
  }
}
