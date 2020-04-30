import 'package:flutter/material.dart';
import 'package:covid19/user.dart';

Widget row(User user) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Text(
        user.name,
        style: TextStyle(fontSize: 16.0),
      ),
      SizedBox(
        width: 10.0,
      ),
//      Text(
//        user.email,
//      ),
    ],
  );
}
