import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kcpm/models/user.dart';
import 'package:kcpm/remote/user_firebase.dart';

class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel? _userFromFirebaseUser(User? user){
    return user != null ? UserModel(uid: user.uid) : null;
  }

  Stream<UserModel?> get user {
    return _auth.userChanges().map(_userFromFirebaseUser);
  }


  Future signInWithGoogle() async {
    try{
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      // obtain auth details from request
      final GoogleSignInAuthentication gAuth = await gUser!.authentication;

      // create a new credential for user
      final credential = GoogleAuthProvider.credential(
          accessToken: gAuth.accessToken, idToken: gAuth.idToken);

      // finally, lets sign in
      UserCredential userCredential =  await FirebaseAuth.instance.signInWithCredential(credential);
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

      return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
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