import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daraz_clone/Admin/adminLogin.dart';
import 'package:daraz_clone/Config/config.dart';
import 'package:daraz_clone/DialogBox/errorDialog.dart';
import 'package:daraz_clone/DialogBox/loadingDialog.dart';
import 'package:daraz_clone/Widgets/customTextField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Store/storehome.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;
    final _screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        child: Form(
          child: Column(
            children: [
              Image.asset(
                'images/login.png',
                height: 240,
                width: 240,
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Login to Your Account',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600),
                ),
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
              SizedBox(
                height: 10,
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                onPressed: () {
                  _emailController.text.trim().isNotEmpty &&
                          _passController.text.isNotEmpty
                      ? loginUser()
                      : showDialog(
                          context: context,
                          builder: (c) {
                            return ErrorAlertDialog(
                              message: 'Please write email and password',
                            );
                          });
//                  _uploadAndSaveImage();
                },
                child: Text(
                  'Login',
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
              FlatButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => AdminSignInPage()),
                  );
                },
                icon: Icon(
                  Icons.nature_people,
                  color: Colors.pink,
                ),
                label: Text(
                  'I am Admin',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future loginUser() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(
            message: 'Authenticatin , Please wait.....',
          );
        });
    FirebaseUser firebaseUser;
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth
        .signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passController.text.trim(),
    )
        .then(
      (value) {
        firebaseUser = value.user;
      },
    ).catchError((error) {
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
      readData(firebaseUser).then((value) {
        Navigator.of(context).pop();
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (ctx) => StoreHome()));
      });
    }
  }

  Future readData(FirebaseUser firebaseUser) async{
    Firestore.instance
        .collection('users')
        .document(firebaseUser.uid)
        .get()
        .then(
          (dataSnapshot) async {
            await EcommerceApp.sharedPreferences.setString("uid", dataSnapshot.data[EcommerceApp.userUID]);
            await EcommerceApp.sharedPreferences
                .setString(EcommerceApp.userEmail,dataSnapshot.data[EcommerceApp.userEmail]);
            await EcommerceApp.sharedPreferences
                .setString(EcommerceApp.userName, dataSnapshot.data[EcommerceApp.userName]);
            await EcommerceApp.sharedPreferences
                .setString(EcommerceApp.userAvatarUrl, dataSnapshot.data[EcommerceApp.userAvatarUrl]);
            List<String> cartList=dataSnapshot.data[EcommerceApp.userCartList].cast<String>();
            await EcommerceApp.sharedPreferences
                .setStringList(EcommerceApp.userCartList, cartList);
          }
        );
  }
}
