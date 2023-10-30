import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kcpm/models/user.dart';
import 'package:kcpm/remote/user_firebase.dart';

abstract class FirebaseAuthClientException implements Exception {
  /// {@macro firebase_auth_client_exception}
  const FirebaseAuthClientException(this.error);

  /// The error which was caught.
  final Object error;
}

/// {@template firebase_sign_in_failure}
/// Thrown during the sign in process if a failure occurs.
/// {@endtemplate}
class FirebaseSignInFailure extends FirebaseAuthClientException {
  /// {@macro firebase_sign_in_failure}
  const FirebaseSignInFailure(super.error);

  /// Construct error messages from the given code.
  factory FirebaseSignInFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const FirebaseSignInFailure(
          'Email address is invalid.',
        );
      case 'user-disabled':
        return const FirebaseSignInFailure(
          'Your account is disabled.',
        );
      case 'user-not-found':
        return const FirebaseSignInFailure(
          'Unable to find your account.',
        );
      case 'wrong-password':
        return const FirebaseSignInFailure(
          'You have entered the wrong password.',
        );
      default:
        return const FirebaseSignInFailure(
          'An unknown error occurred.',
        );
    }
  }

  @override
  String toString() => error.toString();
}

/// {@template firebase_sign_out_failure}
/// Thrown during the sign out process if a failure occurs.
/// {@endtemplate}
class FirebaseSignOutFailure extends FirebaseAuthClientException {
  /// {@macro firebase_sign_out_failure}
  const FirebaseSignOutFailure(super.error);
}

class AuthService{
  final FirebaseAuth _auth;


  const AuthService({
    required FirebaseAuth auth,

  })  : _auth = auth;


  UserModel? _userFromFirebaseUser(User? user){
    return user != null ? UserModel(uid: user.uid) : null;
  }

  Stream<UserModel?> get user {
    return _auth.userChanges().map(_userFromFirebaseUser);
  }


  Future<bool> signInWithGoogle() async {

    try{
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      // obtain auth details from request
      final GoogleSignInAuthentication gAuth = await gUser!.authentication;

      // create a new credential for user
      final credential = GoogleAuthProvider.credential(
          accessToken: gAuth.accessToken, idToken: gAuth.idToken);

      // finally, lets sign in
      UserCredential userCredential =  await _auth.signInWithCredential(credential);
      User user = userCredential.user!;


      if (!await UserFirebaseService().userExists(user.uid)){
        final UserInformation userInformation = UserInformation(
          uid: user.uid,
          avatar: userCredential.additionalUserInfo!.profile!['picture'],
          email: userCredential.additionalUserInfo!.profile!['email'],
          name: user.displayName!,
          bio: ""
        );

        await UserFirebaseService().setDataUse(userInformation);
      }

      _userFromFirebaseUser(user);
      return true;
    }catch(e){
      print(e.toString());
      return false;
    }

  }

  Future signInWithFacebook() async {
    try{
      final LoginResult loginResult = await FacebookAuth.instance
          .login(permissions: ['email', 'public_profile']);

      // Create a credential from the access token
      final OAuthCredential facebookAuthCredential =
      FacebookAuthProvider.credential(loginResult.accessToken!.token);

      //var userData = FacebookAuth.instance.getUserData();

      // Once signed in, return the UserCredential
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);

      User user = userCredential.user!;

      if (!await UserFirebaseService().userExists(user.uid)){
        final UserInformation userInformation = UserInformation(
            uid: user.uid,
            avatar: userCredential.additionalUserInfo!.profile!['picture']['data']['url'],
            email: userCredential.additionalUserInfo!.profile!['email'],
            name: user.displayName!,
            bio: ""
        );

        await UserFirebaseService().setDataUse(userInformation);
      }

      return _userFromFirebaseUser(user);
    }catch (e){
      print(e.toString());
      return null;
    }
  }

  Future createWithEmailAndPassword(String email, String password, String name) async {
    try{
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user!;

      if (!await UserFirebaseService().userExists(user.uid)){
        final UserInformation userInformation = UserInformation(
            uid: user.uid,
            avatar: 'https://img.freepik.com/premium-vector/vector-illustration-chef-avatar-working-restaurant-head-chef-avatar-social-networks-rookie-work-restaurant-tastes-differ-food-gods_469123-403.jpg',
            email: email,
            name: name,
            bio: ""
        );

        await UserFirebaseService().setDataUse(userInformation);
      }

      return _userFromFirebaseUser(user);
    }catch (e){
      print(e.toString());
      return null;
    }
  }


  Future signInWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user!;

      return _userFromFirebaseUser(user);
    }catch (e){
      print(e.toString());
      return null;
    }
  }


  Future signOut() async{
    try{
      return await _auth.signOut();
    } catch(e){
      print(e.toString());
      return null;
    }
  }



}