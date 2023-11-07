import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kcpm/models/category.dart';
import 'package:kcpm/providers/category_provider.dart';

void main(){
  group('Category Test', () {

    FakeFirebaseFirestore? fakeFirebaseFirestore;

    final Category category = Category(id: 'KKFGHFRTGHEDERR', image: 'https://thegirlonbloor.com/wp-content/uploads/2021/07/Summer-Drinks-14-500x500.jpg', name: 'Drinks');

    setUp(() {
      fakeFirebaseFirestore = FakeFirebaseFirestore();
    });
    
    group('Collection Operations', () { 
      test('Test getAllCategories Future', () async{
        final CategoryProvider categoryProvider = CategoryProvider(firestore: fakeFirebaseFirestore!);
        await fakeFirebaseFirestore!.collection('categories').doc(category.id).set(category.toJson());

        List<Category> expectedListCategory = [];
        await fakeFirebaseFirestore!.collection('categories').get().then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            expectedListCategory.add(Category.fromJson(doc.data() as Map<String, dynamic>));
          });
        });

        List<Category> actualListCategory = await categoryProvider.getAllCategories();

        expect(actualListCategory, equals(expectedListCategory));
      });

      test('Test getCategories Stream', () async {
        final CategoryProvider categoryProvider = CategoryProvider(firestore: fakeFirebaseFirestore!);
        await fakeFirebaseFirestore!.collection('categories').doc(category.id).set(category.toJson());

        final List<Category> expectedListCategory = await fakeFirebaseFirestore!.collection('categories').snapshots().map((snapshot) {
          return snapshot.docs.map((doc) => Category.fromJson(doc.data())).toList();
        }).first;

        final List<Category> actualListCategory = await categoryProvider.getCategories().first;

        expect(actualListCategory, equals(expectedListCategory));
      });
    });
    
  });
}