// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:sd_pmn/widgets/wgt_button.dart';

class Wgt_GroupButton extends StatefulWidget {
  List<String> items;
  double heightItem;
  String valueSelected;
  Color? colorSelected;
  Color? colorUnselected;
  Color? textColorSelected;
  Color? textColorUnselected;
  void Function(String item)? onChange;
  Wgt_GroupButton({
    super.key,
    required this.items,
    this.colorSelected,
    this.colorUnselected,
    this.textColorSelected,
    this.textColorUnselected,
    this.valueSelected = "",
    this.onChange,
    this.heightItem = 50,
  }) : assert(items.contains(valueSelected), "valueSelected not exists!");

  @override
  State<Wgt_GroupButton> createState() => _Wgt_GroupButtonState();
}

class _Wgt_GroupButtonState extends State<Wgt_GroupButton> {
  Color? colorSl;
  Color? colorUSL;
  Color? txtColorSL;
  Color? txtColorUSL;

  @override
  void initState() {
    Wgt_button.value = widget.valueSelected;

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    colorSl = widget.colorSelected??Colors.white;
    colorUSL = widget.colorUnselected;
    txtColorSL = widget.textColorSelected;
    txtColorUSL = widget.textColorUnselected;
    List<Expanded> children = widget.items
        .map((e) => Expanded(
              child: Wgt_button(
                color: e == Wgt_button.value ? colorSl : colorUSL,
                textColor: e == Wgt_button.value ? txtColorSL : txtColorUSL,
                onPressed: () {
                  if (e != Wgt_button.value) {
                    Wgt_button.value = e;
                    setState(() {});
                  }
                  widget.onChange!.call(e);
                },
                text: e,
                height: widget.heightItem,
              ),
            ))
        .toList();
    return Row(
      children: children,
    );
  }
}
