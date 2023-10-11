
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class GroceryItemUncheck extends StatelessWidget {
  final String title;
  const GroceryItemUncheck({
    super.key, required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  width: 1,
                  color: AppColors.greyIron
              )
          )
      ),
      child: Row(
        children: [
          Container(
            height: 24,
            width: 24,
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.greyIron
            ),
          ),
          const SizedBox(width: 10.0,),
          Expanded(
            child: Text(
              title,
              softWrap: true,


              style: const TextStyle(
                  fontFamily: 'CeraPro',
                  fontWeight: FontWeight.w500,
                  fontSize: 16
              ),
            ),
          )
        ],
      ),
    );
  }
}
