import 'package:flutter/material.dart';

import '../../core/utils/color_utils.dart';

/// A widget that displays a accept and refuse buttons
class AcceptRefuseWidget extends StatelessWidget {
  final String userId;
  final Function(String) onAccept;
  final Function(String) onReject;

  const AcceptRefuseWidget({
    super.key,
    required this.userId,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.check),
          color: ColorUtils.green,
          onPressed: () {
            onAccept(userId);
          },
        ),
        IconButton(
          icon: const Icon(Icons.close),
          color: ColorUtils.red,
          onPressed: () {
            onReject(userId);
          },
        ),
      ],
    );
  }
}
