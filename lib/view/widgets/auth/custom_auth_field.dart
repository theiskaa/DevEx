import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../components/widgets.dart';

class CustomAuthField extends DevExamStatelessWidget {
  final Color accentColor;
  final Color darkColor;
  final String hint;
  final bool obscureText;
  final Widget sufixIcon;
  final Function(String) validator;
  final Function(String) onChanged;
  final TextEditingController controller;
  final TextInputType textInputType;
  final String errorText;
  final List<TextInputFormatter> formatters;

  CustomAuthField({
    Key key,
    this.accentColor,
    this.darkColor,
    this.hint,
    this.obscureText,
    this.sufixIcon,
    this.validator,
    this.onChanged,
    this.controller,
    this.textInputType,
    this.errorText,
    this.formatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: Colors.black, fontSize: 18),
      cursorColor: darkColor,
      obscureText: (obscureText != null) ? obscureText : false,
      decoration: buildInputDecoration(),
      validator: validator,
      onChanged: onChanged,
      controller: controller,
      keyboardType: textInputType,
      inputFormatters: formatters,
    );
  }

  InputDecoration buildInputDecoration() {
    return InputDecoration(
      errorText: errorText,
      hintText: hint,
      errorStyle: TextStyle(color: Colors.red),
      hintStyle: TextStyle(
        color: Colors.black.withOpacity(.8),
        fontSize: 18,
      ),
      suffixIcon: sufixIcon,
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(width: 2, color: darkColor),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(width: 2, color: Colors.black),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(width: 2, color: Colors.red),
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          width: 2,
          color: Colors.red,
        ),
      ),
      enabled: true,
    );
  }
}
