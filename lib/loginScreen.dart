import 'package:flutter/gestures.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_upload_app/homeScreen.dart';
import 'package:image_upload_app/imageUploadScreen.dart';
import 'package:image_upload_app/signupScreen.dart';
import 'package:image_upload_app/utils/helper.dart';

import 'services/firebaseAuthentication.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailCntrlr = TextEditingController();
  TextEditingController passCntrlr = TextEditingController();
  FocusNode passfocus = FocusNode();
  bool isLoading = false;
  AuthRepository userRepository = AuthRepository();
 
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(16),
          
          child: ListView(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.fromLTRB(5, 48, 5, 5),
                child: SingleChildScrollView(
                  dragStartBehavior: DragStartBehavior.down,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      Container(
                        padding: const EdgeInsets.all(5.0),
                        alignment: Alignment.center,
                        child:  Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.lightBlue[900]),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(children: [
                          Container(
                            padding: const EdgeInsets.all(5.0),
                            child: TextFormField(
                              controller: emailCntrlr,
                              style:  TextStyle(color: Colors.lightBlue[900]),
                              decoration: InputDecoration(
                                errorStyle: const TextStyle(color: Colors.white),
                                filled: true,
                                fillColor: Colors.lightBlue[900]!.withOpacity(0.2),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide: const BorderSide(
                                        color: Colors.transparent)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide: const BorderSide(
                                        color: Colors.transparent)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide: const BorderSide(
                                        color: Colors.transparent)),
                                hintText: "E-mail",
                                hintStyle:  TextStyle(
                                    color: Colors.lightBlue[900],
                                    fontSize: 16),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (text) => validateEmail(text),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(5.0),
                            child: TextFormField(
                              controller: passCntrlr,
                              style:  TextStyle(color: Colors.lightBlue[900]),
                              obscureText: true,
                              decoration: InputDecoration(
                                errorStyle: const TextStyle(color: Colors.white),
                                filled: true,
                                fillColor:  Colors.lightBlue[900]!.withOpacity(0.2),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide: const BorderSide(
                                        color: Colors.transparent)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide: const BorderSide(
                                        color: Colors.transparent)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide: const BorderSide(
                                        color: Colors.transparent)),
                                hintText: "Password",
                                hintStyle:  TextStyle(
                                    color: Colors.lightBlue[900],
                                    fontSize: 16),
                              ),
                              keyboardType: TextInputType.visiblePassword,
                              validator: (text) => validatePassword(text),
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary:  Colors.lightBlue[900],
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4))),
                                    child: const Text("Login",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white)),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        FocusScope.of(context)
                                            .requestFocus(passfocus);
                                            AuthRepository().signInEmailAndPassword(
                                      emailCntrlr.text, passCntrlr.text).then((value) {
                                        if (value != null && value.email != null) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomeScreen()));
                                        

                                        }
                                      });
                                      }
                                    },
                                  ),
                                )
                        ]),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: TextButton(
                          child:  Text("Forgot Password?",
                              // ignore: unnecessary_const
                              style:  TextStyle(
                                  fontSize: 16,
                                  color: Colors.lightBlue[900])),
                          onPressed: () {
                            navigateToForgotPasswordScreen(context);
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: TextButton(
                          child:  Text("Don't have an account?",
                              // ignore: unnecessary_const
                              style:  TextStyle(
                                  fontSize: 16,
                                  color: Colors.lightBlue[900])),
                          onPressed: () {
                            navigateToSignUpScreen(context);
                          },
                        ),
                      ),
                     
                      const SizedBox(
                        height: 60,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFailureUi(String message) {
    print(message);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            "Failed, Retry $message",
            style:  TextStyle(color: Colors.lightBlue[900]),
          ),
        ),
      ],
    );
  }


  void navigateToSignUpScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return const SignupScreen();
    }));
  }

  void navigateToHomeScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return const HomeScreen();
    }));
  }

  void navigateToForgotPasswordScreen(BuildContext context) {
    // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
    //   return ForgotPasswordScreen();
    // }));
  }
}
