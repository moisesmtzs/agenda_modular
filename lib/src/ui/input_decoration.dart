// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class InputDecorations {

  static InputDecoration authInputDecoration({
    String? hintText,
    String? labelText,
    IconData? prefixIcon,
    IconData? suffixIcon
  }) {
    return InputDecoration(
      // contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.indigo.shade300
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.indigo,
          width: 2
        )
      ),
      hintText: hintText,
      hintStyle: TextStyle( color: Colors.grey[400] ),
      labelText: labelText,
      labelStyle: TextStyle( color: Colors.blueGrey ),
      prefixIcon: prefixIcon != null
        ? Icon( prefixIcon, color: Colors.indigo.shade300, )
        : null,
      suffixIcon: suffixIcon != null
        ? Icon( suffixIcon, color: Colors.indigo.shade300, )
        : null
    );
  }

}
