import 'package:cupcoffee/src/view/secondary_pages/loading_page.dart';
import 'package:cupcoffee/src/viewmodel/firestore_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'config/theme.dart';
import 'view/main_pages/bottom_navigator.dart';

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final FirestoreViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Cup Coffee',
      debugShowCheckedModeBanner: false,
      theme: themeData,
      home: Obx(
        () => (_viewModel.state != FirestoreViewModelState.busy)
            ? BottomNavigator()
            : LoadingPage(),
      ),
    );
  }
}
