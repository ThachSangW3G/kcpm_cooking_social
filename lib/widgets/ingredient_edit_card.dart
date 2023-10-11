
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kcpm/widgets/update_item_dialog.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../providers/add_recipe_provider/material_provider.dart';
import '../providers/add_recipe_provider/spice_provider.dart';
import '../providers/add_recipe_provider/steps_provider.dart';

class IngredientEditCard extends StatefulWidget {
  final Item item;
  final bool check;
  // final Function(IngredientItem) onTap;
  // final Function(IngredientItem) onDelete;
  // final Function(IngredientEditCard) onEdit;

  const IngredientEditCard({Key? key, required this.item, required this.check})
      : super(key: key);

  @override
  State<IngredientEditCard> createState() => _IngredientEditCardState();
}

class _IngredientEditCardState extends State<IngredientEditCard> {
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
      child: ExpansionTile(
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
        title: Text(widget.item.name),
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
          title: const Text(
            'Thông tin chi tiết',
            style: TextStyle(
              fontFamily: 'CeraPro',
            ),
          ),
          content: Text(widget.item.name,
              style: const TextStyle(
                fontFamily: 'CeraPro',
              )),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Đóng',
                  style: TextStyle(
                      fontFamily: 'CeraPro', color: AppColors.orangeCrusta)),
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
              _buildOptionItem('Add item to Grocery', context),
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
    VoidCallback actions = () {};
    if (widget.check) {
      switch (option) {
        case 'Edit':
          icon = SvgPicture.asset(
            'assets/icon_svg/pencil.svg',
            height: 20,
            width: 20,
          );
          text = 'Edit';
          actions = () {
            Navigator.pop(context);
            showDialog(
                context: context,
                builder: ((context) {
                  return UpdateItemDialog(
                      initialItemName: widget.item.name,
                      onUpdateItem: (updatedItemName) {
                        Provider.of<MaterialProvider>(context, listen: false)
                            .updateItem(widget.item.id, updatedItemName);
                        //Navigator.pop(context);
                      });
                }));
          };
          break;
        case 'Add item above':
          icon = SvgPicture.asset(
            'assets/icon_svg/chevron-circle-up.svg',
            height: 20,
            width: 20,
          );
          text = 'Add item above';
          actions = () {
            Provider.of<MaterialProvider>(context, listen: false)
                .moveItemUp(widget.item.id);
            Navigator.pop(context);
          };
          break;
        case 'Add item below':
          icon = SvgPicture.asset(
            'assets/icon_svg/chevron-circle-down.svg',
            height: 20,
            width: 20,
          );
          text = 'Add item below';
          actions = () {
            Provider.of<MaterialProvider>(context, listen: false)
                .moveItemDown(widget.item.id);
            Navigator.pop(context);
          };
          break;
        case 'Set as item':
          icon = SvgPicture.asset(
            'assets/icon_svg/flag-alt.svg',
            height: 20,
            width: 20,
          );
          text = 'Set as header';
          actions = () {};
          break;
        case 'Add item to Grocery':
          icon = SvgPicture.asset(
            'assets/icon_svg/cart.svg',
            height: 20,
            width: 20,
          );
          text = 'Add item to Grocery';
          actions = () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //       builder: (context) => const AddGroceryScreen(
            //             key: null, recipe: ,
            //           )),
            //);
          };
          break;
        case 'Delete':
          icon = SvgPicture.asset(
            'assets/icon_svg/trash.svg',
            height: 20,
            width: 20,
          );
          text = 'Delete';
          actions = () {
            Provider.of<MaterialProvider>(context, listen: false)
                .deleteItem(widget.item.id);
            Navigator.pop(context);
          };
          break;
        default:
          icon = SvgPicture.asset(
            'assets/icon_svg/pencil.svg',
            height: 20,
            width: 20,
          );
          text = 'Lỗi';
      }
    } else {
      switch (option) {
        case 'Edit':
          icon = SvgPicture.asset(
            'assets/icon_svg/pencil.svg',
            height: 20,
            width: 20,
          );
          text = 'Edit';
          actions = () {
            Navigator.pop(context);
            showDialog(
                context: context,
                builder: ((context) {
                  return UpdateItemDialog(
                      initialItemName: widget.item.name,
                      onUpdateItem: (updatedItemName) {
                        Provider.of<SpiceProvider>(context, listen: false)
                            .updateItem(widget.item.id, updatedItemName);
                        //Navigator.pop(context);
                      });
                }));
          };
          break;
        case 'Add item above':
          icon = SvgPicture.asset(
            'assets/icon_svg/chevron-circle-up.svg',
            height: 20,
            width: 20,
          );
          text = 'Add item above';
          actions = () {
            Provider.of<SpiceProvider>(context, listen: false)
                .moveItemUp(widget.item.id);
            Navigator.pop(context);
          };
          break;
        case 'Add item below':
          icon = SvgPicture.asset(
            'assets/icon_svg/chevron-circle-down.svg',
            height: 20,
            width: 20,
          );
          text = 'Add item below';
          actions = () {
            Provider.of<SpiceProvider>(context, listen: false)
                .moveItemDown(widget.item.id);
            Navigator.pop(context);
          };
          break;
        case 'Add item to Grocery':
          icon = SvgPicture.asset(
            'assets/icon_svg/cart.svg',
            height: 20,
            width: 20,
          );
          text = 'Add item to Grocery';
          actions = () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //       builder: (context) => const AddGroceryScreen(
            //             key: null,
            //           )),
            // );
          };
          break;
        case 'Delete':
          icon = SvgPicture.asset(
            'assets/icon_svg/trash.svg',
            height: 20,
            width: 20,
          );
          text = 'Delete';
          actions = () {
            Provider.of<SpiceProvider>(context, listen: false)
                .deleteItem(widget.item.id);
            Navigator.pop(context);
          };
          break;
        default:
          icon = SvgPicture.asset(
            'assets/icon_svg/pencil.svg',
            height: 20,
            width: 20,
          );
          text = 'Lỗi';
      }
    }

    return ListTile(
        leading: icon,
        title: Text(text,
            style: const TextStyle(
              fontFamily: 'CeraPro',
            )),
        onTap: actions);
  }
}
