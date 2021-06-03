import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daraz_clone/Admin/uploadItems.dart';
import 'package:daraz_clone/Authentication/authenication.dart';
import 'package:daraz_clone/DialogBox/errorDialog.dart';
import 'package:daraz_clone/Widgets/customTextField.dart';
import 'package:flutter/material.dart';

class AdminSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [Colors.pink, Colors.lightGreenAccent],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          )),
        ),
        title: Text(
          'e_shop',
          style: TextStyle(fontSize: 30),
        ),
        centerTitle: true,
      ),
      body: AdminSignInScreen(),
    );
  }
}

class AdminSignInScreen extends StatefulWidget {
  @override
  _AdminSignInScreenState createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends State<AdminSignInScreen> {
  TextEditingController _adminIdController = TextEditingController();
  TextEditingController _adminPasswordController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;
    final _screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.pink, Colors.lightGreenAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Form(
              child: Column(
                children: [
                  Image.asset(
                    'images/admin.png',
                    height: 240,
                    width: 240,
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Admin',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  CustomTextField(
                    hintText: 'Id',
                    data: Icons.person,
                    isObsecure: false,
                    controller: _adminIdController,
                  ),
                  CustomTextField(
                    hintText: 'Password',
                    data: Icons.security,
                    isObsecure: true,
                    controller: _adminPasswordController,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              onPressed: () {
                _adminIdController.text.trim().isNotEmpty &&
                        _adminPasswordController.text.isNotEmpty
                    ? loginAdmin()
                    : showDialog(
                        context: context,
                        builder: (c) {
                          return ErrorAlertDialog(
                            message: 'Please write id and password',
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
                  MaterialPageRoute(builder: (ctx) => AuthenticScreen()),
                );
              },
              icon: Icon(
                Icons.nature_people,
                color: Colors.pink,
              ),
              label: Text(
                'I am not Admin',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                ),
              ),
            ),
            SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }

  loginAdmin() {
    Firestore.instance.collection('admins').getDocuments().then((snapshot) {
      snapshot.documents.forEach((result) {
        if (result.data['id'] != _adminIdController.text.trim()) {
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text('Your Id is not correct')));
        }
        else if(result.data['password']!=_adminPasswordController.text.trim()){
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text('Your Password is not correct')));
        }
        else{
          setState(() {
            _adminPasswordController.text='';
            _adminIdController.text="";
          });
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text('welcome '+result.data['name'])));
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>UploadPage()));
        }
      });
    });
  }
}
