
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kcpm/providers/notification_provider.dart';

import '../../constants/app_colors.dart';
import '../../models/notification_model.dart';
import '../../models/recipe.dart';
import '../../providers/recipe_provider.dart';
import '../../routes/app_routes.dart';
import '../../widgets/line_row.dart';
import '../../widgets/notification_item.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    //final NotificationProvider notificationProvider = Provider.of<NotificationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Notifications',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              fontFamily: 'Recoleta'),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_outlined,
              color: Colors.black,
              size: 20,
            )),
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 15),
            child: GestureDetector(
              onTap: () async {
                await NotificationProvider(firestore: FirebaseFirestore.instance).deleteNotification(FirebaseAuth.instance.currentUser!.uid);

              },
              child: const Text(
                'Clear',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: AppColors.orangeCrusta,
                    fontSize: 18,
                    fontFamily: 'CeraPro'),
              ),
            ),
          )
        ],
        bottom: const PreferredSize(
            preferredSize: Size.fromHeight(16.0), child: LineRow()),
      ),
      body: StreamBuilder<List<NotificationModel>>(
          stream: NotificationProvider(firestore: FirebaseFirestore.instance).getNotificationStream(),
          builder: (context, snapshot){

            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }else {
              final notifications = snapshot.data;

              if (notifications!.isEmpty){
                return const Center(
                  child: Text(
                    'There are no notification!',
                    style: TextStyle(
                      fontFamily: 'CeraPro',
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                );
              }

              return ListView.builder(
                  itemCount: notifications!.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final dataNotification = notifications[index];
                   // final notificationUpdate = dataNotification['notification'] as NotificationModel;
                    return GestureDetector(
                      onTap: () async {

                        dataNotification.read = true;

                        NotificationProvider(firestore: FirebaseFirestore.instance).updateNotification(dataNotification);

                        if(dataNotification.type == 'liked'){
                          Navigator.of(context).pushNamed(
                              RouteGenerator.recipedetailScreen,
                              arguments: dataNotification.idRecipe);
                        }else if(dataNotification.type == 'newFollower') {
                          Navigator.of(context).pushNamed(
                              RouteGenerator.accountpersonScreen,
                              arguments: dataNotification.idUserGuest);
                        }
                        else if(dataNotification.type == 'newReview'){
                          final recipe = await RecipeProvider(firestore: FirebaseFirestore.instance).getRecipe(dataNotification.idRecipe);
                          Navigator.of(context).pushNamed(
                              RouteGenerator.reviewScreen,
                              arguments: recipe);
                        }

                      },
                      child: NotificationItem(
                        notification: dataNotification,
                        userGuest: dataNotification.idUserGuest,
                        userOwner: dataNotification.idUserOwner,
                        idRecipe: dataNotification.idRecipe,
                      ),
                    );

                  }

              );
            }
            // print(notificationProvider.notifications);


          }
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: 200,
        height: 40,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.appYellow),
          onPressed: () {
            NotificationProvider(firestore: FirebaseFirestore.instance).markAllRead(FirebaseAuth.instance.currentUser!.uid);
            print('Sang');
          },
          child: const Center(
            child: Text(
              'Mark all as Read',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
