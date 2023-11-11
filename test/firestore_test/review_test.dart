import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kcpm/models/review.dart';
import 'package:kcpm/models/user.dart';
import 'package:kcpm/providers/review_provider.dart';

void main(){
  group('Testing Review Provider', () {
    FakeFirebaseFirestore? fakeFirebaseFirestore;

    final Review review = Review(
        uidUser: 'ASFDFGHGFGHGSFGG',
        description: 'Great',
        id: 'GFIGIHCGHLOIHV ',
        time: Timestamp.now(),
        idRecipe: 'DFGFHJKHGTRGTHT',
      );

    // final Map<String, dynamic> dataReview = {
    //   'uidUser': 'SZlTNA6DRHPkrj6TYy3zs6IV25q1',
    //   'time': Timestamp.now(),
    //   'key': 'GFIGIHCGHLOIHV',
    //   'keyRecipe': 'DFGFHJKHGTRGTHT',
    //   'description': 'Great'
    // };
    //
    // final UserInformation user = UserInformation(
    //     uid: 'SZlTNA6DRHPkrj6TYy3zs6IV25q1',
    //     avatar: 'https://lh3.googleusercontent.com/a/ACg8ocKVX8dEogTYvH5L-5RcuOxShjutT8Msgcn3po37NKHw=s96-c',
    //     name: 'Thach Sang',
    //     email: 'thachsang@gmail.com',
    //     bio: 'I really like cooking');

    setUp((){
      fakeFirebaseFirestore = FakeFirebaseFirestore();
    });

    group('Collection Operation', () {
      test('Test fetchReview', () async {
        final ReviewProvider reviewProvider = ReviewProvider(firestore: fakeFirebaseFirestore!);
        await fakeFirebaseFirestore!.collection('reviews').doc(review.id).set(review.toJson());

        List<Review> reviewList = [];
        await fakeFirebaseFirestore!.collection('reviews').where('idRecipe', isEqualTo: review.idRecipe).get().then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            reviewList.add(Review.fromJson(doc.data() as Map<String, dynamic>));
          });
        });

        List<Review> actualReviews =await reviewProvider.getReviewsByRecipe(review.idRecipe);

        expect(actualReviews, equals(reviewList));
      });

      test('Test getReviewsByUser', ()async {
        final ReviewProvider reviewProvider = ReviewProvider(firestore: fakeFirebaseFirestore!);
        await fakeFirebaseFirestore!.collection('reviews').doc(review.id).set(review.toJson());

        List<Review> reviewList = [];
        await fakeFirebaseFirestore!.collection('reviews').where('uidUser', isEqualTo: review.uidUser).get().then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            reviewList.add(Review.fromJson(doc.data() as Map<String, dynamic>));
          });
        });

        List<Review> actualReviews =await reviewProvider.getReviewsByUser(review.uidUser);

        expect(actualReviews, equals(reviewList));
      });

      test('Test deleteReview', ()async{
        final ReviewProvider reviewProvider = ReviewProvider(firestore: fakeFirebaseFirestore!);
        await fakeFirebaseFirestore!.collection('reviews').doc(review.id).set(review.toJson());

        await reviewProvider.deleteReview(review);

        final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =    await fakeFirebaseFirestore!.collection('reviews').doc(review.id).get();
        expect(documentSnapshot.exists, false);
      });

      test('Test addReview', ()async{
        final ReviewProvider reviewProvider = ReviewProvider(firestore: fakeFirebaseFirestore!);
        await reviewProvider.addReview(review);

        final Review expectedReivew = await fakeFirebaseFirestore!.collection('reviews').doc(review.id).get().then((DocumentSnapshot doc) => Review.fromJson(doc.data() as Map<String, dynamic>));

        expect(review, equals(expectedReivew));
      });
    });

  });
}