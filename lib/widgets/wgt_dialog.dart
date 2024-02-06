import 'package:get/get.dart';
import 'package:flutter/material.dart';


void Wgt_Dialog(
    {
      required String title,
      required String text,
      required void Function()? onConfirm,

    }

    ){
  Get.dialog(
      Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 40),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Container(
          width: 200,
          height: 170,
          decoration: const BoxDecoration(
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(flex: 3,child: Container(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                      const SizedBox(height: 10,),
                      Text(text, style: const TextStyle( fontSize: 15),)
                    ],
                  ),
                ),
              )),
              Expanded(flex: 1,child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(10)),

                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(child: TextButton(onPressed: ()=>Get.back(), child: const Text("Hủy"),)),
                    Expanded(child: TextButton(onPressed: onConfirm, child: const Text("Chấp nhận")))
                  ],
                ),
              )),

            ],
          ),
        ),
      )
  );
}