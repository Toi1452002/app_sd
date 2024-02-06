import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sd_pmn/controllers/clt_kqxs.dart';
import 'package:sd_pmn/widgets/wgt_button.dart';
import 'package:sd_pmn/widgets/wgt_dialog.dart';
import 'package:sd_pmn/widgets/wgt_groupbtn.dart';

import '../../config/server.dart';
import 'kqxs_table.dart';

class V_Kqxs extends StatelessWidget {
  const V_Kqxs({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("KQXS"),
        actions: [
          ElevatedButton(
            onPressed: () async {
              DateTime? newDate = await showDatePicker(
                locale: const Locale("vi", ""),
                context: context,
                initialEntryMode: DatePickerEntryMode.calendar,
                initialDate: Ctl_Kqxs().to.ngaylam,
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
                fieldHintText: "Ngày/Tháng/Năm",
                helpText: "Chọn ngày",
              );
              if (newDate != null) {
                Ctl_Kqxs().to.ngaylam = newDate;
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey[200],
                shape: const BeveledRectangleBorder()),
            child: Obx(() => Text(
                  DateFormat("dd/MM/yyyy").format(Ctl_Kqxs().to.ngaylam),
                  style: const TextStyle(color: Colors.black),
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: IconButton(
              onPressed: () {
                Get.dialog(Dialog(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      const Text("Thiết lập"),
                      const Divider(),
                      const SizedBox(
                        height: 5,
                      ),
                      ListTile(
                        title: const Text("Lấy kết quả xổ số Minh Ngọc"),
                        trailing: Obx(()=>Switch(
                          onChanged: (value) {
                            Ctl_Kqxs().to.xsMn = value;
                            Ctl_Kqxs().to.onChangeXsMn(value);
                          },
                          value: Ctl_Kqxs().to.xsMn,
                        )),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      // const Spacer(),
                      TextButton(
                          onPressed: () {
                            Wgt_Dialog(
                                title: "Thông báo",
                                text: "Có chắc muốn xóa hết kết quả xổ số?",
                                onConfirm: () {
                                    Ctl_Kqxs().to.onDeleteKqxs();
                                });
                          },
                          child: const Text(
                            "Xóa kết quả xổ số",
                            style: TextStyle(color: Colors.red),
                          ))
                    ],
                  ),
                ));
              },
              icon: const Icon(Icons.settings),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Wgt_GroupButton(
            items: const ["Nam", "Trung", "Bắc"],
            onChange: (x) {
              Ctl_Kqxs().to.mien = x[0];
            },
            heightItem: 50,
            valueSelected: "Nam",
            colorSelected: Sv_Color.main,
            colorUnselected: Colors.white,
            textColorUnselected: Sv_Color.main,

          ),
          Expanded(child: Obx((){
            if(Ctl_Kqxs().to.thongbao!=""){
              return Center(child: Text(Ctl_Kqxs().to.thongbao,style: const TextStyle(fontSize: 20, color: Colors.grey)));
            }else{
              return KqxsTable(listKqxs: Ctl_Kqxs().to.lstKqxs);
            }

          }))
        ],
      ),
      persistentFooterButtons: [
        Obx(() => Wgt_button(disable: Ctl_Kqxs().to.disableBtn.value,onPressed: (){
          Ctl_Kqxs().to.onGetKqxs();
        }, text: "Xem kết quả",width: Get.width,height: 35,))
      ],
    );
  }
}
