// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:sd_pmn/controllers/ctl_quanlytin.dart';
import 'package:sd_pmn/controllers/ctl_xuly.dart';
import 'package:sd_pmn/function/extension.dart';
import 'package:sd_pmn/config/router.dart';
import 'package:sd_pmn/widgets/wgt_dialog.dart';

import '../../config/server.dart';

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
        List<Map<String, dynamic>> data = Ctl_Quanlytin().to.lstTinCT;

        int k = 0;
        return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, i) {
              if (data[i]['ID'] == 0) {
                return Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Sv_Color.main[50],
                    border:
                        const Border(bottom: BorderSide(color: Sv_Color.main)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 100,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: Colors.blueGrey,

                          // borderRadius: BorderRadius.only(topRight: Radius.circular(50),bottomRight: Radius.circular(50)),
                          // boxShadow: [
                          //   BoxShadow(color: Sv_Color.main  ,blurRadius: 1,offset: Offset(2,0))
                          // ]
                        ),
                        child: Text(
                          replaceMien(data[i]['Mien']),
                          style: const TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                );
              } else {

                k += 1;
                return Container(
                  decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Sv_Color.main))),
                  child: ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: data[i]['TongTien']==null ? Colors.grey[300] : Sv_Color.main.withOpacity(.8),

                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      child: Text(
                        (k).toString(),
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      data[i]["TinXL"] ?? '',
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                         PopupMenuItem(value: 1, child: Text("Sửa",style: Theme.of(context).textTheme.bodyLarge,)),
                         PopupMenuItem(value: 2, child: Text("Xem chi tiết",style: Theme.of(context).textTheme.bodyLarge)),
                         PopupMenuItem(value: 3, child: Text("Xóa",style: Theme.of(context).textTheme.bodyLarge)),
                      ],
                      onSelected: (value) {
                        switch (value) {
                          case 1:
                            Ctl_Xuly().to.onEditTin(
                                ID: data[i]['ID'],
                                mien: data[i]['Mien'],
                                khachID: data[i]['KhachID']??0,
                                tin: data[i]['TinXL']??'',
                                ngay: Ctl_Quanlytin().to.ngaylam);
                            Get.toNamed(routerName.v_xuly)?.then((value){
                              Ctl_Xuly().to.onLoadTinNhan();
                              Ctl_Quanlytin().to.onLoadTinCT(data[i]['KhachID'].toString());
                            });
                            break;
                          case 2:
                            Get.toNamed(routerName.v_xemchitiet,parameters: {
                              'ID' : data[i]['ID'].toString(),
                            });

                            // !.whenComplete(() async{
                            //   await Ctl_Quanlytin().to.xemchitiet(data[i]['ID'],data[i]['TinXL']??'');
                            // });
                            // Ctl_Quanlytin().to.xemchitiet(data[i]['ID']);
                            break;
                          case 3:
                            WgtDialog(
                                title: "Thông báo",
                                text: Sv_String.deleteItem,
                                onConfirm: () {
                                  Ctl_Quanlytin().to.onDeleteTin(data[i]['ID'], data[i]['KhachID']);
                                });
                            break;
                        }
                      },
                    ),
                  ),
                );
              }
            });
      }),
    );
  }
}
