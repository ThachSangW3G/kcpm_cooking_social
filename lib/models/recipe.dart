import 'package:flutter/foundation.dart';

class Recipe {
  String id;
  String url;
  String name;
  int cookTime;
  String description;
  String difficult;
  bool isPublic;
  List<String> material;
  int numberLike;
  String category;
  int numberReview;
  int serves;
  String source;
  List<String> spice;
  List<String> steps;
  String uidUser;
  Recipe(
      {required this.id,
        required this.url,
        required this.name,
        required this.cookTime,
        required this.description,
        required this.difficult,
        required this.isPublic,
        required this.material,
        required this.category,
        required this.numberLike,
        required this.numberReview,
        required this.serves,
        required this.source,
        required this.spice,
        required this.steps,
        required this.uidUser});


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Recipe &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              url == other.url && name == other.name && cookTime == other.cookTime && description == other.description && difficult == other.difficult &&
              isPublic == other.isPublic && listEquals(material, other.material) && category == other.category && numberLike == other.numberLike && numberReview == other.numberReview &&
              serves == other.serves && source == other.source && listEquals(spice, other.spice) && listEquals(steps, other.steps) && uidUser == other.uidUser;

  @override
  int get hashCode => id.hashCode;

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
        id: json['id'] as String,
        url: json['URL'] as String,
        name: json['name'] as String,
        cookTime: json['cookTime'] as int,
        description: json['description'] as String,
        difficult: json['difficult'] as String,
        isPublic: json['isPublic'] as bool,
        material: List<String>.from(json['material']),
        numberLike: json['numberLike'] as int,
        numberReview: json['numberReview'] as int,
        serves: json['serves'] as int,
        source: json['source'] as String,
        category: json['category'] as String,
        spice: List<String>.from(json['spice']),
        steps: List<String>.from(json['steps']),
        uidUser: json['uidUser'] as String);
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'URL': url,
      'name': name,
      'cookTime': cookTime,
      'description': description,
      'difficult': difficult,
      'isPublic': isPublic,
      'material': material,
      'numberLike': numberLike,
      'numberReview': numberReview,
      'category': category,
      'serves': serves,
      'source': source,
      'spice': spice,
      'steps': steps,
      'uidUser': uidUser
    };
  }
}
