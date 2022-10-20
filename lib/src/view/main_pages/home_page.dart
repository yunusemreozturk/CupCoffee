import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cupcoffee/src/models/favorites_model.dart';
import 'package:cupcoffee/src/models/shops_model.dart';
import 'package:cupcoffee/src/view/main_pages/product_detail.dart';
import 'package:cupcoffee/src/view/main_pages/shop_details.dart';
import 'package:cupcoffee/src/viewmodel/firestore_viewmodel.dart';
import 'package:cupcoffee/src/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';

import '../../config/custom_icons_icons.dart';
import '../../config/theme.dart';
import '../../models/products_model.dart';
import '../../widgets/favorite_button.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final FirestoreViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          height: Get.width * .46,
          child: appBar(),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                popularCoffee(),
                nearestCoffeeShops(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding appBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    children: const [
                      TextSpan(text: 'Get your '),
                      TextSpan(
                          text: 'Coffee\n',
                          style: TextStyle(color: Color(0xffFFB067))),
                      TextSpan(text: 'on one finger tap'),
                    ],
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: profilePicture(),
                ),
              ],
            ),
          ),
          Container(
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: themeData.splashColor,
            ),
            child: const Center(
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search anything',
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  CircleAvatar profilePicture() {
    return CircleAvatar(
      radius: 35,
      child: CachedNetworkImage(
        imageUrl: _viewModel.userModel.photoUrl!,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        placeholder: (context, url) => Center(
          child: SpinKitThreeBounce(
            size: 40,
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
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }

  Column popularCoffee() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            'Popular Coffee',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: Get.height * .33,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: _viewModel.productsModel.products?.length,
            itemBuilder: (BuildContext context, int index) {
              ProductModel product = _viewModel.productsModel.products![index];

              return productCard(product);
            },
          ),
        ),
      ],
    );
  }

  Bounceable productCard(ProductModel product) {
    return Bounceable(
      onTap: () {
        Get.to(
          () => ProductDetail(productModel: product),
          transition: Transition.downToUp,
          duration: const Duration(milliseconds: 300),
        );
      },
      child: Container(
        width: Get.width * .7,
        padding: const EdgeInsets.only(left: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: Get.height * .23,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 3.0,
                        spreadRadius: 0.2,
                        offset:
                            Offset(1.0, 4.0), // shadow direction: bottom right
                      )
                    ],
                  ),
                  child: CachedNetworkImage(
                    imageUrl: product.photo!,
                    imageBuilder: (context, imageProvider) => Container(
                      width: Get.width * .65,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
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
                ),
                Positioned(
                  top: 3,
                  right: 3,
                  child: FavoriteButton(productModel: product),
                ),
                Positioned(
                  bottom: 6,
                  left: 5,
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.access_time_outlined,
                          color: Colors.white,
                          size: 19,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${product.deliveryTime} min delivery',
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 6,
                  right: 5,
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 19,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          product.star.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.name!,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        product.price.toString(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    CustomIcons.map_pin,
                    size: 16,
                  ),
                  Text(product.location!),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding nearestCoffeeShops() {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Nearest coffee shops',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Text(
                  'View all',
                  style: TextStyle(
                    color: themeData.colorScheme.secondary,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: Get.height * .3,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: _viewModel.shopsModel.shops!.length,
              itemBuilder: (BuildContext context, int index) {
                ShopModel shop = _viewModel.shopsModel.shops![index];

                return shopCard(shop);
              },
            ),
          ),
        ],
      ),
    );
  }

  Bounceable shopCard(ShopModel shop) {
    return Bounceable(
      onTap: () {
        Get.to(() => ShopDetails(shopModel: shop));
      },
      child: Container(
        height: Get.height * .25,
        width: Get.width * .46,
        padding: const EdgeInsets.only(right: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  height: Get.height * .17,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 3.0,
                        spreadRadius: 0.2,
                        offset: Offset(2.0, 4.0),
                      )
                    ],
                  ),
                  child: CachedNetworkImage(
                    imageUrl: shop.photo!,
                    imageBuilder: (context, imageProvider) => Container(
                      //todo: lokasyon uzaklığını al
                      width: Get.width * .45,
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
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Row(
                    children: [
                      Text(
                        shop.name!,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text('${shop.star} ratings')
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
