import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kcpm/models/like_model.dart';
import 'package:kcpm/models/recipe.dart';
import 'package:kcpm/providers/like_provider.dart';

void main(){
  group('Testing Like', () {
    FakeFirebaseFirestore? fakeFirebaseFirestore;

    final LikeModel likeModel = LikeModel(
        id: 'SADFGHJKMNBVDER',
        idUser: 'DSFDGHJKJJHGF',
        idRecipe: '0x0ZZYG7KEqKkGeSamj4',
        time: Timestamp.fromDate(DateTime.now()));

    setUp((){
      fakeFirebaseFirestore = FakeFirebaseFirestore();
    });

    group('Collection Operations', () {
      test('Test likeExists', ()async{
        final LikeProvider likeProvider = LikeProvider(firestore: fakeFirebaseFirestore!);
        await fakeFirebaseFirestore!.collection('likes').doc(likeModel.id).set(likeModel.toJson());

        final expectedLike = await likeProvider.likeExists(likeModel.idRecipe, likeModel.idUser);

        expect(likeModel, equals(expectedLike));

      });

      test('Test setDataLike', () async{
        final LikeProvider likeProvider = LikeProvider(firestore: fakeFirebaseFirestore!);
        await likeProvider.setDataLike(likeModel);

        final LikeModel expectedLike = await fakeFirebaseFirestore!.collection('likes').doc(likeModel.id).get().then((DocumentSnapshot doc) => LikeModel.fromJson(doc.data() as Map<String, dynamic>));

        expect(likeModel, equals(expectedLike));
      });

      test('Test deleteLike', () async{
        final LikeProvider likeProvider = LikeProvider(firestore: fakeFirebaseFirestore!);

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

        await fakeFirebaseFirestore!.collection('recipes').doc(recipe.id).set(recipe.toJson());
        await fakeFirebaseFirestore!.collection('likes').doc(likeModel.id).set(likeModel.toJson());



        await likeProvider.deleteLike(likeModel);

        final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =    await fakeFirebaseFirestore!.collection('likes').doc(likeModel.id).get();

        expect(documentSnapshot.exists, false);
      });

      test('Test getLikedByIdUser', () async{
        final LikeProvider likeProvider = LikeProvider(firestore: fakeFirebaseFirestore!);
        await fakeFirebaseFirestore!.collection('likes').doc(likeModel.id).set(likeModel.toJson());

        List<LikeModel> expectedListLike = [];
        await fakeFirebaseFirestore!.collection('likes').get().then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            expectedListLike.add(LikeModel.fromJson(doc.data() as Map<String, dynamic>));
          });
        });

        List<LikeModel> actualListLike = await likeProvider.getLikedByIdUser(likeModel.idUser);

        expect(actualListLike, equals(expectedListLike));

      });

      test('Test getLikedRecipe', () async{
        final LikeProvider likeProvider = LikeProvider(firestore: fakeFirebaseFirestore!);

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

        await fakeFirebaseFirestore!.collection('recipes').doc(recipe.id).set(recipe.toJson());
        await fakeFirebaseFirestore!.collection('likes').doc(likeModel.id).set(likeModel.toJson());

        List<Recipe> actualListRecipe = await likeProvider.getLikedRecipe(likeModel.idUser);

        List<LikeModel> listLike = [];
        await fakeFirebaseFirestore!.collection('likes').get().then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            listLike.add(LikeModel.fromJson(doc.data() as Map<String, dynamic>));
          });
        });
        List<Recipe> expectedListRecipes = [];
        for(var liked in listLike){
          Recipe recipe = await await fakeFirebaseFirestore!.collection('recipes').doc(liked.idRecipe).get().then((DocumentSnapshot doc) => Recipe.fromJson(doc.data() as Map<String, dynamic>));
          expectedListRecipes.add(recipe);
        }

        expect(actualListRecipe, equals(expectedListRecipes));

      });

    });

  });

}