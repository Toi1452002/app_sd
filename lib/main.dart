// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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
  // if(Platform.isAndroid){
  Info_App.idDevice = await idDevice();
  // }


  ///--------------------------------------


  /// Nếu là window thì sài sql_common_ffi
  if(Platform.isWindows){
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  ///--------------------------------------

  configLoading(); //Cấu hình loading


  await GetStorage.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    double scaleText = MediaQuery.textScalerOf(context).scale(1);
    return  GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: InitBingding(),
      theme: ThemeData(
        listTileTheme: ListTileThemeData(
          subtitleTextStyle: TextStyle(
              fontSize: 16/scaleText,
            color: Colors.grey
          )
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(
            fontSize: 16/scaleText
          ),
          bodyMedium: TextStyle(
              fontSize: 16/scaleText
          ),
          bodySmall: TextStyle(
              fontSize: 16/scaleText
          ),


        ),
       elevatedButtonTheme: ElevatedButtonThemeData(
         style: ButtonStyle(
           textStyle: MaterialStateProperty.all(TextStyle(
             fontSize: 16 / scaleText
           ))
         )
       ),
        datePickerTheme: DatePickerThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          headerHeadlineStyle: TextStyle(
              fontSize: 35/scaleText
          )
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            textStyle: MaterialStateProperty.all(TextStyle(
                fontSize: 16 / scaleText
            )),
            shape: MaterialStateProperty.all(const RoundedRectangleBorder(borderRadius: BorderRadius.zero))
          )
        ),

        colorSchemeSeed: Colors.blue,
        dialogTheme: DialogTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5)
          )
        ),
        appBarTheme: AppBarTheme(color: Sv_Color.main,titleTextStyle: TextStyle(
          fontSize: 20/scaleText,
          color: Colors.black
        ))
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
    // ..fontSize = Theme.of(context).textTheme.bodyLarge.fontSize
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