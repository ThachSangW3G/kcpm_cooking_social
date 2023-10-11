
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/app_colors.dart';
import '../models/recipe.dart';
import '../models/user.dart';

class FeaturedCardSmallWidget extends StatelessWidget {
  final Recipe recipe;
  final UserInformation userInformation;
  final VoidCallback like;
  final bool liked;
  const FeaturedCardSmallWidget({
    super.key, required this.recipe, required this.userInformation, required this.like, required this.liked,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 160,
          height: 180,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: CachedNetworkImageProvider(recipe.url),
                  fit: BoxFit.cover
              ),
              borderRadius: const BorderRadius.all(Radius.circular(16.0))
          ),
          child: GestureDetector(
            onTap: like,
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(10.0),
              child: SvgPicture.asset(
                liked ? 'assets/icon_svg/heart_orange.svg' : 'assets/icon_svg/heart.svg',
                height: 30,
                width: 30,
                color: liked ? AppColors.orangeCrusta : AppColors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: Text(
            recipe.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                fontFamily: 'Recoleta',
                fontSize: 20,
                fontWeight: FontWeight.w700
            ),
          ),
        ),
        const SizedBox(height: 10,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: Row(
            children: [
              Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: CachedNetworkImageProvider(userInformation.avatar)
                    )
                ),
              ),
              const SizedBox(width: 10,),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            userInformation.name,
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: const TextStyle(
                                fontFamily: 'CeraPro',
                                fontSize: 14,
                                fontWeight: FontWeight.w500
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          recipe.numberReView.toString(),
                          style: const TextStyle(
                              fontFamily: 'CeraPro',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.greyShuttle
                          ),
                        ),
                        const SizedBox(width: 5.0,),
                        const Text(
                          'Reviews',
                          style: TextStyle(
                              fontFamily: 'CeraPro',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.greyShuttle
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
