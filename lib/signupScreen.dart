import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_upload_app/imageUploadScreen.dart';
import 'package:image_upload_app/loginScreen.dart';
import 'package:image_upload_app/services/firebaseAuthentication.dart';

import 'package:meta/meta.dart';

import 'homeScreen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _database = FirebaseDatabase.instance.ref();

  TextEditingController emailCntrl = TextEditingController();
  TextEditingController locationCntrl = TextEditingController();
  TextEditingController nameCntrl = TextEditingController();
  TextEditingController passConfirmCntrlr = TextEditingController();

  TextEditingController passCntrlr = TextEditingController();

  late String authResult;

  late String _selectedCountry;

  final List<String> _countries = ["ETB",
                      "USD",
                      "GBP",
                      "EUR",
                      "SAR",
                      "CHY",
                      "JPY",
                      "CHF",
                      "KWD",
                      "AED",
                      "TRY",];

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _selectedCountry = _countries[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 25,
              ),
              Container(padding: EdgeInsets.all(16.0), child: buildInitialUi()
                  // BlocBuilder<SigninBloc, SigninState>(
                  //   builder: (context, state) {
                  //     if (state is SigninInitial) {
                  //       return buildInitialUi();
                  //     } else if (state is SigninLoading) {
                  //       return buildLoadingUi();
                  //     } else if (state is SigninFailure) {
                  //       return buildFailureUi(state.message);
                  //     }
                  //     return Container();
                  //   },
                  // ),
                  ),
              SizedBox(
                height: 8,
              ),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      Container(
                        padding: EdgeInsets.all(5.0),
                        child: TextFormField(
                          controller: nameCntrl,
                          style: TextStyle(color: Colors.lightBlue[900]),
                          decoration: InputDecoration(
                            errorStyle: TextStyle(color: Colors.white),
                            filled: true,
                            fillColor: Colors.lightBlue[900]!.withOpacity(0.2),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            hintText: "Full name",
                            hintStyle: TextStyle(
                                color: Colors.lightBlue[900], fontSize: 16),
                          ),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(5.0),
                        child: TextFormField(
                          controller: emailCntrl,
                          style: TextStyle(color: Colors.lightBlue[900]),
                          decoration: InputDecoration(
                            errorStyle: TextStyle(color: Colors.white),
                            filled: true,
                            fillColor: Colors.lightBlue[900]!.withOpacity(0.2),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            hintText: "E-mail",
                            hintStyle: TextStyle(
                                color: Colors.lightBlue[900], fontSize: 16),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(5.0),
                        child: TextFormField(
                          controller: locationCntrl,
                          style: TextStyle(color: Colors.lightBlue[900]),
                          decoration: InputDecoration(
                            errorStyle: TextStyle(color: Colors.white),
                            filled: true,
                            fillColor: Colors.lightBlue[900]!.withOpacity(0.2),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            hintText: "Location (Country)",
                            hintStyle: TextStyle(
                                color: Colors.lightBlue[900], fontSize: 16),
                          ),
                          keyboardType: TextInputType.text,
                        ),
                      ),

                      Container(
                          child: Theme(
                        data: Theme.of(context)
                            .copyWith(accentColor: Colors.lightBlue[900]),
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                          color: Colors.lightBlue[900]!.withOpacity(0.2),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: ExpansionTile(
                              // backgroundColor: Colors.lightBlue[900].withOpacity(0.4),
                              title: Text(
                                _selectedCountry,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.lightBlue[900]),
                              ),
                              children: <Widget>[
                                ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    itemCount: _countries.length,
                                    itemBuilder: (context, i) {
                                      return Container(
                                        padding:
                                            EdgeInsets.fromLTRB(16, 8, 8, 8),
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          _countries[i],
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.lightBlue[900]),
                                        ),
                                      );
                                    })
                              ],
                            ),
                          ),
                        ),
                      )),
                                            Container(
                        padding: EdgeInsets.all(5.0),
                        child: TextFormField(
                          controller: passCntrlr,
                          validator: (val) {
                            if (val!.isEmpty) return 'Empty';
                            return null;
                          },
                          style: TextStyle(color: Colors.lightBlue[900]),
                          obscureText: true,
                          decoration: InputDecoration(
                            errorStyle: TextStyle(color: Colors.white),
                            filled: true,
                            fillColor: Colors.lightBlue[900]!.withOpacity(0.2),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            hintText: "Password",
                            hintStyle: TextStyle(
                                color: Colors.lightBlue[900], fontSize: 16),
                          ),
                          keyboardType: TextInputType.visiblePassword,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(5.0),
                        child: TextFormField(
                          controller: passConfirmCntrlr,
                          validator: (val) {
                            if (val!.isEmpty) return 'Empty';
                            if (val != passCntrlr.text)
                              return 'Password Does not Match';
                            return null;
                          },
                          style: TextStyle(color: Colors.lightBlue[900]),
                          obscureText: true,
                          decoration: InputDecoration(
                            errorStyle: TextStyle(color: Colors.white),
                            filled: true,
                            fillColor: Colors.lightBlue[900]!.withOpacity(0.2),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            hintText: "Confirm Password",
                            hintStyle: TextStyle(
                                color: Colors.lightBlue[900], fontSize: 16),
                          ),
                          keyboardType: TextInputType.visiblePassword,
                        ),
                      ),
                      Container(
                        // bottom: 0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            // Container(
                            //   width: MediaQuery.of(context).size.width,
                            //   height: 50,
                            //   child: TextButton(
                            //     child: Text("Login",
                            //         style: TextStyle(
                            //             fontSize: 16,
                            //             color: Colors.lightBlue[900])),
                            //     onPressed: () {
                            //       navigateToLoginPage(context);
                            //     },
                            //   ),
                            // ),
                            SizedBox(height: 16),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.lightBlue[900],
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(4))),
                                child: const Text("Sign In",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white)),
                                onPressed: () {
                                  AuthRepository().signUpUserWithEmailPass(
                                      emailCntrl.text, passConfirmCntrlr.text).then((value) async {
                                        if (value != null && value.email != null) {
                                          var userData = {
                                            'email': value.email,
                                            'location': locationCntrl.text,
                                            'currency': _selectedCountry,
     
                                          };
                                          var uploaduserData = _database.child('userData').push();
                                          await uploaduserData.set(userData);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomeScreen()));
                                        
                                        }
                                      });
                                },
                              ),
                            ),
                          ],
                        ),
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

  Widget buildInitialUi() {
    return  Text(
      "Sign In",
      style: TextStyle(fontSize: 18, color: Colors.lightBlue[900]),
    );
  }

  Widget buildLoadingUi() {
    return const Center(
      child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey)),
    );
  }

  void navigateToHomeScreen(BuildContext context, User user) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return HomeScreen();
    }));
  }

  Widget buildFailureUi(String message) {
    return Text(
      message,
      style: TextStyle(color: Colors.red),
    );
  }

  void navigateToLoginPage(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return LoginScreen();
    }));
  }
}
