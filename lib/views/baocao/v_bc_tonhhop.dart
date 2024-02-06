// ignore_for_file: camel_case_types, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sd_pmn/config/server.dart';
import 'package:sd_pmn/controllers/ctl_baocao.dart';
import 'package:sd_pmn/views/baocao/wgt_bc_tonghop/table.dart';
import 'package:sd_pmn/views/baocao/wgt_bc_tonghop/text.dart';
import 'package:sd_pmn/widgets/wgt_drawer.dart';
import 'package:sd_pmn/widgets/wgt_dropdown.dart';
import 'package:sd_pmn/widgets/wgt_table.dart';

import '../../widgets/wgt_button.dart';

class V_BcTongHop extends StatelessWidget {
  const V_BcTongHop({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Sv_Color.main[100],
      drawer: const Wgt_Drawer(),
      appBar: AppBar(
        title: const Text("Báo cáo tổng hợp"),
      ),
      body: Column(
        children: [
          /** Container Option **/
          Container(
            width: Get.width,
            margin: const EdgeInsets.only(bottom: 10),
            height: 120,
            decoration: BoxDecoration(
              color: Sv_Color.main_1[50],
              border: Border.all(color: Colors.white),
              boxShadow: const [
                BoxShadow(
                    color: Colors.blueGrey, blurRadius: 2, offset: Offset(1, 1))
              ],
              // borderRadius: const BorderRadius.vertical(bottom: Radius.circular(5))
            ),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ngày:',
                      ),
                      Text('Khách:'),
                      Text('Miền:'),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => Wgt_button(
                      height: 30,
                        onPressed: () async {
                          DateTime? newDate = await showDatePicker(
                            locale: const Locale("vi", ""),
                            context: context,
                            initialEntryMode: DatePickerEntryMode.calendar,
                            initialDate: Ctl_BaoCaoTongHop().to.ngay,
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                            fieldHintText: "Ngày/Tháng/Năm",
                            helpText: "Chọn ngày",
                          );
                          if (newDate != null) {
                            Ctl_BaoCaoTongHop().to.ngay = newDate;
                            Ctl_BaoCaoTongHop().to.onLoadBaoCao();
                          }
                        },
                        text: Ctl_BaoCaoTongHop().to.ngayValue,
                        color: Colors.white,
                        textColor: Colors.black)),
                    Obx(() => Wgt_Dropdown(
                      items: Ctl_BaoCaoTongHop().to.lstMaKhach,
                      value: Ctl_BaoCaoTongHop().to.maKhach == ''?null:Ctl_BaoCaoTongHop().to.maKhach,
                      hint: Ctl_BaoCaoTongHop().to.maKhach.toString() != ''? '' : 'Khách',
                      onChange: (value) {
                        Ctl_BaoCaoTongHop().to.maKhach = value!;
                        Ctl_BaoCaoTongHop().to.onFilter('Khach', value);
                      },
                      height: 30,
                      widh: 150,
                    )),
                    Obx(() => Wgt_Dropdown(
                          items: const ['Nam', 'Trung', 'Bắc'],
                          value: Ctl_BaoCaoTongHop().to.mien == ''?null:Ctl_BaoCaoTongHop().to.mien,
                          hint: Ctl_BaoCaoTongHop().to.mien.toString() != ''? '' : 'Miền',
                          onChange: (value) {
                            Ctl_BaoCaoTongHop().to.mien = value!;
                            Ctl_BaoCaoTongHop().to.onFilter('Mien', value[0]);
                          },
                          height: 30,
                        )),
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      'Tổng tiền',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Obx(() =>  Text(
                      Ctl_BaoCaoTongHop().to.tongTien,
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18,color:Ctl_BaoCaoTongHop().to.tongTien.contains('-')? Colors.red: Colors.blue ),
                    )),
                    Wgt_button(
                      onPressed: () {
                        Ctl_BaoCaoTongHop().to.onLoadBaoCao();
                      },
                      text: 'Tất cả',
                      icon: Icons.refresh,
                    )
                  ],
                )
              ],
            ),
          ),
          /// -----------------------------------------------------------------------------------------*
          /// -----------------------------------------------------------------------------------------*
          /// -----------------------------------------------------------------------------------------*
          /// Table
          // const SizedBox(height: 4,),
          Expanded(child: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                Container(
                  color: Sv_Color.main,
                  height: 40,
                  child: const TabBar(
                    indicatorColor: Colors.white,
                    labelColor: Colors.white,
                    tabs: [
                      Tab(text: 'Bảng',),
                      Tab(text: 'Chữ',),
                    ],
                  ),
                ),
                const Expanded(child: TabBarView(

                  children: [
                    Tbl_BCTongHop(),
                    // Text('Dang bang'),
                    Txt_BCTongHop()
                  ],
                ))
              ],
            ),

          ))

        ],
      ),
    );
  }
}
