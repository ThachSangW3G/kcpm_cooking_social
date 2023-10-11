import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/grocery.dart';

class GroceryProvider{

  CollectionReference groceries = FirebaseFirestore.instance.collection('groceries');

  Future<void> createGrogery(Grocery grocery) {
    return groceries.doc(grocery.key).set(grocery.toJson()).then((value) => print('create GROCERY for user!'));
  }

  Future<List<Grocery>> getListGroceries() async {

    List<Grocery> list = [];
    await groceries
        .where('uidUser', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {
        list.add(Grocery.fromJson(doc.data() as Map<String, dynamic>));
      });
    }).onError((error, stackTrace) {
      print(error);
    });

    print(list);


    return Future.value(list);
  }

  Future<void> deleteGrocery() async {
    List<Grocery> listGrocery = await getListGroceries();

    for(var grocery in listGrocery){
      groceries.doc(grocery.key).delete().then((value) => print('grocery likecookbook'));
    }
  }


}