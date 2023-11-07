
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kcpm/models/user.dart';
import 'package:kcpm/providers/follow_provider.dart';
import 'package:kcpm/providers/user_provider.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_styles.dart';
import '../../models/follow_model.dart';
import '../../models/like_model.dart';
import '../../models/recipe.dart';
import '../../providers/like_provider.dart';
import '../../providers/recipe_provider.dart';
import '../../routes/app_routes.dart';
import '../../widgets/featured_card_widget.dart';
import '../../widgets/line_row.dart';

class AccountPerSonScreen extends StatefulWidget {
  final String idUser;
  const AccountPerSonScreen({super.key, required this.idUser});

  @override
  State<AccountPerSonScreen> createState() => _AccountPerSonScreenState();
}

class _AccountPerSonScreenState extends State<AccountPerSonScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late Future<UserInformation> _userModelFuture;
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    //_userModelFuture = Provider.of<UserProvider>(context, listen: false)
     //   .getUser(widget.idUser);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final user = FirebaseAuth.instance.currentUser!;
  String iconFollow = 'assets/icon_svg/user-follow.svg';

  @override
  Widget build(BuildContext context) {
   // final UserProvider userProvider = Provider.of<UserProvider>(context);
  //  final FollowProvider followProvider = Provider.of<FollowProvider>(context);
    // final NotificationProvider notificationProvider =
    // Provider.of<NotificationProvider>(context);
    // final RecipeProvider recipeProvider = Provider.of<RecipeProvider>(context);
    // final LikeProvider likeProvider = Provider.of<LikeProvider>(context);
    // final ReviewStateProvider reviewStateProvider =
    // Provider.of<ReviewStateProvider>(context);
    final bool isOwner = user.uid == widget.idUser;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: StreamBuilder<UserInformation>(
          stream: UserProvider(firestore: FirebaseFirestore.instance).getUser(widget.idUser),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: MediaQuery.of(context).size.height,
                child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [CircularProgressIndicator()]),
              );
            } else {
              final userInformation = snapshot.data;

              return Stack(
                children: [
                  Container(
                    height: 300,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                'assets/images/image_background.png'),
                            fit: BoxFit.fill)),
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: const BoxDecoration(
                                  color: AppColors.white,
                                  shape: BoxShape.circle),
                              child: const Center(
                                child: Icon(
                                  Icons.arrow_back_ios_new,
                                  color: AppColors.black,
                                  size: 25,
                                ),
                              ),
                            ),
                          ),
                          FutureBuilder<FollowModel>(
                              future: FollowProvider(firestore: FirebaseFirestore.instance).followExist(
                                  userInformation!.uid, user.uid),
                              builder: (context, snapshot) {
                                final FollowModel? existFollow = snapshot.data;
                                return GestureDetector(
                                  onTap: () async {
                                    if (isOwner) {
                                      Navigator.of(context).pushNamed(
                                          RouteGenerator.editprofileScreen,
                                          arguments: widget.idUser);
                                    } else {
                                      if (existFollow == null) {
                                        FollowModel follow = FollowModel(
                                            id: DateTime.now()
                                                .toIso8601String(),
                                            idUserOwner: userInformation!.uid,
                                            idUserFollower: user.uid);
                                        await FollowProvider(firestore: FirebaseFirestore.instance).addFollow(follow);

                                        // NotificationModel notification =
                                        // NotificationModel(
                                        //     id: DateTime.now()
                                        //         .toIso8601String(),
                                        //     idUserGuest: user.uid,
                                        //     idUserOwner: userModel.uid,
                                        //     time: Timestamp.now(),
                                        //     type: 'newFollower',
                                        //     read: false,
                                        //     title: "",
                                        //     idRecipe: "");
                                        //
                                        // notificationProvider
                                        //     .addNotification(notification);
                                      } else {
                                        print(existFollow.id);
                                        await FollowProvider(firestore: FirebaseFirestore.instance)
                                            .deleteFollow(existFollow);
                                      }
                                    }
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: const BoxDecoration(
                                        color: AppColors.white,
                                        shape: BoxShape.circle),
                                    child: Center(
                                        child: Container(
                                          height: 25,
                                          width: 25,
                                          child: SvgPicture.asset(
                                            isOwner
                                                ? 'assets/icon_svg/pencil.svg'
                                                : existFollow == null
                                                ? 'assets/icon_svg/user-follow.svg'
                                                : 'assets/icon_svg/group.svg',
                                            height: 25,
                                            width: 25,
                                            color: AppColors.greyShuttle,
                                          ),
                                        )),
                                  ),
                                );
                              })
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 240),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 175,
                              width: MediaQuery.of(context).size.width - 40,
                              decoration: const BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(15)),
                                color: AppColors.white,
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 30.0,
                                        ),
                                        Text(
                                          userInformation!.name,
                                          style: const TextStyle(
                                            fontFamily: 'Recoleta',
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        Text(userInformation.bio,
                                            textAlign: TextAlign.center,
                                            softWrap: true,
                                            overflow: TextOverflow.clip,
                                            style: kLabelTextStyle),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            StreamBuilder<int>(
                                                stream: FollowProvider(firestore: FirebaseFirestore.instance)
                                                    .getFollower(userInformation.uid),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                      .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const Text('0',
                                                        style: kLabelTextStyle);
                                                  } else {
                                                    final follower =
                                                        snapshot.data;
                                                    return Text(
                                                        follower.toString(),
                                                        style: kLabelTextStyle);
                                                  }
                                                }),
                                            const SizedBox(
                                              width: 5.0,
                                            ),
                                            const Text('Followers',
                                                style: kLabelTextStyle),
                                            const SizedBox(
                                              width: 5.0,
                                            ),
                                            const Text(
                                              '|',
                                              style: TextStyle(
                                                  fontFamily: 'CeraPro',
                                                  fontSize: 30,
                                                  color: AppColors.greyIron),
                                            ),
                                            const SizedBox(
                                              width: 5.0,
                                            ),
                                            StreamBuilder<int>(
                                                stream:
                                                FollowProvider(firestore: FirebaseFirestore.instance).getFollowing(
                                                    userInformation.uid),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                      .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const Text('0',
                                                        style: kLabelTextStyle);
                                                  } else {
                                                    final follower =
                                                        snapshot.data;
                                                    return Text(
                                                        follower.toString(),
                                                        style: kLabelTextStyle);
                                                  }
                                                }),
                                            const SizedBox(
                                              width: 5.0,
                                            ),
                                            const Text('Following',
                                                style: kLabelTextStyle)
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [

                            const LineRow(),
                            StreamBuilder<List<Recipe>>(
                                stream: RecipeProvider(firestore: FirebaseFirestore.instance).getRecipeByIdUser(userInformation.uid),
                                builder: (context, snapshot) {

                                  if(snapshot.hasError){
                                    print(snapshot.error);
                                  }

                                  if (snapshot.hasData){

                                    final recipes = snapshot.data;

                                    return ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: recipes!.length,
                                      itemBuilder: (context, index) {
                                        final recipe = recipes[index];
                                        return GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).pushNamed(
                                                RouteGenerator.recipedetailScreen,
                                                arguments: {
                                                  'key': recipe.id,
                                                  'uid': recipe.uidUser,
                                                },
                                              );
                                            },
                                            child: StreamBuilder<UserInformation>(
                                                stream: UserProvider(firestore: FirebaseFirestore.instance).getUser(recipe.uidUser),
                                                builder: (context, snapshot) {

                                                  final userInformation = snapshot.data;

                                                  if (snapshot.hasData){
                                                    return FutureBuilder<LikeModel>(
                                                        future: LikeProvider().likeExists(recipe.id, FirebaseAuth.instance.currentUser!.uid),
                                                        builder: (context, snapshot){
                                                          final LikeModel? liked = snapshot.data;

                                                          return FeaturedCard(recipe: recipe, userInformation: userInformation!,
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

                                                            }, liked: liked != null,
                                                            viewProfile: (){
                                                              Navigator.of(context).pushNamed(
                                                                  RouteGenerator.accountpersonScreen,
                                                                  arguments: recipe.uidUser
                                                              );
                                                            },
                                                          );
                                                        }
                                                    );
                                                  }
                                                  else {
                                                    return const CircularProgressIndicator();
                                                  }

                                                }
                                            ));
                                      },
                                    );
                                  }
                                  else {
                                    return const CircularProgressIndicator();
                                  }

                                }
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 190),
                    width: double.infinity,
                    height: 90,
                    alignment: Alignment.center,
                    child: Container(
                      height: 90,
                      width: 90,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image:
                              CachedNetworkImageProvider(userInformation!.avatar),
                              fit: BoxFit.contain),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.white,
                              spreadRadius: 5,
                              blurRadius: 0.1,
                              offset: Offset(0, 1),
                            )
                          ]),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
