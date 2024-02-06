// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:sd_pmn/widgets/wgt_drawer.dart';


class V_BcTongHop_K1 extends StatelessWidget {
  const V_BcTongHop_K1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Wgt_Drawer(),
      appBar: AppBar(
        title: const Text("Báo cáo tổng hợp"),
      ),
    );
  }
}
