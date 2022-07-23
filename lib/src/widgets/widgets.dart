import 'package:flutter/material.dart';

Text text(String smth, double size) {
  return Text(
    smth,
    style: TextStyle(color: Color.fromRGBO(0, 10, 141, 1), fontSize: size),
  );
}
