import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Wgt_button extends StatelessWidget {
  Wgt_button(
      {Key? key,
      required this.onPressed,
      required this.text,
      this.width,
      this.height,
      this.color,
      this.disable,
      this.textColor,
      this.icon})
      : super(key: key);
  void Function()? onPressed;
  String text;
  double? width;
  double? height;
  Color? color;
  bool? disable;
  Color? textColor;
  IconData? icon;
  static String value = "";

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        height: height,
        child: FilledButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: color,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3))),
            onPressed: disable ?? false ? null : onPressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon == null ? const SizedBox() : SizedBox(width: 25,child: Icon(icon,size: 20,color: textColor,),),
                Text(
                  text.toString(),
                  style: TextStyle(color: textColor ?? Colors.white),
                )
              ],
            )));
  }
}
