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
        child: SizedBox(
          width: 200,
          // height: 170,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10,top: 10),
                child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10,top: 5,bottom: 10),
                child: Text(text ,),
              ),
              SizedBox(height: 10,),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(10)),

                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(child: TextButton(onPressed: ()=>Get.back(), child: const Text("Hủy",style: TextStyle(color: Colors.red),),)),
                    Expanded(child: TextButton(onPressed: onConfirm, child: const Text("Chấp nhận")))
                  ],
                ),
              ),

            ],
          ),
        ),
      )
  );
}