// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sd_pmn/controllers/ctl_thaythetukhoa.dart';
import 'package:sd_pmn/widgets/wgt_button.dart';
import 'package:sd_pmn/widgets/wgt_dialog.dart';
import 'package:sd_pmn/widgets/wgt_textfiled.dart';

import '../../config/server.dart';

class V_ThaytheTK extends StatelessWidget {
  const V_ThaytheTK({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Thay thế từ khóa"),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                onPressed: () {
                  Ctl_ThaytheTK().to.ResetText();
                  Get.dialog(Dialog(
                    child: Container(
                      width: 400,
                      height: 150,
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: Obx(()=>Wgt_TextField(
                                    labelText: "Mô tả",
                                    controller: Ctl_ThaytheTK().to.motaController,
                                    errorText:  Ctl_ThaytheTK().to.motaErr=="" ? null : Ctl_ThaytheTK().to.motaErr,
                                    autofocus: true,
                                    onChanged: (value){
                                      Ctl_ThaytheTK().to.motaErr = "";
                                    },
                                  ))),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: Wgt_TextField(
                                    labelText: "Từ khóa",
                                    controller: Ctl_ThaytheTK().to.tukhoaController,
                                  )),
                            ],
                          ),
                          const Spacer(),
                          Wgt_button(
                            onPressed: () {
                              Ctl_ThaytheTK().to.onThemTuKhoa();
                            },
                            text: "Thêm",
                            width: 200,
                          )
                        ],
                      ),
                    ),
                  ));
                },
                icon: const Icon(Icons.add),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Row(
              children: [
                header(text: "", width: Get.width * .1, height: 40),
                header(text: "Mô tả", width: Get.width * .45, height: 40),
                header(text: "Từ khóa", width: Get.width * .45, height: 40),
              ],
            ),
            Expanded(
                child: Obx(()=>ListView.builder(
                    itemCount: Ctl_ThaytheTK().to.lstTuKhoa.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Theme.of(context).primaryColor))),
                        child: InkWell(
                          onLongPress: () {
                            Wgt_Dialog(
                                title: "Thông báo",
                                text: Sv_String.deleteItem,
                                onConfirm: () {
                                  Ctl_ThaytheTK().to.onDeleteData(Ctl_ThaytheTK().to.lstTuKhoa[index].ID!);
                                });
                          },
                          onTap: () { ///Sửa
                            Ctl_ThaytheTK().to.ResetText();
                            Ctl_ThaytheTK().to.onEdit(Ctl_ThaytheTK().to.lstTuKhoa[index]);
                            Get.dialog(Dialog(
                              child: Container(
                                width: 400,
                                height: 150,
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: Obx(()=>Wgt_TextField(
                                              labelText: "Mô tả",
                                              controller: Ctl_ThaytheTK().to.motaController,
                                              errorText:  Ctl_ThaytheTK().to.motaErr==""?null: Ctl_ThaytheTK().to.motaErr,
                                              autofocus: true,
                                              onChanged: (value){
                                                Ctl_ThaytheTK().to.motaErr = "";
                                              },
                                            ))),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                            child: Wgt_TextField(
                                              labelText: "Từ khóa",
                                              controller: Ctl_ThaytheTK().to.tukhoaController,
                                            )),
                                      ],
                                    ),
                                    const Spacer(),
                                    Wgt_button(
                                      onPressed: () {
                                        Ctl_ThaytheTK().to.onUpdate();
                                      },
                                      text: "Sửa",
                                      width: 200,
                                    )
                                  ],
                                ),
                              ),
                            ));
                          },
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        right: BorderSide(
                                            color: Theme.of(context)
                                                .primaryColor))),
                                width: Get.width * .1,
                                alignment: Alignment.center,
                                height: 40,
                                child: Text((index + 1).toString()),
                              ),
                              Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    border: Border(
                                        right: BorderSide(
                                            color: Theme.of(context)
                                                .primaryColor))),
                                width: Get.width * .45,
                                height: 40,
                                child: Text(Ctl_ThaytheTK()
                                    .to
                                    .lstTuKhoa[index]
                                    .CumTu),
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: Get.width * .45,
                                height: 40,
                                child: Text(Ctl_ThaytheTK()
                                    .to
                                    .lstTuKhoa[index]
                                    .ThayThe),
                              ),
                            ],
                          ),
                        ),
                      );
                    }))),
          ],
        ),
      ),
    );
  }
}

Container header({
  double width = 0,
  double height = 0,
  String text = '',
}) {
  return Container(
    alignment: Alignment.center,
    width: width,
    height: height,

    decoration: BoxDecoration(
      color: Sv_Color.main[200],
      border: const Border(right: BorderSide(color: Colors.blueGrey))
    ),
    child: Text(
      text,
      style: const TextStyle(color: Colors.white, fontSize: 15),
    ),
  );
}
