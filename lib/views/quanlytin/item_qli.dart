import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/router.dart';
import '../../config/server.dart';
import '../../controllers/ctl_quanlytin.dart';
import '../../controllers/ctl_xuly.dart';
import '../../function/extension.dart';
import '../../models/mdl_ql_tinct.dart';
import '../../widgets/wgt_dialog.dart';

class ItemQli extends StatelessWidget {
  ItemQli({super.key, required this.data});

  List<QliTinCTModel> data;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, i) {
          return Container(
            decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Sv_Color.main))),
            child: ListTile(
              leading: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: data[i].TongTien == null
                        ? Colors.grey[300]
                        : Sv_Color.main.withOpacity(.8),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Text(
                  (i+1).toString(),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(
                data[i].TinXL,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                      value: 1,
                      child: Text(
                        "Sửa",
                        style: Theme.of(context).textTheme.bodyLarge,
                      )),
                  PopupMenuItem(
                      value: 2,
                      child: Text("Xem chi tiết",
                          style: Theme.of(context).textTheme.bodyLarge)),
                  PopupMenuItem(
                      value: 3,
                      child: Text("Xóa",
                          style: Theme.of(context).textTheme.bodyLarge)),
                ],
                onSelected: (value) {
                  switch (value) {
                    case 1:
                      Ctl_Xuly().to.onEditTin(
                          ID: data[i].ID!,
                          mien: data[i].Mien,
                          khachID: data[i].KhachID ?? 0,
                          tin: data[i].TinXL,
                          ngay: Ctl_Quanlytin().to.ngaylam);
                      Get.toNamed(routerName.v_xuly)?.then((value) {
                        Ctl_Xuly().to.onLoadTinNhan();
                        Ctl_Quanlytin()
                            .to
                            .onLoadTinCT(data[i].KhachID.toString());
                      });
                      break;
                    case 2:
                      Get.toNamed(routerName.v_xemchitiet, parameters: {
                        'ID': data[i].ID.toString(),
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
                            Ctl_Quanlytin()
                                .to
                                .onDeleteTin(data[i].ID!, data[i].KhachID!);
                          });
                      break;
                  }
                },
              ),
            ),
          );
        });
  }
}
