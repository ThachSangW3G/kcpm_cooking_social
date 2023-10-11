import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../models/like_review.dart';

class LikeReviewProvider extends ChangeNotifier {
  CollectionReference likes =
  FirebaseFirestore.instance.collection('reviewlike');


  Future<void> addLike(LikeReview likeModel) async {
    await likes
        .doc(likeModel.id)
        .set(likeModel.toJson())
        .then((value) => print('liked add'));
    notifyListeners();
  }

  Future<LikeReview> likeExist(String idReview, String idUser) async {
    return await likes
        .where('idReview', isEqualTo: idReview)
        .where('idUser', isEqualTo: idUser)
        .limit(1)
        .get()
        .then((value) => LikeReview.fromJson(
        value.docs.first.data() as Map<String, dynamic>));
  }

  Future<void> deleteLike(LikeReview likeModel) async {
    await likes
        .doc(likeModel.id)
        .delete()
        .then((value) => print('deleted like'));
    notifyListeners();
  }
}