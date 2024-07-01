import 'package:dsplus_finance/admin/home_page.dart';
import 'package:dsplus_finance/admin/requests/cubit/requests_cubit.dart';
import 'package:dsplus_finance/presentation/home_page/bloc/home_bloc.dart';
import 'package:dsplus_finance/widgets/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/app/app_export.dart';

class LoginPageSecond extends StatefulWidget {
  @override
  _LoginPageSecondState createState() => _LoginPageSecondState();
}

class _LoginPageSecondState extends State<LoginPageSecond> {
  bool _isObscure3 = true;
  bool visible = false;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              color: AppColors.backgroundColor,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(12),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 100,
                        ),

                        Image.asset(
                          "assets/images/logo.png",
                          color: AppColors.logoColor,
                        ),
                        // const Text(
                        //   "Login",
                        //   style: TextStyle(
                        //     fontWeight: FontWeight.bold,
                        //     color: Colors.white,
                        //     fontSize: 40,
                        //   ),
                        // ),
                        const SizedBox(
                          height: 60,
                        ),
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Email',
                            enabled: true,
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 8.0, top: 8.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: new BorderRadius.circular(10),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: new BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value!.length == 0) {
                              return "Email cannot be empty";
                            }
                            if (!RegExp(
                                    "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                .hasMatch(value)) {
                              return ("Please enter a valid email");
                            } else {
                              return null;
                            }
                          },
                          onSaved: (value) {
                            emailController.text = value!;
                          },
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: passwordController,
                          obscureText: _isObscure3,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                icon: Icon(_isObscure3
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _isObscure3 = !_isObscure3;
                                  });
                                }),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Password',
                            enabled: true,
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 8.0, top: 15.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: new BorderRadius.circular(10),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: new BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            RegExp regex = new RegExp(r'^.{6,}$');
                            if (value!.isEmpty) {
                              return "Password cannot be empty";
                            }
                            if (!regex.hasMatch(value)) {
                              return ("please enter valid password min. 6 character");
                            } else {
                              return null;
                            }
                          },
                          onSaved: (value) {
                            passwordController.text = value!;
                          },
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        MaterialButton(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          elevation: 5.0,
                          height: 40,
                          onPressed: () {
                            setState(() {
                              if (_formkey.currentState!.validate()) {
                                visible = true;
                              } else {
                                visible = false;
                              }
                            });
                            signIn(
                                emailController.text, passwordController.text);
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: AppColors.logoColor,
                              fontSize: 20,
                            ),
                          ),
                          color: Colors.white,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Visibility(
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                          visible: visible,
                          child: Container(
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              //for registration add when you are an admin to register new users
                              // MaterialButton(
                              //   shape: const RoundedRectangleBorder(
                              //     borderRadius: BorderRadius.all(
                              //       Radius.circular(20.0),
                              //     ),
                              //   ),
                              //   elevation: 5.0,
                              //   height: 40,
                              //   onPressed: () {
                              //     Navigator.push(
                              //         context,
                              //         MaterialPageRoute(
                              //           builder: (context) => BlocProvider(
                              //             create: (context) => AddUserCubit(
                              //                 FirebaseAuth.instance,
                              //                 FirebaseFirestore.instance),
                              //             child: AddUsers(
                              //               addUserCubit: AddUserCubit(
                              //                   FirebaseAuth.instance,
                              //                   FirebaseFirestore.instance),
                              //             ),
                              //           ),
                              //         ));
                              //   },
                              //   color: Colors.white,
                              //   child: const Text(
                              //     "Register Now",
                              //     style: TextStyle(
                              //       fontSize: 20,
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void route() {
    User? user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (documentSnapshot.get('role') == "Admin" ||
            documentSnapshot.get('role') == "SuperAdmin") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => AdminRequestsCubit(),
                  ),
                  BlocProvider(
                    create: (context) => HomeBloc()..add(GetUserData()),
                  )
                ],
                child: AdminHomePage(),
              ),
            ),
          );
        } else if(documentSnapshot.get('role') == "User") {
          NavigatorService.pushNamedAndRemoveUntil(
            AppRoutes.homePageContainerScreen,
          );
        }
      } else {
        debugPrint('Document does not exist on the database');
      }
    });
  }

  void signIn(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

// addUserSharedPrefs({String? email, String? password}) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('email', email);
        prefs.setString('password', password);

        User? user = FirebaseAuth.instance.currentUser;
        FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            prefs.setString('role', documentSnapshot.get('role'));
            prefs.setString('userName', documentSnapshot.get('name'));
            prefs.setString('jobTitle', documentSnapshot.get('jobTitle'));
            prefs.setString('userImageUrl', documentSnapshot.get('userImageUrl'));
          }
        });
        // String semail = prefs.getString('email') ?? "";
        // debugPrint(semail);
        // }
        route();
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        if (e.code == 'user-not-found') {
          errorMessage = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Wrong password provided for that user.';
        } else {
          debugPrint(e.code);
          errorMessage = 'invalid-credentials Wrong Email or Password';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          visible = false;
        });
      }
    }
  }
}
