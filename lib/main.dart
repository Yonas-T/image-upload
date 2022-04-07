import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_upload_app/imageUploadScreen.dart';
import 'package:image_upload_app/loginScreen.dart';
import 'package:image_upload_app/services/firebaseAuthentication.dart';

import 'homeScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool signed = false;
  
  @override
  void initState() {
    AuthRepository().isSignedIn().then((value) {
      setState(() {
        signed = value;
      });
    print(signed);

    });

    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: signed ? HomeScreen() : LoginScreen(),
    );
  }
}
