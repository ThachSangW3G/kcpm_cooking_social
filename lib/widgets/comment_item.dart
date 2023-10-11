
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kcpm/providers/review_provider.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../constants/app_styles.dart';
import '../models/like_review.dart';
import '../models/review.dart';
import '../providers/like_review_provider.dart';

class CommentItem extends StatefulWidget {
  final Review review;
  const CommentItem({super.key, required this.review});

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  Review? review;
  bool check = false;
  bool first = true;
  @override
  void initState() {
    review = widget.review;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final LikeReviewProvider reviewLikeProvider =
    Provider.of<LikeReviewProvider>(context);
    //final ReviewStateProvider reviewProvider =
    //Provider.of<ReviewStateProvider>(context);
    final String? uid = FirebaseAuth.instance.currentUser?.uid;
    return Padding(
      padding: const EdgeInsets.only(left: 25, bottom: 15, right: 25, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 33,
            width: 33,
            padding: const EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: NetworkImage(review!.avatar), fit: BoxFit.fill)),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  review!.name,
                  style: const TextStyle(
                      color: Colors.black,
                      fontFamily: "CeraPro",
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                Text(
                  review!.time,
                  style: kLabelTextStyle,
                ),
                Text(
                  review!.description,
                  style: kReviewLabelTextStyle,
                )
              ],
            ),
          ),
          FutureBuilder<LikeReview>(
              future: reviewLikeProvider.likeExist(review!.key, uid!),
              builder: (context, snapshot) {
                final LikeReview? liked = snapshot.data;
                if (liked != null && first) {
                  check = true;
                  first = false;
                }
                return Container(
                  padding: EdgeInsets.zero,
                  child: Row(children: [
                    GestureDetector(
                      onTap: () async {
                        if (!check) {
                          setState(() {
                            check = true;
                            LikeReview likeReview = LikeReview(
                                id: DateTime.now().toIso8601String(),
                                idUser: uid,
                                idReview: review!.key,
                                time: Timestamp.now());
                            reviewLikeProvider.addLike(likeReview);
                            Provider.of<ReviewProvider>(context,
                                listen: false)
                                .updatePropertyById(review!.key, 'check', true);
                            //reviewProvider.update(review);
                          });
                        } else {
                          await reviewLikeProvider.deleteLike(liked!);
                          setState(() {
                            check = false;
                            Provider.of<ReviewProvider>(context,
                                listen: false)
                                .updatePropertyById(
                                review!.key, 'check', false);
                          });
                        }
                      },
                      child: check == false
                          ? SvgPicture.asset(
                        'assets/icon_svg/heart.svg',
                        colorFilter: const ColorFilter.mode(
                            AppColors.greyBombay, BlendMode.srcIn),
                        height: 24,
                        width: 24,
                      )
                          : SvgPicture.asset(
                        'assets/icon_svg/heart_orange.svg',
                        colorFilter: const ColorFilter.mode(
                            AppColors.orangeCrusta, BlendMode.srcIn),
                        height: 24,
                        width: 24,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SvgPicture.asset(
                      'assets/icon_svg/options.svg',
                      colorFilter: const ColorFilter.mode(
                          AppColors.greyBombay, BlendMode.srcIn),
                      height: 24,
                      width: 24,
                    ),
                  ]),
                );
              }),
        ],
      ),
    );
  }
}
