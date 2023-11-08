import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kcpm/models/like_review.dart';
import 'package:kcpm/providers/like_review_provider.dart';

void main(){
  group("Testing LikeReviewProvider", () {
    FakeFirebaseFirestore? fakeFirebaseFirestore;

    final LikeReview likeReview = LikeReview(
        id: 'SDFGHKJHREHFGBSFR',
        idUser: 'SDGHMGHFHDHJTJGH',
        idReview: 'SDTYHFGDHYTH',
        time: Timestamp.fromDate(DateTime.now()));

    setUp((){
      fakeFirebaseFirestore = FakeFirebaseFirestore();
    });

    group('Collection Operations', () {
      test('Test addLikeReview', ()async {
        final LikeReviewProvider likeReviewProvider = LikeReviewProvider(firestore: fakeFirebaseFirestore!);
        await likeReviewProvider.addLikeReview(likeReview);

        final LikeReview expectedLikeReview = await fakeFirebaseFirestore!.collection('likeReviews').doc(likeReview.id).get().then((DocumentSnapshot doc) => LikeReview.fromJson(doc.data() as Map<String, dynamic>));

        expect(likeReview, equals(expectedLikeReview));

      });
      
      test('Test likeExist', () async{
        final LikeReviewProvider likeReviewProvider = LikeReviewProvider(firestore: fakeFirebaseFirestore!);
        await fakeFirebaseFirestore!.collection('likeReviews').doc(likeReview.id).set(likeReview.toJson());

        final expectedLike = await likeReviewProvider.likeExist(likeReview.idReview, likeReview.idUser);

        expect(likeReview, equals(expectedLike));
      });

      test('Test deleteLike', ()async{
        final LikeReviewProvider likeReviewProvider = LikeReviewProvider(firestore: fakeFirebaseFirestore!);
        await fakeFirebaseFirestore!.collection('likeReviews').doc(likeReview.id).set(likeReview.toJson());

        await likeReviewProvider.deleteLike(likeReview);

        final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =    await fakeFirebaseFirestore!.collection('likeReviews').doc(likeReview.id).get();

        expect(documentSnapshot.exists, false);
      });
    });
  });
}