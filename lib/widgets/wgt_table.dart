import 'package:flutter/material.dart';

import '../config/server.dart';

Container cell_Header({required String text, double height = 35, Color? color, bool border = false}) {
  return Container(
    alignment: Alignment.center,
    height: height,
    decoration: BoxDecoration(
      color: color ?? Sv_Color.main_1[50],
      border: border ? Border.all(color: Sv_Color.main[200]!,width: 0.3): null
    ),

    child: Text(text,style: const TextStyle(fontSize: 15),),
  );
}

Container cell_Body({required String text, double height = 35, int index = 0, Color? textColor, Alignment? alignment, double pdLeft = 0,double pdRight = 0}) {
  return Container(
    alignment: alignment?? Alignment.center,
    padding: EdgeInsets.only(left: pdLeft, right: pdRight),
    height: height,
    decoration: BoxDecoration(
        color: index%2!=0 ? Colors.grey[100] : Colors.white,
        border: Border.all(color: Colors.blueGrey[100]!,width: 0.2)
    ),

    child: Text(text,style: TextStyle(fontSize: 15,color: textColor??Colors.black),),
  );
}