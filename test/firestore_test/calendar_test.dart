import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kcpm/models/recipe_calendar.dart';
import 'package:kcpm/providers/calendar_provider.dart';

void main(){
  group('Calendar Test', (){
    FakeFirebaseFirestore? fakeFirebaseFirestore;

    final recipeCalendar = RecipeCalendar(
        id: DateTime.now().toIso8601String(),
        date: Timestamp.fromDate(DateTime.now()),
        meal: 'Breakfast',
        idRecipe: 'dfghjkjhgfdserfbgg',
        idUser: 'sdfghjfđfghgdfg');


    setUp(() {
      fakeFirebaseFirestore  =FakeFirebaseFirestore();
    });

    group('Collection Operations', () {
      test('Test addRecipeCalendar', () async{
        final CalendarProvider calendarProvider = CalendarProvider(firestore: fakeFirebaseFirestore!);
        await calendarProvider.addRecipeCalendar(recipeCalendar);

        final RecipeCalendar expectedRecipe = await fakeFirebaseFirestore!.collection('calendars').doc(recipeCalendar.id).get().then((DocumentSnapshot doc) => RecipeCalendar.fromJson(doc.data() as Map<String, dynamic>));

        expect(recipeCalendar, equals(expectedRecipe));

      });

      test('Test getRecipeCalendar by date', () async{
        final CalendarProvider calendarProvider = CalendarProvider(firestore: fakeFirebaseFirestore!);
        await fakeFirebaseFirestore!.collection('calendars').doc(recipeCalendar.id).set(recipeCalendar.toJson());

        List<RecipeCalendar> recipeList = [];
        await fakeFirebaseFirestore!.collection('calendars').get().then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            recipeList.add(RecipeCalendar.fromJson(doc.data() as Map<String, dynamic>));
          });
        });

        List<RecipeCalendar> actualListRecipeCalendar = await calendarProvider.getRecipeCalendar(recipeCalendar.date.toDate(), recipeCalendar.idUser);

        expect(actualListRecipeCalendar, equals(recipeList));

      });

      test('Test deleteRecipeCalendar', () async{
        final CalendarProvider calendarProvider = CalendarProvider(firestore: fakeFirebaseFirestore!);
        await fakeFirebaseFirestore!.collection('calendars').doc(recipeCalendar.id).set(recipeCalendar.toJson());

        await calendarProvider.deleteRecipeCalendar(recipeCalendar);

        final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =    await fakeFirebaseFirestore!.collection('calendars').doc(recipeCalendar.id).get();

        expect(documentSnapshot.exists, false);
      });


      test('Test UpdateRecipeCalendar', () async {
        final CalendarProvider calendarProvider = CalendarProvider(firestore: fakeFirebaseFirestore!);
        await fakeFirebaseFirestore!.collection('calendars').doc(recipeCalendar.id).set(recipeCalendar.toJson());

        final RecipeCalendar recipeCalendarUpdate = RecipeCalendar(
            id: recipeCalendar.id,
            date: Timestamp.fromDate(DateTime.now()),
            meal: 'Lunch',
            idRecipe: 'dfghjkjhgfdserfbgg',
            idUser: 'sdfghjfđfghgdfg');

        await calendarProvider.updateRecipeCalendar(recipeCalendarUpdate);
        final RecipeCalendar actualRecipeCalendar = await fakeFirebaseFirestore!.collection('calendars').doc(recipeCalendar.id).get().then((DocumentSnapshot doc) => RecipeCalendar.fromJson(doc.data() as Map<String, dynamic>));

        expect(actualRecipeCalendar, equals(recipeCalendarUpdate));
      });



    });

  });


}
