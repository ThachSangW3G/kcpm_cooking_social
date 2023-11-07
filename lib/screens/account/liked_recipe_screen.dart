
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kcpm/providers/like_provider.dart';

import '../../models/recipe.dart';
import '../../routes/app_routes.dart';
import '../../widgets/line_row.dart';
import '../../widgets/recipe_item_unpublished.dart';

class LikedRecipeScreen extends StatefulWidget {
  const LikedRecipeScreen({super.key});

  @override
  State<LikedRecipeScreen> createState() => _LikedRecipeScreenState();
}

class _LikedRecipeScreenState extends State<LikedRecipeScreen> {
  @override
  Widget build(BuildContext context) {
    //final LikeProvider likeProvider = Provider.of<LikeProvider>(context);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Liked Recipe',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 24,
                fontFamily: 'Recoleta'),
          ),
          leading: IconButton(
              onPressed: () {
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
        body: FutureBuilder<List<Recipe>>(
          future: LikeProvider(firestore: FirebaseFirestore.instance).getLikedRecipe(),
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }else {
              final listRecipe = snapshot.data;
              return ListView.builder(
                itemCount: listRecipe!.length,
                itemBuilder: (context, index){
                  final recipe = listRecipe[index];
                  return GestureDetector(
                    onTap: (){
                      Navigator.of(context).pushNamed(
                          RouteGenerator.recipedetailScreen,
                          arguments: recipe.id);
                    },
                    child: RecipeItemUnPublishedWidget(
                      recipe: recipe,
                    ),
                  );
                },
              );
            }

          },
        )
    );
  }
}
