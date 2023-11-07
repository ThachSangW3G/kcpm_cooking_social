import 'package:cloud_firestore/cloud_firestore.dart';

class LikeModel {
  final String id;
  final String idUser;
  final String idRecipe;
  final Timestamp time;

  LikeModel({required this.id, required this.idUser, required this.idRecipe, required this.time});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is LikeModel &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              idUser == other.idUser &&
              idRecipe == other.idRecipe && time == other.time;

  @override
  int get hashCode => id.hashCode;


  factory LikeModel.fromJson(Map<String, dynamic> json){
    return LikeModel(
        id: json['id'],
        idUser: json['idUser'],
        idRecipe: json['idRecipe'],
        time: json['time']
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'idUser': idUser,
      'idRecipe': idRecipe,
      'time': time
    };
  }

}

