
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kcpm/models/user.dart';
import 'package:kcpm/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../constants/app_styles.dart';
import '../models/review.dart';
import '../providers/review_provider.dart';

class CommentItemNotOption extends StatefulWidget {
  const CommentItemNotOption({super.key});
  @override
  State<CommentItemNotOption> createState() => _CommentItemNotOptionState();
}

class _CommentItemNotOptionState extends State<CommentItemNotOption> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ReviewProvider reviewProvider =
    Provider.of<ReviewProvider>(context);
    if (reviewProvider.review.isEmpty) {
      return const Center(
        child: Text(
          "Don't have review",
          style: kReviewLabelTextStyle,
        ),
      );
    } else {
      Review review = reviewProvider.review[0];
      return FutureBuilder<UserInformation>(
        future: UserProvider(firestore: FirebaseFirestore.instance).getUserFuture(review.uidUser),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const CircularProgressIndicator();
          }else{
            final user = snapshot.data;
            return  Row(
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
                          image: NetworkImage(user!.avatar), fit: BoxFit.fill)),
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
                        user!.name,
                        style: const TextStyle(
                            color: Colors.black,
                            fontFamily: "CeraPro",
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      Text(
                        reviewProvider.getTimeAgo(review.time),
                        style: kLabelTextStyle,
                      ),
                      Text(
                        review.description,
                        style: kReviewLabelTextStyle,
                      )
                    ],
                  ),
                ),
                // reviewProvider.review[0].check == false
                //     ? SvgPicture.asset(
                //   'assets/icon_svg/heart.svg',
                //   colorFilter: const ColorFilter.mode(
                //       AppColors.greyBombay, BlendMode.srcIn),
                //   height: 24,
                //   width: 24,
                // )
                //     : SvgPicture.asset(
                //   'assets/icon_svg/heart_orange.svg',
                //   colorFilter: const ColorFilter.mode(
                //       AppColors.orangeCrusta, BlendMode.srcIn),
                //   height: 24,
                //   width: 24,
                // ),
                const SizedBox(
                  width: 10,
                ),
                // FutureBuilder<LikeReview>(
                //     future: reviewLikeProvider.likeExist(review!.key, uid!),
                //     builder: (context, snapshot) {
                //       final LikeReview? liked = snapshot.data;
                //       if (liked != null && first) {
                //         check = true;
                //         first = false;
                //       }
                //       return Container(
                //         padding: EdgeInsets.zero,
                //         child: Row(children: [
                //           GestureDetector(
                //             onTap: () async {
                //               if (!check) {
                //                 setState(() {
                //                   check = true;
                //                   LikeReview likeReview = LikeReview(
                //                       id: DateTime.now().toIso8601String(),
                //                       idUser: uid,
                //                       idReview: review!.key,
                //                       time: Timestamp.now());
                //                   reviewLikeProvider.addLike(likeReview);
                //                   Provider.of<ReviewStateProvider>(context,
                //                           listen: false)
                //                       .updatePropertyById(review!.key, 'check', true);
                //                   //reviewProvider.update(review);
                //                 });
                //               } else {
                //                 await reviewLikeProvider.deleteLike(liked!);
                //                 setState(() {
                //                   check = false;
                //                   Provider.of<ReviewStateProvider>(context,
                //                           listen: false)
                //                       .updatePropertyById(review!.key, 'check', false);
                //                 });
                //               }
                //             },
                //             child: check == false
                //                 ? SvgPicture.asset(
                //                     'assets/icon_svg/heart.svg',
                //                     colorFilter: const ColorFilter.mode(
                //                         AppColors.greyBombay, BlendMode.srcIn),
                //                     height: 24,
                //                     width: 24,
                //                   )
                //                 : SvgPicture.asset(
                //                     'assets/icon_svg/heart_orange.svg',
                //                     colorFilter: const ColorFilter.mode(
                //                         AppColors.orangeCrusta, BlendMode.srcIn),
                //                     height: 24,
                //                     width: 24,
                //                   ),
                //           ),
                //           const SizedBox(
                //             width: 10,
                //           ),
                //           // SvgPicture.asset(
                //           //   'assets/icon_svg/options.svg',
                //           //   colorFilter: const ColorFilter.mode(
                //           //       AppColors.greyBombay, BlendMode.srcIn),
                //           //   height: 24,
                //           //   width: 24,
                //           // ),
                //         ]),
                //       );
                //     }),
              ],
            );
          }
        }
      );
    }
  }
}
