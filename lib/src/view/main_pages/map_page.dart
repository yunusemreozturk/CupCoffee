import 'package:cupcoffee/src/viewmodel/firestore_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../config/theme.dart';

class MapPage extends StatefulWidget {
  MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final FirestoreViewModel _viewModel = Get.find();
  List<Marker> markersList = [];

  @override
  void initState() {
    super.initState();

    _viewModel.shopsModel.shops!.forEach((element) {
      markersList.add(
        Marker(
            point: LatLng(
                element.coordinate!.latitude, element.coordinate!.longitude),
            builder: (BuildContext context) {
              return const Icon(
                Icons.location_on,
                size: 40,
                color: Colors.blue,
              );
            }),
      );
    });

    markersList.add(
      Marker(
        point: LatLng(40.2230133, 28.8590904),
        builder: (BuildContext context) {
          return const Icon(
            Icons.location_on,
            size: 40,
            color: Colors.red,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        title: const Text(
          'Location',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: themeData.scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: FlutterMap(
            options: MapOptions(
              center: LatLng(40.2230133, 28.8590904),
              zoom: 18,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(
                markers: markersList,
              )
            ],
          ),
        ),
      ),
    );
  }
}
