// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sd_pmn/config/server.dart';
import 'package:sd_pmn/controllers/ctl_baocao.dart';
import 'package:sd_pmn/widgets/wgt_button.dart';
import 'package:sd_pmn/widgets/wgt_dropdown.dart';

import '../../widgets/wgt_table.dart';

class V_BcTongTien extends StatelessWidget {
  const V_BcTongTien({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Sv_Color.main[200],
      appBar: AppBar(
        title: const Text("BC tổng tiền"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(() =>
                Wgt_Dropdown(
                  color: Sv_Color.main[50],
                  items: Ctl_BaoCaoTongTien().to.lstMaKhach,
                  value: Ctl_BaoCaoTongTien().to.maKhach == '' ? null : Ctl_BaoCaoTongTien().to.maKhach,
                  onChange: (value) {
                    Ctl_BaoCaoTongTien().to.maKhach = value!;
                    Ctl_BaoCaoTongTien().to.onChangeMaKhach();
                  },
                  height: 30,
                  widh: 120,)),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: Get.width,
            margin: EdgeInsets.only(bottom: 10),
            height: 120,
            decoration: BoxDecoration(
              color: Sv_Color.main_1[50],
              border: Border.all(color: Colors.white),
                boxShadow: [
                  const BoxShadow(color: Colors.blueGrey,blurRadius: 2,offset: Offset(1, 1))
                ],
              // borderRadius: const BorderRadius.vertical(bottom: Radius.circular(5))
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(width: 10,),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Từ: "),
                    Text("Đến: "),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [

                    Obx(() =>
                        Wgt_button(onPressed: () async {
                          DateTime? newDate = await showDatePicker(
                            locale: const Locale("vi", ""),
                            context: context,
                            initialEntryMode: DatePickerEntryMode.calendar,
                            initialDate: Ctl_BaoCaoTongTien().to.tuNgay,
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                            fieldHintText: "Ngày/Tháng/Năm",
                            helpText: "Chọn ngày",
                          );
                          if (newDate != null) {
                            Ctl_BaoCaoTongTien().to.tuNgay = newDate;
                          }
                        },
                            text: Ctl_BaoCaoTongTien().to.tuNgayValue,
                            color: Colors.white,
                            textColor: Colors.black)),
                    Obx(() =>
                        Wgt_button(onPressed: () async {
                          DateTime? newDate = await showDatePicker(
                            locale: const Locale("vi", ""),
                            context: context,
                            initialEntryMode: DatePickerEntryMode.calendar,
                            initialDate: Ctl_BaoCaoTongTien().to.denNgay,
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                            fieldHintText: "Ngày/Tháng/Năm",
                            helpText: "Chọn ngày",
                          );
                          if (newDate != null) {
                            Ctl_BaoCaoTongTien().to.denNgay = newDate;
                          }
                        },
                            text: Ctl_BaoCaoTongTien().to.denNgayValue,
                            color: Colors.white,
                            textColor: Colors.black)),
                  ],
                ),
                const SizedBox(width: 25,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [

                    // const Text("Tổng tiền", style: TextStyle(fontSize: 22),),
                    Obx(() =>
                        RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(text: "Tổng: ",style: TextStyle(
                                fontSize: 20,
                                color: Colors.black
                              )),
                              TextSpan(text:  Ctl_BaoCaoTongTien().to.tongTien,
                                style: TextStyle(fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Ctl_BaoCaoTongTien().to.tongTien
                                        .contains('-') ? Colors.red : Colors
                                        .blue),)
                            ]
                          ),
                        )),
                    Wgt_button(onPressed: () {
                      Ctl_BaoCaoTongTien().to.loadData();
                    }, text: "Thực hiện",width: 140,),
                  ],
                ),
              ],
            ),
          ),
          // SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Table(
              border: TableBorder.all(color: Sv_Color.main,width: 0.2),
              children: [
                TableRow(children: [
                  cell_Header(text: 'Khách'),
                  cell_Header(text: 'N'),
                  cell_Header(text: 'T'),
                  cell_Header(text: 'B'),
                  cell_Header(text: 'ThuBu'),
                ]),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Obx(()=>Table(

              border: TableBorder.all(color: Sv_Color.main,width: 0.2),
              children: [
                TableRow(children: [
                  cell_Body(text: ''),
                  cell_Body(text: Ctl_BaoCaoTongTien().to.tongN,alignment: Alignment.centerRight,pdRight: 5),
                  cell_Body(text: Ctl_BaoCaoTongTien().to.tongT,alignment: Alignment.centerRight,pdRight: 5),
                  cell_Body(text: Ctl_BaoCaoTongTien().to.tongB,alignment: Alignment.centerRight,pdRight: 5),
                  cell_Body(text: Ctl_BaoCaoTongTien().to.tongTien,textColor: Ctl_BaoCaoTongTien().to.tongTien.contains('-') ? Colors.red : Colors.blue,alignment: Alignment.centerRight,pdRight: 5),
                ]),
              ],
            )),
          ),
          Expanded(child: Obx((){
            List<Map<String, dynamic>> data = Ctl_BaoCaoTongTien().to.lstBCLoad;
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              itemCount: data.length,
              itemBuilder: (context,i){
                if(data[i]['ID']=='title'){
                  return Container(
                    alignment: Alignment.center,
                    height: 25,
                    decoration: BoxDecoration(
                      // border: Border.symmetric(vertical: BorderSide(color: Colors.blueGrey[100]!)),
                      color: Sv_Color.main[200]
                    ),
                    child: Text("------- ${data[i]['Ngay'].toString()} -------",style: TextStyle(fontWeight: FontWeight.bold),),
                  );
                }else{
                  return Row(
                    children: [
                      Expanded(child: cell_Body(text: data[i]['Khách'],index: i)),
                      Expanded(child: cell_Body(text:data[i]['Nam'].toString()== 'null' ? '' : NumberFormat("#,###").format(data[i]['Nam']??0),index: i,alignment: Alignment.centerRight,pdRight: 5)),
                      Expanded(child: cell_Body(text:data[i]['Trung'].toString()== 'null' ? '' : NumberFormat("#,###").format(data[i]['Trung']??0),index: i,alignment: Alignment.centerRight,pdRight: 5)),
                      Expanded(child: cell_Body(text:data[i]['Bắc'].toString()== 'null' ? '' : NumberFormat("#,###").format(data[i]['Bắc']??0),index: i,alignment: Alignment.centerRight,pdRight: 5)),
                      Expanded(child: cell_Body(text: NumberFormat("#,###").format(data[i]['Thu Bù']??0),index: i,textColor: data[i]['Thu Bù'].toString().contains('-') ? Colors.red : Colors.blue,alignment: Alignment.centerRight,pdRight: 5)),
                    ],
                  );
                }
              },
            );
          }))
        ],
      ),

    );
  }
}


 