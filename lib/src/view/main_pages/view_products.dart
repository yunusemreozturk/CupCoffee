import 'package:cached_network_image/cached_network_image.dart';
import 'package:cupcoffee/src/config/theme.dart';
import 'package:cupcoffee/src/models/products_model.dart';
import 'package:cupcoffee/src/models/shops_model.dart';
import 'package:cupcoffee/src/view/main_pages/product_detail.dart';
import 'package:cupcoffee/src/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:vertical_tab_bar_view/vertical_tab_bar_view.dart';

import '../../viewmodel/firestore_viewmodel.dart';
import '../../widgets/my_grid_view.dart';

class ViewProducts extends StatefulWidget {
  final ShopModel shopModel;

  ViewProducts({Key? key, required this.shopModel}) : super(key: key);

  @override
  State<ViewProducts> createState() => _ViewProductsState();
}

class _ViewProductsState extends State<ViewProducts> {
  final FirestoreViewModel _viewModel = Get.find();
  List<ProductModel> products = [];
  List<Widget> productList = [];

  @override
  void initState() {
    super.initState();

    _viewModel.productsModel.products!.forEach((element) {
      if (widget.shopModel.id == element.shopId) {
        products.add(element);
      }
    });

    products = products.reversed.toList();

    products.forEach((element) {
      productList.add(productCard(product: element));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  height: Get.height * .1,
                  width: Get.width * .6,
                  child: const TabBar(
                    indicatorColor: Colors.black,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorPadding: EdgeInsets.all(10),
                    tabs: [
                      Tab(
                        child: Text(
                          'Coffee',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Cakes',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Bounceable(
                    onTap: () {},
                    child: const Icon(Icons.tune),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Center(child: tabView()),
                  Center(child: Text('Tap Bar 2')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column tabView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
          child: Text(
            'Today\'s Special',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: MyGridView(
              columnLength: 2,
              children: productList,
            ),
          ),
        ),
      ],
    );
  }

  Padding productCard({
    required ProductModel product,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Bounceable(
        onTap: () {
          Get.to(
            () => ProductDetail(productModel: product),
            transition: Transition.downToUp,
            duration: const Duration(milliseconds: 300),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: Get.height * .25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: CachedNetworkImage(
                imageUrl: product.photo!,
                imageBuilder: (context, imageProvider) => Container(
                  width: Get.width * .43,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.fill,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 3.0,
                        spreadRadius: 0.2,
                        offset: Offset(2.0, 4.0),
                      )
                    ],
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
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 10),
              child: Row(
                children: [
                  Text(
                    product.name!,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Row(
                children: [
                  Text(
                    r'$ ' + product.price.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  CustomAppBar appBar() {
    return CustomAppBar(
      height: Get.height * .26,
      child: Column(
        children: [
          AppBar(
            leading: Bounceable(
              onTap: () {
                Get.back();
              },
              child: Container(
                width: 35,
                height: 35,
                margin: const EdgeInsets.all(5),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 28,
                ),
              ),
            ),
            title: Text(
              widget.shopModel.name!,
              style: const TextStyle(
                fontSize: 17,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            backgroundColor: themeData.scaffoldBackgroundColor,
            elevation: 0,
          ),
          Bounceable(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                height: Get.height * .17,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 3.0,
                      spreadRadius: 0.2,
                      offset: Offset(2.0, 4.0),
                    )
                  ],
                ),
                clipBehavior: Clip.hardEdge,
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/reserve.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Reseve a table now',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                            Text(
                              'Lorem ipsum dolor sit amet, cons ectetur adipiscing elit.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.chevron_right,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
