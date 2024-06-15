import 'package:flutter/material.dart';

class DeleteProductConfirmationDialog extends StatefulWidget {
  final String productID;
  final void Function(String) deleteProduct;

  DeleteProductConfirmationDialog({Key? key, required this.productID, required this.deleteProduct}) : super(key: key);

  @override
  _DeleteProductConfirmationDialogState createState() => _DeleteProductConfirmationDialogState();
}

class _DeleteProductConfirmationDialogState extends State<DeleteProductConfirmationDialog> {
  bool _isDeleted = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: _isDeleted ? const SizedBox(
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
              setState(() {
                widget.deleteProduct(widget.productID);
                _isDeleted = true;
                Navigator.of(context).pop();
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
