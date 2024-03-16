import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sd_pmn/config/router.dart';
import 'package:sd_pmn/config/server.dart';
import 'package:sd_pmn/controllers/ctl_baocao.dart';
import 'package:sd_pmn/widgets/wgt_table.dart';

class Tbl_BCTongHop extends StatelessWidget {
  const Tbl_BCTongHop({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /** Header **/
        Row(
          children: [
            Expanded(flex: 1,child: cell_Header(text: 'Miền',border: true),),
            Expanded(flex: 2,child: cell_Header(text: 'Xác',border: true),),
            Expanded(flex: 2, child: cell_Header(text: 'Vốn',border: true)),
            Expanded(flex: 2, child: cell_Header(text: 'Trúng',border: true)),
            Expanded(flex: 2, child: cell_Header(text: 'Tổng',border: true)),
          ],
        ),
        /// -----------------------------------------------------------------------------------------*
        /** Row Tổng tiền **/
        Obx(() => Row(
          children: [
            Expanded(flex: 1,child: cell_Body(text: ''),),
            Expanded(flex: 2,child: PopupMenuButton(
              offset: const Offset(80,-10),
              tooltip: 'Xác',
              itemBuilder: (BuildContext context) {
                List<PopupMenuItem> pp = [];
                if(Ctl_BaoCaoTongHop().to.tongXac2 != '0') pp.add(PopupMenuItem(textStyle: TextStyle(color: Colors.black),height: 30, child: Text("Xac2s: ${Ctl_BaoCaoTongHop().to.tongXac2}")));
                if(Ctl_BaoCaoTongHop().to.tongXac3 != '0') pp.add(PopupMenuItem(textStyle: TextStyle(color: Colors.black),height: 30, child: Text("Xac3s: ${Ctl_BaoCaoTongHop().to.tongXac3}")));
                return pp;
              },
              child: cell_Body(text: Ctl_BaoCaoTongHop().to.tongXac,alignment: Alignment.centerRight,pdRight: 5),
            ),),
            Expanded(flex: 2, child: cell_Body(text: Ctl_BaoCaoTongHop().to.tongVon,alignment: Alignment.centerRight,pdRight: 5)),
            Expanded(flex: 2, child: PopupMenuButton(
              tooltip: 'Trúng',
              enabled: Ctl_BaoCaoTongHop().to.tongTrung!= '0' ?true: false,
              offset: const Offset(-100,-10),
              itemBuilder: (BuildContext context) {
                List<PopupMenuItem> pp = [];
                if(Ctl_BaoCaoTongHop().to.tongTrung2s != '0') pp.add(PopupMenuItem(textStyle: const TextStyle(color: Colors.red),height: 30, child: Text("Trung2s: ${Ctl_BaoCaoTongHop().to.tongTrung2s}n")));
                if(Ctl_BaoCaoTongHop().to.tongTrung3s != '0') pp.add(PopupMenuItem(textStyle: const TextStyle(color: Colors.red),height: 30, child: Text("Trung3s: ${Ctl_BaoCaoTongHop().to.tongTrung3s}n")));
                if(Ctl_BaoCaoTongHop().to.tongTrung4s != '0') pp.add(PopupMenuItem(textStyle: const TextStyle(color: Colors.red),height: 30, child: Text("Trung4s: ${Ctl_BaoCaoTongHop().to.tongTrung4s}n")));
                if(Ctl_BaoCaoTongHop().to.tongTrungDt != '0') pp.add(PopupMenuItem(textStyle: const TextStyle(color: Colors.red),height: 30, child: Text("TrungDt: ${Ctl_BaoCaoTongHop().to.tongTrungDt}n")));
                if(Ctl_BaoCaoTongHop().to.tongTrungDx != '0') pp.add(PopupMenuItem(textStyle: const TextStyle(color: Colors.red),height: 30, child: Text("TrungDx: ${Ctl_BaoCaoTongHop().to.tongTrungDx}n")));
                return pp;
              },
              child: cell_Body(text: Ctl_BaoCaoTongHop().to.tongTrung,alignment: Alignment.centerRight,pdRight: 5),
            )),
            Expanded(flex: 2, child: cell_Body(text: Ctl_BaoCaoTongHop().to.tongTien,alignment: Alignment.centerRight,pdRight: 5,textColor: Ctl_BaoCaoTongHop().to.tongTien.contains('-')? Colors.red: Colors.blue)),
          ],
        )),
        /// -----------------------------------------------------------------------------------------*
        /** Body **/
        Expanded(child: Obx((){
          List<Map<String, dynamic>> data = Ctl_BaoCaoTongHop().to.lstBaoCao;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context,i){
              if(data[i]['ttMien']==0){
                return Container(
                  height: 30,
                  // alignment: Alignment.center,
                  padding: const EdgeInsets.only(left: 10,top: 5),
                  decoration: BoxDecoration(
                      color: Sv_Color.main[100]
                  ),
                  child: Text(data[i]['Khach'],style: const TextStyle(fontWeight: FontWeight.bold),),
                );
              }else{
                return InkWell(onLongPress: (){
                  Get.lazyPut(()=>Ctl_BaoCaoChiTiet());
                  Ctl_BaoCaoChiTiet().to.onLoadBCCT(Ctl_BaoCaoTongHop().to.ngay, data[i]['Khach'], data[i]['Mien']);
                  Get.toNamed(routerName.v_bcChiTiet);

                },child: Row(
                  children: [
                    Expanded(flex: 1,child: cell_Body(text: data[i]['Mien'])),
                    Expanded(flex: 2,child:
                    PopupMenuButton(
                      offset: const Offset(80,-10),
                      tooltip: 'Xác',
                      itemBuilder: (BuildContext context) {
                        List<PopupMenuItem> pp = [];
                        if(data[i]['Xac2s']!='') pp.add(PopupMenuItem(textStyle: TextStyle(color: Colors.black),height: 30,child: Text('Xac2s: ${data[i]['Xac2s']}'),));
                        if(data[i]['Xac3s']!='') pp.add(PopupMenuItem(textStyle: TextStyle(color: Colors.black),height: 30,child: Text('Xac3s: ${data[i]['Xac3s']}'),));
                        return pp;
                      },

                      child: cell_Body(text: data[i]['Xac'],alignment: Alignment.centerRight,pdRight: 5),
                    )
                    ),
                    Expanded(flex: 2, child: cell_Body(text: data[i]['Von'],alignment: Alignment.centerRight,pdRight: 5)),
                    Expanded(flex: 2, child: PopupMenuButton(
                      enabled: data[i]['Trung']!=''?true: false,
                      offset: const Offset(-100,-10),
                      tooltip: 'Trúng',
                      itemBuilder: (BuildContext context){
                        List<PopupMenuItem> pp = [];
                        if(data[i]['Trung2s']!='0') pp.add(PopupMenuItem(textStyle: const TextStyle(color: Colors.red),height: 30, child: Text("Trung2s: ${data[i]['Trung2s']}n")));
                        if(data[i]['Trung3s']!='0') pp.add(PopupMenuItem(textStyle: const TextStyle(color: Colors.red),height: 30, child: Text("Trung3s: ${data[i]['Trung3s']}n")));
                        if(data[i]['Trung4s']!='0') pp.add(PopupMenuItem(textStyle: const TextStyle(color: Colors.red),height: 30, child: Text("Trung4s: ${data[i]['Trung4s']}n")));
                        if(data[i]['TrungDt']!='0') pp.add(PopupMenuItem(textStyle: const TextStyle(color: Colors.red),height: 30, child: Text("TrungDt: ${data[i]['TrungDt']}n")));
                        if(data[i]['TrungDx']!='0') pp.add(PopupMenuItem(textStyle: const TextStyle(color: Colors.red),height: 30, child: Text("TrungDx: ${data[i]['TrungDx']}n")));
                        return pp;
                      },
                      child: cell_Body(text: data[i]['Trung'],alignment: Alignment.centerRight,pdRight: 5),
                    )),
                    Expanded(flex: 2, child: cell_Body(text: data[i]['thubu'],alignment: Alignment.centerRight,pdRight: 5,textColor: data[i]['thubu'].toString().contains('-')? Colors.red: Colors.blue)),
                  ],
                ),);
              }
            },
          );
        }))
      ],
    );
  }
}
