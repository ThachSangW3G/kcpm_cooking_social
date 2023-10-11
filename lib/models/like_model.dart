import 'package:cloud_firestore/cloud_firestore.dart';

class LikeModel {
  final String id;
  final String idUser;
  final String idRecipe;
  final Timestamp time;

  LikeModel({required this.id, required this.idUser, required this.idRecipe, required this.time});

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

