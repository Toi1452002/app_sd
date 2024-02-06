import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sd_pmn/config/server.dart';
import 'package:sd_pmn/controllers/ctl_baocao.dart';
import 'package:sd_pmn/widgets/wgt_button.dart';

class Txt_BCTongHop extends StatelessWidget {
  const Txt_BCTongHop({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx((){
      List<Map<String, dynamic>> data = Ctl_BaoCaoTongHop().to.lstBaoCao;
      List<String> khach = data.map((e) => e['Khach'].toString()).toSet().toList();
      return ListView.builder(
        itemCount: khach.length,
        itemBuilder: (context,i){
          List<Map<String, dynamic>> tmp = data.where((e) => e['Khach']==khach[i]).where((e) => e['ttMien']!=0).toList();
          String text = khach[i];
          double tongTien = 0.0;
          for(var x in tmp){
              text += "\n- ${x['Mien']}: \n\t+ Xác: ${x['Xac']} (";
                if(x['Xac2s']!='') text+= "2s: ${x['Xac2s']} ";
                if(x['Xac3s']!='') text+= "3s: ${x['Xac3s']}";
              text = text.trim();
              text += ")";
              text += "\n\t+ Vốn: ${x['Von']}";
              if(x['Trung']!=''){
                text += "\n\t+ Trúng: ${x['Trung']} (";
                if(x['Trung2s']!='0') text += "2s: ${x['Trung2s']} ";
                if(x['Trung3s']!='0') text += "3s: ${x['Trung3s']} ";
                if(x['Trung4s']!='0') text += "4s: ${x['Trung4s']} ";
                if(x['TrungDt']!='0') text += "Dt: ${x['TrungDt']} ";
                if(x['TrungDx']!='0') text += "Dx: ${x['TrungDx']} ";
                text = text.trim();
                text += ")";
              }
              if(x['thubu'].toString().contains('-')){
                text += "\n\t+ Bù: ${x['thubu'].toString().replaceFirst('-', '')}";
              }else{
                text += "\n\t+ Thu: ${x['thubu']}";
              }
              tongTien += double.parse(x['thubu'].toString().replaceAll(',', ''));
          }
          if(tongTien>0){
            text += "\nTổng cộng thu: ${NumberFormat('#,###').format(tongTien).toString()}";
          }else{
            text += "\nTổng cộng bù: ${NumberFormat('#,###').format(tongTien).toString().replaceFirst('-', '')}";
          }

          return Container(
            padding: const EdgeInsets.only(left: 8,bottom: 8,top: 8),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.grey,blurRadius: 2,offset: Offset(0,3)),
              ]
            ),

            margin: const EdgeInsets.only(bottom: 5),
            child: Row(
              children: [
                Expanded(child: Text(text)),
                TextButton(child: const Text('Sao chép'),onPressed: (){
                  Clipboard.setData(ClipboardData(text: text));
                  EasyLoading.showToast("Sao chép thành công", toastPosition: EasyLoadingToastPosition.bottom);
                },),
              ],
            ),
          );
        },
      );

    });
  }
}
