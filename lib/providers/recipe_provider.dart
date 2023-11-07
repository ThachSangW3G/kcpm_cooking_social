import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:kcpm/models/recipe.dart';

class RecipeProvider extends ChangeNotifier{

  RecipeProvider({required this.firestore}){
    init();
  }

  final FirebaseFirestore firestore;

  List<Recipe> _recipeListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc) => Recipe.fromJson(doc.data() as Map<String, dynamic>)).toList();
  }


  Stream<List<Recipe>> getRecipes() {
    return firestore.collection('recipes').snapshots().map(_recipeListFromSnapshot);
  }



  List<Recipe> _recipeSearchListFromSnapshot(QuerySnapshot snapshot, String searchText){
    return snapshot.docs.map((doc) => Recipe.fromJson(doc.data() as Map<String, dynamic>)).toList().where((element) => element.name.toLowerCase().contains(searchText))
        .toList();
  }


  Stream<List<Recipe>> getSearchRecipe(String searchText) {
    return firestore.collection('recipes').snapshots().map((snapshot) => _recipeSearchListFromSnapshot(snapshot, searchText));
  }

  Stream<List<Recipe>> getRecipeByIdUser(String idUser){
    return firestore.collection('recipes').where('uidUser', isEqualTo: idUser).snapshots().map(_recipeListFromSnapshot);
  }

  Future<Recipe> getRecipe(String idRecipe) async {
    return await firestore.collection('recipes').doc(idRecipe).get().then(
            (DocumentSnapshot doc){
          final data = Recipe.fromJson(doc.data() as Map<String, dynamic>);
          return Future.value(data);
        }
    );
  }


  List<Recipe> _recipes = <Recipe>[];

  List<Recipe> get listRecipe => _recipes;

  // RecipeProvider(){
  //   init();
  //   print('Sanggg');
  // }

  Future<List<Recipe>> getAllRecipes() async {
    List<Recipe> recipeList = [];
    await firestore.collection('recipes').get().then((QuerySnapshot querySnapshot) {
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

  String _sort = 'relevancy';

  String get sort => _sort;

  setSort(String strSort) {
    _sort = strSort;
    notifyListeners();
  }

  List<Recipe> filterRecipe = [];
  List<String> filterKey = [];

  addFilterKey(String idCategory) {
    filterKey.add(idCategory);
    notifyListeners();
  }

  removeFilterKey(String idCategory) {
    filterKey.remove(idCategory);
    notifyListeners();
  }

  eventFilterKey(String idCategory) {
    if (!filterKey.contains(idCategory)) {
      addFilterKey(idCategory);
    } else {
      removeFilterKey(idCategory);
    }

    print(filterKey);

    notifyListeners();
  }

  bool containsFilter(String idCategory) {
    if (filterKey.contains(idCategory)) {
      return true;
    } else {
      return false;
    }
  }

  List<Recipe> _recipeSortAndFilter(QuerySnapshot snapshot){

    List<Recipe> listRecipe = snapshot.docs.map((doc) => Recipe.fromJson(doc.data() as Map<String, dynamic>)).toList();

    List<Recipe> listRecipeFilter = [];

    if (filterKey.isEmpty) {
      listRecipeFilter = listRecipe;
      print(filterKey);

    } else {
      listRecipeFilter = listRecipe.where((feature) {
        return filterKey.contains(feature.category);
      }).toList();
      //print(filterKey);
    }



    switch (_sort) {
      case 'relevancy':
        //listRecipeFilter = snapshot.docs.map((doc) => Recipe.fromJson(doc.data() as Map<String, dynamic>)).toList();
        break;
      case 'popular':
        listRecipeFilter.sort((a, b) => b.numberLike.compareTo(a.numberLike));
        break;
      case 'commented':
        listRecipeFilter.sort((a, b) => b.numberReview.compareTo(a.numberReview));
        break;
      case 'preparation_time':
        listRecipeFilter.sort((a, b) => b.cookTime.compareTo(a.cookTime));
    }


    return listRecipeFilter;
  }


  Stream<List<Recipe>> getRecipeSortAndFilter() {
    return firestore.collection('recipes').snapshots().map(_recipeSortAndFilter);
  }

  Future<void> increaseNumberLikeRecipe(Recipe recipe){
    recipe.numberLike += 1;
    return firestore.collection('recipes')
        .doc(recipe.id)
        .update(recipe.toJson())
        .then((value) => print('recipe updated'));

  }


}