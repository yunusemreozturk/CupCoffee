import 'package:cached_network_image/cached_network_image.dart';
import 'package:cupcoffee/src/config/custom_icons_icons.dart';
import 'package:cupcoffee/src/config/theme.dart';
import 'package:cupcoffee/src/view/bottom_navigator.dart';
import 'package:cupcoffee/src/viewmodel/firestore_viewmodel.dart';
import 'package:cupcoffee/src/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'home_page.dart';

class ShopingPage extends StatelessWidget {
  ShopingPage({Key? key}) : super(key: key);
  final FirestoreViewModel _viewModel = Get.find();
  int subtotal = 0;
  int discount = 90;
  int delivery = 50;
  int totalPrice = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        height: Get.height * .4,
        child: Column(
          children: [
            AppBar(
              leading: Bounceable(
                onTap: () {
                  Get.back();
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 30,
                ),
              ),
              centerTitle: true,
              title: Text(
                'Place order',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: themeData.scaffoldBackgroundColor,
              elevation: 0,
            ),
            addressContainer(),
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              orders(),
              calculatePrice(),
              payNow(context),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox addressCard(String title, String subtitle, Icon icon) {
    return SizedBox(
      height: Get.height * .1,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          icon,
          const SizedBox(width: 7),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Container addressContainer() {
    return Container(
      width: Get.width * .9,
      height: Get.height * .3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
        border: Border.all(
          width: 2,
          color: Colors.black,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              addressCard(
                'Hotel Diamond Palace',
                '394K, Central Park, New Delhi, India',
                Icon(
                  CustomIcons.map_pin,
                  color: themeData.colorScheme.secondary,
                  size: 28,
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: themeData.colorScheme.secondary.withOpacity(.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.border_color,
                  size: 20,
                  color: themeData.colorScheme.secondary,
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              addressCard(
                'Middle road Sediago',
                '201, sector 25, Centre Park, New Delhi, India',
                Icon(
                  CustomIcons.map_pin,
                  color: themeData.colorScheme.secondary,
                  size: 28,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container orders() {
    List<Widget> list = <Widget>[];

    _viewModel.ordersModel.orders.forEach((order) {
      _viewModel.productsModel.products!.forEach((product) {
        RxInt productAmount = order.amount!.obs;

        if (order.id == product.id) {
          list.add(
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              width: Get.width,
              height: Get.height * .14,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  CachedNetworkImage(
                    imageUrl: product.photo!,
                    imageBuilder: (context, imageProvider) => Container(
                      width: Get.width * .3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => Center(
                      child: SpinKitThreeBounce(
                        size: 50,
                        itemBuilder: (BuildContext context, int index) {
                          return DecoratedBox(
                            decoration: BoxDecoration(
                              color: index.isEven ? Colors.white : Colors.brown,
                              shape: BoxShape.circle,
                            ),
                          );
                        },
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                  Container(
                    width: Get.width * .3,
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          '${order.size} ml',
                          style: const TextStyle(fontSize: 13),
                        )
                      ],
                    ),
                  ),
                  increaseOrDecreaseAmount(productAmount),
                ],
              ),
            ),
          );
        }
      });
    });

    if (_viewModel.ordersModel.orders.isEmpty) {
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        width: Get.width,
        height: Get.height * .14,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: const Center(
            child: Text(
          'You don\'t add any coffee',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        )),
      );
    } else {
      return Container(
        width: Get.width,
        child: Column(
          children: list,
        ),
      );
    }
  }

  Container calculatePrice() {
    _viewModel.ordersModel.orders.forEach((element) {
      subtotal += element.totalPrice!;
    });

    totalPrice = (subtotal == 0) ? 0 : subtotal - discount + delivery;
    TextStyle textStyle1 =
        const TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
    TextStyle textStyle2 =
        const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

    return Container(
      height: Get.width * .6,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Selected',
                style: textStyle1,
              ),
              Text(
                _viewModel.ordersModel.orders.length.toString(),
                style: textStyle1,
              )
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal',
                style: textStyle1,
              ),
              Text(
                r'$' + subtotal.toString(),
                style: textStyle1,
              ),
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Discount',
                style: textStyle1,
              ),
              Text(
                r'$' + discount.toString(),
                style: textStyle1,
              ),
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Delivery',
                style: textStyle1,
              ),
              Text(
                r'$' + delivery.toString(),
                style: textStyle1,
              ),
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: textStyle2,
              ),
              Text(
                r'$' + totalPrice.toString(),
                style: textStyle2,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Bounceable payNow(context) {
    return Bounceable(
      onTap: () async {
        await _viewModel.payNow(context);
      },
      child: Container(
        margin: const EdgeInsets.only(top: 15, bottom: 30),
        height: Get.height * .08,
        decoration: BoxDecoration(
          color: themeData.colorScheme.primary,
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Center(
          child: Text(
            'Pay Now',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  //todo: cleane çek
  SizedBox increaseOrDecreaseAmount(RxInt productAmount) {
    return SizedBox(
      width: 100,
      height: 35,
      child: Row(
        children: [
          Expanded(
            child: Bounceable(
              onTap: () {
                productAmount.value--;
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: themeData.colorScheme.secondary.withOpacity(.2),
                ),
                child: Center(
                  child: Text(
                    '-',
                    style: TextStyle(
                      fontSize: 25,
                      color: themeData.colorScheme.secondary,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Obx(
                () => Text(
                  productAmount.value.toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
          ),
          Expanded(
            child: Bounceable(
              onTap: () {
                productAmount.value++;
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: themeData.colorScheme.secondary,
                ),
                child: const Center(
                  child: Text(
                    '+',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}