import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kcpm/providers/user_provider.dart';
import 'package:mockito/mockito.dart';

class MockFirestore extends Mock implements FirebaseFirestore {}


class MockUserProvider extends Mock implements UserProvider{}

void main(){
  late MockFirestore instance;
  late MockUserProvider mockUserProvider;

  setUp(() {
    instance = MockFirestore();
    mockUserProvider = MockUserProvider();
  });
  test('should return data when the call to remote source is successful.', () async {
    when()

  });

}