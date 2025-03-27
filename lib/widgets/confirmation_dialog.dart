import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final bool visible;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final String title;

  const ConfirmationDialog({
    required this.visible,
    required this.onConfirm,
    required this.onCancel,
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return visible
        ? AlertDialog(
          title: Text(title),
          actions: [
            TextButton(onPressed: onCancel, child: Text('Cancel')),
            TextButton(onPressed: onConfirm, child: Text('Confirm')),
          ],
        )
        : SizedBox.shrink();
  }
}
