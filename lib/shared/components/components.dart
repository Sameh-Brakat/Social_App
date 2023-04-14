import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../styles/icon_broken.dart';
import 'constants.dart';


PreferredSizeWidget DefaultAppBar({
  required BuildContext context,
  String? title,
  List<Widget>? actions,
}) =>AppBar(
  leading: IconButton(onPressed: () {
    Navigator.pop(context);
  }, icon: Icon(IconBroken.Arrow___Left_2)),
title: Text('$title'),
  actions: actions,
);


Widget DefaultForm({
  required controller,
  required TextInputType type,
  required String label,
  required IconData preIcon,
  IconData? suffix,
  required String? Function(String?) validate,
  String? Function(String?)? submit,
  String? Function(String?)? onChange,
  Function()? suffixPressed,
  bool isPassword = false,
}) =>
    TextFormField(
      obscureText: isPassword,
      validator: validate,
      controller: controller,
      onFieldSubmitted: submit,
      onChanged: onChange,
      keyboardType: type,
      decoration: InputDecoration(
        suffixIcon: suffix != null
            ? IconButton(
                icon: Icon(suffix),
                onPressed: suffixPressed,
              )
            : null,
        prefixIcon: Icon(preIcon),
        labelText: label,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
    );

Widget DefaultButton({
  required String text,
  double width = double.infinity,
  double radius = 0,
  double border = 0,
  Color color = defaultColorLight,
  Color textColor = Colors.white,
  Color borderColor = Colors.black,
  required Function() onPressed,
}) =>
    Container(
      width: width,
      height: 50,
      decoration:
          BoxDecoration(border: Border.all(width: border , color: borderColor) ,color: color, borderRadius: BorderRadius.circular(radius)),
      child: MaterialButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(color: textColor),
        ),
        // () {
        //   if (formkey.currentState!.validate()) {
        //     print(emailcontroller.text);
        //     print(Passcontroller.text);
        //   }
        // }
      ),
    );

void Toastt({
  required String message,
  required ToastStates state,
}) =>
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 16,
    );

enum ToastStates { SUCCESS, ERROR, WARNING }

Color chooseToastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.yellow;
      break;
  }
  return color;
}
