import 'package:flutter/material.dart';
import 'package:image_upload_app/loginScreen.dart';
import 'package:image_upload_app/priceUploadScreen.dart';
import 'package:image_upload_app/services/firebaseAuthentication.dart';

import 'imageUploadScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.lightBlue[900],
        actions: [
          InkWell(
                  onTap: () {
                    AuthRepository().signOut().then((value) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    });
                    
                  },
                  child: Container(
                      height: 40,
                      width: 40,
                      margin: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Icon(
                        Icons.logout,
                        color: Colors.lightBlue[900],
                        size: 32,
                      )),
                )
        ],
      ),
      body: Center(
        child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0, left: 32),
                  child: FloatingActionButton(
                    backgroundColor: Colors.lightBlue[900],
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                        return ImageUploadScreen();
                      }));
                    },
                    heroTag: 'image',
                    tooltip: 'Image with Info',
                    child: const Icon(
                      Icons.image,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: FloatingActionButton(
                    backgroundColor: Colors.lightBlue[900],
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                        return PriceUploadScreen();
                      }));
                    },
                    heroTag: 'price',
                    tooltip: 'Only Price',
                    child: const Icon(
                      Icons.price_check_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
    
        
      ),
    );
  }
}