
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../models/review.dart';
import '../services/date_time.dart';

class ReviewProvider extends ChangeNotifier {
  List<Review> _review = [];
  List<Review> get review => _review;

  List<Review> _reviewByUser = [];
  List<Review> get reviewByUser => _reviewByUser;

  final FirebaseFirestore firestore;
  ReviewProvider({required this.firestore});

  Future<List<Review>> getReviewsByRecipe(String idRecipe) async {
    List<Review> reviewList = [];
    await firestore.collection('reviews').where('idRecipe', isEqualTo: idRecipe).get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        reviewList.add(Review.fromJson(doc.data() as Map<String, dynamic>));
        //print(recipeList.length);
      });
    });

    return Future.value(reviewList);
  }

  Future<List<Review>> getReviewsByUser(String uidUser) async {
    List<Review> reviewList = [];
    await firestore.collection('reviews').where('uidUser', isEqualTo: uidUser).get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        reviewList.add(Review.fromJson(doc.data() as Map<String, dynamic>));
        //print(recipeList.length);
      });
    });

    return Future.value(reviewList);

  }

  Future<void> deleteReview(Review review) async {
    return firestore.collection('reviews').doc(review.id).delete().then((value) => print('deleted review'));
  }

  Future<void> addReview(Review review) async {
    return firestore.collection('reviews').doc(review.id).set(review.toJson()).then((value) => print('review added'));
  }

  // Future<void> update(Review review) async {
  //   try {
  //     int index = _review.indexWhere((r) => r.key == review.key);
  //     if (index != -1) {
  //       _review[index] = review;
  //     }
  //     notifyListeners();
  //   } catch (error) {
  //     debugPrint(error as String?);
  //   }
  // }

  // void updatePropertyById(
  //     String reviewId, String propertyName, dynamic propertyValue) {
  //   final reviewIndex = _review.indexWhere((review) => review.key == reviewId);
  //   if (reviewIndex != -1) {
  //     _review[reviewIndex].setProperty(propertyName, propertyValue);
  //     notifyListeners();
  //   }
  //}

  String getTimeAgo(Timestamp timestamp){
    DateTime dateTime = timestamp.toDate();

    // Sử dụng DateTime và timeago để hiển thị khoảng thời gian
    String timeAgo = calculateTimeAgo(dateTime);
    return timeAgo;
  }
}
