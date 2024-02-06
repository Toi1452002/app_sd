// import 'dart:ffi';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sd_pmn/controllers/ctl_xuly.dart';
//
// import '../../config/server.dart';
// import '../../widgets/wgt_table.dart';
//
// class XemChiTiet extends StatelessWidget {
//   const XemChiTiet({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: Get.height,
//       color: Colors.white,
//       child: Column(
//         children: [
//           Table(
//             border: TableBorder.all(color: Sv_Color.main, width: 0.5),
//             columnWidths: const {
//               0: FractionColumnWidth(.35),
//               1: FractionColumnWidth(.19),
//               2: FractionColumnWidth(.18),
//               3: FractionColumnWidth(.18),
//               4: FractionColumnWidth(.1),
//             },
//             children: [
//               TableRow(children: [
//                 cell_Header(text: 'Tin'),
//                 cell_Header(text: 'Xác'),
//                 cell_Header(text: 'Vốn'),
//                 cell_Header(text: 'Trúng'),
//                 cell_Header(text: 'SLT'),
//               ]),
//             ],
//           ),
//           Expanded(child: GetBuilder<Ctl_Xuly>(
//             builder: (ctl) {
//               List<TableRow> data = ctl.lstXemCT.value;
//               return SingleChildScrollView(
//                 child: Table(
//                   columnWidths: const {
//                     0: FractionColumnWidth(.35),
//                     1: FractionColumnWidth(.19),
//                     2: FractionColumnWidth(.18),
//                     3: FractionColumnWidth(.18),
//                     4: FractionColumnWidth(.1),
//                   },
//                   children: data,
//                   // children: data.map((e) {
//                   //   return TableRow(children: [
//                   //     PopupMenuButton(
//                   //         itemBuilder: (context) => [
//                   //               PopupMenuItem(
//                   //                   textStyle:
//                   //                       const TextStyle(color: Colors.black),
//                   //                   child: Text(e['Tin']))
//                   //             ],
//                   //         child: cell_Body(
//                   //             text: e['Tin'],
//                   //             alignment: Alignment.centerLeft,
//                   //             pdLeft: 5,
//                   //             textColor: e['SLT'] != '' ? Colors.red : null,
//                   //             index: e['i'])),
//                   //     cell_Body(
//                   //         text: e['Xac'],
//                   //         textColor: e['SLT'] != '' ? Colors.red : null,
//                   //         alignment: Alignment.centerRight,
//                   //         pdRight: 5,
//                   //         index: e['i']),
//                   //     cell_Body(
//                   //         text: e['Von'],
//                   //         textColor: e['SLT'] != '' ? Colors.red : null,
//                   //         alignment: Alignment.centerRight,
//                   //         pdRight: 5,
//                   //         index: e['i']),
//                   //     cell_Body(
//                   //         text: e['Trung'],
//                   //         textColor: e['SLT'] != '' ? Colors.red : null,
//                   //         alignment: Alignment.centerRight,
//                   //         pdRight: 5,
//                   //         index: e['i']),
//                   //     cell_Body(
//                   //         text: e['SLT'],
//                   //         textColor: e['SLT'] != '' ? Colors.red : null,
//                   //         alignment: Alignment.centerRight,
//                   //         pdRight: 5,
//                   //         index: e['i']),
//                   //   ]);
//                   // }).toList(),
//                 ),
//               );
//             },
//           ))
//         ],
//       ),
//     );
//   }
// }
