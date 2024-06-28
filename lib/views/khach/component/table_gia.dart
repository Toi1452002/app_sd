import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/services.dart';
import 'package:sd_pmn/function/extension.dart';
import 'package:sd_pmn/models/mdl_giakhach.dart';

import '../../../widgets/widgets.dart';
class TableGia extends StatelessWidget {
  String mien;
  List<GiaKhachModel> gia;
  TableGia({super.key, required this.mien, required this.gia});


  @override
  Widget build(BuildContext context) {
    return DataTable2(
        columnSpacing: 10,
        empty: const Column(children: [LinearProgressIndicator()],),
        lmRatio: 0,
        border: TableBorder.all(color: Colors.grey, style: BorderStyle.solid),
        horizontalMargin: 5,
        headingRowHeight: 40,
        dataRowColor: WidgetStateProperty.all(Colors.white),
        headingRowColor: WidgetStateProperty.all(Colors.blueGrey.shade200),
        columns: [
          const DataColumn2(label: Text('Mã kiểu')),
          DataColumn2(label: Text('Cò M$mien')),
          DataColumn2(label: Text('Trúng M$mien')),
        ],
        rows: gia.map((e){
          var co, trung;
          if(mien=="N"){
            co = textField(gia:  e.CoMN ,onChanged: (value){e.CoMN = value != "" && value.isNumeric ? double.parse(value) : 0;});
            trung =  textField(gia:  e.TrungMN ,onChanged: (value){e.TrungMN = value != "" && value.isNumeric? double.parse(value) : 0;});
          }else if(mien == 'T'){
            co = textField(gia:  e.CoMT ,onChanged: (value){e.CoMT = value != "" && value.isNumeric? double.parse(value) : 0;});
            trung =  textField(gia:  e.TrungMT ,onChanged: (value){e.TrungMT = value != "" && value.isNumeric? double.parse(value) : 0;});

          }else{
            co = textField(gia:  e.CoMB ,onChanged: (value){e.CoMB = value != "" && value.isNumeric? double.parse(value) : 0;});
            trung =  textField(gia:  e.TrungMB ,onChanged: (value){e.TrungMB = value != "" && value.isNumeric? double.parse(value) : 0;});

          }

          return DataRow2(cells: [
            DataCell(Text(e.MaKieu)),
            DataCell(Padding(
              padding: const EdgeInsets.only(top: 1,bottom: 1),
              child: co,
            )),
            DataCell(Padding(
              padding: const EdgeInsets.only(top: 1,bottom: 1),
              child: trung,
            )),
          ]);
        }).toList());
  }
}
Widget textField({
  required double gia,
  Function(String)? onChanged,
}) {
  return TextField(
    textAlign: TextAlign.center,
    controller: TextEditingController(text: gia.toString()),
    decoration: const InputDecoration(
      fillColor: Colors.white,
      filled: true,
      border: InputBorder.none,
    ),
    inputFormatters: [
      FilteringTextInputFormatter.deny(',', replacementString: '.'),

    ],
    keyboardType: TextInputType.number,
    onChanged: onChanged,
  );
}
