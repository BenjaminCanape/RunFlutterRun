import 'package:flutter/material.dart';
import '../../../domain/entities/user.dart';
import '../../common/friendship/widgets/accept_refuse.dart';

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
            title: Text(
              user.firstname != null && user.lastname != null
                  ? '${user.firstname} ${user.lastname}'
                  : user.username,
            ),
            trailing: AcceptRefuseWidget(
                userId: user.id, onAccept: onAccept, onReject: onReject));
      },
    );
  }
}
