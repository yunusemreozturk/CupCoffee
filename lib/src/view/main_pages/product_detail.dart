import 'package:cached_network_image/cached_network_image.dart';
import 'package:cupcoffee/src/config/theme.dart';
import 'package:cupcoffee/src/widgets/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';

import '../../models/products_model.dart';
import '../../viewmodel/firestore_viewmodel.dart';

class ProductDetail extends StatelessWidget {
  final ProductModel productModel;
  final FirestoreViewModel _viewModel = Get.find();

  ProductDetail({Key? key, required this.productModel}) : super(key: key);

  RxInt sizeSelect = 0.obs;
  RxInt productAmount = 1.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: Get.height * .4,
              margin: const EdgeInsets.only(
                right: 15,
                left: 15,
                top: 10,
                bottom: 20,
              ),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: productModel.photo!,
                    imageBuilder: (context, imageProvider) => Container(
                      width: Get.width,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Bounceable(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            width: 35,
                            height: 35,
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(.5),
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                        const Text(
                          'Details',
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        FavoriteButton(productModel: productModel),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              productModel.name!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                  size: 25,
                                ),
                                Text(
                                  productModel.star.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              r'($' '${productModel.price})',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5,),
                        SizedBox(
                          height: Get.height * .075,
                          child: ReadMoreText(
                            '${productModel.description!} ',
                            trimLines: 2,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                            colorClickableText: Colors.pink,
                            trimMode: TrimMode.Line,
                            trimCollapsedText: 'Show more',
                            trimExpandedText: 'Show less',
                            lessStyle: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: themeData.colorScheme.secondary,
                            ),
                            moreStyle: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: themeData.colorScheme.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ingredientContainer('assets/images/coffee_beans.png'),
                        ingredientContainer('assets/images/milk_carton.png'),
                        ingredientContainer('assets/images/whiped_cream.png'),
                      ],
                    ),
                    const SizedBox(),
                    Column(
                      children: [
                        Row(
                          children: const [
                            Text(
                              'Choose Size',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        chooseSize(),
                      ],
                    ),
                    const SizedBox(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        increaseOrDecreaseAmount(),
                        addToCard(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Bounceable addToCard() {
    return Bounceable(
      onTap: () async {
        await _viewModel.addToBasket(
          productAmount: productAmount.value,
          productModel: productModel,
          sizeSelect: sizeSelect.value,
        );
        Get.snackbar(
          'Successful',
          '${productModel.name} Added to Your Cart',
          backgroundColor: themeData.colorScheme.secondary,
          colorText: Colors.white,
        );
      },
      child: Container(
        width: Get.width * .45,
        height: 55,
        decoration: BoxDecoration(
            color: themeData.colorScheme.primary,
            borderRadius: BorderRadius.circular(15)),
        child: const Center(
          child: Text(
            'Add to card',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  SizedBox chooseSize() {
    return SizedBox(
      width: Get.width,
      height: 35,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: productModel.sizes!.length,
        itemBuilder: (BuildContext context, int index) {
          int size = productModel.sizes![index];

          return Obx(
            () => Bounceable(
              onTap: () {
                sizeSelect.value = index;
              },
              child: Container(
                width: Get.width * .24,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: (sizeSelect.value == index)
                      ? themeData.colorScheme.primary
                      : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: themeData.colorScheme.primary,
                    width: 3,
                  ),
                ),
                child: Center(
                    child: Text(
                  '$size ml',
                  style: TextStyle(
                    fontSize: 15,
                    color: (sizeSelect.value == index)
                        ? Colors.white
                        : themeData.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                )),
              ),
            ),
          );
        },
      ),
    );
  }

  SizedBox increaseOrDecreaseAmount() {
    return SizedBox(
      width: 120,
      height: 40,
      child: Row(
        children: [
          Expanded(
            child: Bounceable(
              onTap: () {
                if (productAmount.value != 1) {
                  productAmount.value--;
                } else {
                  Get.snackbar(
                    'Warning',
                    'Amount must be at least 1.',
                    backgroundColor: themeData.colorScheme.secondary,
                    colorText: Colors.white,
                  );
                }
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
                if (productAmount.value < 10) {
                  productAmount.value++;
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
                child: Center(
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

  Container ingredientContainer(String path) {
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
          color: themeData.colorScheme.secondary.withOpacity(.2),
          borderRadius: BorderRadius.circular(15)),
      child: Image.asset(
        path,
        scale: 1.2,
      ),
    );
  }
}
