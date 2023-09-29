import 'package:flutter/material.dart';

class FriendRequestWidget extends StatelessWidget {
  final String username;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const FriendRequestWidget({
    super.key,
    required this.username,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              '$username vous a envoyé une demande d\'amitié',
              style:
                  const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: onAccept,
                  child: const Text('Accepter'),
                ),
                const SizedBox(width: 16.0),
                OutlinedButton(
                  onPressed: onDecline,
                  child: const Text('Décliner'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
