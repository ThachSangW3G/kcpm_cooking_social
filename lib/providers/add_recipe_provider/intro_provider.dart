
import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../../models/category.dart';

enum Difficulty { Difficult, Medium, Easy }

class Intro {
  String? name;
  String? url;
  int? cookTime;
  int? cookTimeHour;
  String? description;
  bool? isPublic;
  int? server;
  Category? category;
  String? difficult;
  File? file;
  String? source;

  Intro(
      {this.name,
        this.url,
        this.cookTime,
        this.cookTimeHour,
        this.description,
        this.isPublic = false,
        this.server,
        this.category,
        this.difficult,
        this.file,
        this.source});
}

class IntroProvider with ChangeNotifier {
  Intro _intro = Intro();

  Intro get intro => _intro;

  void updateIntro(
      {String? name,
        String? url,
        int? cookTime,
        int? cookTimeHour,
        String? description,
        bool? isPublic,
        int? server,
        Category? category,
        String? difficult,
        File? file,
        String? source}) {
    _intro = Intro(
        name: name ?? _intro.name,
        url: url ?? _intro.url,
        cookTime: cookTime ?? _intro.cookTime,
        cookTimeHour: cookTimeHour ?? _intro.cookTimeHour,
        description: description ?? _intro.description,
        isPublic: isPublic ?? _intro.isPublic,
        server: server ?? _intro.server,
        category: category ?? _intro.category,
        difficult: difficult ?? _intro.difficult,
        file: file ?? _intro.file,
        source: source ?? _intro.source);
    notifyListeners();
  }

  void clearData() {
    _intro = Intro();
    notifyListeners();
  }

  void updateItemsFormList(Intro intro) {
    _intro = intro;
    notifyListeners();
  }
}
