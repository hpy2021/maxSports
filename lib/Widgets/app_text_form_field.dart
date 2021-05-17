import 'package:flutter/material.dart';

class AppTextFormField extends StatelessWidget {

  AppTextFormField(
      {@required this.controller,
      @required this.obscureText,
      this.hintStyle,
      this.hintText,
      this.validator,
      this.onTap});

  TextEditingController controller;
  String hintText;
  TextStyle hintStyle;
  bool obscureText = false;
  Function validator, onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        validator: validator,
        onTap: onTap,

        controller: controller,
        obscureText: obscureText,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          hintText: hintText,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28),
              borderSide: BorderSide(color: Colors.grey)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: Colors.grey),
          ),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28),
              borderSide: BorderSide(color: Colors.red)),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28),
              borderSide: BorderSide(color: Colors.red)),
        ),
      ),
    );
  }
}
