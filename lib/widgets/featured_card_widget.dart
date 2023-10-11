import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kcpm/models/recipe.dart';
import 'package:kcpm/models/user.dart';

import '../constants/app_colors.dart';

class FeaturedCard extends StatelessWidget {
  final Recipe recipe;
  final UserInformation userInformation;
  final VoidCallback like;
  final VoidCallback viewProfile;
  final bool liked;
  const FeaturedCard({
    super.key, required this.like, required this.liked, required this.viewProfile, required this.recipe, required this.userInformation
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        children: [
          SizedBox(
            width: 350,
            height: 300,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(16.0)),
              child: CachedNetworkImage(
                imageUrl: recipe.url,
                fit: BoxFit.cover,
                placeholder: (context, url){
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.04),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 10.0,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  recipe.name,
                  style: const TextStyle(
                      fontFamily: 'Recoleta',
                      fontSize: 24,
                      fontWeight: FontWeight.w700
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10.0,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: viewProfile,
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: CachedNetworkImageProvider(userInformation.avatar),
                                fit: BoxFit.contain
                            )
                        ),

                      ),
                    ),
                    const SizedBox(width: 10,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: viewProfile,
                          child: Text(
                            userInformation.name,
                            style: const TextStyle(
                                fontFamily: 'CeraPro',
                                fontSize: 18,
                                fontWeight: FontWeight.w500
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('assets/icons/heart_orange.png')
                                  )
                              ),
                            ),
                            const SizedBox(width: 10.0,),
                            Text(
                              recipe.numberLike.toString(),
                              style: const TextStyle(
                                  fontFamily: 'CeraPro',
                                  fontSize: 14,
                                  color: AppColors.greyShuttle
                              ),
                            ),
                            const SizedBox(width: 10.0,),
                            const Text(
                              '·',
                              style: TextStyle(
                                  fontFamily: 'CeraPro',
                                  fontSize: 14,
                                  color: AppColors.greyShuttle

                              ),
                            ),
                            const SizedBox(width: 10.0,),
                            Text(
                              recipe.numberReView.toString(),
                              style: const TextStyle(
                                  fontFamily: 'CeraPro',
                                  fontSize: 14,
                                  color: AppColors.greyShuttle
                              ),
                            ),
                            const Text(
                              ' Reviews',
                              style: TextStyle(
                                  fontFamily: 'CeraPro',
                                  fontSize: 14,
                                  color: AppColors.greyShuttle
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),

                GestureDetector(
                  onTap: like,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: liked  ? const AssetImage('assets/icons/heart_orange.png') : const AssetImage('assets/icons/heart_border_orange.png')
                        )
                    ),
                  ),
                )

              ],
            ),
          )
        ],
      ),
    );
  }
}