// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sd_pmn/controllers/ctl_khach.dart';
import 'package:sd_pmn/models/mdl_khach.dart';
import 'package:sd_pmn/config/router.dart';
import 'package:sd_pmn/widgets/wgt_dialog.dart';

import '../../config/server.dart';

class V_LstKhach extends StatelessWidget {
  const V_LstKhach({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Obx(()=>Text("Danh sách khách (${Ctl_Khach().to.lstKhach.length})",)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
                onPressed: () {
                  Ctl_Khach().to.ResetText();
                  Get.toNamed(routerName.v_themkhach);
                },
                icon: const Icon(
                  Icons.add,
                  size: 30,
                  opticalSize: 15,
                )),
          )
        ],
      ),
      body: Obx((){
        List<KhachModel> khach = Ctl_Khach().to.lstKhach;
        if(khach.isEmpty){
          return const Center(child: Text("Chưa có khách hàng\n Nhấn (+) để thêm khách hàng",textAlign: TextAlign.center,style: TextStyle(color: Colors.grey,fontSize: 20),),);
        }else{
          return ListView.separated(
            itemCount: khach.length,
            itemBuilder: (context, i) {
              return ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Sv_Color.main.withOpacity(.8),
                      borderRadius: const BorderRadius.all(Radius.circular(10))
                  ),
                  child: Text((i+1).toString(),style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                ),
                title: Text(khach[i].MaKhach),
                subtitle:khach[i].SDT!='' ? Text(khach[i].SDT) : null,
                trailing: PopupMenuButton(
                  itemBuilder: (BuildContext context) {
                    return const [
                      PopupMenuItem(value: 1, child: Text("Sửa")),
                      PopupMenuItem(value: 2,child: Text("Sao chép"),),
                      PopupMenuItem(value: 3,child: Text("Xóa"),),
                    ];
                  },
                  onSelected: (value){
                    switch(value){
                      case 1:
                        Ctl_Khach().to.ResetText();
                        Ctl_Khach().to.onEdit(khach[i]);
                        Get.toNamed(routerName.v_themkhach);
                        break;
                      case 2:
                        Ctl_Khach().to.ResetText();
                        Ctl_Khach().to.onEdit(khach[i],copy: true);
                        Get.toNamed(routerName.v_themkhach);
                        break;
                      case 3:
                        Wgt_Dialog(title: "Có chắc muốn xóa?", text: "Toàn bộ dữ liệu của khách này sẽ mất", onConfirm: (){
                          Ctl_Khach().to.onDeleteKhach(khach[i].ID!);
                        });
                        break;
                    }
                  },
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(
                color: Sv_Color.main,
              );
            },
          );
        }
      }),
    );
  }
}
