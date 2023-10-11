
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../models/category.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final bool select;
  const CategoryCard({
    super.key,
    required this.category, required this.select,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            child: Stack(
                children: [

                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: select ? AppColors.orangeCrusta : AppColors.transparentColor,
                    ),
                  ),
                  Center(
                    child: Container(
                      width: 75,
                      height: 75,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: CachedNetworkImage(imageUrl: category.image,
                          fit: BoxFit.cover,
                          placeholder: (context, url) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.04),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                ]
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Text(
            category.name,
            style: TextStyle(
                fontFamily: 'CeraPro',
                fontSize: 14,
                fontWeight: select ? FontWeight.bold : FontWeight.w500

            ),
          )
        ],
      ),
    );
  }
}
