import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailCntrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16),
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(
              height: 16,
            ),
            Text(
              "Forgot Password",
              style: TextStyle(fontSize: 18, color: Color(0xffffffff)),
            ),
            // SizedBox(
            //   height: 32,
            // ),
            Column(
              children: <Widget>[
                Text(
                  "Please fill in your email address",
                  style: TextStyle(fontSize: 16, color: Color(0xffffffff)),
                ),
                Container(
                  padding: EdgeInsets.all(5.0),
                  child: TextField(
                    controller: emailCntrl,
                    decoration: InputDecoration(
                      errorStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Color(0xffffffff).withOpacity(0.4),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.transparent)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.transparent)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.transparent)),
                      hintText: "E-mail",
                      hintStyle: TextStyle(
                          color: Color(0xffffffff), fontSize: 16),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 32,
            ),

            Container(
              width: MediaQuery.of(context).size.width,
              height: 32,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Color(0xffffffff),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16))),
                child: Text("Continue",
                    style: TextStyle(
                        fontSize: 16, color: Colors.blueGrey)),
                onPressed: () {
                  // userSigninBloc.add(SigninButtonPressed(
                  //     email: emailCntrl.text,
                  //     password: passCntrlr.text));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
