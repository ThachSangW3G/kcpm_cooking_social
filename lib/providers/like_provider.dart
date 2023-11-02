import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:kcpm/providers/recipe_provider.dart';

import '../models/like_model.dart';
import '../models/recipe.dart';

class LikeProvider extends ChangeNotifier{

  CollectionReference likes = FirebaseFirestore.instance.collection('likes');
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<LikeModel> likeExists(String idRecipe, String idUser) async {
    return await likes
        .where('idRecipe', isEqualTo: idRecipe)
        .where('idUser', isEqualTo: idUser)
        .limit(1)
        .get()
        .then((value) => LikeModel.fromJson(
        value.docs.first.data() as Map<String, dynamic>));
  }

  Future setDataLike(LikeModel likeModel) {
    return likes.doc(likeModel.id).set(likeModel.toJson()).then((value) => print('like added'));
  }

  Future<void> deleteLike(LikeModel likeModel) async {
    DocumentSnapshot snapshot =
    await firestore.collection('recipes').doc(likeModel.idRecipe).get();
    int currentReviewCount = snapshot['numberLike'];
    // Cập nhật số lượng review của công thức
    DocumentReference recipeRef =
    firestore.collection('recipes').doc(likeModel.idRecipe);
    firestore.runTransaction((transaction) async {
      transaction.update(recipeRef, {'numberLike': currentReviewCount - 1});
    });
    return likes
        .doc(likeModel.id)
        .delete()
        .then((value) => print('deleted like'));
  }

  Future<void> updateRecipe(Recipe recipe){
    recipe.numberLike += 1;
    return firestore.collection('recipes')
        .doc(recipe.id)
        .update(recipe.toJson())
        .then((value) => print('recipe updated'));

  }

  Future<List<LikeModel>> getLiked() async {
    List<LikeModel> listLikedRecipe = [];
    await likes
        .where('idUser', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        listLikedRecipe
            .add(LikeModel.fromJson(doc.data() as Map<String, dynamic>));
      });
    });
    listLikedRecipe.sort((a, b) => a.time.compareTo(b.time));

    return Future.value(listLikedRecipe);
  }

  Future<List<Recipe>> getLikedRecipe() async {
    List<LikeModel> listLikeRecipe = await getLiked();

    List<Recipe> recipes = [];

    for(var liked in listLikeRecipe){
      Recipe recipe = await RecipeProvider(firestore: FirebaseFirestore.instance).getRecipe(liked.idRecipe);

      recipes.add(recipe);
    }

    return Future.value(recipes);

  }

}