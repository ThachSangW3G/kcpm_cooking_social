import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  String id;
  String uidUser;
  String description;
  Timestamp time;
  String idRecipe;


  Review(
      {required this.uidUser,
        required this.description,
        required this.id,


        required this.time,
        required this.idRecipe,
     });


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Review &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              uidUser == other.uidUser &&
            time == other.time && description == other.description && idRecipe == other.idRecipe;

  @override
  int get hashCode => id.hashCode;


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uidUser': uidUser,
      'description': description,
      'time': time,
      'idRecipe': idRecipe,
    };
  }

  // void setProperty(String propertyName, dynamic propertyValue) {
  //   if (propertyName == 'check') {
  //     check = propertyValue;
  //   }
  //   // Thêm các trường hợp xử lý cho các thuộc tính khác (nếu có)
  // }

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
        id: json['id'],
        uidUser: json['uidUser'],
        description: json['description'],
        time: json['time'],
        idRecipe: json['idRecipe']);
  }
}
