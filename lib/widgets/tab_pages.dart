
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sd_pmn/controllers/ctl_baocao.dart';
import 'package:sd_pmn/views/baocao/v_bc_tonhhop.dart';
import 'package:sd_pmn/views/quanlytin/v_quanlytin.dart';
import 'package:sd_pmn/views/xuly/v_xuly.dart';

class TabPage extends StatefulWidget {
  TabPage({Key? key}) : super(key: key);
  static const tabpageRouter = "/tabpage";
  @override
  State<TabPage> createState() => _TabPageState();
}

class _TabPageState extends State<TabPage>{


  int selectedTab = 0;
  final List<dynamic> _tabs = [
    V_Xuly(),
    const V_Quanlytin(),
    const V_BcTongHop(),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[selectedTab],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blueGrey ,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.blueGrey[200],
        selectedFontSize: 13,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.party_mode_rounded), label: "Xử lý"),
          BottomNavigationBarItem(
              icon: Icon(Icons.message_sharp), label: "Quản lý tin"),
          BottomNavigationBarItem(
              icon: Icon(Icons.event_note_sharp), label: "Báo cáo"),
        ],
        currentIndex: selectedTab,
        onTap: (index) {
          setState(() {
            selectedTab = index;
            if(index==2){
              Ctl_BaoCaoTongHop().to.onLoadBaoCao();
            }
          });
        },
      ),
    );
  }
}
