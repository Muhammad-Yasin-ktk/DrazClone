import 'package:daraz_clone/Config/config.dart';
import 'package:flutter/foundation.dart';


class CartItemCounter extends ChangeNotifier{
  int _counter=EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList).length-1;
  int get count{
    return _counter;
  }
  Future<void> displayresult()async{
    int _counter=EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList).length-1;
    await Future.delayed(Duration(milliseconds: 100),(){notifyListeners();});
  }
}