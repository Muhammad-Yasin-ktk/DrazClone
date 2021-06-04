import 'package:flutter/foundation.dart';

class ItemQuantity with ChangeNotifier {
  int _numberOfItems=0;
  int get numberOfItem=>numberOfItem;
  display(int no){
    _numberOfItems=no;
    notifyListeners();
  }
}
