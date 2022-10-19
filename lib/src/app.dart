import 'package:cupcoffee/src/view/loading_page.dart';
import 'package:cupcoffee/src/view/map_sample.dart';
import 'package:cupcoffee/src/viewmodel/firestore_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'config/theme.dart';
import 'view/bottom_navigator.dart';

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final FirestoreViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Cup Coffee',
      debugShowCheckedModeBanner: false,
      theme: themeData,
      // home: MapSample(),
      home: FutureBuilder(
        future: _viewModel.onStart(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData == true){
            return BottomNavigator();
          } else {
            return LoadingPage();
          }
        },
      ),
    );
  }
}
