import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sd_pmn/config/server.dart';
import 'package:sd_pmn/controllers/ctl_baocao.dart';
import 'package:sd_pmn/widgets/wgt_groupbtn.dart';

class VBC_ChiTiet extends StatelessWidget {
  const VBC_ChiTiet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Sv_Color.main[100],
      appBar: AppBar(
        title: Obx(() => Text(
            "${Ctl_BaoCaoChiTiet().to.tenKhach} (${Ctl_BaoCaoChiTiet().to.Mien}) - ${Ctl_BaoCaoChiTiet().to.dataLoad1.value.length} tin")),
      ),
      body: SizedBox(
        width: Get.width,
        height: Get.height,
        // padding: EdgeInsets.all(8),
        child: Obx(() {
          List<Map<String, dynamic>> data = Ctl_BaoCaoChiTiet().to.dataLoad1.value;
          Ctl_BaoCaoChiTiet().to.kieuBC = 'Báo cáo 1';
          return PageView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: data.length,
            itemBuilder: (context, i) {
              return Padding(
                padding: const EdgeInsets.all(1.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 30,
                      width: 100,
                      alignment: Alignment.center,
                      color: Colors.grey,
                      child: Text((i+1).toString(),style: TextStyle(
                        // fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      ),),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      width: Get.width,
                      height: 150,
                      color: Colors.white,
                      child: SingleChildScrollView(
                          child: Text(data[i]['TinXL']??'',
                              overflow: TextOverflow.fade)),
                    ),

                    /// -----------------------------------------------------------------------------------------*
                    /// Container Xac, Von, Trung, LaiLo
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blueGrey[50],
                      ),
                      height: 90,
                      width: Get.width,
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              itemKQ(
                                  text: "Xác:",
                                  sb: 23,
                                  wgt: Text(data[i]['Xac'].toString(),
                                       )),
                              itemKQ(
                                  text: "Vốn:",
                                  wgt: Text(data[i]['Von'].toString(),
                                     )),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              itemKQ(
                                  text: "Trúng:",
                                  wgt: Text(data[i]['Trung'].toString(),
                                      )),
                              itemKQ(
                                  text: "Tổng:",
                                  wgt: Text(
                                    data[i]['LaiLo'].toString(),
                                    style: TextStyle(
                                        color: data[i]['LaiLo']
                                                .toString()
                                                .contains('-')
                                            ? Colors.red
                                            : Colors.blue,
                                         ),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),

                    /// -----------------------------------------------------------------------------------------*
                    SizedBox(
                      width: Get.width,
                      child: Obx(()=>Wgt_GroupButton(
                        items: [
                          'Báo cáo 1',
                          'Báo cáo 2',
                        ],
                        valueSelected: Ctl_BaoCaoChiTiet().to.kieuBC,
                        colorSelected: Sv_Color.main,
                        colorUnselected: Colors.white,
                        textColorUnselected: Sv_Color.main,
                        onChange: (e) {
                          Ctl_BaoCaoChiTiet().to.kieuBC = e;
                        },
                        // heightItem: 40,
                      )),
                    ),
                    Obx((){
                      if(Ctl_BaoCaoChiTiet().to.kieuBC == 'Báo cáo 1'){
                        return SizedBox(
                          width: Get.width,
                          child: Table(
                            border: TableBorder.all(color: Colors.grey,width: 0.2),
                            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                            columnWidths: {0: FixedColumnWidth(30)},
                            children: [
                              TableRow(decoration: BoxDecoration(
                                color: Sv_Color.main_1[50],
                              ),children: [
                                SizedBox(height: 30,child: Text('')),
                                Text('Số Trúng',textAlign: TextAlign.center,),
                                Text('Điểm trúng',textAlign: TextAlign.center),
                                Text('Tiền Trúng',textAlign: TextAlign.center),
                              ]),
                              row1(title: '2s', data: {
                                'SoTrung': data[i]['SoTrung2s'],
                                'DiemTrung': data[i]['DiemTrung2s'],
                                'TienTrung': data[i]['TienTrung2s'],
                              }),
                              row1(title: '3s', data: {
                                'SoTrung': data[i]['SoTrung3s'],
                                'DiemTrung': data[i]['DiemTrung3s'],
                                'TienTrung': data[i]['TienTrung3s'],
                              }), row1(title: '4s', data: {
                                'SoTrung': data[i]['SoTrung4s'],
                                'DiemTrung': data[i]['DiemTrung4s'],
                                'TienTrung': data[i]['TienTrung4s'],
                              }),
                              row1(title: 'Dt', data: {
                                'SoTrung': data[i]['SoTrungDt'],
                                'DiemTrung': data[i]['DiemTrungDt'],
                                'TienTrung': data[i]['TienTrungDt'],
                              }),
                              row1(title: 'Dx', data: {
                                'SoTrung': data[i]['SoTrungDx'],
                                'DiemTrung': data[i]['DiemTrungDx'],
                                'TienTrung': data[i]['TienTrungDx'],
                              })
                            ],
                          ),
                        );
                      }else{
                        return SizedBox(
                          width: Get.width,
                          child: Table(
                            border: TableBorder.all(color: Colors.grey,width: 0.2),
                            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                            columnWidths: {0: FixedColumnWidth(50)},
                            children: [
                              TableRow(
                                  decoration: BoxDecoration(
                                    color: Sv_Color.main_1[50],
                                  ),
                                children: [
                                  SizedBox(height: 30,child: Text('')),
                                  Text('Điểm',textAlign: TextAlign.center,),
                                  Text('Tiền',textAlign: TextAlign.center)
                                ]
                              ),
                              row2(title: 'AB', data: {
                                'Diem': data[i]['DiemAB'],
                                'Tien': data[i]['TienAB'],
                              }),
                              row2(title: 'XC', data: {
                                'Diem': data[i]['DiemXC'],
                                'Tien': data[i]['TienXC'],
                              }),
                              row2(title: 'Dt', data: {
                                'Diem': data[i]['DiemDt'],
                                'Tien': data[i]['TienDt'],
                              }),
                              row2(title: 'Dx', data: {
                                'Diem': data[i]['DiemDx'],
                                'Tien': data[i]['TienDx'],
                              }),
                              row2(title: 'Lô 2', data: {
                                'Diem': data[i]['Diemlo2'],
                                'Tien': data[i]['Tienlo2'],
                              }),
                              row2(title: 'Lô 3', data: {
                                'Diem': data[i]['Diemlo3'],
                                'Tien': data[i]['Tienlo3'],
                              }),
                              row2(title: 'Lô 4', data: {
                                'Diem': data[i]['Diemlo4'],
                                'Tien': data[i]['Tienlo4'],
                              })
                            ],
                          ),
                        );
                      }
                    })
                  ],
                ),
              );
            },
            // separatorBuilder: (BuildContext context, int index) {
            //   return const SizedBox(
            //     width: 10,
            //   );
            // },
          );
        }),
      ),
    );
  }

  TableRow row1({required String title, required Map<String, dynamic> data}){
    return TableRow(
      decoration: BoxDecoration(
        color: Colors.white
      ),
      children: [
        Text(title,textAlign: TextAlign.center,),
        PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
                textStyle:
                const TextStyle(color: Colors.black),
                child: Text(data['SoTrung'],style: Theme.of(context).textTheme.bodyLarge,))
          ],
          child: SizedBox(height: 30,child: Padding(
            padding: const EdgeInsets.only(top: 5,left: 3),
            child: Text(data['SoTrung']),
          )),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 5),
          child: Text(data['DiemTrung'],textAlign: TextAlign.right),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 5),
          child: Text(data['TienTrung'],textAlign: TextAlign.right),
        ),
      ]
    );
  }
  TableRow row2({required String title, required Map<String, dynamic> data}){
    return TableRow(
        decoration: BoxDecoration(
            color: Colors.white
        ),
        children: [
          SizedBox(height: 30,child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(title,textAlign: TextAlign.center,),
          )),
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Text(data['Diem'],textAlign: TextAlign.right),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Text(data['Tien'],textAlign: TextAlign.right),
          ),
        ]
    );
  }
}

Row itemKQ(
    {required String text,
    double sb = 10,
    double widthCt = 100,
    required Widget wgt}) {
  return Row(
    children: [
      Text(
        text,
      ),
      SizedBox(
        width: sb,
      ),
      Container(
        alignment: Alignment.center,
        width: widthCt,
        height: 30,
        color: Colors.white,
        child: wgt,
      )
    ],
  );
}
