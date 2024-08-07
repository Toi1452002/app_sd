// ignore_for_file: camel_case_types

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sd_pmn/controllers/ctl_quanlytin.dart';
import 'package:sd_pmn/controllers/ctl_xuly.dart';
import 'package:sd_pmn/function/extension.dart';
import 'package:sd_pmn/config/router.dart';
import 'package:sd_pmn/views/quanlytin/item_qli.dart';
import 'package:sd_pmn/widgets/wgt_dialog.dart';

import '../../config/server.dart';
import 'package:grouped_list/grouped_list.dart';

import '../../models/mdl_ql_tinct.dart';

class V_QLTin_CT extends StatelessWidget {
  const V_QLTin_CT({super.key});

  @override
  Widget build(BuildContext context) {
    Ctl_Quanlytin().to.onLoadTinCT(Get.parameters['KhachID'].toString());
    return Scaffold(
      appBar: AppBar(
        title: Text(Get.parameters['MaKhach'].toString()),
      ),
      body: Obx(() {
        List<QliTinCTModel> data = Ctl_Quanlytin().to.lstTinCT;
        return DefaultTabController(length: 3, child: Column(
          children: [
            Container(
              color: Sv_Color.main,
              height: 40,
              child: TabBar( indicatorColor: Colors.white,
                  labelColor: Colors.white,tabs: [
                Text('Nam'),
                Text('Trung'),
                Text('Bac'),
              ]),
            ),
            Expanded(child: TabBarView(
              children: [
                ItemQli(data: data.where((e)=>e.Mien == 'N').toList()),
                ItemQli(data: data.where((e)=>e.Mien == 'T').toList()),
                ItemQli(data: data.where((e)=>e.Mien == 'B').toList()),
                // Text('1'),
                // Text('1'),
                // Text('1'),
              ],
            ),)
          ],
        ));

      }),
    );
  }
}
