// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sd_pmn/controllers/ctl_user.dart';
import "package:sqflite_common_ffi/sqflite_ffi.dart";
import 'config/router.dart';
import 'config/server.dart';
import 'function/extension.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Lấy version của app
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  Info_App.version = packageInfo.version;
  if(Platform.isAndroid){
    Info_App.idDevice = await idDevice();
  }


  ///--------------------------------------


  /// Nếu là window thì sài sql_common_ffi
  if(Platform.isWindows){
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  ///--------------------------------------

  configLoading(); //Cấu hình loading


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: InitBingding(),
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        dialogTheme: DialogTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          )
        ),
        appBarTheme: const AppBarTheme(color: Sv_Color.main)
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: EasyLoading.init(),
      supportedLocales:const [
        // Locale('en', ''),
        Locale('vi', ''), // arabic, no country code
      ],
      initialRoute: '/',
      getPages: getRouter(),
    );
  }
}


class InitBingding extends Bindings{
  @override
  void dependencies() {
    Get.put(Ctl_User());
    // TODO: implement dependencies
  }

}


void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.white
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = false
    ..maskType = EasyLoadingMaskType.black
    ..dismissOnTap = true;

  // ..customAnimation = CustomAnimation();
}