
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_styles.dart';
import '../../models/recipe.dart';
import '../../models/review.dart';
import '../../providers/review_provider.dart';
import '../../widgets/comment_item.dart';
import '../../widgets/line_row.dart';

class ReViewScreen extends StatefulWidget {
  final Recipe recipe;
  const ReViewScreen({super.key, required this.recipe});

  @override
  State<ReViewScreen> createState() => _ReViewScreenState();
}

class _ReViewScreenState extends State<ReViewScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  String? keyRecipe;
  String? _description;
  @override
  void initState() {
    keyRecipe = widget.recipe.id;
    //context.read<ReviewStateProvider>().fetchReview(keyRecipe!);
    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   context.read<ReviewStateProvider>().fetchReview(keyRecipe!);
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    final ReviewProvider reviewProvider =
    Provider.of<ReviewProvider>(context);
    // final NotificationProvider notificationProvider =
    // Provider.of<NotificationProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Reviews',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
              fontFamily: 'Recoleta'),
        ),
        leading: IconButton(
            onPressed: () {
              // Navigator.pushReplacementNamed(
              //     context, RouteGenerator.recipedetailScreen,
              //     arguments: keyRecipe);
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_outlined,
              color: Colors.black,
              size: 20,
            )),
        bottom: const PreferredSize(
            preferredSize: Size.fromHeight(16.0), child: LineRow()),
      ),
      resizeToAvoidBottomInset: false,
      body: Scaffold(
        body: Stack(
          children: [
            FutureBuilder<List<Review>>(
              future: reviewProvider.fetchReview(keyRecipe!),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  // Hiển thị widget khi có lỗi xảy ra
                  return const Center(
                    child: Text(
                      "Don't have review",
                      style: kReviewLabelTextStyle,
                    ),
                  );
                } else {
                  final listReview = snapshot.data;
                  return listReview == null
                      ? const Center(child: CircularProgressIndicator())
                      : Padding(
                    padding: const EdgeInsets.all(0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: listReview.length,
                      itemBuilder: (context, index) {
                        return CommentItem(review: listReview[index]);
                      },
                    ),
                  );
                }
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Container(
                  decoration: const BoxDecoration(
                      border:
                      Border(top: BorderSide(color: AppColors.greyBombay))),
                  padding:
                  const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.whitePorcelain),
                          child: TextField(
                            controller: _textEditingController,
                            onChanged: (value) {
                              _description = value;
                            },
                            onTap: () {},
                            decoration: const InputDecoration(
                              hintText: 'Your Review',
                              hintStyle: TextStyle(
                                  color: AppColors.greyShuttle,
                                  fontFamily: 'CeraPro',
                                  fontWeight: FontWeight.w400),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (_description != null) {
                            reviewProvider.addReview(_description!, keyRecipe!);
                            _textEditingController.clear();

                            // NotificationModel notification = NotificationModel(
                            //     id: DateTime.now().toIso8601String(),
                            //     idUserGuest:
                            //     FirebaseAuth.instance.currentUser!.uid,
                            //     idUserOwner: widget.recipe.uidUser,
                            //     time: Timestamp.now(),
                            //     type: 'newReview',
                            //     read: false,
                            //     title: _description!,
                            //     idRecipe: keyRecipe!);
                            //
                            // notificationProvider.addNotification(notification);
                          }
                        },
                        child: const Text(
                          'SUBMIT',
                          style: TextStyle(
                              color: AppColors.orangeCrusta,
                              fontFamily: 'CeraPro',
                              fontWeight: FontWeight.w500,
                              fontSize: 17),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: Container(
      //   decoration: const BoxDecoration(
      //       border: Border(top: BorderSide(color: AppColors.greyBombay))),
      //   padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       Expanded(
      //         child: ElevatedButton(
      //           onPressed: () {},
      //           style: ElevatedButton.styleFrom(
      //               backgroundColor: AppColors.whitePorcelain),
      //           child: TextField(
      //             controller: _textEditingController,
      //             onChanged: (value) {
      //               _description = value;
      //             },
      //             onTap: () {},
      //             decoration: const InputDecoration(
      //               hintText: 'Your Review',
      //               hintStyle: TextStyle(
      //                   color: AppColors.greyShuttle,
      //                   fontFamily: 'CeraPro',
      //                   fontWeight: FontWeight.w400),
      //               border: InputBorder.none,
      //             ),
      //           ),
      //         ),
      //       ),
      //       const SizedBox(
      //         width: 10,
      //       ),
      //       GestureDetector(
      //         onTap: () async {
      //           if (_description != null) {
      //             reviewProvider.addReview(_description!, keyRecipe!);
      //             _textEditingController.clear();

      //             NotificationModel notification = NotificationModel(
      //                 id: DateTime.now().toIso8601String(),
      //                 idUserGuest: FirebaseAuth.instance.currentUser!.uid,
      //                 idUserOwner: widget.recipe.uidUser,
      //                 time: Timestamp.now(),
      //                 type: 'newReview',
      //                 read: false,
      //                 title: _description!,
      //                 idRecipe: keyRecipe!);

      //             notificationProvider.addNotification(notification);
      //           }
      //         },
      //         child: const Text(
      //           'SUBMIT',
      //           style: TextStyle(
      //               color: AppColors.orangeCrusta,
      //               fontFamily: 'CeraPro',
      //               fontWeight: FontWeight.w500,
      //               fontSize: 17),
      //         ),
      //       )
      //     ],
      //   ),
      // ),
    );
  }
}
