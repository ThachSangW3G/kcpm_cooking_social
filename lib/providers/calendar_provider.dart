import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../models/recipe_calendar.dart';

class CalendarProvider extends ChangeNotifier{
  CollectionReference calendars = FirebaseFirestore.instance.collection('calendars');

  DateTime dateSelected = DateTime.now();

  addRecipeCalendar(RecipeCalendar recipeCalendar) async {
    await calendars.doc(recipeCalendar.id).set(recipeCalendar.toJson()).then((value) => print('calendar add'));
    notifyListeners();
  }

  selectDate(DateTime date){
    dateSelected = date;
    notifyListeners();
  }

  Future<List<RecipeCalendar>> getRecipeCalendar(DateTime date) async {
    final startDate = DateTime(date.year, date.month, date.day);
    final endDate = DateTime(date.year, date.month, date.day + 1);

    List<RecipeCalendar> list = [];
    print(list);

    await calendars
        .where('idUser', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('date', isGreaterThanOrEqualTo: startDate)
        .where('date', isLessThan: endDate)
        .get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        list.add(RecipeCalendar.fromJson(doc.data() as Map<String, dynamic>));
        //print(notificationList.length);
      });
    }).onError((error, stackTrace){
      print(error);
    });


    return Future.value(list);
  }

  Future<void> deleteRecipeCalendar(RecipeCalendar recipeCalendar) async {
    await calendars.doc(recipeCalendar.id).delete().then((value) => print('deleted calendar'));

    notifyListeners();
  }

  Future<void> updateRecipeCalendar(RecipeCalendar recipeCalendar) async {
    await calendars
        .doc(recipeCalendar.id)
        .update(recipeCalendar.toJson())
        .then((value) => print('recipeCalendar updated'));
    notifyListeners();
  }


}