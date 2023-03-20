import 'package:flutter/material.dart';


class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;
  const ConfirmationDialog({Key? key,
    required this.title,
    required this.content,
    required this.onConfirm,}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text('Delete'),
          onPressed: onConfirm,
        ),
      ],
    );
  }
}
