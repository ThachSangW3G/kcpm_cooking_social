

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kcpm/providers/like_provider.dart';
import 'package:kcpm/providers/review_provider.dart';
import 'package:kcpm/widgets/heart_widget.dart';

import '../constants/app_colors.dart';
import '../constants/app_styles.dart';
import '../models/like_model.dart';
import '../models/recipe.dart';
import '../models/review.dart';
import '../routes/app_routes.dart';
import 'comment_item_not_option.dart';
import 'icon_content_orange.dart';
import 'line_row.dart';

class RecipeSummary extends StatefulWidget {
  const RecipeSummary({Key? key, required this.recipe}) : super(key: key);
  final Recipe recipe;
  @override
  State<RecipeSummary> createState() => _RecipeSummaryState();
}

class _RecipeSummaryState extends State<RecipeSummary> {
  Recipe? recipeGet;
  bool check = false;
  bool first = true;

  @override
  void initState() {
    recipeGet = widget.recipe;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    // final LikeProvider likeProvider = Provider.of<LikeProvider>(context);
    // final ReviewStateProvider reviewProvider =
    // Provider.of<ReviewStateProvider>(context);

    // final RecipeStateProvider recipeProvider =
    //     Provider.of<RecipeStateProvider>(context);
    final String? uid = FirebaseAuth.instance.currentUser?.uid;
    // return FutureBuilder(
    //     future: recipeProvider.fetchRecipe(recipeGet!.key),
    //     builder: (context, snapchot) {
    final recipe = widget.recipe;
    // return recipe == null
    //     ? const Center(child: CircularProgressIndicator())
    return Container(
      width: double.infinity,
      color: AppColors.whitePorcelain,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            color: AppColors.whitePorcelain,
          ),
          Container(
              height: 350,
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(recipe.url),
                    fit: BoxFit.cover,
                  )),
              alignment: Alignment.topCenter,
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 30),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Navigator.of(context).popUntil((route) =>
                            //     route.settings.name == '/detailCookbook');
                            // Navigator.popUntil(context,
                            //     ModalRoute.withName('/detailCookbook'));
                            // Navigator.popUntil(
                            //     context, (route) => route.isFirst);
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: const BoxDecoration(
                                color: AppColors.white, shape: BoxShape.circle),
                            child: const Center(
                              child: Icon(
                                Icons.arrow_back_ios_new,
                                color: AppColors.black,
                                size: 25,
                              ),
                            ),
                          ),
                        ),
                        FutureBuilder<LikeModel>(
                            future: LikeProvider().likeExists(recipe.id, uid!),
                            builder: (context, snapshot) {
                              final LikeModel? liked = snapshot.data;

                              return HeartWidget(
                                like: () async {
                                  if(liked == null){
                                    LikeModel likeModel = LikeModel(
                                        id: DateTime.now().toIso8601String(),
                                        idRecipe: recipe.id,
                                        idUser: FirebaseAuth.instance.currentUser!.uid,
                                        time: Timestamp.now()
                                    );

                                    await LikeProvider().setDataLike(likeModel);

                                    await LikeProvider().updateRecipe(recipe);

                                    // NotificationModel notification = NotificationModel(
                                    //     id: DateTime.now().toIso8601String(),
                                    //     idUserGuest: user.uid,
                                    //     idUserOwner: featured.idUser,
                                    //     time: Timestamp.now(),
                                    //     type: 'liked',
                                    //     read: false,
                                    //     title: "",
                                    //     idRecipe: featured.id
                                    // );
                                    //
                                    // notificationProvider.addNotification(notification);

                                  }else {
                                    await LikeProvider().deleteLike(liked);
                                  }

                                }

                                , liked: liked != null);

                            })
                      ]))),
          Container(
              margin: const EdgeInsets.only(top: 290),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width - 40,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            color: AppColors.white,
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            color: AppColors.whitePorcelain,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5.0,
                                        ),
                                        Text(
                                          recipe.name,
                                          style: const TextStyle(
                                            fontFamily: 'Recoleta',
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/icon_svg/heart.svg',
                                              colorFilter:
                                              const ColorFilter.mode(
                                                  AppColors.orangeCrusta,
                                                  BlendMode.srcIn),
                                              height: 15,
                                              width: 15,
                                            ),
                                            const SizedBox(
                                              width: 10.0,
                                            ),
                                            Text(
                                              recipe.numberLike.toString(),
                                              style: const TextStyle(
                                                  fontFamily: 'CeraPro',
                                                  color: AppColors.greyShuttle),
                                            ),
                                            const SizedBox(
                                              width: 10.0,
                                            ),
                                            const Text(
                                              '|',
                                              style: TextStyle(
                                                  fontFamily: 'CeraPro',
                                                  color: AppColors.greyShuttle),
                                            ),
                                            const SizedBox(
                                              width: 10.0,
                                            ),
                                            Text(
                                              recipe.numberReview.toString(),
                                              style: const TextStyle(
                                                  fontFamily: 'CeraPro',
                                                  color: AppColors.greyShuttle),
                                            ),
                                            const SizedBox(
                                              width: 10.0,
                                            ),
                                            const Text(
                                              'Reviews',
                                              style: TextStyle(
                                                  fontFamily: 'CeraPro',
                                                  color: AppColors.greyShuttle),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        const LineRow(),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            IconContentOrange(
                                              label:
                                              "${recipe.cookTime.toString()} min",
                                              iconData:
                                              'assets/icon_svg/clock.svg',
                                            ),
                                            Container(
                                              width: 1.0,
                                              height: 40,
                                              color: AppColors.greyBombay,
                                            ),
                                            IconContentOrange(
                                              label: recipe.difficult,
                                              iconData:
                                              'assets/icon_svg/dinner.svg',
                                            ),
                                            Container(
                                              width: 1.0,
                                              height: 40,
                                              color: AppColors.greyBombay,
                                            ),
                                            IconContentOrange(
                                              label:
                                              'Serves ${recipe.serves.toString()}',
                                              iconData:
                                              'assets/icon_svg/restaurant.svg',
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width - 40,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: AppColors.white,
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Text(
                                            'Reviews (',
                                            style: kReviewLabelTextStyleBold,
                                          ),
                                          Text(recipe.numberReview.toString(),
                                              style: kReviewLabelTextStyleBold),
                                          const Text(
                                            ')',
                                            style: kReviewLabelTextStyleBold,
                                          )
                                        ],
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(context,
                                              RouteGenerator.reviewScreen,
                                              arguments: recipe);
                                        },
                                        child: const Text(
                                          'READ ALL',
                                          style: TextStyle(
                                              fontFamily: 'CeraPro',
                                              color: AppColors.orangeCrusta),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  FutureBuilder<List<Review>>(
                                      future: ReviewProvider()
                                          .fetchReview(recipe.id),
                                      builder: (context, snapshotReview) {
                                        try {
                                          if (snapshotReview.hasError) {
                                            // Hiển thị widget khi có lỗi xảy ra
                                            return const Center(
                                              child: Text(
                                                "Don't have review",
                                                style: kReviewLabelTextStyle,
                                              ),
                                            );
                                          } else {
                                            final review = snapshotReview.data;
                                            return review == null
                                                ? const Center(
                                              child:
                                              CircularProgressIndicator(),
                                            )
                                                : const CommentItemNotOption();
                                          }
                                        } catch (e) {
                                          return const Center(
                                            child: Text(
                                              "Don't have review",
                                              style: kReviewLabelTextStyle,
                                            ),
                                          );
                                        }
                                      })
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ))
              ])),
        ],
      ),
    );
    //});
  }


}
