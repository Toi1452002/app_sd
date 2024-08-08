import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class WgtTextField extends StatelessWidget {
  WgtTextField(
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
      this.style,
      this.fillColor,
      this.borderRadius,
      this.enable,
      this.maxLength,
      this.suffixIcon,
      this.inputFormatters,this.hasBoder = true,
      // this.onSubmitted,this.onTapOutside,this.onTap,
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
  int? maxLength;
  TextStyle? style;
  List<TextInputFormatter>? inputFormatters;
  BorderRadius? borderRadius;
  Color? fillColor;
  Widget? suffixIcon;
  void Function(String)? onChanged;
  bool hasBoder;
  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: enable,
      controller: controller,
      keyboardType: textInputType,
      maxLines: maxLines ?? 1,
      maxLength: maxLength,
      obscureText: obscureText ?? false,
      autofocus: autofocus ?? false,
      textAlign: textAlign ?? TextAlign.start,

      inputFormatters: inputFormatters?? [
        FilteringTextInputFormatter.deny("'"),
        FilteringTextInputFormatter.deny("\"")
      ],
      decoration: InputDecoration(
          counterText: '',
          filled: fillColor!=null ? true : false,
          fillColor: fillColor,
          prefixIcon: icon,
          suffixIcon: suffixIcon,
          // border: OutlineInputBorder(
          //   borderSide: hasBoder ? const BorderSide(width: .1) : BorderSide.none,
          //     borderRadius: borderRadius ?? BorderRadius.zero),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3),
            borderSide: BorderSide(width: .3,color: Colors.black)
          ),
          disabledBorder:  OutlineInputBorder(
              borderRadius: BorderRadius.circular(3),
              borderSide: BorderSide(width: .3,color: Colors.black)
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3),
            borderSide: BorderSide(width: .5,color: Colors.blueAccent.shade700)
          ),
          hintText: hintText,
          errorText: errorText,
          labelText: labelText),
      onChanged: onChanged,
    );
  }
}
