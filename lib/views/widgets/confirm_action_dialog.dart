import 'package:flutter/material.dart';

class ConfirmActionDialog extends StatelessWidget {
  final String dialogBodyText;
  final VoidCallback onYesCallBack;
  final VoidCallback onNoCallBack;

  const ConfirmActionDialog({
    super.key,
    required this.dialogBodyText,
    required this.onYesCallBack,
    required this.onNoCallBack,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Are you sure?"),
      content: Text(dialogBodyText),
      actions: [
        TextButton(onPressed: onNoCallBack, child: Text("No")),

        TextButton(onPressed: onYesCallBack, child: Text("Yes")),
      ],
    );
  }
}
