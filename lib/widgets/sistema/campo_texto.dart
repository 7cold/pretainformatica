import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pretainformatica/configs/cores.dart';

class CampoTexto extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType inputType;
  final bool passTrue;
  final bool readOnly;
  final Function onTap;
  final Function onChanged;
  final Function onSubmited;
  final Function validator;
  final TextCapitalization textCapitalization;
  final int maxLines;
  final Widget suffixIcon;
  String varValue;

  CampoTexto({
    Key key,
    @required this.controller,
    @required this.hintText,
    @required this.inputType,
    @required this.passTrue,
    @required this.varValue,
    @required this.readOnly,
    @required this.textCapitalization,
    this.onTap,
    this.onChanged,
    this.onSubmited,
    this.maxLines,
    this.suffixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: maxLines,
      onTap: onTap,
      readOnly: readOnly,
      onChanged: onChanged,
      onFieldSubmitted: onSubmited,
      controller: controller,
      cursorColor: Color(corAccent),
      cursorWidth: 3.5,
      keyboardType: inputType,
      textCapitalization: textCapitalization,
      obscureText: passTrue,
      style: TextStyle(fontFamily: "FontBold"),
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        filled: true,
        hintText: hintText,
        hintStyle: TextStyle(fontFamily: "FontBold"),
        fillColor: CupertinoColors.systemGrey5,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(corDark), width: 3),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.transparent, width: 1.5),
        ),
      ),
      validator: validator,
      onSaved: (value) => controller.text = value,
    );
  }
}
