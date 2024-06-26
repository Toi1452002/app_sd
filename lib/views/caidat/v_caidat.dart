import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sd_pmn/config/server.dart';
import 'package:sd_pmn/controllers/ctl_caidat.dart';
import 'package:sd_pmn/controllers/ctl_xuly.dart';
import 'package:sd_pmn/widgets/wgt_button.dart';
import 'package:sd_pmn/widgets/wgt_dialog.dart';
import 'package:sd_pmn/widgets/wgt_textfield.dart';

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
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Wgt_button(
              onPressed: () {
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
              },
              text: 'Tùy chọn',
              color: Colors.white,
              textColor: Colors.black,
              height: 50,
            ),
            const SizedBox(
              height: 10,
            ),
            Wgt_button(
              icon: Icons.cloud_upload,
              onPressed: () {

                WgtDialog(
                    title: 'Thông báo',
                    text: 'Sao lưu dữ liệu?',
                    onConfirm: () {
                      controller.onSaoLuu();
                    });
              },
              text: 'Sao lưu dữ liệu',
              color: Colors.white,
              textColor: Colors.black,
              height: 50,
            ),
            const SizedBox(
              height: 10,
            ),
            Wgt_button(
              icon: Icons.cloud_download,
              onPressed: () {
                WgtDialog(
                    title: 'Thông báo',
                    text: 'Khôi phục sẽ làm mất dữ liệu hiện tại!',
                    onConfirm: () {
                      controller.onKhoiPhuc();
                    });
              },
              text: 'Khôi phục dữ liệu',
              color: Colors.white,
              textColor: Colors.black,
              height: 50,
            ),
            const SizedBox(
              height: 10,
            ),
            Platform.isAndroid ? Wgt_button(
              onPressed: () {
                controller.onCapNhat();
              },
              text: "Cập nhật ứng dụng",
              color: Colors.white,
              textColor: Colors.black,
              height: 50,
              icon: Icons.update,
            ) : const SizedBox(),
            const SizedBox(
              height: 10,
            ),
            Wgt_button(
              onPressed: () {
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
                      : Obx(() => Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Username: ${controller.username}'),
                              Text('Password: ${controller.password}'),
                            ],
                          )),
                ));
              },
              text: "Tài khoản",
              color: Colors.white,
              textColor: Colors.black,
              height: 50,
              icon: Icons.person,
            ),
            const SizedBox(
              height: 10,
            ),
            Wgt_button(
              onPressed: () {
                WgtDialog(
                    title: 'Thông báo',
                    text: 'Toàn bộ tin nhắn sẽ bị xóa?',
                    onConfirm: () {
                      Ctl_Xuly().to.onDeleteAllTin();
                      Get.back();
                    });
              },
              text: "Xóa tất cả tin nhắn",
              color: Colors.white,
              textColor: Colors.red,
              height: 50,
              icon: Icons.delete,
            ),
          ],
        ),
      ),
    );
  }
}
