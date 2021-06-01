import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daraz_clone/Config/config.dart';
import 'package:daraz_clone/DialogBox/errorDialog.dart';
import 'package:daraz_clone/DialogBox/loadingDialog.dart';
import 'package:daraz_clone/Widgets/customTextField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../Store/storehome.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  TextEditingController _cPassController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _userImageUrl = '';
  File _imageFile;

  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;
    final _screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
        child: Container(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: _selectAndPickImage,
              child: CircleAvatar(
                radius: _screenWidth * .15,
                backgroundColor: Colors.white,
                backgroundImage:
                    _imageFile == null ? null : FileImage(_imageFile),
                child: _imageFile == null
                    ? Icon(
                        Icons.camera_alt,
                        size: _screenWidth * 0.15,
                        color: Colors.grey,
                      )
                    : null,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            CustomTextField(
              hintText: 'Name',
              data: Icons.person,
              isObsecure: false,
              controller: _nameController,
            ),
            CustomTextField(
              hintText: 'Email',
              data: Icons.email,
              isObsecure: false,
              controller: _emailController,
            ),
            CustomTextField(
              hintText: 'Password',
              data: Icons.security,
              isObsecure: true,
              controller: _passController,
            ),
            CustomTextField(
              hintText: 'confirm Password',
              data: Icons.security,
              isObsecure: true,
              controller: _cPassController,
            ),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              onPressed: () {
                _uploadAndSaveImage();
              },
              child: Text(
                'Sign Up',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.pink,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 4,
              width: _screenWidth * 0.8,
              color: Colors.pink,
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    ));
  }

  Future _selectAndPickImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = image;
    });
  }

  Future<void> _uploadAndSaveImage() async {
    if (_imageFile == null) {
      displayDialog('Please Select an Image....');
    } else {
      _passController.text == _cPassController.text
          ? _nameController.text.isNotEmpty &&
                  _emailController.text.isNotEmpty &&
                  _passController.text.isNotEmpty &&
                  _cPassController.text.isNotEmpty
              ? _uploadTaskToStorage()
              : displayDialog('Fill the Form..')
          : displayDialog("Password do not match..");
    }
  }

  displayDialog(String message) {
    showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(
            message: message,
          );
        });
  }

  _uploadTaskToStorage() async {
    print('hellloooooooooooooooooooooooooooooooooooooo');
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(
            message: 'Authenticating, Please wait.....',
          );
        });

    String image_url = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(image_url);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    taskSnapshot.ref.getDownloadURL().then((value) {
      _userImageUrl = value;
      registerUser();
    });
  }

  FirebaseUser firebaseUser;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future registerUser() async {
    await firebaseAuth
        .createUserWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passController.text.trim(),
    )
        .then((value) {
      firebaseUser = value.user;
    }).catchError((error) {
      Navigator.of(context).pop();
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: error.message.toString(),
            );
          });
    });
    if (firebaseUser != null) {
      _saveUserInfoToFireStore(firebaseUser).then((value) {
        Navigator.of(context).pop();
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (ctx) => StoreHome()));
      });
    }
  }

  Future _saveUserInfoToFireStore(FirebaseUser firebaseUser) async {
    Firestore.instance.collection('users').document(firebaseUser.uid).setData({
      'uid': firebaseUser.uid,
      'name': _nameController.text.trim(),
      'email': _emailController.text.trim(),
      'url': _userImageUrl,
      EcommerceApp.userCartList:['garbageValue']
    });
    await EcommerceApp.sharedPreferences.setString("uid", firebaseUser.uid);
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userEmail, firebaseUser.email);
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userName, _nameController.text);
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userAvatarUrl, _userImageUrl);
    await EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.userCartList, ['garbageValue']);
  }
}
