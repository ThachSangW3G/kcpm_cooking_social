
import 'package:flutter/material.dart';

import '../models/recipe.dart';
import 'ingredient_item.dart';

class TabContentIngredients extends StatefulWidget {
  final Recipe? recipe;
  const TabContentIngredients({Key? key, required this.recipe})
      : super(key: key);

  @override
  State<TabContentIngredients> createState() => _TabContentIngredientsState();
}

class _TabContentIngredientsState extends State<TabContentIngredients> {
  List<String>? _material;
  List<String>? _spice;

  @override
  void initState() {
    _material = widget.recipe?.material;
    _spice = widget.recipe?.spice;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nguyên liệu',
            style: TextStyle(
                fontSize: 20,
                fontFamily: 'CeraPro',
                fontWeight: FontWeight.w600,
                color: Colors.black),
          ),
          // ListView(
          //   padding: const EdgeInsets.symmetric(horizontal: 12),
          //   shrinkWrap: true,
          //   physics: const NeverScrollableScrollPhysics(),
          //   children: const [
          //     IngredientItemComponents(
          //         ingredientItem: '1 buah wortel, potong-potong'),
          //     IngredientItemComponents(ingredientItem: '5 potong sayap ayam'),
          //     IngredientItemComponents(
          //         ingredientItem: '1 buah wortel, potong-potong'),
          //     IngredientItemComponents(
          //         ingredientItem: '1 buah wortel, potong-potong'),
          //   ],
          // ),
          ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _material!.length,
            itemBuilder: (context, index) {
              return IngredientItemComponents(
                  ingredientItem: _material![index]);
            },
          ),
          const Text(
            'Gia Vị',
            style: TextStyle(
                fontSize: 20,
                fontFamily: 'CeraPro',
                fontWeight: FontWeight.w600,
                color: Colors.black),
          ),
          // ListView(
          //   padding: const EdgeInsets.symmetric(horizontal: 12),
          //   shrinkWrap: true,
          //   physics: const NeverScrollableScrollPhysics(),
          //   children: const [
          //     IngredientItemComponents(
          //         ingredientItem: '1 buah wortel, potong-potong'),
          //     IngredientItemComponents(
          //         ingredientItem: '1 buah wortel, potong-potong'),
          //     IngredientItemComponents(
          //         ingredientItem: '1 buah wortel, potong-potong'),
          //     IngredientItemComponents(
          //         ingredientItem: '1 buah wortel, potong-potong'),
          //     IngredientItemComponents(
          //         ingredientItem: '1 buah wortel, potong-potong'),
          //     IngredientItemComponents(
          //         ingredientItem: '1 buah wortel, potong-potong')
          //   ],
          // ),
          ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _spice!.length,
            itemBuilder: (context, index) {
              return IngredientItemComponents(ingredientItem: _spice![index]);
            },
          ),
        ],
      ),
    );
  }
}
