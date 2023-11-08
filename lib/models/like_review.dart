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


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is LikeReview &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              idUser == other.idUser &&
              idReview == other.idReview && time == other.time;

  @override
  int get hashCode => id.hashCode;

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
