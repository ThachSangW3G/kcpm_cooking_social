import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kcpm/models/user.dart';
import 'package:kcpm/providers/user_provider.dart';

void main(){
  group('User test', () {
    FakeFirebaseFirestore? fakeFirebaseFirestore;

    final UserInformation userInformation = UserInformation(
        uid: '67pXjcN4rVXWU0Uy9kkUSP2ZcLL2',
        avatar: 'https://lh3.googleusercontent.com/a/ACg8ocKVX8dEogTYvH5L-5RcuOxShjutT8Msgcn3po37NKHw=s96-c',
        name: 'Thạch Sang',
        email: 'thachsang2202@gmail.com',
        bio: ' Diligent in saving and loves to cook'
    );

    setUp(() {
      fakeFirebaseFirestore = FakeFirebaseFirestore();
    });

    group('Collection Operations', () {
      test('test getUserFuture', () async{
        final UserProvider userProvider = UserProvider(firestore: fakeFirebaseFirestore!);
        await fakeFirebaseFirestore!.collection('users').doc(userInformation.uid).set(userInformation.toJson());
        final UserInformation expectedUser = await fakeFirebaseFirestore!.collection('users').doc(userInformation.uid).get().then((DocumentSnapshot doc) => UserInformation.fromJson(doc.data() as Map<String, dynamic>));


        final UserInformation actualUser = (await userProvider.getUserFuture(userInformation.uid));

        expect(actualUser, equals(expectedUser));
      });


      test('test getUserStream', () async{
        final UserProvider userProvider = UserProvider(firestore: fakeFirebaseFirestore!);
        await fakeFirebaseFirestore!.collection('users').doc(userInformation.uid).set(userInformation.toJson());

        final UserInformation expectedUser = await fakeFirebaseFirestore!.collection('users').doc(userInformation.uid).snapshots().map((docSnapshot) => UserInformation.fromJson(docSnapshot.data() as Map<String, dynamic>)).first;

        final UserInformation actualUser =  await userProvider.getUser(userInformation.uid).first;

        expect(actualUser, equals(expectedUser));
      });

      test('test updateUser', () async{
        final UserProvider userProvider = UserProvider(firestore: fakeFirebaseFirestore!);
        await fakeFirebaseFirestore!.collection('users').doc(userInformation.uid).set(userInformation.toJson());

        final UserInformation userUpdate = UserInformation(
            uid: '67pXjcN4rVXWU0Uy9kkUSP2ZcLL2',
            avatar: 'https://lh3.googleusercontent.com/a/ACg8ocKVX8dEogTYvH5L-5RcuOxShjutT8Msgcn3po37NKHw=s96-c',
            name: 'Lê Thị Bích Loan',
            email: 'lebichloanxinhdep@gmail.com',
            bio: ' Diligent in saving and loves to cook'
        );

        await userProvider.updateUser(userUpdate);

        final UserInformation actualUser = await fakeFirebaseFirestore!.collection('users').doc(userInformation.uid).get().then((DocumentSnapshot doc) => UserInformation.fromJson(doc.data() as Map<String, dynamic>));
        expect(actualUser, equals(userUpdate));
      });

    });
  });
}