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
  final int maxLines;
  final InputDecoration decoration;

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
    this.maxLines = 1,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: (decoration != null)
          ? decoration
          : InputDecoration(hintText: hint, errorText: errorText),
      obscureText: (obscureText != null) ? obscureText : false,
      validator: validator,
      maxLines: maxLines,
      onChanged: onChanged,
      controller: controller,
      keyboardType: textInputType,
      inputFormatters: formatters,
    );
  }
}
