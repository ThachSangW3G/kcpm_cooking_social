import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kcpm/models/recipe.dart';
import 'package:kcpm/providers/recipe_provider.dart';

void main(){

  group('Recipe test', () {
    FakeFirebaseFirestore? fakeFirebaseFirestore;

    final Recipe recipe = Recipe(
        id: '0x0ZZYG7KEqKkGeSamj4',
        url: 'https://lavenderstudio.com.vn/wp-content/uploads/2017/03/chup-san-pham.jpg',
        name: 'Lẩu thái lan',
        cookTime: 12,
        description: 'Nghe đến từ Súp tất nhiên điều hiện lên trong đầu chúng ta là một món gì đó thơm ngon hấp dẫn. ',
        difficult: 'Easy',
        isPublic: true,
        material: [
          '3 tép tỏi',
          '2 củ hành'
        ],
        category: 'vO6JKDM57yJfZz2lqmA1',
        numberLike: 12,
        numberReview: 10,
        serves: 2,
        source: 'https://www.fimela.com/lifestyle-relationsh',
        spice: [
          'nước mắm',
          'bột ngọt'
        ],
        steps: [
          'đun xôi'
        ],
        uidUser: '67pXjcN4rVXWU0Uy9kkUSP2ZcLL2');


    setUp(() {
      fakeFirebaseFirestore = FakeFirebaseFirestore();
    });
    
    group('Collection Operations', () {

      test('Test getRecipe Stream', () async{
        final RecipeProvider recipeProvider = RecipeProvider(firestore: fakeFirebaseFirestore!);
        await fakeFirebaseFirestore!.collection('recipes').doc(recipe.id).set(recipe.toJson());

        final List<Recipe> expectListRecipe = await fakeFirebaseFirestore!.collection('recipes').snapshots().map((snapshot) {
          return snapshot.docs.map((doc) => Recipe.fromJson(doc.data())).toList();
        }).first;

        final Stream<List<Recipe>> streamList =  recipeProvider.getRecipes();
        final List<Recipe> actualListRecipe = await streamList.first;

        
        expect(actualListRecipe, equals(expectListRecipe));

      });

      test('Test getRecipeSearch Stream', () async{
        final RecipeProvider recipeProvider = RecipeProvider(firestore: fakeFirebaseFirestore!);
        await fakeFirebaseFirestore!.collection('recipes').doc(recipe.id).set(recipe.toJson());
        
        String searchText = 'Lẩu thái lan';
        
        final List<Recipe> expectListRecipe = await fakeFirebaseFirestore!.collection('recipes').snapshots().map((snapshot) {
          return snapshot.docs.map((doc) => Recipe.fromJson(doc.data())).toList().where((element) => element.name.toLowerCase().contains(searchText))
              .toList();
        }).first;

      

        final Stream<List<Recipe>> streamList =  recipeProvider.getSearchRecipe(searchText);
        final List<Recipe> listRecipe = await streamList.first;

        expect(listRecipe, equals(expectListRecipe));

      });

      test('Test getRecipeByIdUser Stream', () async{
        final RecipeProvider recipeProvider = RecipeProvider(firestore: fakeFirebaseFirestore!);
        await fakeFirebaseFirestore!.collection('recipes').doc(recipe.id).set(recipe.toJson());

        String idUser = 'IdUser';

        final List<Recipe> expectListRecipe = await fakeFirebaseFirestore!.collection('recipes').where('uidUser', isEqualTo: idUser).snapshots().map((snapshot) {
          return snapshot.docs.map((doc) => Recipe.fromJson(doc.data())).toList();
        }).first;

        final Stream<List<Recipe>> streamList =  recipeProvider.getRecipeByIdUser(idUser);
        final List<Recipe> listRecipe = await streamList.first;
        

        expect(listRecipe, equals(expectListRecipe));

      });

      test('Test getRecipe Future', () async{
        final RecipeProvider recipeProvider = RecipeProvider(firestore: fakeFirebaseFirestore!);
        await fakeFirebaseFirestore!.collection('recipes').doc(recipe.id).set(recipe.toJson());

        final Recipe expectRecipe = await fakeFirebaseFirestore!.collection('recipes').doc(recipe.id).get().then((DocumentSnapshot doc) => Recipe.fromJson(doc.data() as Map<String, dynamic>));

        final Recipe actualRecipe = await recipeProvider.getRecipe(recipe.id);

        expect(actualRecipe, equals(expectRecipe));

      });

      test('Test getAllRecipes Future', () async {
        final RecipeProvider recipeProvider = RecipeProvider(firestore: fakeFirebaseFirestore!);
        await fakeFirebaseFirestore!.collection('recipes').doc(recipe.id).set(recipe.toJson());

        List<Recipe> recipeList = [];
        await fakeFirebaseFirestore!.collection('recipes').get().then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            recipeList.add(Recipe.fromJson(doc.data() as Map<String, dynamic>));
          });
        });

        List<Recipe> actualListRecipe = await recipeProvider.getAllRecipes();

        expect(actualListRecipe, equals(recipeList));

      });

    });
  });
}


