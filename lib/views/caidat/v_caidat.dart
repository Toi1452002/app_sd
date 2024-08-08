import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sd_pmn/config/server.dart';
import 'package:sd_pmn/controllers/ctl_caidat.dart';
import 'package:sd_pmn/controllers/ctl_xuly.dart';

import '../../widgets/widgets.dart';

class V_CaiDat extends StatelessWidget {
  V_CaiDat({super.key});

  Ctl_CaiDat controller = Get.put(Ctl_CaiDat());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cài đặt"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            item('Tùy chọn',onTap: (){
              Ctl_CaiDat().to.onLoadTuyChon();
              Get.dialog(Dialog(
                insetPadding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: const Text("Lấy 3 con"),
                      subtitle: const Text(
                          '1234b1.b1.xc1.dd1=1234b1.234b1.234.xc1.34dd1'),
                      trailing: Obx(() => Switch(
                          value: controller.kXc,
                          onChanged: (value) {
                            controller.kXc = value;
                            controller.onUpdateTuyChon(
                                'kxc', value ? 1 : 0);
                          })),
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text("Đối '.' thành ' '"),
                      subtitle: const Text("Đổi dấu '.' thành dấu ' ' khi xử lý tin"),
                      trailing: Obx(() => Switch(
                          value: controller.bDoiDauCach,
                          onChanged: (value) {
                            controller.bDoiDauCach = value;
                          })),
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text("An ủi"),
                      subtitle: const Text(
                          'Vd: Đánh 14, ra 15 hoặc 16 được an ủi'),
                      trailing: SizedBox(
                        width: 50,
                        child: WgtTextField(
                          controller: controller.txtAnui,
                          textInputType: TextInputType.number,
                          fillColor: Colors.white.withOpacity(.8),
                          onChanged: (value) {
                            if(value=='') value= '0';
                            controller.onUpdateTuyChon('au', value );
                          },
                          maxLength: 2,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ));
            }),
            item('Sao lưu dữ liệu',onTap: (){
              WgtDialog(
                  title: 'Thông báo',
                  text: 'Sao lưu dữ liệu?',
                  onConfirm: () {
                    controller.onSaoLuu();
                  });
            }),
            item('Khôi phục dữ liệu',onTap: (){
              WgtDialog(
                  title: 'Thông báo',
                  text: 'Khôi phục sẽ làm mất dữ liệu hiện tại!',
                  onConfirm: () {
                    controller.onKhoiPhuc();
                  });
            }),
            // const SizedBox(
            //   height: 10,
            // ),
            Visibility(visible: Platform.isAndroid ,child:item(
              "Cập nhật ứng dụng",
              onTap: () {
                controller.onCapNhat();
              },

            ),),
            // const SizedBox(
            //   height: 10,
            // ),
            item(
              "Tài khoản",
              onTap: () {
                controller.clearTextChangePassword();
                controller.taikhoanCTL.text = Info_App.Username;
                if (Info_App.Username == 'pmn') {
                  controller.onOpenDialogPMN();
                }
                Get.dialog(Dialog(
                  child: Info_App.Username != 'pmn'
                      ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                            children: [
                              WgtTextField(
                                fillColor: Colors.white.withOpacity(.8),
                                controller: controller.taikhoanCTL,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              WgtTextField(
                                fillColor: Colors.white.withOpacity(.8),
                                labelText: 'Mật khẩu mới',
                                obscureText: true,
                                controller: controller.matkhaumoiCTl,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              WgtTextField(
                                fillColor: Colors.white.withOpacity(.8),
                                controller: controller.xn_matkhaumoiCTl,
                                obscureText: true,
                                labelText: 'Xác nhận mật khẩu mới',
                              ),
                              const SizedBox(height: 10,),
                              Wgt_button(
                                color: Colors.teal.shade200,
                                onPressed: () {
                                  controller.onChangePassword();
                                },
                                text: "Chấp nhận",
                                height: 40,
                              )
                            ],
                          ),
                      )
                      : Obx(() => Padding(
                        padding: EdgeInsets.all(5),
                        child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Username: ${controller.username}'),
                                Text('Password: ${controller.password}'),
                              ],
                            ),
                      )),
                ));
              },
            ),
            item(
                "Xóa tất cả tin nhắn",
              textColor: Colors.red,
              onTap: () {
                WgtDialog(
                    title: 'Thông báo',
                    text: 'Toàn bộ tin nhắn sẽ bị xóa?',
                    onConfirm: () {
                      Ctl_Xuly().to.onDeleteAllTin();
                      Get.back();
                    });
              },
            ),
          ],
        ),
      ),
    );
  }


  Widget item(String title, {void Function()? onTap, Color? textColor}){
    return Card(
      color: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3)
      ),
      child: ListTile(
        onTap: onTap,
        title: Text(title,style: TextStyle(
          color: textColor ,
          fontWeight: FontWeight.bold,
          fontSize: 14
        ),),
      ),
    );
  }
}
