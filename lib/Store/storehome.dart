import 'package:daraz_clone/Counters/cartitemcounter.dart';
import 'package:daraz_clone/Store/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Widgets/loadingWidget.dart';
import '../Widgets/myDrawer.dart';
import '../Widgets/searchBox.dart';
import '../Models/item.dart';

double width;

class StoreHome extends StatefulWidget {
  @override
  _StoreHomeState createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
//          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.pink, Colors.lightGreenAccent],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
          ),
          title: Text(
            'e_shop',
            style: TextStyle(fontSize: 30),
          ),
          centerTitle: true,
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.shopping_cart,
                    color: Colors.pink,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (ctx) => CartPage(),
                    ));
                  },
                ),
                Positioned(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.brightness_1,
                        color: Colors.green,
                        size: 20,
                      ),
                      Positioned(
//                        top: 3,
//                        bottom: 4,
//                        child: Consumer<CartItemCounter>(
//                          builder: (context,counter,_){
//                            return Text(
//                              counter.count.toString(),
//                            style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),
//                            );
//                          },
//                        ),
                        child: Text('5'),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
        drawer: MyDrawer(),
      ),
    );
  }
}

Widget sourceInfo(ItemModel model, BuildContext context,
    {Color background, removeCartFunction}) {
  return InkWell();
}

Widget card({Color primaryColor = Colors.redAccent, String imgPath}) {
  return Container();
}

void checkItemInCart(String productID, BuildContext context) {}
