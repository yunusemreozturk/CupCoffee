import 'package:cupcoffee/src/config/theme.dart';
import 'package:cupcoffee/src/view/main_pages/bottom_navigator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../viewmodel/firestore_viewmodel.dart';

class OrderConfirmed extends StatelessWidget {
  OrderConfirmed({Key? key}) : super(key: key);
  final FirestoreViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: Get.width * .7,
                child: Center(
                  child: Lottie.asset(
                    'assets/gif/ordered.json',
                  ),
                ),
              ),
            ],
          ),
          const Text(
            'Order Confirmed!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 23,
            ),
          ),
          GestureDetector(
            onTap: () {
              _viewModel.payingState = Paying.idle;

              Get.offAll(
                () => BottomNavigator(),
                transition: Transition.fadeIn,
              );
            },
            child: Text(
              'back to the homepage',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: themeData.colorScheme.secondary,
                decoration: TextDecoration.underline,
              ),
            ),
          )
        ],
      ),
    );
  }
}
