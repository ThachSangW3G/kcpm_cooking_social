
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/add_recipe_provider/material_provider.dart';
import '../../providers/add_recipe_provider/spice_provider.dart';
import '../../widgets/ingredient_edit_card.dart';

class RecipeIngredientsEdit extends StatefulWidget {
  const RecipeIngredientsEdit({Key? key}) : super(key: key);

  @override
  State<RecipeIngredientsEdit> createState() => RecipeIngredientsEditState();
}

class RecipeIngredientsEditState extends State<RecipeIngredientsEdit> {
  List<String> ingredients = [
    'Ingredients A',
    'Ingredients B',
    'Ingredients C',
    'Ingredients D',
    'Ingredients E',
    'Ingredients H'
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      const Padding(
        padding: EdgeInsets.only(left: 35),
        child: Text(
          'Nguyên liệu',
          style: TextStyle(
              fontSize: 18,
              fontFamily: 'CeraPro',
              fontWeight: FontWeight.w500,
              color: Colors.black),
        ),
      ),
      Consumer<MaterialProvider>(
        builder: (context, itemProvider, _) {
          return itemProvider.items.isEmpty
              ? const Center()
              : ReorderableListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              for (int index = 0;
              index < itemProvider.items.length;
              index++)
                IngredientEditCard(
                  key: ValueKey(itemProvider.items[index].id),
                  item: itemProvider.items[index],
                  check: true,
                )
            ],
            onReorder: (int oldIndex, int newIndex) {
              itemProvider.reorderItems(oldIndex, newIndex);
            },
          );
        },
      ),
      const SizedBox(
        height: 20,
      ),
      const Padding(
        padding: EdgeInsets.only(left: 35),
        child: Text(
          'Gia vị',
          style: TextStyle(
              fontSize: 18,
              fontFamily: 'CeraPro',
              fontWeight: FontWeight.w500,
              color: Colors.black),
        ),
      ),
      Consumer<SpiceProvider>(
        builder: (context, itemProvider, _) {
          return itemProvider.items.isEmpty
              ? const Center()
              : ReorderableListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              for (int index = 0;
              index < itemProvider.items.length;
              index++)
                IngredientEditCard(
                  key: ValueKey(itemProvider.items[index].id),
                  item: itemProvider.items[index],
                  check: false,
                )
            ],
            onReorder: (int oldIndex, int newIndex) {
              itemProvider.reorderItems(oldIndex, newIndex);
            },
          );
        },
      )
    ]);
  }
}
