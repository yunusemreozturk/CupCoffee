import 'package:cached_network_image/cached_network_image.dart';
import 'package:cupcoffee/src/config/custom_icons_icons.dart';
import 'package:cupcoffee/src/config/theme.dart';
import 'package:cupcoffee/src/models/basket_model.dart';
import 'package:cupcoffee/src/models/products_model.dart';
import 'package:cupcoffee/src/view/main_pages/bottom_navigator.dart';
import 'package:cupcoffee/src/viewmodel/firestore_viewmodel.dart';
import 'package:cupcoffee/src/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../models/orders_model.dart';
import 'home_page.dart';

class ShopingPage extends StatefulWidget {
  ShopingPage({Key? key}) : super(key: key);

  @override
  State<ShopingPage> createState() => _ShopingPageState();
}

class _ShopingPageState extends State<ShopingPage> {
  final FirestoreViewModel _viewModel = Get.find();
  final controller = TextEditingController();

  int subtotal = 0;
  RxInt discount = 0.obs;
  int delivery = 50;
  int totalPrice = 0;
  String? couponCode;

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
              title: const Text(
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
              coupon(),
              calculatePrice(),
              payNow(context),
            ],
          ),
        ),
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                addressItem(
                  _viewModel.userModel.address!['title'],
                  _viewModel.userModel.address!['full_address'],
                  Icon(
                    CustomIcons.map_pin,
                    color: themeData.colorScheme.secondary,
                    size: 28,
                  ),
                ),
                Bounceable(
                  scaleFactor: .7,
                  onTap: () {},
                  child: Container(
                    width: 40,
                    height: 40,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: themeData.colorScheme.secondary.withOpacity(.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.border_color,
                      size: 20,
                      color: themeData.colorScheme.secondary,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                addressItem(
                  'Middle road Sediago',
                  '201, sector 25, Centre Park, New Delhi, India',
                  Icon(
                    Icons.sports_soccer,
                    color: themeData.colorScheme.secondary,
                    size: 26,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container addressItem(String title, String subtitle, Icon icon) {
    return Container(
      height: Get.height * .1,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon,
          const SizedBox(width: 7),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Container(
                width: Get.width * .5,
                child: Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Container orders() {
    List<Widget> list = <Widget>[];

    _viewModel.basketModel!.basket!.forEach((order) {
      _viewModel.productsModel.products!.forEach((product) {
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
                  increaseOrDecreaseAmount(order, _viewModel.basketModel!),
                ],
              ),
            ),
          );
        }
      });
    });

    if (_viewModel.basketModel!.basket!.isEmpty) {
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

  //turkticaret yazarsanız $300 indirim kazanırsınız
  Container coupon() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      width: Get.width,
      height: Get.height * .13,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Enter promotion code',
              suffixIcon: Bounceable(
                onTap: checkCouponCode,
                child: const Icon(Icons.check),
              ),
              hintStyle: const TextStyle(fontWeight: FontWeight.bold),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }

  void checkCouponCode() async {
    couponCode = controller.value.text;

    if (couponCode != null) {
      couponCode!.trim().toLowerCase();
      int? res = await _viewModel.checkCouponCodes(couponCode!);

      if (res != null) {
        discount.value = res;
        Get.snackbar(
          'Successful',
          'Coupon applied.',
          backgroundColor: themeData.colorScheme.secondary,
          colorText: Colors.white,
        );
      } else {
        discount.value = 0;
        Get.snackbar(
          'Warning',
          'No such coupon code was found.',
          backgroundColor: themeData.colorScheme.secondary,
          colorText: Colors.white,
        );
      }
    }
  }

  Container calculatePrice() {
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
      child: Obx(
        () {
          discount.value;
          subtotal = 0;
          _viewModel.basketModel?.basket?.forEach((element) {
            subtotal += element.price!.toInt() * element.amount!;
          });

          totalPrice =
              (subtotal == 0) ? 0 : subtotal + delivery - discount.value;

          return Column(
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
                    _viewModel.basketModel!.basket!.length.toString(),
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
              const Divider(),
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
              const Divider(),
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
          );
        },
      ),
    );
  }

  Bounceable payNow(context) {
    return Bounceable(
      onTap: () async {
        if (_viewModel.userModel.credit! > 0 &&
            _viewModel.userModel.credit! - totalPrice > 0) {
          if (_viewModel.basketModel!.basket!.isNotEmpty) {
            await _viewModel.payNow(context);
          } else {
            Get.snackbar(
              'Warning',
              'You don\'t add any coffee',
              backgroundColor: themeData.colorScheme.secondary,
              colorText: Colors.white,
            );
          }
        } else {
          Get.snackbar(
            'Warning',
            'You don\'t have enough money.',
            backgroundColor: themeData.colorScheme.secondary,
            colorText: Colors.white,
          );
        }
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

  SizedBox increaseOrDecreaseAmount(
    OrderModel order,
    BasketModel basketModel,
  ) {
    return SizedBox(
      width: 100,
      height: 35,
      child: Row(
        children: [
          Expanded(
            child: Bounceable(
              onTap: () async {
                if (order.amount != 1) {
                  order.amount = order.amount! - 1;
                } else {
                  basketModel.basket!.removeWhere((element) =>
                      (element.id == order.id && element.size == order.size));

                  String name = '';

                  _viewModel.productsModel.products!.forEach((element) {
                    if (order.id == element.id) {
                      name = element.name!;
                    }
                  });

                  Get.snackbar(
                    'Successful',
                    '$name Deleted',
                    backgroundColor: themeData.colorScheme.secondary,
                    colorText: Colors.white,
                  );
                }
                //todo: getx ile yap
                setState(() {});

                await _viewModel.setBasket(_viewModel.basketModel!);
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
              child: Text(
                order.amount.toString(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ),
          Expanded(
            child: Bounceable(
              onTap: () async {
                if (order.amount! < 10) {
                  order.amount = order.amount! + 1;
                  setState(() {});
                  await _viewModel.setBasket(_viewModel.basketModel!);
                } else {
                  Get.snackbar(
                    'Warning',
                    'You can order up to 10.',
                    backgroundColor: themeData.colorScheme.secondary,
                    colorText: Colors.white,
                  );
                }
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
