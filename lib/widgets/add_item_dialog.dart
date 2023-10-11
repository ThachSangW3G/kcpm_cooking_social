
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AddItemDialog extends StatefulWidget {
  final Function(String) onAddItem;

  const AddItemDialog({super.key, required this.onAddItem});

  @override
  _AddItemDialogState createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Add Item',
        style: TextStyle(
          fontFamily: 'CeraPro',
        ),
      ),
      content: TextField(
        controller: _textEditingController,
        decoration: const InputDecoration(
            hintText: 'Enter item name',
            hintStyle: TextStyle(
              fontFamily: 'CeraPro',
            )),
        maxLines: null,
      ),
      actions: [
        TextButton(
          child: const Text('Cancel',
              style: TextStyle(
                  fontFamily: 'CeraPro', color: AppColors.orangeCrusta)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: const Text('Add',
              style: TextStyle(
                  fontFamily: 'CeraPro', color: AppColors.orangeCrusta)),
          onPressed: () {
            final itemName = _textEditingController.text;
            if (itemName.isNotEmpty) {
              widget.onAddItem(itemName);
            }
          },
        ),
      ],
    );
  }
}
