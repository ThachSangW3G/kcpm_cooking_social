import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kcpm/models/user.dart';

abstract class UserDataService{
  Future setDataUse(UserInformation userInformation);
  Future<bool> userExists(String uid);
  Future<UserInformation> getUser(String uid);
}

class UserFirebaseService implements UserDataService{
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  Future setDataUse(UserInformation userInformation) {
    return users.doc(userInformation.uid).set(userInformation.toJson()).then((value) => print('user added'));
  }

  @override
  Future<bool> userExists(String uid) async {
    DocumentSnapshot userSnapshot = await users
        .doc(uid)
        .get();
    return userSnapshot.exists;
  }

  Future<UserInformation> getUser(String uid) async {
    final docRef = users.doc(uid);
    final docSnapshot = await docRef.get();
    final data = UserInformation.fromJson(docSnapshot.data() as Map<String, dynamic>);
    return data;
  }


}