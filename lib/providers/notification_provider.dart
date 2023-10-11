import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kcpm/models/user.dart';
import 'package:kcpm/providers/recipe_provider.dart';
import 'package:kcpm/providers/user_provider.dart';

import '../models/notification_model.dart';
import '../models/recipe.dart';

class NotificationProvider{

  CollectionReference notifications = FirebaseFirestore.instance.collection('notifications');

  Future<List<NotificationModel>> getListNotification() async {
    List<NotificationModel> notificationList = [];
    await notifications
        .where('idUserOwner', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        notificationList.add(NotificationModel.fromJson(doc.data() as Map<String, dynamic>));
        //print(notificationList.length);
      });
    });

    //print(notificationList.length);

    return Future.value(notificationList);
  }

  Future<void> deleteNotification() async {
    List<NotificationModel> listNotification = await getListNotification();

    for(var notification in listNotification){
      notifications.doc(notification.id).delete().then((value) => print('notification likecookbook'));
    }

  }

  List<NotificationModel> _notificationFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc) => NotificationModel.fromJson(doc.data() as Map<String, dynamic>)).toList();
  }


  Stream<List<NotificationModel>> getNotificationStream() {
    return notifications
        .where('idUserOwner', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .map((snapshot) => _notificationFromSnapshot(snapshot));
  }


  Future<List<Map<String, dynamic>>> getListNotificationMapString() async {

    List<Map<String, dynamic>> data = [];

    List<NotificationModel> notifications = await getListNotification();


    notifications.sort((b, a) => a.time.compareTo(b.time));

    for(var notification in notifications){

      UserInformation userOwner =
      UserProvider().getUser(notification.idUserOwner) as UserInformation ;

      UserInformation userGuest = UserProvider().getUser(notification.idUserGuest) as UserInformation;

      Recipe? recipe;
      if(notification.idRecipe != ""){
        recipe =  await RecipeProvider().getRecipe(notification.idRecipe);
      }


      //print(notification);
      Map<String, dynamic> map = {
        'notification': notification,
        'userOwner': userOwner,
        'userGuest': userGuest,
        'recipe': notification.idRecipe != "" ? recipe! : ""
      };

      data.add(map);


    }
    //print('Sang');

    return Future.value(data);
  }

  Future<void> updateNotification(NotificationModel notificationModel) {
    return notifications
        .doc(notificationModel.id)
        .update(notificationModel.toJson())
        .then((value) => print('notification updated'));
  }


  Future<void> markAllRead() async {
    print('Sang');
    final listNotification = await getListNotification();
    for(var notification in listNotification){
      notification.read = true;


      await updateNotification(notification);

    }
  }


}