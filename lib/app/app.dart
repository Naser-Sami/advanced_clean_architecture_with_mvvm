import 'package:advanced_clean_architecture_with_mvvm/presentation/resources/routes_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../presentation/resources/theme_manager.dart';

class MyApp extends StatefulWidget {
  // .. default constructor
  // const MyApp({super.key});

  // .. named constructor
  const MyApp._internal();

  // .. singleton or single instance
  static const MyApp _instance = MyApp._internal();

  // .. factory
  factory MyApp() => _instance;

  ///   SINGLETON .. will keep the same value everywhere we use it in the app
  ///   MyApp.appState = 0;
  ///
  ///   void updateAppState() {
  ///    MyApp.appState = 11;
  ///  }
  ///
  ///  any where we print the MyApp.appState value it will give us 11
  ///  until we change it

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );
    //Set the fit size (Find your UI design, look at the dimensions of the device screen and fill it in,unit in dp)
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'First Method',
          // You can use the library anywhere in the app even in theme
          theme: getApplicationTheme(),
          onGenerateRoute: RoutesGenerator.getRoute,
          initialRoute: Routes.splashRoute,
        );
      },
    );
  }
}
