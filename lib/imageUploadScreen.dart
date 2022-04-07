import 'dart:typed_data';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
import 'package:path/path.dart' as Path;
import 'package:image_picker/image_picker.dart';

class ImageUploadScreen extends StatefulWidget {
  const ImageUploadScreen({Key? key}) : super(key: key);

  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  final _database = FirebaseDatabase.instance.ref();
  TextEditingController priceCntrl = TextEditingController();
  TextEditingController amountCntrl = TextEditingController();

  List _uploadedFileURL = [];
  List<XFile>? _imageFileList = [];
  List<XFile>? listToUpload = [];
  List<Map<String, dynamic>> listImageToUpload = [];
  XFile? pickedFile;
  String _price = '';
  String _amount = '';
  String? _chosenCategory;
  String? _chosenCurrency;
  String? _chosenUnit;
  XFile? _cameraFile;
  bool keyValue = true;
  set _imageFile(XFile? value) {
    _imageFileList = value == null ? null : [value];
  }

  bool isLoading = false;
  dynamic _pickImageError;
  bool isVideo = false;

  String? _retrieveDataError;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  Future _onImageButtonPressed(ImageSource source,
      {BuildContext? context, bool isMultiImage = false}) async {
    await _displayPickImageDialog(context!, () async {
      try {
        pickedFile = await _picker.pickImage(source: source, imageQuality: 80);

        if (source == ImageSource.camera) {
          if (pickedFile!.path.isNotEmpty && _imageFileList!.length < 10) {
            setState(() {
              _imageFileList!.add(pickedFile!);
              listToUpload!.add(pickedFile!);

              // listToUpload!.add({
              //   'pickedFile': pickedFile!,
              //   'category': _chosenCategory!,
              //   'price': _price,
              // });
            });
          }
        } else {
          if (pickedFile!.path.isNotEmpty && _imageFileList!.length < 10) {
            // var i = 1;
            setState(() {
              print(pickedFile!.path);

              // i++;
              print(keyValue);
              _imageFileList!.add(pickedFile!);
              listToUpload!.add(pickedFile!);

              // listToUpload!.add({
              //   'pickedFile': pickedFile!,
              //   'category': _chosenCategory!,
              //   'price': _price,
              // });
            });
          }
        }
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
    });
    // }
  }

  Future<void> _showDialog(ImageSource imgSrc) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text(
              "Enter Price and Category",
              style: TextStyle(fontSize: 16, color: Colors.lightBlue[900]),
            ),
            content: Container(
              height: 320,
              width: MediaQuery.of(context).size.width * .85,
              child: ListView(
                children: [
                  const SizedBox(height: 8),
                  TextField(
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: false,
                    ),
                    controller: amountCntrl,
                    onChanged: (value) {
                      setState(() {
                        _amount = amountCntrl.text;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      labelStyle: TextStyle(color: Colors.lightBlue[900]),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButton<String>(
                    value: _chosenUnit,
                    items: <String>[
                      "Kg",
                      "gram",
                      "Litre",
                      "ml",
                      "Quintal",
                      "Ton",
                      "Pack",
                      "Piece",
                      "Dozzen",
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    hint: Text(
                      "Choose a unit",
                      style:
                          TextStyle(color: Colors.lightBlue[900], fontSize: 16),
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        _chosenUnit = value!;
                        print(_chosenUnit);
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  // TextField(
                  //   keyboardType: const TextInputType.numberWithOptions(
                  //     decimal: true,
                  //     signed: false,
                  //   ),
                  //   controller: priceCntrl,
                  //   onChanged: (value) {
                  //     setState(() {
                  //       _price = priceCntrl.text;
                  //     });
                  //   },
                  //   decoration: InputDecoration(
                  //     labelText: 'Price',
                  //     labelStyle: TextStyle(color: Colors.lightBlue[900]),
                  //   ),
                  // ),
                  // const SizedBox(height: 8),
                  // DropdownButton<String>(
                  //   value: _chosenCurrency,
                  //   items: <String>[
                  //     "ETB",
                  //     "USD",
                  //     "GBP",
                  //     "EUR",
                  //     "SAR",
                  //     "CHY",
                  //     "JPY",
                  //     "CHF",
                  //     "KWD",
                  //     "AED",
                  //     "TRY",
                  //   ].map<DropdownMenuItem<String>>((String value) {
                  //     return DropdownMenuItem<String>(
                  //       value: value,
                  //       child: Text(value),
                  //     );
                  //   }).toList(),
                  //   hint: Text(
                  //     "Choose a currency",
                  //     style:
                  //         TextStyle(color: Colors.lightBlue[900], fontSize: 16),
                  //   ),
                  //   onChanged: (String? value) {
                  //     setState(() {
                  //       _chosenCurrency = value!;
                  //       print(_chosenCurrency);
                  //     });
                  //   },
                  // ),
                  const SizedBox(height: 16),
                  DropdownButton<String>(
                    value: _chosenCategory,
                    items: <String>[
                      "Jar water",
                      "bottled water",
                      "Pack of water",
                      "Cartoon Milk",
                      "Milk",
                      "Packed Lentils",
                      "Unpacked Lentils",
                      "Packed Sugar",
                      "Unpacked Sugar",
                      "Liquid Soap",
                      "Soap",
                      "Pack of soap",
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    hint: Text(
                      "Please choose a category",
                      style:
                          TextStyle(color: Colors.lightBlue[900], fontSize: 16),
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        _chosenCategory = value!;
                        print(_chosenCategory);
                      });
                    },
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              MaterialButton(
                child: const Text(
                  "No",
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  Navigator.of(context).pop();
                },
              ),
              MaterialButton(
                child: Text(
                  "Yes",
                  style: TextStyle(color: Colors.lightBlue[900]),
                ),
                onPressed: () async {
                  print(listToUpload.toString());
                  listImageToUpload.add({
                    'pickedFile': listToUpload!,
                    'category': _chosenCategory!,
                    'currency': _chosenCurrency,
                    'amount': _amount,
                    'price': _price,
                  });
                  FocusManager.instance.primaryFocus?.unfocus();
                    Navigator.of(context).pop();
                    if (listToUpload!.isEmpty && imgSrc == ImageSource.camera) {
                      _onImageButtonPressed(
                    ImageSource.camera,
                    context: context,
                    isMultiImage: true,
                  );
                    } else if (listToUpload!.isEmpty && imgSrc == ImageSource.gallery) {
                      _onImageButtonPressed(
                    ImageSource.gallery,
                    context: context,
                    isMultiImage: true,
                  );
                    }
                  
                },
              ),
            ],
          );
        });
      },
    );
  }

  Widget _previewImages(bool edit) {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_cameraFile != null || _imageFileList != null) {
      return ListView(
        scrollDirection: Axis.vertical,
        children: [
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              '    Upload Photos',
              style: TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 4),
          _imageFileList!.isNotEmpty
              ? GridView.builder(
                  scrollDirection: Axis.vertical,
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemCount: _imageFileList!.length,
                  itemBuilder: (BuildContext context, int index) {
                    // String key = _imageFileMap.keys.elementAt(index);
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.file(
                        File(_imageFileList![index].path),
                        fit: BoxFit.cover,
                      ),
                    );
                  })
              : GridView.builder(
                  scrollDirection: Axis.vertical,
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8),
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      height: MediaQuery.of(context).size.height * 0.3,
                      color: Colors.grey[300],
                    );
                  }),
        ],
      );
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return ListView(
        scrollDirection: Axis.vertical,
        children: [
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              '    Upload Photos',
              style: TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(height: 4),
          GridView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              scrollDirection: Axis.vertical,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8),
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: MediaQuery.of(context).size.height * 0.3,
                  color: Colors.grey[300],
                );
              }),
        ],
      );
    }
  }

  Widget _handlePreview() {
    // if (isVideo) {
    //   return _previewVideo();
    // } else {
    return _previewImages(false);
    // }
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      if (response.type == RetrieveType.video) {
        isVideo = true;
        // await _playVideo(response.file);
      } else {
        isVideo = false;
        setState(() {
          _imageFile = response.file;
          _imageFileList = response.files;
        });
      }
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Future<void> _displayPickImageDialog(
      BuildContext context, OnPickImageCallback onPick) async {
    return onPick();
  }

  var _progress = 0.0;
  // List<XFile> imageSelected = listImageToUpload['pickedFile'];
  // Future<List<String>> uploadFiles() async {
  //   var imageUrls =
  //       await Future.wait(listToUpload!.map((_image) => uploadImage(_image)));
  //   print(imageUrls);
  //   return imageUrls;
  // }

  // Future<String> uploadImage(XFile _image) async {
  //   var storageInstance = firebase_storage.FirebaseStorage.instance.ref();
  //   firebase_storage.Reference storageReference = storageInstance
  //       .child('uploads/${Path.basename(_image.path)}');
  //   firebase_storage.UploadTask uploadTask =
  //       storageReference.putFile(File(_image.path));

  //   return await storageReference.getDownloadURL();
  // }

  Future<void> uploadFile() async {
    setState(() {
      isLoading = true;
    });
    // uploadFiles().then((value) {
    //   print(value);

    //   var imageData = {
    //     'category': _chosenCategory,
    //     'price': _price,
    //     'urlList': value,
    //   };
    //   var uploadImageData = _database.child('images').push();
    //   uploadImageData.set(imageData);
    //   setState(() {
    //     isLoading = false;
    //   });
    //   print(value);
    // });

    for (XFile img in listToUpload!) {
      firebase_storage.Reference storageReference = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('uploads/${Path.basename(img.path)}');
      print(img.path);
      firebase_storage.UploadTask uploadTask =
          storageReference.putFile(File(img.path));
      await uploadTask.then((value) async {
        await storageReference.getDownloadURL().then((value) {
          setState(() {
            _uploadedFileURL.add(value);
          });
          print(value);
          // imgRef.add({'url': value});
          // i++;
          // var imageData = {
          //   'category': _chosenCategory,
          //   'price': _price,
          //   'urlList': value,
          // };
          // var uploadImageData = _database.child('images').push();
          // uploadImageData.set(imageData);
          // setState(() {
          //   isLoading = false;
          // });
        }).onError((error, stackTrace) {
          print(error);
        });
        // print(_uploadedFileURL);
      });

      print(_uploadedFileURL);
    }
    var imageData = {
      'category': _chosenCategory,
      'price': _price,
      'amount': _amount,
      'currency': _chosenCurrency,
      'unitOfMeasurement': _chosenUnit,
      'urlList': _uploadedFileURL,
    };
    var uploadImageData = _database.child('images').push();
    uploadImageData.set(imageData);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(listToUpload.toString());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[900],
        title: Text('${listToUpload!.length} / 10 Photos'),
        actions: [
          listToUpload!.length == 10
              ? InkWell(
                  onTap: () {
                    uploadFile().then((value) {
                      listToUpload!.clear();
                      _imageFileList!.clear();
                      _uploadedFileURL.clear();
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
                        Icons.upload,
                        color: Colors.lightBlue[900],
                        size: 32,
                      )),
                )
              : Container(
                  height: 40,
                  width: 40,
                  margin: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Icon(
                    Icons.upload,
                    color: Colors.grey[400],
                    size: 32,
                  ))
        ],
      ),
      body: Column(
        children: [
          isLoading
              ? Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * .38),
                      CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation(Colors.lightBlue[900]),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '${_uploadedFileURL.length} photos uploaded',
                        style: const TextStyle(fontSize: 16),
                      )
                    ],
                  ),
                )
              : Expanded(
                  // height: MediaQuery.of(context).size.height * 0.7,
                  child: defaultTargetPlatform == TargetPlatform.android
                      ? FutureBuilder<void>(
                          future: retrieveLostData(),
                          builder: (BuildContext context,
                              AsyncSnapshot<void> snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.none:
                              case ConnectionState.waiting:
                                return const Text(
                                  'You have not yet picked an image.',
                                  textAlign: TextAlign.center,
                                );
                              case ConnectionState.done:
                                return _handlePreview();
                              default:
                                if (snapshot.hasError) {
                                  return Text(
                                    'Pick image/video error: ${snapshot.error}}',
                                    textAlign: TextAlign.center,
                                  );
                                } else {
                                  return const Text(
                                    'You have not yet picked an image.',
                                    textAlign: TextAlign.center,
                                  );
                                }
                            }
                          },
                        )
                      : _handlePreview(),
                ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // SizedBox(width: 2),
              // Semantics(
              //   label: 'image_picker_._from_gallery',
              //   child: FloatingActionButton(
              //     onPressed: () {
              //       UploadImageApiProvider().uploadFile(_imageFileList, 'PROFILE');
              //     },
              //     heroTag: 'image0',
              //     tooltip: 'Pick Image from gallery',
              //     child: const Icon(Icons.photo),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0, left: 32),
                child: FloatingActionButton(
                  backgroundColor: Colors.lightBlue[900],
                  onPressed: () {
                    isVideo = false;
                    // _imageFileList!.length < 10
                    //     ? _onImageButtonPressed(
                    //         ImageSource.gallery,
                    //         context: context,
                    //         isMultiImage: true,
                    //       ).then((value) {
                    //         if (listToUpload!.isEmpty) {
                    //           _showDialog();
                    //         }
                    //       })
                    //     : null;
                    _imageFileList!.length < 10
                        ? listToUpload!.isEmpty
                            ? _showDialog(ImageSource.gallery)
                            : _onImageButtonPressed(
                                ImageSource.gallery,
                                context: context,
                                isMultiImage: true,
                              )
                        : null;
                  },
                  heroTag: 'image1',
                  tooltip: 'Pick Multiple Image from gallery',
                  child: const Icon(
                    Icons.folder,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: FloatingActionButton(
                  backgroundColor: Colors.lightBlue[900],
                  onPressed: () {
                    isVideo = false;
                    _imageFileList!.length < 10
                        ? listToUpload!.isEmpty
                            ? _showDialog(ImageSource.camera)
                            : _onImageButtonPressed(
                                ImageSource.camera,
                                context: context,
                                isMultiImage: true,
                              )
                        : null;
                    // ? _onImageButtonPressed(ImageSource.camera,
                    //         context: context)
                    //     .then((value) {
                    //     if (listToUpload!.isEmpty) {
                    //       _showDialog();
                    //     }
                    //   })
                    // : null;
                  },
                  heroTag: 'image2',
                  tooltip: 'Take a Photo',
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

typedef void OnPickImageCallback();
