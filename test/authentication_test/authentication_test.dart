import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics_platform_interface/firebase_analytics_platform_interface.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kcpm/models/user.dart';
import 'package:kcpm/remote/user_firebase.dart';
import 'package:kcpm/services/auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:mocktail/mocktail.dart';

class MockGoogleSignIn extends Mock implements GoogleSignIn {}
class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}
class MockGoogleSignInAuthentication extends Mock implements GoogleSignInAuthentication {}
class MockUserCredential extends Mock implements UserCredential {}
class MockUser extends Mock implements User {}
class MockUserInformation extends Mock implements UserInformation {}
class MockAuthCredential extends Mock implements AuthCredential{}
class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockGoogleAuthProvider extends Mock implements GoogleAuthProvider{}

typedef Callback = void Function(MethodCall call);

final List<MethodCall> methodCallLog = <MethodCall>[];

void setupFirebaseAnalyticsMocks([Callback? customHandlers]) {
  TestWidgetsFlutterBinding.ensureInitialized();

  setupFirebaseCoreMocks();

  MethodChannelFirebaseAnalytics.channel
      .setMockMethodCallHandler((MethodCall methodCall) async {
    methodCallLog.add(methodCall);
    switch (methodCall.method) {
      case 'Analytics#getAppInstanceId':
        return 'ABCD1234';

      default:
        return false;
    }
  });
}

void main(){

  setupFirebaseAnalyticsMocks();

  FirebaseAnalytics? analytics;
  late AuthService authService;
  late MockFirebaseAuth firebaseAuth;

  const email = 'test@test.com';
  const password = 'password';


  group('$FirebaseAnalytics', ()
    {
      setUpAll(() async {
        await Firebase.initializeApp();
        analytics = FirebaseAnalytics.instance;

        firebaseAuth = MockFirebaseAuth();
        authService = AuthService(auth: firebaseAuth);
      });

      setUp(() async {
        methodCallLog.clear();
      });

      tearDown(methodCallLog.clear);

      test('sign in with google completes', () async {

        expect(authService.signInWithGoogle(), completes);
      });


      test('sign in with google error', () async {

        when(
              () => firebaseAuth.signInWithProvider(GoogleAuthProvider()),
        ).thenThrow(Exception('oops'));

        expect(authService.signInWithGoogle(), completes);
      });


      test('sign in with facebook completes', () async {
        expect(authService.signInWithFacebook(), completes);
      });

      test('sign in with google error', () async {

        when(
              () => firebaseAuth.signInWithProvider(FacebookAuthProvider()),
        ).thenThrow(Exception('oops'));

        expect(authService.signInWithFacebook(), completes);
      });

      test('sign in with email completes', () async {
        expect(authService.signInWithEmailAndPassword(email, password), completes);
      });

      test('sign in with email error', () async {

        when(
              () => firebaseAuth.signInWithEmailAndPassword(
            email: email,
            password: password,
          ),
        ).thenThrow(Exception('oops'));

        expect(authService.signInWithEmailAndPassword(email, password), completes);
      });
    });
}