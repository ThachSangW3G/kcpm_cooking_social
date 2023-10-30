import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kcpm/services/auth.dart';

import '../../constants/app_colors.dart';
import '../../routes/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  bool loading = false;
  bool _obscureText = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: 400,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/background_1.jpg'),
                      fit: BoxFit.cover)),
            ),
            Container(
              margin: const EdgeInsets.only(top: 150),
              width: double.infinity,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60), topRight: Radius.circular(60)),
                  color: Colors.white),
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                  child: Column(children: [
                    const Text(
                      'Mallika',
                      style: TextStyle(
                          fontFamily: 'Recoleta',
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5),
                    ),
                    const Text(
                      'Everyone can be a chef',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'CeraPro'),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),

                    Container(
                      child: TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          labelText: 'Email',
                          focusColor: Colors.grey,
                          labelStyle: TextStyle(
                              fontSize: 18, color: Colors.grey, letterSpacing: 1.0),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.orangeCrusta),
                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Container(
                      child: TextField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        decoration:  InputDecoration(
                          suffixIcon: GestureDetector(
                              onTap: (){
                                // setState(() {
                                //   _obscureText = !_obscureText;
                                // });
                              },
                              child: Icon(!_obscureText ? Icons.remove_red_eye : Icons.visibility_off)),
                          prefixIcon: const Icon(Icons.lock),
                          labelText: 'Password',
                          focusColor: Colors.grey,
                          labelStyle: const TextStyle(
                              fontSize: 18, color: Colors.grey, letterSpacing: 1.0),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.orangeCrusta),
                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          ),
                        ),
                      ),
                    ),


                    const SizedBox(
                      height: 10.0,
                    ),
                    GestureDetector(
                      onTap: () async {
                        try{
                          AuthService(auth: _auth).signInWithEmailAndPassword(_emailController.text, _passwordController.text);
                        }catch (e) {
                          print(e.toString());
                        }

                      },
                      child: Container(
                        width: double.infinity,
                        height: 60,
                        decoration: const BoxDecoration(
                          color: AppColors.orangeCrusta,
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        ),
                        child: Center(
                            child: loading ? const CircularProgressIndicator() : const Text(
                              'Sign In',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  letterSpacing: 1.2,
                                  fontFamily: 'CeraPro'),
                            )),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    GestureDetector(
                      onTap: () async {
                        Navigator.pushNamed(context, RouteGenerator.sign_up_email);
                      },
                      child: Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                            border: Border.all(color: AppColors.orangeCrusta,)
                        ),
                        child: const Center(
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.orangeCrusta,
                                  letterSpacing: 1.2,
                                  fontFamily: 'CeraPro'),
                            )),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Divider(
                            color: AppColors.greyBombay,
                            indent: 30,
                            endIndent: 10,
                            thickness: 2,
                          ),
                        ),
                        Text(
                          'OR',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              letterSpacing: 1.3,
                              fontFamily: 'CeraPro',
                              color: AppColors.greyBombay),
                        ),
                        Expanded(
                          child: Divider(
                            color: AppColors.greyBombay,
                            indent: 10,
                            endIndent: 30,
                            thickness: 2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              try {
                                AuthService(auth: _auth).signInWithFacebook();
                              } catch (e) {
                                print(e.toString());
                                return null;
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              height: 60,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                  const BorderRadius.all(Radius.circular(15.0)),
                                  border: Border.all(
                                      color: AppColors.greyBombay, width: 1)),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    margin:
                                    const EdgeInsets.only(left: 20, right: 10),
                                    height: 30,
                                    width: 30,
                                    decoration: const BoxDecoration(
                                      // image: DecorationImage(
                                      //   image: AssetImage('assets/icons/apple_icon.png'),
                                      //   fit: BoxFit.cover,
                                      // )
                                    ),
                                    child: const Image(
                                      image: AssetImage(
                                          'assets/icons/facebook_icon.png'),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 6.0),
                                      child: const Text(
                                        'Facebook',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                            fontFamily: 'CeraPro',
                                            letterSpacing: 1.0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              try {
                                AuthService(auth: _auth).signInWithGoogle();
                              } catch (e) {
                                print(e.toString());
                                return null;
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              height: 60,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                  const BorderRadius.all(Radius.circular(15.0)),
                                  border: Border.all(
                                      color: AppColors.greyBombay, width: 1)),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    margin:
                                    const EdgeInsets.only(left: 20, right: 10),
                                    height: 40,
                                    width: 40,
                                    decoration: const BoxDecoration(
                                      // image: DecorationImage(
                                      //   image: AssetImage('assets/icons/apple_icon.png'),
                                      //   fit: BoxFit.cover,
                                      // )
                                    ),
                                    child: const Image(
                                      image: AssetImage(
                                          'assets/icons/google_icon.png'),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: const Text(
                                        'Google',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                            fontFamily: 'CeraPro',
                                            letterSpacing: 1.0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    const Text(
                      "By continuing, you agree to our",
                      style: TextStyle(
                          color: Colors.black, fontSize: 12, fontFamily: 'CeraPro'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom:
                                  BorderSide(color: Colors.black, width: 1.0))),
                          child: const Text(
                            "Terms of Service",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'CeraPro'),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          child: const Text(
                            '·',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom:
                                  BorderSide(color: Colors.black, width: 1.0))),
                          child: const Text(
                            "Privacy Policy",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'CeraPro'),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          child: const Text(
                            '·',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom:
                                  BorderSide(color: Colors.black, width: 1.0))),
                          child: const Text(
                            "Content Policy",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'CeraPro'),
                          ),
                        )
                      ],
                    )
                  ]),
                ),
              ),
            )
          ],
        ));
  }
}
