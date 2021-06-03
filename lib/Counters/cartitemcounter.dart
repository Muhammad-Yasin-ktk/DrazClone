import 'package:daraz_clone/Config/config.dart';
import 'package:flutter/foundation.dart';


class CartItemCounter extends ChangeNotifier{
  int _counter=EcommerceApp.sharedPreferences.getString(EcommerceApp.userCartList).length-1;
  int get count{
    return _counter;
  }
}