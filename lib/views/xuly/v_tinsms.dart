import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sd_pmn/config/server.dart';
import 'package:sd_pmn/controllers/ctl_xuly.dart';
import 'package:sd_pmn/widgets/wgt_button.dart';
import 'package:sd_pmn/widgets/wgt_dropdown.dart';

class V_TinSMS extends StatelessWidget {
  const V_TinSMS({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text('Tin SMS (${Ctl_Xuly().to.soTin})')),
        actions: [
          Obx(() => Wgt_Dropdown(items: const ['All','Nhận','Gửi'],value: Ctl_Xuly().to.typeSMS, onChange: (value){
            Ctl_Xuly().to.typeSMS = value!;
          })
          )
        ],
      ),
      body: Obx(() {
        List<Map<String, dynamic>> data = Ctl_Xuly().to.lstSMS;
        List<Map<String, dynamic>> lstSelect = Ctl_Xuly().to.lstSelectSMS;
        return ListView.separated(
          itemCount: data.length,
          itemBuilder: (context, i) {
            return CheckboxListTile(
              value: lstSelect.contains(data[i]),
              secondary: Container(
                margin: EdgeInsets.only(left: 10),
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Sv_Color.main.withOpacity(.8),
                ),
                child: Text((i+1).toString(),style: TextStyle(color: Colors.white),),
              ),
              contentPadding: EdgeInsets.zero,
              // activeColor: Colors.grey,
              tileColor: lstSelect.contains(data[i]) ? Colors.blue[100] : null,
              onChanged: (value) {
                Ctl_Xuly().to.onChonSMS(data[i], value!);
              },
              subtitle: Text(data[i]['Date']),
              title: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 150,
                ),
                child: SingleChildScrollView(
                  child: Text(data[i]['Tin'],
                     ),
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(),
        );
      }),
      persistentFooterButtons: [
        Obx(() => Wgt_button(onPressed: (){ Ctl_Xuly().to.onChapNhanSMS();
          }, text: 'Chấp nhận ${Ctl_Xuly().to.lstSelectSMS.length}'))
      ],
    );
  }
}
