
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kcpm/models/user.dart';
import 'package:kcpm/providers/like_provider.dart';
import 'package:kcpm/providers/recipe_provider.dart';
import 'package:kcpm/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../models/like_model.dart';
import '../../models/recipe.dart';
import '../../providers/category_provider.dart';
import '../../routes/app_routes.dart';
import '../../widgets/category_card.dart';
import '../../widgets/featured_card_small_widget.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {




  @override
  Widget build(BuildContext context) {
    final RecipeProvider recipeProvider = Provider.of<RecipeProvider>(context);
    final LikeProvider likeProvider = Provider.of<LikeProvider>(context);
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Comminity',
          style: TextStyle(
            fontFamily: 'Recoleta',
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            decoration:
            BoxDecoration(border: Border.all(color: AppColors.greyIron)),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const OptionItemDialog();
                        });
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            right: BorderSide(color: AppColors.greyIron))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 10.0),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icon_svg/equalizer.svg',
                            color: AppColors.greyBombay,
                            height: 20,
                            width: 20,
                          ),
                          const SizedBox(
                            width: 15.0,
                          ),
                          const Text(
                            'Filter',
                            style: TextStyle(
                                fontFamily: 'CeraPro',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.greyShuttle),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 15.0),
                  height: 20,
                  width: 250,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: GestureDetector(
                          onTap: (){
                            recipeProvider.setSort('relevancy');
                          },
                          child: Text(
                            'Relevancy',
                            style: TextStyle(
                                fontFamily: 'CeraPro',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: recipeProvider.sort == 'relevancy' ? AppColors.yellowOrange : AppColors.greyShuttle),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: GestureDetector(
                          onTap: (){
                            recipeProvider.setSort('popular');
                          },
                          child: Text(
                            'Popular',
                            style: TextStyle(
                                fontFamily: 'CeraPro',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: recipeProvider.sort == 'popular' ? AppColors.yellowOrange : AppColors.greyShuttle),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: GestureDetector(
                          onTap: (){
                            recipeProvider.setSort('commented');
                          },
                          child: Text(
                            'Commented',
                            style: TextStyle(
                                fontFamily: 'CeraPro',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color:  recipeProvider.sort == 'commented' ? AppColors.yellowOrange : AppColors.greyShuttle),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: GestureDetector(
                          onTap: (){
                            recipeProvider.setSort('preparation_time');
                          },
                          child: Text(
                            'Preparation Time',
                            style: TextStyle(
                                fontFamily: 'CeraPro',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: recipeProvider.sort == 'preparation_time' ? AppColors.yellowOrange : AppColors.greyShuttle),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: StreamBuilder<List<Recipe>>(
                  stream: recipeProvider.getRecipeSortAndFilter(),
                  builder: (context, snapshot){
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }else {
                      final recipes = snapshot.data;
                      return  GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, mainAxisExtent: 320),
                          itemCount: recipes!.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final recipe = recipes[index];
                            return GestureDetector(
                              onTap: (){
                                Navigator.of(context).pushNamed(
                                  RouteGenerator.recipedetailScreen,
                                  arguments: {
                                    'key': recipe.key,
                                    'uid': recipe.uidUser,
                                  },
                                );
                              },
                              child: StreamBuilder<UserInformation>(
                                stream: UserProvider().getUser(recipe.uidUser),
                                builder: (context, snapshot) {

                                  if (snapshot.connectionState == ConnectionState.waiting){
                                    return const CircularProgressIndicator();
                                  }

                                  final userInformation = snapshot.data;

                                  return FutureBuilder<LikeModel>(
                                    future: LikeProvider().likeExists(recipe.key, user.uid),
                                    builder: (context, snapshot){

                                      final LikeModel? liked = snapshot.data;
                                      return  FeaturedCardSmallWidget(recipe: recipe, userInformation: userInformation!, like: () async {

                                        if(liked == null){
                                          LikeModel likeModel = LikeModel(
                                              id: DateTime.now().toIso8601String(),
                                              idRecipe: recipe.key,
                                              idUser: user.uid,
                                              time: Timestamp.now()
                                          );
                                          await LikeProvider().setDataLike(likeModel);

                                          await LikeProvider().updateRecipe(recipe);
                                        }else {
                                          await LikeProvider().deleteLike(liked);
                                        }

                                      }, liked: liked != null,);
                                    },
                                  );
                                }
                              ),
                            );
                          });
                    }
                  },
                )
            ),
          )
        ],
      ),
    );
  }
}

class OptionItemDialog extends StatelessWidget {
  const OptionItemDialog({super.key});


  @override
  Widget build(BuildContext context) {
    final CategoryProvider categoryProvider = Provider.of<CategoryProvider>(context);
    final RecipeProvider recipeProvider = Provider.of<RecipeProvider>(context);
    return Dialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))),
      child: SizedBox(
        height: 480,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Category',
                      style: TextStyle(
                        fontFamily: 'CeraPro',
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                RefreshIndicator(
                  onRefresh: () async{
                    context.read<CategoryProvider>().init();
                  },
                  child: Container(
                    height: 130,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: categoryProvider.listCategories.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index){
                        final category = categoryProvider.listCategories[index];
                        return GestureDetector(
                          onTap: (){
                            recipeProvider.eventFilterKey(category.id);
                          },
                          child: CategoryCard(
                            category: category,
                            select: recipeProvider.containsFilter(category.id),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Sort',
                      style: TextStyle(
                        fontFamily: 'CeraPro',
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: (){
                        recipeProvider.setSort('relevancy');
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Relevancy',
                        style: TextStyle(
                            fontFamily: 'CeraPro',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: recipeProvider.sort == 'relevancy' ? AppColors.yellowOrange : AppColors.greyShuttle),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: (){
                        recipeProvider.setSort('popular');
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Popular',
                        style: TextStyle(
                            fontFamily: 'CeraPro',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: recipeProvider.sort == 'popular' ? AppColors.yellowOrange : AppColors.greyShuttle),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: (){
                        recipeProvider.setSort('commented');
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Commented',
                        style: TextStyle(
                            fontFamily: 'CeraPro',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color:recipeProvider.sort == 'commented' ? AppColors.yellowOrange : AppColors.greyShuttle),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: (){
                        recipeProvider.setSort('preparation_time');
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Preparation Time',
                        style: TextStyle(
                            fontFamily: 'CeraPro',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: recipeProvider.sort == 'preparation_time' ? AppColors.yellowOrange : AppColors.greyShuttle),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
