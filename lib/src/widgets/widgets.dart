import 'package:flutter/material.dart';

Text text(String smth, double size) {
  return Text(
    smth,
    style: TextStyle(color: Color.fromARGB(255, 253, 253, 253), fontSize: size),
  );
}
