import 'package:daraz_clone/Authentication/authenication.dart';
import 'package:daraz_clone/Config/config.dart';
import 'package:daraz_clone/Orders/myOrders.dart';
import 'package:daraz_clone/Store/Search.dart';
import 'package:daraz_clone/Store/cart.dart';
import 'package:daraz_clone/Store/storehome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(top: 25, bottom: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.pink, Colors.lightGreenAccent],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
            child: Column(
              children: [
                Material(
                  borderRadius: BorderRadius.all(Radius.circular(90)),
                  elevation: 8,
                  child: Container(
                    height: 180,
                    width: 180,
                    child: CircleAvatar(
                      backgroundImage:
                          NetworkImage(EcommerceApp.sharedPreferences.getString(
                        EcommerceApp.userAvatarUrl,
                      )),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  EcommerceApp.sharedPreferences.getString(
                    EcommerceApp.userName,
                  ),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontFamily: 'Signatra'),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 3,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.pink, Colors.lightGreenAccent],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    'Home',
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_)=>StoreHome(),
                      ),
                    );
                  },
                ),
                Divider(height: 5,thickness: 3,color: Colors.white,),
                ListTile(
                  title: Text(
                    'My Orders',
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: Icon(
                    Icons.book_online,
                    color: Colors.white,
                  ),
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_)=>MyOrders(),
                      ),
                    );
                  },
                ),
                Divider(height: 5,thickness: 3,color: Colors.white,),
                ListTile(
                  title: Text(
                    'My cart',
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_)=>CartPage(),
                      ),
                    );
                  },
                ),
                Divider(height: 5,thickness: 3,color: Colors.white,),
                ListTile(
                  title: Text(
                    'Search',
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_)=>SearchProduct(),
                      ),
                    );
                  },
                ),
                Divider(height: 5,thickness: 3,color: Colors.white,),
                ListTile(
                  title: Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                  onTap: () {
                 FirebaseAuth.instance.signOut().then((value) {
                   Navigator.of(context).pushReplacement(
                     MaterialPageRoute(
                       builder: (_)=>AuthenticScreen(),
                     ),
                   );
                 });
                  },
                ),
                Divider(height: 5,thickness: 3,color: Colors.white,),
                Container(height: 150,)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
