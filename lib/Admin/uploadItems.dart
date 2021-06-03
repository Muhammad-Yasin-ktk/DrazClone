import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daraz_clone/Admin/adminShiftOrders.dart';
import 'package:daraz_clone/Authentication/authenication.dart';
import 'package:daraz_clone/Config/config.dart';
import 'package:daraz_clone/Widgets/loadingWidget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage>
    with AutomaticKeepAliveClientMixin<UploadPage> {
  bool get wantKeepAlive => true;
  File _imageFile;
  TextEditingController _titleControllr = TextEditingController();
  TextEditingController _discriptioncontroller = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _shortInfoConroller = TextEditingController();
  bool uploading = false;

  @override
  Widget build(BuildContext context) {
    return _imageFile == null
        ? displayAdminHomeScreen()
        : displayAdminUploadScreen();
  }

  displayAdminUploadScreen() {
    return Scaffold(
      appBar: AppBar(
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
          'New Product',
          style: TextStyle(fontSize: 30),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
        actions: [
          FlatButton(
            onPressed: uploadAndSaveItem,
            child: Text(
              'Add',
              style: TextStyle(
                  color: Colors.pink,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          uploading ? linearProgress() : Text(''),
          Container(
            height: 200,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: FileImage(_imageFile), fit: BoxFit.cover)),
          ),
          Padding(padding: EdgeInsets.only(top: 10)),
          ListTile(
            leading: Icon(
              Icons.perm_device_information,
              color: Colors.pink,
            ),
            title: Container(
              width: 250,
              child: TextField(
                controller: _shortInfoConroller,
                style: TextStyle(color: Colors.deepPurple),
                decoration: InputDecoration(
                    hintText: 'short Info',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.deepPurple)),
              ),
            ),
          ),
          Divider(
            height: 5,
          ),
          ListTile(
            leading: Icon(
              Icons.perm_device_information,
              color: Colors.pink,
            ),
            title: Container(
              width: 250,
              child: TextField(
                controller: _titleControllr,
                style: TextStyle(color: Colors.deepPurple),
                decoration: InputDecoration(
                    hintText: 'Title',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.deepPurple)),
              ),
            ),
          ),
          Divider(
            height: 5,
          ),
          ListTile(
            leading: Icon(
              Icons.perm_device_information,
              color: Colors.pink,
            ),
            title: Container(
              width: 250,
              child: TextField(
                controller: _discriptioncontroller,
                style: TextStyle(color: Colors.deepPurple),
                decoration: InputDecoration(
                    hintText: 'Description',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.deepPurple)),
              ),
            ),
          ),
          Divider(
            height: 5,
          ),
          ListTile(
            leading: Icon(
              Icons.perm_device_information,
              color: Colors.pink,
            ),
            title: Container(
              width: 250,
              child: TextField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.deepPurple),
                decoration: InputDecoration(
                    hintText: 'Price',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.deepPurple)),
              ),
            ),
          ),
          Divider(
            height: 5,
          ),
        ],
      ),
    );
  }

  clearForm() {
    setState(() {
      _imageFile = null;
      _titleControllr.clear();
      _discriptioncontroller.clear();
      _priceController.clear();
      _shortInfoConroller.clear();
    });
  }

  uploadAndSaveItem() async {
    setState(() {
      uploading=true;
    });
    String _downloadUrl = await uploadImage(_imageFile);
    _saveItemInfo(_downloadUrl);
  }

  var productId = DateTime.now().millisecondsSinceEpoch.toString();

  Future<String> uploadImage(File mFile) async {
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('items');
    StorageUploadTask uploadTask =
        firebaseStorageRef.child('product_$productId.jpg').putFile(mFile);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  _saveItemInfo(String url) {
    final itemRef = Firestore.instance.collection('items');
    itemRef.document(productId).setData({
      'title': _titleControllr.text.trim(),
      'shortInfo': _shortInfoConroller.text.trim(),
      'publishedDate': DateTime.now(),
      'thumbnailUrl': url,
      'longDescription': _discriptioncontroller.text.trim(),
      'status': 'Available',
      'price': _priceController.text.trim()
    });
    setState(() {
      uploading=false;
      _imageFile=null;
      _priceController.clear();
      _titleControllr.clear();
      _discriptioncontroller.clear();
      _shortInfoConroller.clear();
    });
  }

  displayAdminHomeScreen() {
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
        leading: IconButton(
          icon: Icon(
            Icons.border_color,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => AdminShiftOrders()));
          },
        ),
        actions: [
          FlatButton(
            onPressed: () {
//              EcommerceApp.auth.signOut();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => AuthenticScreen()));
            },
            child: Text(
              'Logout',
              style: TextStyle(
                color: Colors.pink,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.pink, Colors.lightGreenAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shop_two,
                size: 200,
                color: Colors.white,
              ),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                color: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                onPressed: () => takeImage(context),
                child: Text(
                  'Add New Items',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  takeImage(BuildContext mContext) {
    return showDialog(
        context: mContext,
        builder: (c) {
          return SimpleDialog(
            title: Text(
              'Item Image',
            ),
            children: [
              SimpleDialogOption(
                child: Text('Take Image from Gellery'),
                onPressed: () {
                  _selectImageFromGellery();
                  Navigator.of(context).pop();
                },
              ),
              SimpleDialogOption(
                child: Text('Take Image from Camera'),
                onPressed: () {
                  _selectFromCamera();
                  Navigator.of(context).pop();
                },
              ),
              SimpleDialogOption(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Future _selectFromCamera() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 650, maxWidth: 500);

    setState(() {
      _imageFile = image;
    });
  }

  Future _selectImageFromGellery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = image;
    });
  }
}
