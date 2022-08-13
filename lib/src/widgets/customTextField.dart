// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField(
      {Key? key,
      required this.hint,
      required this.prefixIcon,
      required this.newController})
      : super(key: key);
  String hint;
  TextEditingController newController;
  IconData prefixIcon;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: newController,
      decoration: InputDecoration(
        label: Text(hint),
        prefixIcon: Icon(
          prefixIcon,
        ),
        border: OutlineInputBorder(),
      ),
    );
  }
}
