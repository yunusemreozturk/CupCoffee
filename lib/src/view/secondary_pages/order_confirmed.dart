import 'package:cupcoffee/src/config/theme.dart';
import 'package:cupcoffee/src/view/main_pages/bottom_navigator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../viewmodel/firestore_viewmodel.dart';

class OrderConfirmed extends StatelessWidget {
  const OrderConfirmed({Key? key}) : super(key: key);

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
                    'assets/gif/processing.json',
                    animate: false,
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
              Get.offAll(
                () => BottomNavigator(),
                transition: Transition.fadeIn,
              );

              final FirestoreViewModel viewModel = Get.find();
              viewModel.payingState = Paying.idle;
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
