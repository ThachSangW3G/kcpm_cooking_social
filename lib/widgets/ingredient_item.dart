
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class IngredientItemComponents extends StatelessWidget {
  final String ingredientItem;
  const IngredientItemComponents({super.key, required this.ingredientItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Row(
        children: [
          Container(
            height: 18,
            width: 18,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: AppColors.orangeCrusta),
          ),
          const SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: Text(
              ingredientItem,
              softWrap: true,
              style: const TextStyle(
                  fontFamily: 'CeraPro',
                  fontWeight: FontWeight.w500,
                  fontSize: 16),
            ),
          )
        ],
      ),
    );
  }
}
