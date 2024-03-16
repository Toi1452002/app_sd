// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sd_pmn/controllers/ctl_khach.dart';
import 'package:sd_pmn/models/mdl_giakhach.dart';
import 'package:sd_pmn/views/khach/cauhinh.dart';
import 'package:sd_pmn/widgets/wgt_groupbtn.dart';
import 'package:sd_pmn/widgets/wgt_textfiled.dart';

import '../../config/server.dart';

class V_ThemKhach extends StatelessWidget {
  V_ThemKhach({super.key});
  Ctl_GiaKhach controller  = Get.put(Ctl_GiaKhach());
  final RxString _mien = "N".obs;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Thêm khách"),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: IconButton(
                    onPressed: () {
                      Ctl_Khach().to.onSave();
                    },
                    icon: const Icon(
                      Icons.save_outlined,
                      size: 30,
                    )),
              )
            ],
            bottom: const TabBar(
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              tabs: [
                Tab(
                  text: "Chỉnh giá",
                ),
                Tab(
                  text: "Cấu hình",
                ),
              ],
            ),
          ),
          body:  TabBarView(children: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  Wgt_TextField(
                    fillColor: Colors.white,
                    controller: Ctl_Khach().to.makhachController,
                    enable:  Ctl_Khach().to.enableMaKhach,
                    labelText: "Tên khách",
                    // errorText: Ctl_Khach().to.makhachErr!="" ? Ctl_Khach().to.makhachErr : null,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Wgt_GroupButton(
                    items: ["Nam", "Trung", "Bắc"],
                    valueSelected: "Nam",
                    colorSelected: Sv_Color.main,
                    colorUnselected: Colors.white,
                    textColorUnselected: Sv_Color.main,
                    onChange: (a) {
                      _mien.value = a[0];
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Expanded(child: Obx(() {
                    // return ListTile(title: Text(Ctl_GiaKhach().to.lstGiaKhach.first.ChiaMB.toString()),);
                    return Table(
                      columnWidths: const {
                        0: FractionColumnWidth(.25),
                      },
                      border: TableBorder.all(
                          color: Colors.grey, style: BorderStyle.solid, width: 1),
                      children:
                      showBangGia(_mien.value, Ctl_GiaKhach().to.lstGiaKhach),
                    );
                  }))
                ],
              ),
            ),
            CauHinh()
          ]),
        ),
      ),
    );
  }
}

List<TableRow> showBangGia(String mien, List<GiaKhachModel> list) {
  List<TableRow> result = [];
  result.add(TableRow(children: [
    cell(text: "Mã kiểu", height: 40),
    cell(text: "Cò M$mien", height: 40),
    cell(text: "Trúng M$mien", height: 40),
  ]));
  switch (mien) {
    case "N":
      for (var x in list) {
        result.add(TableRow(children: [
          cell(text: x.MaKieu),
          textField(
              gia: x.CoMN,
              onChanged: (value) {
                x.CoMN = value != "" ? double.parse(value) : 0;
              }),
          textField(
              gia: x.TrungMN,
              onChanged: (value) {
                x.TrungMN = value != "" ? double.parse(value) : 0;
              })
        ]));
      }
      break;
    case "T":
      for (var x in list) {
        result.add(TableRow(children: [
          cell(text: x.MaKieu),
          textField(
              gia: x.CoMT,
              onChanged: (value) {
                x.CoMT = value != "" ? double.parse(value) : 0;
              }),
          textField(
              gia: x.TrungMT,
              onChanged: (value) {
                x.TrungMT = value != "" ? double.parse(value) : 0;
              })
        ]));
      }
      break;
    case "B":
      for (var x in list) {
        result.add(TableRow(children: [
          cell(text: x.MaKieu),
          textField(
              gia: x.CoMB,
              onChanged: (value) {
                x.CoMB = value != "" ? double.parse(value) : 0;
              }),
          textField(
              gia: x.TrungMB,
              onChanged: (value) {
                x.TrungMB = value != "" ? double.parse(value) : 0;
              })
        ]));
      }
      break;
  }
  return result;
}

Container cell({required String text, double height = 50, Color? color}) {
  return Container(
    alignment: Alignment.center,
    height: height,
    color: color ?? Colors.teal[100],
    child: Text(text),
  );
}

TextField textField({required double gia, Function(String)? onChanged,}) {
  return TextField(
    textAlign: TextAlign.center,
    controller: TextEditingController(text: gia.toString()),
    decoration: const InputDecoration(
      fillColor: Colors.white,
      filled: true,
      border: InputBorder.none,
    ),
    inputFormatters: [
        FilteringTextInputFormatter.deny(',',replacementString: '.'),
    ],
    keyboardType: TextInputType.number,
    onChanged: onChanged,
  );
}
