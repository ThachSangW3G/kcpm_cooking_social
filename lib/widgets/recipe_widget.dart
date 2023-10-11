
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/app_colors.dart';
import '../models/recipe.dart';

class RecipeWidget extends StatelessWidget {
  final Recipe recipe;
  final bool selected;
  const RecipeWidget({
    super.key,
    required this.recipe, required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          border: const Border(bottom: BorderSide(color: AppColors.greyIron)
          ),
          color: selected ? AppColors.orange : AppColors.transparentColor,

        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 60,
                width: 60,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                  child: CachedNetworkImage(
                    imageUrl: recipe.url,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.name,
                      style: const TextStyle(
                          fontFamily: 'CeraPro',
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icon_svg/clock.svg',
                                height: 16,
                                width: 16,
                                color: AppColors.greyBombay,
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                recipe.cookTime.toString(),
                                style: const TextStyle(
                                  fontFamily: 'CeraPro',
                                  fontSize: 14,
                                  color: AppColors.greyShuttle,
                                ),
                              ),
                              const SizedBox(
                                width: 8.0,
                              ),
                              const Text(
                                'mins',
                                style: TextStyle(
                                  fontFamily: 'CeraPro',
                                  fontSize: 14,
                                  color: AppColors.greyShuttle,
                                ),
                              ),
                              const SizedBox(
                                width: 12.0,
                              ),
                              SvgPicture.asset(
                                'assets/icon_svg/dinner.svg',
                                height: 16,
                                width: 16,
                                color: AppColors.greyBombay,
                              ),
                              const SizedBox(
                                width: 8.0,
                              ),
                              Text(
                                recipe.difficult,
                                style: const TextStyle(
                                  fontFamily: 'CeraPro',
                                  fontSize: 14,
                                  color: AppColors.greyShuttle,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
