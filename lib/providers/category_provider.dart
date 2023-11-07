import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:kcpm/models/category.dart';

class CategoryProvider extends ChangeNotifier{

  final FirebaseFirestore firestore;
  
  CategoryProvider({required this.firestore}){
    init();
  }
  
  
  
  List<Category> _categories = <Category>[];

  List<Category> get listCategories => _categories;
  

  init() async {
    _categories = await getAllCategories();

    notifyListeners();
  }

  Future<List<Category>> getAllCategories() async {
    List<Category> listCategory = [];

    await firestore.collection('categories').get().then((QuerySnapshot querySnapshot){
      querySnapshot.docs.forEach((doc){
        listCategory.add(Category.fromJson(doc.data() as Map<String, dynamic>));
      });
    }) ;

    return Future.value(listCategory);
  }

  List<Category> _recipeListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc) => Category.fromJson(doc.data() as Map<String, dynamic>)).toList();
  }


  Stream<List<Category>> getCategories() {
    return firestore.collection('categories').snapshots().map(_recipeListFromSnapshot);
  }

}