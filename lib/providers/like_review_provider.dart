import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../models/like_review.dart';

class LikeReviewProvider extends ChangeNotifier {

  final FirebaseFirestore firestore;

  LikeReviewProvider({required this.firestore});


  Future<void> addLikeReview(LikeReview likeReview) async {
    await firestore.collection('likeReviews')
        .doc(likeReview.id)
        .set(likeReview.toJson())
        .then((value) => print('liked add'));
    notifyListeners();
  }

  Future<LikeReview> likeExist(String idReview, String idUser) async {
    return await firestore.collection('likeReviews')
        .where('idReview', isEqualTo: idReview)
        .where('idUser', isEqualTo: idUser)
        .limit(1)
        .get()
        .then((value) => LikeReview.fromJson(
        value.docs.first.data() as Map<String, dynamic>));
  }

  Future<void> deleteLike(LikeReview likeModel) async {
    await firestore.collection('likeReviews')
        .doc(likeModel.id)
        .delete()
        .then((value) => print('deleted like'));
    notifyListeners();
  }
}