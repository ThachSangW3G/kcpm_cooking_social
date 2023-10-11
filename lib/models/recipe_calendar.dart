import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeCalendar{
  final String id;
  final Timestamp date;
  String meal;
  String idRecipe;
  final String idUser;

  RecipeCalendar( {required this.id, required this.date, required this.meal, required this.idRecipe, required this.idUser,});

  factory RecipeCalendar.fromJson(Map<String, dynamic> json){
    return RecipeCalendar(
        id: json['id'],
        date: json['date'],
        meal: json['meal'],
        idRecipe: json['idRecipe'],
        idUser: json['idUser']
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'date': date,
      'meal': meal,
      'idRecipe': idRecipe,
      'idUser': idUser
    };
  }
}