
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kcpm/models/category.dart';
import 'package:kcpm/models/recipe.dart';
import 'package:kcpm/models/user.dart';
import 'package:kcpm/providers/category_provider.dart';
import 'package:kcpm/providers/like_provider.dart';
import 'package:kcpm/providers/recipe_provider.dart';
import 'package:kcpm/providers/user_provider.dart';
import 'package:kcpm/services/auth.dart';

import '../../constants/app_colors.dart';
import '../../models/like_model.dart';
import '../../routes/app_routes.dart';
import '../../widgets/category_card.dart';
import '../../widgets/featured_card_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();

  int pageCurrent = 1;


  //late Future<UserModel> _userModelFuture;
  @override
  void initState() {

    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whitePorcelain,
      body: Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    StreamBuilder<UserInformation>(
                      stream: UserProvider(firestore: FirebaseFirestore.instance).getUser(FirebaseAuth.instance.currentUser!.uid),
                      builder: (context, snapshot){
                        if (snapshot.hasData){

                          final userInformation = snapshot.data;

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        RouteGenerator.accountScreen,
                                      );


                                    },
                                    child: Container(
                                      height: 60,
                                      width: 60,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: CachedNetworkImage(
                                          imageUrl: userInformation!.avatar,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Hi ${userInformation.name}',
                                        style: const TextStyle(
                                          fontFamily: 'CeraPro',
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const Text(
                                        'What are you cooking today?',

                                        style: TextStyle(
                                          fontFamily: 'CeraPro',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Navigator.pushNamed(
                                  //     context, RouteGenerator.notificationScreen);
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: const Icon(
                                    Icons.notifications_outlined,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }else {
                          return const CircularProgressIndicator();
                        }
                      }
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Featured Community Recipes',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontFamily: 'Recoleta',
                                fontSize: 24,
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            'Get lots of recipe inspiration from the community',
                            style: TextStyle(
                                fontFamily: 'CeraPro',
                                fontSize: 18,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),


                    StreamBuilder<List<Recipe>>(
                      stream: RecipeProvider(firestore: FirebaseFirestore.instance).getRecipes(),
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
                                        'id': recipe.id,
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

                    const SizedBox(
                      height: 50,
                    ),
                    //     Navigator.pushNamed(
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, RouteGenerator.community);
                      },
                      child:  const Text(
                        'Show All Recipe by Community',
                        style: TextStyle(
                            fontFamily: 'CeraPro',
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: AppColors.orangeCrusta),
                      ),
                    ),
                    const SizedBox(
                      height: 40.0,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Category',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontFamily: 'Recoleta',
                                fontSize: 24,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Container(
                      height: 130,
                      child: StreamBuilder<List<Category>>(
                        stream: CategoryProvider().getCategories(),
                        builder: (context, snapshot) {

                          if (snapshot.connectionState == ConnectionState.waiting){
                            return const CircularProgressIndicator();
                          }else{

                            final categories = snapshot.data;

                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: categories!.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                final category = categories[index];
                                return GestureDetector(
                                  onTap: (){
                                    //recipeProvider.eventFilterKey(category.id);
                                    Navigator.pushNamed(context, RouteGenerator.community);
                                  },
                                  child: CategoryCard(
                                    category: category,
                                    select: false,
                                  ),
                                );
                              },
                            );
                          }

                        }
                      ),
                    ),
                    const SizedBox(
                      height: 100,
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }}
