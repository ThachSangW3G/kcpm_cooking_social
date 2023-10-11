
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

  Future<List<Review>> fetchReview(String key) async {
    // try {
    List<Review> fetchedReview = [];
    //
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('reviews')
        .where('keyRecipe', isEqualTo: key)
        .get();
    for (var doc in snapshot.docs) {
      String uidUser = doc['uidUser'];
      String description = doc['description'];
      String key = doc['key'];
      Timestamp timestamp = doc['time'];
      String keyRecipe = doc['keyRecipe'];

      //
      DateTime dateTime = timestamp.toDate();

      // Sử dụng DateTime và timeago để hiển thị khoảng thời gian
      String timeAgo = calculateTimeAgo(dateTime);
      //
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uidUser)
          .get();

      String name = userSnapshot['name'];
      String avatar = userSnapshot['avatar'];
      //
      QuerySnapshot snapshotLike = await FirebaseFirestore.instance
          .collection('reviewlike')
          .where('idReview', isEqualTo: key)
          .get();
      bool check = false;
      for (var docs in snapshotLike.docs) {
        if (docs['idUser'] == FirebaseAuth.instance.currentUser?.uid) {
          check = true;
          break;
        }
      }

      Review review = Review(
          uidUser: uidUser,
          description: description,
          key: key,
          avatar: avatar,
          name: name,
          time: timeAgo,
          keyRecipe: keyRecipe,
          check: check);
      fetchedReview.add(review);
    }
    _review = fetchedReview;
    //notifyListeners();
    //print(_review.length.toString() + "hddddddddddddddddd");
    //print(_review[0].description);
    return Future.value(_review);
    // } catch (e) {
    //   debugPrint(e as String?);
    // }
    // return null;
  }

  Future<List<Review>> fetchReviewByUser(String userUid) async {
    // try {
    List<Review> fetchedReviewByUser = [];
    //
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('reviews')
        .where('uidUser', isEqualTo: userUid)
        .get();
    for (var doc in snapshot.docs) {
      String uidUser = doc['uidUser'];
      String description = doc['description'];
      String key = doc['key'];
      Timestamp timestamp = doc['time'];
      String keyRecipe = doc['keyRecipe'];

      //
      DateTime dateTime = timestamp.toDate();

      // Sử dụng DateTime và timeago để hiển thị khoảng thời gian
      String timeAgo = calculateTimeAgo(dateTime);
      //
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uidUser)
          .get();

      String name = userSnapshot['name'];
      String avatar = userSnapshot['avatar'];
      //
      QuerySnapshot snapshotLike = await FirebaseFirestore.instance
          .collection('reviewlike')
          .where('idReview', isEqualTo: key)
          .get();
      bool check = false;
      for (var docs in snapshotLike.docs) {
        if (docs['iddUser'] == FirebaseAuth.instance.currentUser?.uid) {
          check = true;
          break;
        }
      }
      Review review = Review(
          uidUser: uidUser,
          description: description,
          key: key,
          avatar: avatar,
          name: name,
          time: timeAgo,
          keyRecipe: keyRecipe,
          check: check);
      fetchedReviewByUser.add(review);
    }
    _review = fetchedReviewByUser;
    return Future.value(_review);
  }

  Future<void> delete(Review review) async {
    try {
      // Xóa công thức từ cơ sở dữ liệu (ví dụ: Firestore)
      await FirebaseFirestore.instance
          .collection('reviews')
          .doc(review.key)
          .delete();

      // Cập nhật danh sách công thức sau khi xóa
      _review.remove(review);
      notifyListeners();
    } catch (error) {
      debugPrint(error as String?);
    }
  }

  Future<void> addReview(String description, String keyRecipe) async {
    // Khởi tạo Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    // Tạo một document reference và lấy ra ID ngẫu nhiên
    CollectionReference reviewRef = firestore.collection('reviews');
    // Tạo một map chứa thông tin review
    String time = DateTime.now().toIso8601String();
    Map<String, dynamic> reviewData = {
      'uidUser':
      FirebaseAuth.instance.currentUser?.uid, // Giá trị uidUser (String)
      'time': Timestamp.now(), // Giá trị time (Timestamp)
      'key': time, // Giá trị key (String)
      'keyRecipe': keyRecipe,
      'description': description
    };
    // Thêm review vào Firestore
    await reviewRef.doc(time).set(reviewData);
    //Get so luong hien tai
    DocumentSnapshot snapshot =
    await firestore.collection('recipes').doc(keyRecipe).get();
    int currentReviewCount = snapshot['numberReview'];
    // Cập nhật số lượng review của công thức
    DocumentReference recipeRef =
    firestore.collection('recipes').doc(keyRecipe);
    firestore.runTransaction((transaction) async {
      transaction.update(recipeRef, {'numberReview': currentReviewCount + 1});
    });
    //
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();

    String name = userSnapshot['name'];
    String avatar = userSnapshot['avatar'];
    //
    DateTime dateTime = Timestamp.now().toDate();

    // Sử dụng DateTime và timeago để hiển thị khoảng thời gian
    String timeAgo = calculateTimeAgo(dateTime);
    Review review = Review(
        uidUser: FirebaseAuth.instance.currentUser!.uid,
        description: description,
        key: recipeRef.id,
        avatar: avatar,
        name: name,
        time: timeAgo,
        keyRecipe: keyRecipe,
        check: false);
    _review.add(review);
    notifyListeners();
  }

  Future<void> update(Review review) async {
    try {
      int index = _review.indexWhere((r) => r.key == review.key);
      if (index != -1) {
        _review[index] = review;
      }
      notifyListeners();
    } catch (error) {
      debugPrint(error as String?);
    }
  }

  void updatePropertyById(
      String reviewId, String propertyName, dynamic propertyValue) {
    final reviewIndex = _review.indexWhere((review) => review.key == reviewId);
    if (reviewIndex != -1) {
      _review[reviewIndex].setProperty(propertyName, propertyValue);
      notifyListeners();
    }
  }
}
