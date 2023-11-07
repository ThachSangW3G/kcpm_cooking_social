import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/follow_model.dart';

class FollowProvider{

  final FirebaseFirestore firestore;

  FollowProvider({required this.firestore});




  Future<void> addFollow(FollowModel followModel) {
    return firestore.collection('follows').doc(followModel.id).set(followModel.toJson()).then((value) => print('follow added'));
  }


  Future<FollowModel> followExist(String idUserOwner, String idUserFollower) async {
    return await firestore.collection('follows')
        .where('idUserOwner', isEqualTo: idUserOwner)
        .where('idUserFollower', isEqualTo: idUserFollower)
        .limit(1)
        .get().then((value) => FollowModel.fromJson( value.docs.first.data() as Map<String, dynamic>));

  }
  // Stream<FollowModel?> followExist(String idUserOwner, String idUserFollower) {
  //   StreamController<FollowModel?> controller = StreamController<FollowModel>();
  //
  //   follows
  //       .where('idUserOwner', isEqualTo: idUserOwner)
  //       .where('idUserFollower', isEqualTo: idUserFollower)
  //       .limit(1)
  //       .snapshots()
  //       .listen((QuerySnapshot querySnapshot) {
  //     if (querySnapshot.docs.isNotEmpty) {
  //       FollowModel followModel = FollowModel.fromJson(querySnapshot.docs.first.data() as Map<String, dynamic>);
  //       controller.add(followModel);
  //     } else {
  //       controller.add(null);
  //     }
  //   });
  //
  //   return controller.stream;
  // }

  Future<void> deleteFollow(FollowModel followModel) {
    return firestore.collection('follows').doc(followModel.id).delete().then((value) => print('deleted follow'));
  }

  Stream<int> getFollower(String idUser) {
    StreamController<int> controller = StreamController<int>();
    firestore.collection('follows')
        .where('idUserOwner', isEqualTo: idUser)
        .snapshots()
        .listen((QuerySnapshot querySnapshot) {
      int count = querySnapshot.size;
      controller.add(count);
    });

    return controller.stream;
  }


  Stream<int> getFollowing(String idUser){
    StreamController<int> controller = StreamController<int>();

    firestore.collection('follows')
        .where('idUserFollower', isEqualTo: idUser)
        .snapshots()
        .listen((QuerySnapshot querySnapshot) {
      int count = querySnapshot.size;
      controller.add(count);
    });

    return controller.stream;
  }

}