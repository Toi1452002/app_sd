import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sd_pmn/controllers/ctl_khach.dart';

import '../../widgets/wgt_textfield.dart';

class CauHinh extends StatelessWidget {
  const CauHinh({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(
          height: 10,
        ),
        Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Theme.of(context).primaryColor))),
          child: ListTile(
            title: const Text("Đá 2 đài chuyển thành đá xiên"),
            trailing: Obx(() => Switch(
              onChanged: (value) {
                Ctl_Khach().to.b_2dx.value = value;
              },
              value: Ctl_Khach().to.b_2dx.value,
            )),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Theme.of(context).primaryColor))),
          child: ListTile(
            title: const Text("Đầu trên"),
            trailing: Obx(() => Switch(
              onChanged: (value) {
                Ctl_Khach().to.b_dautren.value = value;
              },
              value: Ctl_Khach().to.b_dautren.value,
            )),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: WgtTextField(
                  labelText: "Hồi tổng",
                  fillColor: Colors.white,
                  textInputType: TextInputType.number,
                  controller: Ctl_Khach().to.hoiTongController,
                ),
              ),
              Expanded(
                child: WgtTextField(
                  labelText: "Hồi 2s",
                  fillColor: Colors.white,
                  textInputType: TextInputType.number,
                  controller: Ctl_Khach().to.hoi2SoController,
                ),
              ),
              Expanded(
                child: WgtTextField(
                  labelText: "Hồi 3s",
                  fillColor: Colors.white,
                  textInputType: TextInputType.number,
                  controller: Ctl_Khach().to.hoi3SoController,
                ),
              ),
            ],
          ),
        ),
        Platform.isAndroid ? Padding(
          padding: const EdgeInsets.all(8.0),
          child: WgtTextField(
            fillColor: Colors.white,
            labelText: 'Số điện thoại',
            controller: Ctl_Khach().to.sdtCTL,
            textInputType: TextInputType.phone,
          ),
        ) : const SizedBox(),
        Padding(
          padding: const EdgeInsets.only(left: 8,right: 8),
          child: GetBuilder<Ctl_GiaKhach>(builder: (controller) {
            return Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).primaryColor)),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Thưởng đá thẳng",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          const Text("Miền Nam"),
                          const SizedBox(
                            width: 3,
                          ),
                          Checkbox(
                              value: controller.ck_thuongMN.value,
                              onChanged: (value) =>
                                  controller.thay_doi_thuongDT(value!, "N"))
                        ],
                      ),
                      Row(
                        children: [
                          const Text("Thêm chi"),
                          Checkbox(
                              fillColor: MaterialStateProperty.resolveWith(
                                      (states) => controller.ck_thuongMN.value
                                      ? null
                                      : Colors.grey[400]),
                              value: controller.ck_themchiMN.value,
                              onChanged: (value) => controller.ck_thuongMN.value
                                  ? controller.thay_doi_themchi(value!, "N")
                                  : null)
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          const Text("Miền Trung"),
                          Checkbox(
                              value: controller.ck_thuongMT.value,
                              onChanged: (value) =>
                                  controller.thay_doi_thuongDT(value!, "T"))
                        ],
                      ),
                      Row(
                        children: [
                          const Text("Thêm chi"),
                          Checkbox(
                              fillColor: MaterialStateProperty.resolveWith(
                                      (states) => controller.ck_thuongMT.value
                                      ? null
                                      : Colors.grey[400]),
                              value: controller.ck_themchiMT.value,
                              onChanged: (value) => controller.ck_thuongMT.value
                                  ? controller.thay_doi_themchi(value!, "T")
                                  : null)
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          const Text("Miền Bắc"),
                          const SizedBox(
                            width: 12,
                          ),
                          Checkbox(
                              value: controller.ck_thuongMB.value,
                              onChanged: (value) =>
                                  controller.thay_doi_thuongDT(value!, "B"))
                        ],
                      ),
                      Row(
                        children: [
                          const Text("Thêm chi"),
                          Checkbox(
                              fillColor: MaterialStateProperty.resolveWith(
                                      (states) => controller.ck_thuongMB.value
                                      ? null
                                      : Colors.grey[400]),
                              value: controller.ck_themchiMB.value,
                              onChanged: (value) => controller.ck_thuongMB.value
                                  ? controller.thay_doi_themchi(value!, "B")
                                  : null)
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        )
      ],
    );
  }
}
