import 'package:cached_network_image/cached_network_image.dart';
import 'package:cupcoffee/src/config/theme.dart';
import 'package:cupcoffee/src/view/main_pages/product_detail.dart';
import 'package:cupcoffee/src/viewmodel/firestore_viewmodel.dart';
import 'package:cupcoffee/src/widgets/favorite_button.dart';
import 'package:cupcoffee/src/widgets/my_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../../models/favorites_model.dart';
import '../../models/products_model.dart';

class FavoritesPage extends StatelessWidget {
  FavoritesPage({Key? key}) : super(key: key);
  final FirestoreViewModel _viewModel = Get.find();
  List<Widget> favoriteList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Favorites',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: themeData.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: Obx(() {
        _viewModel.favoritesModel.value;
        favoriteList = [];
        _viewModel.favoritesModel.value!.favorites!.forEach((element) {
          favoriteList.add(favoriteCard(product: element));
        });

        if (_viewModel.favoritesModel.value!.favorites!.isEmpty) {
          return const Center(
            child: Text(
              'You have not added products to favorites.',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
          );
        } else {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: MyGridView(
              columnLength: 2,
              children: favoriteList,
            ),
          );
        }
      }),
    );
  }

  Padding favoriteCard({
    required ProductModel product,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
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
              child: Stack(
                children: [
                  CachedNetworkImage(
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
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: FavoriteButton(productModel: product),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 5),
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
}
