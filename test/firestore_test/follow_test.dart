import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kcpm/models/follow_model.dart';
import 'package:kcpm/providers/follow_provider.dart';

void main(){
  group('Test Follow', () {
    FakeFirebaseFirestore? fakeFirebaseFirestore;

    final FollowModel followModel = FollowModel(
        id: 'SDFGHJKNBFDERTYUJHGFD',
        idUserOwner: 'sdfghjmnbfdserty',
        idUserFollower: 'sdfghjdsasdfgh');

    setUp(() {
      fakeFirebaseFirestore = FakeFirebaseFirestore();
    });

    group('Collection Operations', () {
      test('Test addFollow', () async {
        final FollowProvider followProvider = FollowProvider(firestore: fakeFirebaseFirestore!);

        await followProvider.addFollow(followModel);

        final FollowModel expectedFollow = await fakeFirebaseFirestore!.collection('follows').doc(followModel.id).get().then((DocumentSnapshot doc) => FollowModel.fromJson(doc.data() as Map<String, dynamic>));

        expect(followModel, equals(expectedFollow));
      });

      test('Test followExist', () async{
        final FollowProvider followProvider = FollowProvider(firestore: fakeFirebaseFirestore!);
        await fakeFirebaseFirestore!.collection('follows').doc(followModel.id).set(followModel.toJson());

        final actualFollow = await followProvider.followExist(followModel.idUserOwner, followModel.idUserFollower);

        expect(actualFollow, equals(followModel));

      });

      test('Test deleteFollow', () async{
        final FollowProvider followProvider = FollowProvider(firestore: fakeFirebaseFirestore!);
        await fakeFirebaseFirestore!.collection('follows').doc(followModel.id).set(followModel.toJson());

        await followProvider.deleteFollow(followModel);

        final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =    await fakeFirebaseFirestore!.collection('follows').doc(followModel.id).get();

        expect(documentSnapshot.exists, false);
      });

      test('Test getFollower', () async{
        final FollowProvider followProvider = FollowProvider(firestore: fakeFirebaseFirestore!);
        await fakeFirebaseFirestore!.collection('follows').doc(followModel.id).set(followModel.toJson());

        final follower =await followProvider.getFollower(followModel.idUserOwner).first;

        expect(follower, 1);
      });

      test('Test getFollowing', () async{
        final FollowProvider followProvider = FollowProvider(firestore: fakeFirebaseFirestore!);
        await fakeFirebaseFirestore!.collection('follows').doc(followModel.id).set(followModel.toJson());

        final following = await followProvider.getFollowing(followModel.idUserFollower).first;

        expect(following, 1);
      });

    });

  });
}