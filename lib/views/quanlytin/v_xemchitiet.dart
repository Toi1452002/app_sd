import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sd_pmn/controllers/ctl_quanlytin.dart';
import 'package:sd_pmn/widgets/wgt_table.dart';

import '../../config/server.dart';

class V_XemChiTiet extends StatefulWidget {
  const V_XemChiTiet({super.key});

  @override
  State<V_XemChiTiet> createState() => _V_XemChiTietState();
}

class _V_XemChiTietState extends State<V_XemChiTiet> {

  @override
  void initState() {
    // TODO: implement initState
    Ctl_Quanlytin().to.xemchitiet(Get.parameters['ID']!);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    Ctl_Quanlytin().to.clearXemCT();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // print(Get.parameters);
    // Ctl_Quanlytin().to.xemchitiet(Get.parameters['ID']!);
    return Scaffold(
      appBar: AppBar(
        title: Text('Xem chi tiết'),
      ),
      body: Container(
        height: Get.height,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.topLeft,
              height: 150,
              child: SingleChildScrollView(child: Obx(()=>Text(Ctl_Quanlytin().to.tin.value))),
            ),
            Table(
              border: TableBorder.all(color: Sv_Color.main, width: 0.5),
              columnWidths: const {
                0: FractionColumnWidth(.35),
                1: FractionColumnWidth(.19),
                2: FractionColumnWidth(.18),
                3: FractionColumnWidth(.18),
                4: FractionColumnWidth(.1),
              },
              children: [
                TableRow(children: [
                  cell_Header(text: 'Tin'),
                  cell_Header(text: 'Xác'),
                  cell_Header(text: 'Vốn'),
                  cell_Header(text: 'Trúng'),
                  cell_Header(text: 'SLT'),
                ]),
              ],
            ),
            Obx(() => Table(
              border: TableBorder.all(color: Sv_Color.main, width: 0.5),
              columnWidths: const {
                0: FractionColumnWidth(.35),
                1: FractionColumnWidth(.19),
                2: FractionColumnWidth(.18),
                3: FractionColumnWidth(.18),
                4: FractionColumnWidth(.1),
              },
              children: [
                TableRow(children: [
                  cell_Body(text: ''),
                  cell_Body(text:  Ctl_Quanlytin().to.tongXac,alignment: Alignment.centerRight,pdRight: 5),
                  cell_Body(text:  Ctl_Quanlytin().to.tongVon,alignment: Alignment.centerRight,pdRight: 5),
                  cell_Body(text:  Ctl_Quanlytin().to.tongTrung,alignment: Alignment.centerRight,pdRight: 5),
                  cell_Body(text: ''),
                ]),
              ],
            )),
            Expanded(child: GetBuilder<Ctl_Quanlytin>(
              builder: (ctl) {
                List<Map<String, dynamic>> data = ctl.lstXemCT.value;
                if(ctl.isLoading){
                  return Column(
                    children: [
                      const LinearProgressIndicator(),
                    ],
                  );
                }
                int i = 0;
                return SingleChildScrollView(
                  child: Table(
                    columnWidths: const {
                      0: FractionColumnWidth(.35),
                      1: FractionColumnWidth(.19),
                      2: FractionColumnWidth(.18),
                      3: FractionColumnWidth(.18),
                      4: FractionColumnWidth(.1),
                    },
                    children: data.map((e) {
                    i+=1;
                    return TableRow(children: [
                      PopupMenuButton(
                          itemBuilder: (context) => [
                                PopupMenuItem(
                                    textStyle:
                                        const TextStyle(color: Colors.black),
                                    child: Text(e['Tin']))
                              ],
                          child: cell_Body(
                              text: e['Tin'],
                              alignment: Alignment.centerLeft,
                              pdLeft: 5,
                              textColor: e['SLT'] != '' ? Colors.red : null,
                              index: i)),
                      cell_Body(
                          text: e['Xac'],
                          textColor: e['SLT'] != '' ? Colors.red : null,
                          alignment: Alignment.centerRight,
                          pdRight: 5,
                          index: i),
                      cell_Body(
                          text: e['Von'],
                          textColor: e['SLT'] != '' ? Colors.red : null,
                          alignment: Alignment.centerRight,
                          pdRight: 5,
                          index: i),
                      cell_Body(
                          text: e['Trung'],
                          textColor: e['SLT'] != '' ? Colors.red : null,
                          alignment: Alignment.centerRight,
                          pdRight: 5,
                          index: i),
                      cell_Body(
                          text: e['SLT'],
                          textColor: e['SLT'] != '' ? Colors.red : null,
                          alignment: Alignment.centerRight,
                          pdRight: 5,
                          index: i),
                    ]);
                  }).toList(),
                  ),
                );
              },
            ))
          ],
        ),
      ),
    );
  }
}
