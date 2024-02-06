import 'package:flutter/material.dart';
import 'package:sd_pmn/models/mdl_kqxs.dart';

class KqxsTable extends StatelessWidget {
  List<KqxsModel> listKqxs = <KqxsModel>[];

  KqxsTable({Key? key, required this.listKqxs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> MaDai = [];
    listKqxs.forEach((element) {
      MaDai.add(element.MaDai);
    });
    MaDai = MaDai.toSet().toList();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Table(
        columnWidths: const{
          0: FractionColumnWidth(.1),
        },
        border: TableBorder.all(
            color: Colors.black, style: BorderStyle.solid, width: 1),
        children: _createRow(MaDai),
      ),
    );
  }

  TableRow _createHeader() {
    List<Widget> childrenTable = [];
    List<String> MoTa = [];
    for(var item in listKqxs){
      MoTa.add(item.MoTa);
    }
    MoTa = MoTa.toSet().toList();
    childrenTable.add(const SizedBox());
    for (var element in MoTa) {
      // element = replaceDai(element);
      childrenTable.add(Column(
        children: [
          Text(
            element,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
          )
        ],
      ));
    }

    return TableRow(children: childrenTable);
  }

  List<TableRow> _createRow(List<String> MaDai) {
    List<TableRow> result = [];
    result.add(_createHeader());
    List<String> giai = [];
    for (var element in listKqxs) {
      giai.add(element.MaGiai);
    }
    giai = giai.toSet().toList();
    for (var _giai in giai) {
      result.add(TableRow(children: _createCell(_giai, MaDai)));
    }
    return result;
  }

  List<Column> _createCell(String giai, List<String> maDai) {

    List<Column> result = [];
    List<KqxsModel> kqSo = <KqxsModel>[];
    List<String> number = [];
    result.add(Column(
      children: [Text(giai)],
    ));
    maDai.forEach((element) {
      number.clear();
      kqSo = listKqxs
          .where((kq) => kq.MaGiai == giai)
          .where((dai) => dai.MaDai == element)
          .toList();
      kqSo.forEach((so) {
        number.add(so.KqSo);
      });
      result.add(Column(children: [
        Text(
          maDai[0] == 'mb' ? number.join("\-") : number.join("\n"),
          style: TextStyle(
              fontSize: giai == "DB" ? 19 : 17,
              fontWeight: giai == "DB" ? FontWeight.bold : FontWeight.normal,
              color: giai == "DB" ? Colors.red : Colors.black),
        )
      ]));
    });
    return result;
  }
}
