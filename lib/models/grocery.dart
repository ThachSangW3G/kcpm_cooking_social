
import 'package:cloud_firestore/cloud_firestore.dart';

class Grocery {
  String key;
  Timestamp date;
  List<String> ingredients;
  String recipeId;
  String uidUser;

  Grocery(
      {required this.key,
        required this.date,
        required this.ingredients,
        required this.recipeId,
        required this.uidUser});

  factory Grocery.fromJson(Map<String, dynamic> json) {
    return Grocery(
        key: json['key'] as String,
        date: json['date'],
        ingredients: List<String>.from(json['ingredients']),
        recipeId: json['recipeId'] as String,
        uidUser: json['uidUser'] as String);
  }
  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'date': date,
      'ingredients': ingredients,
      'recipeId': recipeId,
      'uidUser': uidUser
    };
  }
}
