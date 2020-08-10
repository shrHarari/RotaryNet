import 'package:flutter/material.dart';

const myTextInputDecoration = InputDecoration(
  contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 1.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.pink, width: 2.0),
  ),
);


const myDisabledTextInputDecoration = InputDecoration(
  contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
  fillColor: Colors.white10,
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blue, width: 1.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blue, width: 2.0),
  ),
  disabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blue, width: 1.0),
  ),
);

