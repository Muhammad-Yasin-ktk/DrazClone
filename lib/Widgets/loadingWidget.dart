import 'package:flutter/material.dart';


circularProgress() {
  return Container(
    padding: EdgeInsets.all(5),
    child: Center(
      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.lightGreenAccent),),
    ),
  );
}

linearProgress() {
  return Container(
    padding: EdgeInsets.all(5),
    child: Center(
      child: LinearProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.lightGreenAccent),),
    ),
  );
}
