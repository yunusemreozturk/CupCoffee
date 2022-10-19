import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../models/shops_model.dart';

class ShopDetails extends StatefulWidget {
  final ShopModel shopModel;

  ShopDetails({Key? key, required this.shopModel}) : super(key: key);

  @override
  State<ShopDetails> createState() => _ShopDetailsState();
}

class _ShopDetailsState extends State<ShopDetails> {

  MapController controller = MapController(
    initMapWithUserPosition: false,
    initPosition: GeoPoint(latitude: 47.4358055, longitude: 8.4737324),
    areaLimit: BoundingBox( east: 10.4922941, north: 47.8084648, south: 45.817995, west: 5.9559113,),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OSMFlutter(
        controller:controller,
        trackMyPosition: false,
        initZoom: 12,
        minZoomLevel: 8,
        maxZoomLevel: 14,
        stepZoom: 1.0,
        userLocationMarker: UserLocationMaker(
          personMarker: MarkerIcon(
            icon: Icon(
              Icons.location_history_rounded,
              color: Colors.red,
              size: 48,
            ),
          ),
          directionArrowMarker: MarkerIcon(
            icon: Icon(
              Icons.double_arrow,
              size: 48,
            ),
          ),
        ),
        roadConfiguration: RoadConfiguration(
          startIcon: MarkerIcon(
            icon: Icon(
              Icons.person,
              size: 64,
              color: Colors.brown,
            ),
          ),
          roadColor: Colors.yellowAccent,
        ),
        markerOption: MarkerOption(
            defaultMarker: MarkerIcon(
              icon: Icon(
                Icons.person_pin_circle,
                color: Colors.blue,
                size: 56,
              ),
            )
        ),
      ),
      // body: SafeArea(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.spaceAround,
      //     children: [
      //       Container(
      //         height: Get.height * .4,
      //         padding: const EdgeInsets.symmetric(horizontal: 15),
      //         child: Stack(
      //           children: [
      //             CachedNetworkImage(
      //               imageUrl: widget.shopModel.photo!,
      //               imageBuilder: (context, imageProvider) => Container(
      //                 width: Get.width,
      //                 decoration: BoxDecoration(
      //                   borderRadius: BorderRadius.circular(30),
      //                   image: DecorationImage(
      //                     image: imageProvider,
      //                     fit: BoxFit.fill,
      //                   ),
      //                 ),
      //               ),
      //               placeholder: (context, url) => Center(
      //                 child: SpinKitThreeBounce(
      //                   size: 50,
      //                   itemBuilder: (BuildContext context, int index) {
      //                     return DecoratedBox(
      //                       decoration: BoxDecoration(
      //                         color: index.isEven ? Colors.white : Colors.brown,
      //                         shape: BoxShape.circle,
      //                       ),
      //                     );
      //                   },
      //                 ),
      //               ),
      //               errorWidget: (context, url, error) =>
      //                   const Icon(Icons.error),
      //             ),
      //             Padding(
      //               padding: const EdgeInsets.symmetric(horizontal: 8),
      //               child: Row(
      //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                 children: [
      //                   Bounceable(
      //                     onTap: () {
      //                       Get.back();
      //                     },
      //                     child: Container(
      //                       width: 35,
      //                       height: 35,
      //                       margin: const EdgeInsets.all(5),
      //                       decoration: BoxDecoration(
      //                         shape: BoxShape.circle,
      //                         color: Colors.white.withOpacity(.5),
      //                       ),
      //                       child: const Icon(
      //                         Icons.arrow_back,
      //                         color: Colors.white,
      //                         size: 28,
      //                       ),
      //                     ),
      //                   ),
      //                   const Text(
      //                     'Nearby shops',
      //                     style: TextStyle(
      //                       fontSize: 17,
      //                       color: Colors.white,
      //                       fontWeight: FontWeight.bold,
      //                     ),
      //                   ),
      //                   const SizedBox(width: 35, height: 35)
      //                 ],
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //       Padding(
      //         padding: const EdgeInsets.symmetric(horizontal: 25),
      //         child: SingleChildScrollView(
      //           child: Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               Row(
      //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                 children: [
      //                   Text(
      //                     widget.shopModel.name!,
      //                     style: const TextStyle(
      //                       fontSize: 20,
      //                       fontWeight: FontWeight.bold,
      //                     ),
      //                   ),
      //                   Row(
      //                     children: [
      //                       const Icon(
      //                         Icons.star,
      //                         color: Colors.yellow,
      //                         size: 15,
      //                       ),
      //                       Text(
      //                         '${widget.shopModel.star!} ratings',
      //                         style: const TextStyle(
      //                           fontSize: 12,
      //                           color: Colors.grey,
      //                         ),
      //                       )
      //                     ],
      //                   )
      //                 ],
      //               ),
      //               Text(
      //                 widget.shopModel.subtitle!,
      //                 style: const TextStyle(fontWeight: FontWeight.w600),
      //               ),
      //               const SizedBox(height: 10),
      //               Text(
      //                 widget.shopModel.description!,
      //                 style: const TextStyle(color: Colors.grey),
      //               ),
      //               const SizedBox(height: 10),
      //               Container(
      //                 color: Colors.red,
      //                 height: Get.height * .3,
      //                 child:
      //               )
      //             ],
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
