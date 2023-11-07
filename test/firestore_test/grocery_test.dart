import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kcpm/models/grocery.dart';
import 'package:kcpm/providers/grocery_provider.dart';

void main(){
  group('Testing Grocery', () {
    FakeFirebaseFirestore? fakeFirebaseFirestore;

    final Grocery grocery = Grocery(
        key: 'GHSEFUTEEVDGRGPWE',
        date: Timestamp.fromDate(DateTime.now()),
        ingredients: [
          '1 củ hành',
          'đường',
          'bột ngọt'
        ],
        recipeId: 'SRFHIRUGHEOGFEF',
        uidUser: 'SNSFNGBOSPEFJGERPG');

    setUp(() {
      fakeFirebaseFirestore = FakeFirebaseFirestore();
    });

    group('Collection Operations', () {
      test('Test createGrocery', () async {
        final GroceryProvider groceryProvider = GroceryProvider(firestore: fakeFirebaseFirestore!);
        await groceryProvider.createGrogery(grocery);

        final Grocery expectGrocery =await fakeFirebaseFirestore!.collection('groceries').doc(grocery.key).get().then((DocumentSnapshot doc) => Grocery.fromJson(doc.data() as Map<String, dynamic>));
          expect(grocery, equals(expectGrocery));
      });

      test('Test getListGroceries', ()async{
        final GroceryProvider groceryProvider = GroceryProvider(firestore: fakeFirebaseFirestore!);
        await fakeFirebaseFirestore!.collection('groceries').doc(grocery.key).set(grocery.toJson());

        List<Grocery> expectedListGrocery = [];
        await fakeFirebaseFirestore!.collection('groceries').get().then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            expectedListGrocery.add(Grocery.fromJson(doc.data() as Map<String, dynamic>));
          });

        });

        List<Grocery> actualListGrocery = await groceryProvider.getListGroceries(grocery.uidUser);

        expect(actualListGrocery, equals(expectedListGrocery));

      });

      test('Test deleteGrocery', () async{
        final GroceryProvider groceryProvider = GroceryProvider(firestore: fakeFirebaseFirestore!);
        await fakeFirebaseFirestore!.collection('groceries').doc(grocery.key).set(grocery.toJson());

        await groceryProvider.deleteGrocery(grocery.uidUser);

        final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =    await fakeFirebaseFirestore!.collection('groceries').doc(grocery.key).get();

        expect(documentSnapshot.exists, false);

      });
    });
  });
}