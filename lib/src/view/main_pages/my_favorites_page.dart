import 'package:cached_network_image/cached_network_image.dart';
import 'package:cupcoffee/src/config/theme.dart';
import 'package:cupcoffee/src/view/main_pages/product_detail.dart';
import 'package:cupcoffee/src/viewmodel/firestore_viewmodel.dart';
import 'package:cupcoffee/src/widgets/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../../models/favorites_model.dart';
import '../../models/products_model.dart';

class MyFavoritesPage extends StatelessWidget {
  MyFavoritesPage({Key? key}) : super(key: key);
  final FirestoreViewModel _viewModel = Get.find();

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
        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 17,
            childAspectRatio: 0.55,
          ),
          itemCount: _viewModel.favoritesModel.value!.favorites!.length,
          itemBuilder: (BuildContext context, int index) {
            return favoriteCard(
              product: _viewModel.favoritesModel.value!.favorites![index],
            );
          },
        );
      }),
    );
  }

  Bounceable favoriteCard({
    required ProductModel product,
  }) {
    return Bounceable(
      onTap: () {
        Get.to(
          () => ProductDetail(productModel: product),
          transition: Transition.downToUp,
          duration: const Duration(milliseconds: 300),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    width: Get.width * .45,
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
                      fontWeight: FontWeight.w600, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
