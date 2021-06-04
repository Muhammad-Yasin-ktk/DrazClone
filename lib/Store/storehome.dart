import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daraz_clone/Counters/cartitemcounter.dart';
import 'package:daraz_clone/Store/cart.dart';
import 'package:daraz_clone/Store/product_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../Widgets/myDrawer.dart';

import '../Models/item.dart';
import 'Search.dart';

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
//                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.brightness_1,
                        color: Colors.green,
                        size: 20,
                      ),
                      Positioned(
                        top: 3,
                        bottom: 4,
                        left: 4,
                        child: Consumer<CartItemCounter>(
                          builder: (context, counter, _) {
                            return Text(
                              counter.count.toString(),
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
        drawer: MyDrawer(),
//          body: Column(
//            children: [
//              Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: InkWell(
//                  onTap: () {
////                      Navigator.of(context).pushReplacement(
////                          MaterialPageRoute(builder: (_) => SearchProduct()));
//                  },
//                  child: Container(
//                    height: 80,
//                    width: MediaQuery.of(context).size.width,
//                    alignment: Alignment.center,
//                    decoration: BoxDecoration(
//                      gradient: LinearGradient(
//                        colors: [Colors.pink, Colors.lightGreenAccent],
//                        begin: FractionalOffset(0.0, 0.0),
//                        end: FractionalOffset(1.0, 0.0),
//                        stops: [0.0, 1.0],
//                        tileMode: TileMode.clamp,
//                      ),
//                    ),
//                    child: InkWell(
//                      child: Container(
//                        margin: EdgeInsets.symmetric(horizontal: 20),
//                        height: 50,
//                        width: MediaQuery.of(context).size.width,
//                        decoration: BoxDecoration(
//                            color: Colors.white,
//                            borderRadius: BorderRadius.circular(10)),
//                        child: Row(
//                          children: [
//                            Padding(
//                              padding: EdgeInsets.only(
//                                left: 10,
//                              ),
//                              child: Icon(Icons.search),
//                            ),
//                            Padding(
//                              padding: EdgeInsets.only(left: 10),
//                              child: Text('Search here...'),
//                            ),
//                          ],
//                        ),
//                      ),
//                    ),
//                  ),
//                ),
//              ),
        body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('items')
              .limit(15)
              .orderBy('publishedDate', descending: true)
              .snapshots(),
          builder: (context, dataSnapshot) {
            if (dataSnapshot.data == null) {
              return CircularProgressIndicator();
            }
            return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: dataSnapshot.data.documents.length,
              itemBuilder: (ctx, index) {
                var model = dataSnapshot.data.documents[index];
                print("model ...................." + "$model");

                return sourceInfo(model, ctx);
              },
            );
          },
        ),
      ),
    );
  }
}

Widget sourceInfo(var model, BuildContext context,
    {Color background, removeCartFunction}) {
//  double newv=double.parse(model['price']);
//double newvalue=newv/2;
  return InkWell(
    onTap: () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => ProductPage(model)));
    },
    child: Container(
      height: 170,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 0.5, color: Colors.grey)),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              model['thumbnailUrl'],
              height: 160,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 15, top: 15, bottom: 15, right: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model['title'],
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  model['shortInfo'],
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 50,
                      width: 40,
                      padding: EdgeInsets.all(5),
                      color: Colors.pink,
                      child: Text(
                        '50% \nOFF',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Column(
                        children: [
                          Text(
                            'Orignil Price \$${model['price']}',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough),
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Text(
                            'new Price \$${model['price']}',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              margin: EdgeInsets.only(bottom: 10, right: 5),
              child: IconButton(
                icon: Icon(Icons.add_shopping_cart),
                color: Colors.pink,
                onPressed: () {},
              ),
            ),
          )
        ],
      ),
    ),
  );
}

Widget card({Color primaryColor = Colors.redAccent, String imgPath}) {
  return Container();
}

void checkItemInCart(String productID, BuildContext context) {}
