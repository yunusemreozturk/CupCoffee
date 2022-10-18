import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'config/theme.dart';
import 'view/bottom_navigator.dart';

class MyApp extends StatelessWidget {
  const MyApp({key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Cup Coffee',
      debugShowCheckedModeBanner: false,
      theme: themeData,
      home: BottomNavigator(),
    );
  }
}
