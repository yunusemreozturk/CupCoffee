import 'package:cached_network_image/cached_network_image.dart';
import 'package:cupcoffee/src/view/main_pages/view_products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:readmore/readmore.dart';

import '../../config/theme.dart';
import '../../models/shops_model.dart';
import '../../viewmodel/firestore_viewmodel.dart';

class ShopDetails extends StatelessWidget {
  final ShopModel shopModel;

  ShopDetails({Key? key, required this.shopModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            body(context),
            appBar(),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView body(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: Get.height * .4,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: shopModel.photo!,
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
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 25,
              vertical: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      shopModel.name!,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 16,
                        ),
                        Text(
                          '${shopModel.star!} ratings',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 1),
                Text(
                  shopModel.subtitle!,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 13),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: Get.height * .1,
                  child: ReadMoreText(
                    '${shopModel.description!} ',
                    trimLines: 3,
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
                const SizedBox(height: 10),
                Container(
                  height: Get.height * .3,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: FlutterMap(
                    options: MapOptions(
                      center: LatLng(51.509364, -0.128928),
                      zoom: 16,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.app',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: LatLng(51.509364, -0.128928),
                            builder: (BuildContext context) {
                              return const Icon(
                                Icons.location_on,
                                size: 40,
                                color: Colors.red,
                              );
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
                viewProducts(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Padding appBar() {
    return Padding(
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
            'Nearby shops',
            style: TextStyle(
              fontSize: 17,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 60, height: 35)
        ],
      ),
    );
  }

  Bounceable viewProducts(context) {
    return Bounceable(
      onTap: () async {
        Get.to(() => ViewProducts(
              shopModel: shopModel,
            ));
      },
      child: Container(
        margin: const EdgeInsets.only(top: 15),
        height: Get.height * .08,
        decoration: BoxDecoration(
          color: themeData.colorScheme.primary,
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Center(
          child: Text(
            'View Products',
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
}
