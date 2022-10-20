import 'package:cupcoffee/src/models/products_model.dart';
import 'package:cupcoffee/src/viewmodel/firestore_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';

class FavoriteButton extends StatelessWidget {
  FavoriteButton({Key? key, required this.productModel}) : super(key: key);
  final FirestoreViewModel _viewModel = Get.find();
  final ProductModel productModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35,
      height: 35,
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(.5),
      ),
      child: Center(
        child: Obx(() {
          RxBool isLiked = false.obs;
          _viewModel.favoritesModel.value;
          return LikeButton(
            size: 21,
            circleColor:
                const CircleColor(start: Colors.red, end: Colors.brown),
            bubblesColor: const BubblesColor(
              dotPrimaryColor: Colors.brown,
              dotSecondaryColor: Colors.red,
            ),
            isLiked: isLiked.value,
            onTap: (bool value) async {
              bool temp = false;

              _viewModel.favoritesModel.value?.favorites!.forEach((element) {
                if (element.id == productModel.id) {
                  temp = true;
                }
              });

              if (!temp) {
                _viewModel.addFavorites(productModel);
                _viewModel.favoritesModel.refresh();
                isLiked.value = true;
                return true;
              } else {
                _viewModel.deleteFavorites(productModel);
                _viewModel.favoritesModel.refresh();
                isLiked.value = false;
                return false;
              }
            },
            likeBuilder: (bool value) {
              _viewModel.favoritesModel.value?.favorites!.forEach((element) {
                if (element.id == productModel.id) {
                  value = true;
                }
              });

              return value
                  ? const Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 24,
                    )
                  : const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 24,
                    );
            },
            likeCountAnimationType: LikeCountAnimationType.none,
          );
        }),
      ),
    );
  }
}
