import 'package:cloud_firestore/cloud_firestore.dart';

class LikeReview {
  final String id;
  final String idUser;
  final String idReview;
  final Timestamp time;

  LikeReview(
      {required this.id,
        required this.idUser,
        required this.idReview,
        required this.time});

  factory LikeReview.fromJson(Map<String, dynamic> json) {
    return LikeReview(
        id: json['id'],
        idUser: json['idUser'],
        idReview: json['idReview'],
        time: json['time']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'idUser': idUser, 'idReview': idReview, 'time': time};
  }
}
