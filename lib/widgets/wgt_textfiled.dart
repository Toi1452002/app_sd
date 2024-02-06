import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class Wgt_TextField extends StatelessWidget {
  Wgt_TextField(
      {Key? key,
      this.controller,
      this.labelText,
      this.textInputType,
      this.textAlign,
      this.maxLines,
      this.hintText,
      this.errorText,
      this.onChanged,
      this.obscureText,
      this.icon,
      this.fillColor,
      this.borderRadius,
      this.enable,
      this.maxLenght,
      this.suffixIcon,
      this.inputFormatters,
      // this.onSubmitted,this.onTapOutside,this.onTap,
      this.undoController,
      this.autofocus})
      : super(key: key);
  TextEditingController? controller = TextEditingController();
  String? labelText;
  TextInputType? textInputType;
  int? maxLines;
  TextAlign? textAlign;
  String? hintText;
  String? errorText;
  bool? autofocus;
  bool? obscureText;
  Icon? icon;
  bool? enable;
  int? maxLenght;

  List<TextInputFormatter>? inputFormatters;
  BorderRadius? borderRadius;
  Color? fillColor;
  Widget? suffixIcon;
  void Function(String)? onChanged;
  // void Function(String)? onSubmitted;
  // void Function(PointerDownEvent)? onTapOutside;
  // void Function()? onTap;
  UndoHistoryController? undoController;
  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: enable,
      // onSubmitted: onSubmitted,
      undoController:undoController ,
      controller: controller,
      keyboardType: textInputType,
      // onTapOutside: onTapOutside,
      // onTap: onTap,
      maxLines: maxLines ?? 1,
      maxLength: maxLenght,
      obscureText: obscureText ?? false,
      autofocus: autofocus ?? false,
      textAlign: textAlign ?? TextAlign.start,

      inputFormatters: inputFormatters?? [
        FilteringTextInputFormatter.deny("'"),
        FilteringTextInputFormatter.deny("\"")
      ],
      decoration: InputDecoration(
          counterText: '',
          // icon: icon,
          filled: fillColor!=null ? true : false,
          fillColor: fillColor,
          prefixIcon: icon,
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
              borderRadius: borderRadius ?? BorderRadius.zero),
          hintText: hintText,
          errorText: errorText,
          labelText: labelText),
      onChanged: onChanged,
    );
  }
}
