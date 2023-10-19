import 'package:flutter/material.dart';
import 'package:run_flutter_run/domain/entities/user.dart';
import 'package:run_flutter_run/presentation/common/friendship/widgets/accept_refuse.dart';

class PendingRequestsListWidget extends StatelessWidget {
  final List<User> users;
  final Function(String) onAccept;
  final Function(String) onReject;

  const PendingRequestsListWidget({
    super.key,
    required this.users,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return ListTile(
            title: Text(user.username),
            trailing: AcceptRefuseWidget(
                userId: user.id, onAccept: onAccept, onReject: onReject));
      },
    );
  }
}
