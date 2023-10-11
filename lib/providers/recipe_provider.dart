import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:kcpm/models/recipe.dart';

class RecipeProvider extends ChangeNotifier{
  CollectionReference recipes = FirebaseFirestore.instance.collection('recipes');


  List<Recipe> _recipeListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc) => Recipe.fromJson(doc.data() as Map<String, dynamic>)).toList();
  }


  Stream<List<Recipe>> getRecipes() {
    return recipes.snapshots().map(_recipeListFromSnapshot);
  }


  List<Recipe> _recipeSearchListFromSnapshot(QuerySnapshot snapshot, String searchText){
    return snapshot.docs.map((doc) => Recipe.fromJson(doc.data() as Map<String, dynamic>)).toList().where((element) => element.name.toLowerCase().contains(searchText))
        .toList();
  }


  Stream<List<Recipe>> getSearchRecipe(String searchText) {
    return recipes.snapshots().map((snapshot) => _recipeSearchListFromSnapshot(snapshot, searchText));
  }

  Future<Recipe> getRecipe(String idRecipe) async {
    return await recipes.doc(idRecipe).get().then(
            (DocumentSnapshot doc){
          final data = Recipe.fromJson(doc.data() as Map<String, dynamic>);
          return Future.value(data);
        }
    );
  }


  List<Recipe> _recipes = <Recipe>[];

  List<Recipe> get listRecipe => _recipes;

  RecipeProvider(){
    init();
    print('Sanggg');
  }

  Future<List<Recipe>> getAllRecipes() async {
    List<Recipe> recipeList = [];
    await recipes.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        recipeList.add(Recipe.fromJson(doc.data() as Map<String, dynamic>));
        //print(recipeList.length);
      });
    });

    return Future.value(recipeList);
  }

  Future<void> init() async {
    _recipes = await getAllRecipes();
  }

}