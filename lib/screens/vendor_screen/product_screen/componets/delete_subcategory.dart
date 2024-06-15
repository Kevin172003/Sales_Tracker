import 'package:flutter/material.dart';

class DeleteSubcategoryDialog extends StatefulWidget {
  final String subProductID;
  final void Function(String) deleteSubProduct;

  DeleteSubcategoryDialog({Key? key, required this.subProductID, required this.deleteSubProduct}) : super(key: key);

  @override
  State<DeleteSubcategoryDialog> createState() => DeleteSubcategoryDialogState();
}

class DeleteSubcategoryDialogState extends State<DeleteSubcategoryDialog> {
  bool _isDeleted = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: _isDeleted
          ? const SizedBox(
        height: 48,
        width: 48,
        child: Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 60,
        ),
      )
          : const Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('Are you sure you want to delete?', style: TextStyle(fontSize: 20)),
          SizedBox(height: 20),
        ],
      ),
      actions: <Widget>[
        if (!_isDeleted)
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        if (!_isDeleted)
          TextButton(
            onPressed: () async {
              widget.deleteSubProduct(widget.subProductID);
              setState(() {
                _isDeleted = true;
              });
              await Future.delayed(const Duration(seconds: 1));
              if (mounted) {
                setState(() {
                  _isDeleted = false;
                });
              }
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
      ],
    );
  }
}
