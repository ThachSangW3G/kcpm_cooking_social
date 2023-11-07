import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/grocery.dart';

class GroceryProvider{

  final FirebaseFirestore firestore;
  GroceryProvider({required this.firestore});


  Future<void> createGrogery(Grocery grocery) {
    return firestore.collection('groceries').doc(grocery.key).set(grocery.toJson()).then((value) => print('create GROCERY for user!'));
  }

  Future<List<Grocery>> getListGroceries(String idUser) async {

    List<Grocery> list = [];
    await firestore.collection('groceries')
        .where('uidUser', isEqualTo: idUser)
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

  Future<void> deleteGrocery(String idUser) async {
    List<Grocery> listGrocery = await getListGroceries(idUser);

    for(var grocery in listGrocery){
      firestore.collection('groceries').doc(grocery.key).delete().then((value) => print('grocery likecookbook'));
    }
  }


}