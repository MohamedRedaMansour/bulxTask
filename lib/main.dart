import 'package:bulx/pages/MainPage/ui/MainPageView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  ScreenUtilInit(
        builder: (BuildContext context,child) {
          return   const MaterialApp(
              home:   MainPageView());
        },
        designSize: const Size(375, 812));

  }
}


