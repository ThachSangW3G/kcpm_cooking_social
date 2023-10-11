
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class UpdateItemDialog extends StatefulWidget {
  final String initialItemName;
  final Function(String) onUpdateItem;

  const UpdateItemDialog({
    Key? key,
    required this.initialItemName,
    required this.onUpdateItem,
  }) : super(key: key);

  @override
  _UpdateItemDialogState createState() => _UpdateItemDialogState();
}

class _UpdateItemDialogState extends State<UpdateItemDialog> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController =
        TextEditingController(text: widget.initialItemName);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update Item',
          style: TextStyle(
            fontFamily: 'CeraPro',
          )),
      content: TextField(
        controller: _textEditingController,
        decoration: const InputDecoration(
          hintText: 'Enter updated item name',
        ),
        maxLines: null,
        style: const TextStyle(
          fontFamily: 'CeraPro',
        ),
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
          child: const Text('Update',
              style: TextStyle(
                  fontFamily: 'CeraPro', color: AppColors.orangeCrusta)),
          onPressed: () {
            final updatedItemName = _textEditingController.text;
            if (updatedItemName.isNotEmpty) {
              widget.onUpdateItem(updatedItemName);
            }
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
