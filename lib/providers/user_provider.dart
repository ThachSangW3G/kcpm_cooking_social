import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:kcpm/remote/user_firebase.dart';
import 'package:kcpm/services/auth.dart';

import '../models/user.dart';

class UserProvider extends ChangeNotifier{

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Stream<UserInformation> getUser(String uid) {
    final docRef = users.doc(uid);
    return docRef.snapshots().map((docSnapshot) {
      return UserInformation.fromJson(docSnapshot.data() as Map<String, dynamic>);
    });
  }

  Future<UserInformation> getUserFuture(String uid) async {
    return await users.doc(uid).get().then(
            (DocumentSnapshot doc){
          final data = UserInformation.fromJson(doc.data() as Map<String, dynamic>);
          return Future.value(data);
        }
    );

  }

  Future<void> updateUser(UserInformation userInformation) {
    return users.doc(userInformation.uid).update(userInformation.toJson()).then((value) => print(''));
  }


}