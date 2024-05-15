import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sd_pmn/config/router.dart';
import 'package:sd_pmn/controllers/ctl_khach.dart';
import 'package:sd_pmn/controllers/ctl_xuly.dart';
import '../../config/server.dart';
import '../../widgets/widgets.dart';

class V_Xuly extends StatelessWidget {
  V_Xuly({super.key});

  @override
  Widget build(BuildContext context) {
    double scaleText = MediaQuery.textScalerOf(context).scale(1);
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
          appBar: AppBar(
            title: Obx(() => Text("Mã tin: ${Ctl_Xuly().to.matin}")),
            actions: [
              Obx(() => Wgt_button(
                disable: Ctl_Xuly().to.bDaTinh,
                onPressed: () async {
                  DateTime? newDate = await showDatePicker(
                    locale: const Locale("vi", ""),
                    context: context,
                    initialEntryMode: DatePickerEntryMode.calendar,
                    initialDate: Ctl_Xuly().to.ngaylam,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                    fieldHintText: "Ngày/Tháng/Năm",
                    helpText: "Chọn ngày",
                  );
                  if (newDate != null) {
                    Ctl_Xuly().to.ngaylam = newDate;
                    Ctl_Xuly().to.onChange(newDate, kieu: 'ngay');
                  }
                },
                text: DateFormat("dd/MM/yyyy").format(Ctl_Xuly().to.ngaylam),
              )),
              Platform.isAndroid ? PopupMenuButton(itemBuilder: (context)=>[
                PopupMenuItem(child: Text('Tin SMS',style: Theme.of(context).textTheme.bodyLarge,),value: 1,)
              ],
              onSelected: (value){
                if(value==1){
                  // Ctl_Xuly().to.typeSMS = 'All';
                  Ctl_Xuly().to.getAllMessages();
                  Get.toNamed(routerName.v_tinsms);
                }
              },
              ) : const SizedBox()
            ],
          ),
          drawer: Ctl_Xuly().to.bUpdate ? null : const Wgt_Drawer(),
          body: Padding(
            padding: const EdgeInsets.all(3.0),
            child: ListView(
              children: [
                /** 2 Combobox **/
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Khách: ",
                          style: TextStyle(
                               fontWeight: FontWeight.bold),
                        ),
                        Obx(() {
                          List<String> k = Ctl_Khach().to.lstKhach.map((e) => e.MaKhach).toList();
                          String? value = Ctl_Xuly().to.maKhach;
                          if (!k.contains(value) || value == "") value = null;
                          return InkWell(
                            onLongPress: ()=>Ctl_Xuly().to.onEditMaKhach(),
                            child: Wgt_Dropdown(
                                disable: Ctl_Xuly().to.bDaTinh,
                                widh: 180,
                                hint: value == "" ? "Chọn khách" : "",
                                value: value,
                                items: k,
                                onChange: (value) {
                                  Ctl_Xuly().to.maKhach = value!;
                                  Ctl_Xuly().to.onChange(value, kieu: 'makhach');
                                }),
                          );
                        })
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Miền: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold),
                        ),
                        Obx(() => Wgt_Dropdown(
                            widh: 150,
                            disable: Ctl_Xuly().to.bDaTinh,
                            value: Ctl_Xuly().to.mien,
                            items: const ["Nam", "Trung", "Bắc"],
                            onChange: (value) {
                              Ctl_Xuly().to.mien = value!;
                              Ctl_Xuly().to.onChange(value, kieu: 'mien');
                            }))
                      ],
                    ),
                  ],
                ),

                /// -----------------------------------------------------------------------------------------*
                /** 2 Button (Kiem loi--Tinh Toan **/
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Obx(() {
                        return Wgt_button(
                          color: Colors.blue,
                          disable: Ctl_Xuly().to.matin == 0 ? true : false,
                          onPressed: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            Ctl_Xuly().to.onKiemLoi();
                          },
                          text: "Kiểm lỗi",
                          height: 40,
                        );
                      }),
                    ),
                    Expanded(
                      child: Obx(()=>Wgt_button(
                        onPressed: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          Ctl_Xuly().to.onTinhToan();
                        },
                        disable: !Ctl_Xuly().to.enableTinhToan,
                        text: "Tính toán",
                        color: Colors.red[300],
                        height: 40,
                      )),
                    ),
                  ],
                ),

                /// -----------------------------------------------------------------------------------------*
                /** Container kết quả **/
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[50],
                  ),
                  // height: 90,
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          itemKQ(text: "Xác:",scale: scaleText, sb: 23, wgt: Obx(() => Text(Ctl_Xuly().to.tienXac,style:  TextStyle(
                            fontSize: 16/scaleText
                          ),))),
                          itemKQ(text: "Vốn:",scale: scaleText, wgt: Obx(() => Text(Ctl_Xuly().to.tienVon,style: TextStyle(
                            fontSize: 16/scaleText
                          ),))),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          itemKQ(text: "Trúng:",scale: scaleText, wgt:  Obx(() => Text(Ctl_Xuly().to.tienTrung,style:  TextStyle(
                            fontSize: 16/scaleText
                          ),))),
                          itemKQ(text: "Tổng:",scale: scaleText, wgt: Obx(() => Text(Ctl_Xuly().to.thuBu,style: TextStyle(
                            color: Ctl_Xuly().to.thuBu.contains('-')? Colors.red : Colors.blue,
                            fontSize: 16/scaleText
                          ),))),
                        ],
                      ),
                    ],
                  ),
                ),

                /// -----------------------------------------------------------------------------------------*
                /** TextFied Nhập tin **/

                Obx(() => WgtTextField(
                      fillColor: Colors.white,
                      controller: Ctl_Xuly().to.tinController,
                      enable:  Ctl_Xuly().to.enableText,
                      errorText: Ctl_Xuly().to.txtErr == ''
                          ? null
                          : Ctl_Xuly().to.txtErr,
                      maxLines: 10,
                      // undoController: Ctl_Xuly().to.undoController,
                      onChanged: (value) {
                        Ctl_Xuly().to.onUpdateTin(value);
                      },
                    )),

                  /// -----------------------------------------------------------------------------------------*
                  const SizedBox(
                    height: 10,
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() {
                      if(Ctl_Xuly().to.bUpdate){
                        return SizedBox();
                      }else{
                        return Row(
                          children: [
                            Text('Đã tính'),
                            Obx(()=>Checkbox(value: Ctl_Xuly().to.bDaTinh, onChanged: (value){
                              Ctl_Xuly().to.onChange(value,kieu: 'DaTinh');
                            })),
                          ],
                        );
                      }
                    }),

                    Wgt_button(
                      disable: Ctl_Xuly().to.bUpdate ? true : false,
                      color: Sv_Color.main,

                      onPressed: () {
                        Ctl_Xuly().to.onThemTin();

                      },
                      textColor: Colors.white,
                      icon: Icons.add,
                      text: "Thêm tin mới",
                    ),
                  ],
                )
              ],
            ),
          ),

      ),

    );
  }
  Row itemKQ(
      {required String text,
        double sb = 10,
        double scale = 0,
        double widthCt = 100,
        required Widget wgt}) {
    return Row(
      children: [
        Text(
          text,
          style: TextStyle(fontSize: 15/scale),
        ),
        SizedBox(
          width: sb,
        ),
        Container(
          alignment: Alignment.center,
          width: widthCt,
          height: 30,
          color: Colors.white,
          child: wgt,
        )
      ],
    );
  }
}


