// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sd_pmn/controllers/ctl_quanlytin.dart';
import 'package:sd_pmn/controllers/ctl_xuly.dart';
import 'package:sd_pmn/config/router.dart';
import 'package:sd_pmn/widgets/wgt_dialog.dart';
import 'package:sd_pmn/widgets/wgt_drawer.dart';

import '../../config/server.dart';


class V_Quanlytin extends StatelessWidget {
  const V_Quanlytin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Wgt_Drawer(),
      appBar: AppBar(
        title: const Text("Quản lý tin"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton(
              onPressed: () async {
                DateTime? newDate = await showDatePicker(
                  locale: const Locale("vi", ""),
                  context: context,
                  initialEntryMode: DatePickerEntryMode.calendar,
                  initialDate: Ctl_Quanlytin().to.ngaylam,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                  fieldHintText: "Ngày/Tháng/Năm",
                  helpText: "Chọn ngày",
                );
                if (newDate != null) {
                  Ctl_Quanlytin().to.ngaylam = newDate;
                  Ctl_Quanlytin().to.onLoadDanhSachTin();
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey[200],
                  shape: const BeveledRectangleBorder()),
              child: Obx(() =>
                  Text(
                    DateFormat("dd/MM/yyyy")
                        .format(Ctl_Quanlytin().to.ngaylam),
                    style: const TextStyle(color: Colors.black),
                  )),
            ),
          ),
        ],
      ),
      body: GetBuilder<Ctl_Quanlytin>(
        builder: (ctl) {
          List<Map<String, dynamic>> k = ctl.lstKhach;
          return ListView.separated(
              itemBuilder: (context,i)=>ListTile(
                onTap: (){
                  Get.toNamed(routerName.v_qltin_ct,parameters: {
                    'KhachID': k[i]['ID'].toString(),
                    'MaKhach': k[i]['MaKhach']
                  })?.then((value) => Ctl_Xuly().to.onLoadTinNhan());
                },
                leading: const Icon(Icons.mail),
                trailing: IconButton(onPressed: (){
                  Wgt_Dialog(title: 'Thông báo', text: 'Toàn bộ tin hiện tại của khách này sẽ bị xóa?', onConfirm: (){
                    Ctl_Quanlytin().to.onDeleteKhach(k[i]['ID']);
                  });
                },icon: Icon(Icons.delete,color: Colors.red,),),
                title: RichText(
                  text: TextSpan(
                      children: [
                        TextSpan(text: k[i]["MaKhach"],style: const TextStyle(color: Colors.black,fontSize: 20)),
                        TextSpan(text: " (${k[i]["sotin"].toString()} tin)",style: const TextStyle(color: Colors.grey, fontSize: 20)),
                      ]
                  ),
                ),

              ),
              separatorBuilder: (context, i)=>const Divider(color: Sv_Color.main,),
              itemCount: k.length);
        },
      ),
    );
  }
}
