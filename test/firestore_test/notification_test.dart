import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kcpm/models/notification_model.dart';
import 'package:kcpm/models/user.dart';
import 'package:kcpm/providers/notification_provider.dart';

void main(){
  group('Tesing Notification Provider', () {
    FakeFirebaseFirestore? fakeFirebaseFirestore;

    final NotificationModel notificationModel = NotificationModel(
        id: 'DFGNMGOPJHPRENGBD',
        idUserOwner: '67pXjcN4rVXWU0Uy9kkUSP2ZcLL2',
        idUserGuest: '9jrGsiGTolNBNtxCTamMt9atjvB2',
        type: 'NewFollower',
        title: '',
        time: Timestamp.fromDate(DateTime.now()),
        read: false,
        idRecipe: '');

    setUp(() {
      fakeFirebaseFirestore = FakeFirebaseFirestore();
    });
    
    group('Collection Operations', () {
      test('Test getListNotification', () async{
        final NotificationProvider notificationProvider = NotificationProvider(firestore: fakeFirebaseFirestore!);
        await fakeFirebaseFirestore!.collection('notifications').doc(notificationModel.id).set(notificationModel.toJson());

        List<NotificationModel> expectedListNotification = [];
        await fakeFirebaseFirestore!.collection('notifications').get().then((QuerySnapshot querySnapshot){
          querySnapshot.docs.forEach((doc){
            expectedListNotification.add(NotificationModel.fromJson(doc.data() as Map<String, dynamic>));
          });
        });

        List<NotificationModel> actualListNotification = await notificationProvider.getListNotification(notificationModel.idUserOwner);

        expect(actualListNotification, equals(expectedListNotification));
      });

      test('Test deleteNotification', ()async {
        final NotificationProvider notificationProvider = NotificationProvider(firestore: fakeFirebaseFirestore!);
        await fakeFirebaseFirestore!.collection('notifications').doc(notificationModel.id).set(notificationModel.toJson());

        await notificationProvider.deleteNotification(notificationModel.idUserOwner);

        final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =    await fakeFirebaseFirestore!.collection('notifications').doc(notificationModel.id).get();

        expect(documentSnapshot.exists, false);

      });

      // test('Test getListNotification Map String', () async{
      //   final NotificationProvider notificationProvider = NotificationProvider(firestore: fakeFirebaseFirestore!);
      //
      //   final userOwner = UserInformation(
      //       uid: '67pXjcN4rVXWU0Uy9kkUSP2ZcLL2',
      //       avatar: 'https://lh3.googleusercontent.com/a/ACg8ocKVX8dEogTYvH5L-5RcuOxShjutT8Msgcn3po37NKHw=s96-c',
      //       name: 'Thach Sang',
      //       email: 'thachsang2202@gmail.com',
      //       bio: ' Diligent in saving and loves to cook');
      //
      //   final userGuest = UserInformation(
      //       uid: '9jrGsiGTolNBNtxCTamMt9atjvB2',
      //       avatar: 'https://lh3.googleusercontent.com/a/ACg8ocKVX8dEogTYvH5L-5RcuOxShjutT8Msgcn3po37NKHw=s96-c',
      //       name: 'Le Thi Bich Loan',
      //       email: 'lebichloan@gmail.com',
      //       bio: 'Diligent in saving and loves to cook');
      //
      //   await fakeFirebaseFirestore!.collection('users').doc(userOwner.uid).set(userOwner.toJson());
      //   await fakeFirebaseFirestore!.collection('users').doc(userGuest.uid).set(userGuest.toJson());
      //   await fakeFirebaseFirestore!.collection('notifications').doc(notificationModel.id).set(notificationModel.toJson());
      //
      //   List<Map<String, dynamic>> expectList = [];
      //
      //   List<NotificationModel> notificationList = [];
      //   await fakeFirebaseFirestore!.collection('notifications').where('idUserOwner', isEqualTo: notificationModel.idUserOwner).get().then((QuerySnapshot querySnapshot) {
      //     querySnapshot.docs.forEach((doc) {
      //       notificationList.add(NotificationModel.fromJson(doc.data() as Map<String, dynamic>));
      //     });
      //   });
      //
      //   notificationList.sort((b, a) => a.time.compareTo(b.time));
      //
      //   for( var notification in notificationList){
      //     UserInformation userOwner = await fakeFirebaseFirestore!.collection('users').doc(notification.idUserOwner).get().then((DocumentSnapshot doc) => UserInformation.fromJson(doc.data() as Map<String, dynamic>));
      //     UserInformation userGuest = await fakeFirebaseFirestore!.collection('users').doc(notification.idUserGuest).get().then((DocumentSnapshot doc) => UserInformation.fromJson(doc.data() as Map<String, dynamic>));
      //
      //     Map<String, dynamic> map = {
      //       'notification': notification,
      //       'userOwner': userOwner,
      //       'userGuest': userGuest,
      //       'recipe': ""
      //     };
      //
      //     expectList.add(map);
      //   }
      //
      //   List<Map<String, dynamic>> actualList = await notificationProvider.getListNotificationMapString(notificationModel.idUserOwner);
      //
      //   expect(actualList, equals(expectList));
      //
      // });

      test('Test updateNotification', () async{
        final NotificationProvider notificationProvider = NotificationProvider(firestore: fakeFirebaseFirestore!);
        await fakeFirebaseFirestore!.collection('notifications').doc(notificationModel.id).set(notificationModel.toJson());

        final NotificationModel notificationUpdate = NotificationModel(
            id: 'DFGNMGOPJHPRENGBD',
            idUserOwner: '67pXjcN4rVXWU0Uy9kkUSP2ZcLL2',
            idUserGuest: '9jrGsiGTolNBNtxCTamMt9atjvB2',
            type: 'NewFollower',
            title: '',
            time: Timestamp.fromDate(DateTime.now()),
            read: true,
            idRecipe: '');

        await notificationProvider.updateNotification(notificationUpdate);

        NotificationModel actualNotification = await fakeFirebaseFirestore!.collection('notifications').doc(notificationModel.id).get().then((DocumentSnapshot doc) => NotificationModel.fromJson(doc.data() as Map<String, dynamic>));


        expect(actualNotification, equals(notificationUpdate));

      });

      test('Test mankAllRead', () async{
        final NotificationProvider notificationProvider = NotificationProvider(firestore: fakeFirebaseFirestore!);
        await fakeFirebaseFirestore!.collection('notifications').doc(notificationModel.id).set(notificationModel.toJson());

        await notificationProvider.markAllRead(notificationModel.idUserOwner);

        bool allRead = true;

        List<NotificationModel> listNotification = [];
        await fakeFirebaseFirestore!.collection('notifications').get().then((QuerySnapshot querySnapshot){
          querySnapshot.docs.forEach((doc){
            listNotification.add(NotificationModel.fromJson(doc.data() as Map<String, dynamic>));
          });
        });

        for(var notification in listNotification){
          if (notification.read == false) allRead = false;
        }

        expect(allRead, true);

      });

    });
    
  });
}