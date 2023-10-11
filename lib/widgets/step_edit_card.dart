
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kcpm/widgets/update_item_dialog.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../providers/add_recipe_provider/steps_provider.dart';

class StepEditCard extends StatelessWidget {
  final Item step;
  // final Function(IngredientItem) onTap;
  // final Function(IngredientItem) onDelete;
  // final Function(IngredientEditCard) onEdit;

  const StepEditCard({Key? key, required this.step}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              // Hiển thị thông tin chi tiết của nguyên liệu
              _showDetailDialog(context);
            },
            label: 'Thông tin',
            icon: Icons.info,
            backgroundColor: Colors.blue,
          ),
          SlidableAction(
            onPressed: (context) {
              // Hiển thị menu tùy chọn
              _showOptionMenu(context);
            },
            label: 'Tùy chọn',
            icon: Icons.more,
            backgroundColor: Colors.green,
          ),
        ],
      ),
      child: ListTile(
        leading: GestureDetector(
          onTap: () {
            // Hiển thị thông tin chi tiết của nguyên liệu
            _showDetailDialog(context);
          },
          child: SvgPicture.asset(
            'assets/icon_svg/menu.svg',
            height: 20,
            width: 20,
          ),
        ),
        title: Text(step.name),
        trailing: GestureDetector(
          onTap: () {
            // Hiển thị menu tùy chọn
            _showOptionMenu(context);
          },
          child: SvgPicture.asset(
            'assets/icon_svg/options.svg',
            height: 20,
            width: 20,
          ),
        ),
      ),
    );
  }

  void _showDetailDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Thông tin chi tiết',
              style: TextStyle(fontFamily: "CeraPro")),
          content:
          Text(step.name, style: const TextStyle(fontFamily: "CeraPro")),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Đóng',
                  style: TextStyle(
                      fontFamily: "CeraPro", color: AppColors.orangeCrusta)),
            ),
          ],
        );
      },
    );
  }

  void _showOptionMenu(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentTextStyle: const TextStyle(
            fontFamily: 'CeraPro',
          ),
          title: const Text('Option',
              style: TextStyle(
                fontFamily: 'CeraPro',
              )),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildOptionItem('Edit', context),
              _buildOptionItem('Add item above', context),
              _buildOptionItem('Add item below', context),
              _buildOptionItem('Delete', context),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOptionItem(String option, BuildContext context) {
    Widget icon;
    String text;
    switch (option) {
      case 'Edit':
        icon = SvgPicture.asset(
          'assets/icon_svg/pencil.svg',
          height: 20,
          width: 20,
        );
        text = 'Edit';
        break;
      case 'Add item above':
        icon = SvgPicture.asset(
          'assets/icon_svg/chevron-circle-up.svg',
          height: 20,
          width: 20,
        );
        text = 'Add item above';
        break;
      case 'Add item below':
        icon = SvgPicture.asset(
          'assets/icon_svg/chevron-circle-down.svg',
          height: 20,
          width: 20,
        );
        text = 'Add item below';
        break;
      case 'Delete':
        icon = SvgPicture.asset(
          'assets/icon_svg/trash.svg',
          height: 20,
          width: 20,
        );
        text = 'Delete';
        break;
      default:
        icon = SvgPicture.asset(
          'assets/icon_svg/pencil.svg',
          height: 20,
          width: 20,
        );
        text = 'Lỗi';
    }

    return ListTile(
      leading: icon,
      title: Text(
        text,
        style: const TextStyle(
          fontFamily: 'CeraPro',
        ),
      ),
      onTap: () {
        // Xử lý khi tùy chọn được chọn
        _handleOptionSelection(option, context);
      },
    );
  }

  void _handleOptionSelection(String option, BuildContext context) {
    if (option == 'Edit') {
      Navigator.pop(context);
      _handleEditOption(context);
    } else if (option == 'Add item above') {
      _handleAddItemAboveOption(context);
    } else if (option == 'Add item below') {
      _handleAddItemBelowOption(context);
    } else if (option == 'Set as header') {
      _handleSetAsHeaderOption();
    } else if (option == 'Delete') {
      _handleDeleteOption(context);
    } else {
      // Xử lý khi không có tùy chọn phù hợp
    }
  }

  void _handleEditOption(BuildContext context) {
    showDialog(
        context: context,
        builder: ((context) {
          return UpdateItemDialog(
              initialItemName: step.name,
              onUpdateItem: (updatedItemName) {
                Provider.of<StepsProvider>(context, listen: false)
                    .updateItem(step.id, updatedItemName);
                //Navigator.pop(context);
              });
        }));
    // Xử lý khi tùy chọn "Edit" được chọn
  }

  void _handleAddItemAboveOption(BuildContext context) {
    // Xử lý khi tùy chọn "Add item above" được chọn
    Provider.of<StepsProvider>(context, listen: false).moveItemUp(step.id);
    Navigator.pop(context);
  }

  void _handleAddItemBelowOption(BuildContext context) {
    // Xử lý khi tùy chọn "Add item below" được chọn
    Provider.of<StepsProvider>(context, listen: false).moveItemDown(step.id);
    Navigator.pop(context);
  }

  void _handleSetAsHeaderOption() {
    // Xử lý khi tùy chọn "Set as header" được chọn
  }

  void _handleDeleteOption(BuildContext context) {
    // Xử lý khi tùy chọn "Delete" được chọn
    Provider.of<StepsProvider>(context, listen: false).deleteItem(step.id);
    Navigator.pop(context);
  }
}
