import 'package:cached_network_image/cached_network_image.dart';
import 'package:cupcoffee/src/models/reservation_model.dart';
import 'package:cupcoffee/src/viewmodel/firestore_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../config/theme.dart';
import '../../models/orders_model.dart';

class UserInfoPage extends StatelessWidget {
  final FirestoreViewModel _viewModel = Get.find();

  UserInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Info',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: themeData.scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: DefaultTabController(
        length: 2,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                appBar(),
                body(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Expanded body() {
    return Expanded(
      flex: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: Get.height * .1,
            width: Get.width * .8,
            child: const TabBar(
              indicatorColor: Colors.black,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorPadding: EdgeInsets.all(10),
              tabs: [
                Tab(
                  child: Text(
                    'Past Orders',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                Tab(
                  child: Text(
                    'Reservations',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 7),
          Expanded(
            child: TabBarView(
              children: [
                Center(child: tabView1()),
                Center(child: tabView2()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget tabView2() {
    List<ReservationModel>? reservations =
        _viewModel.reservationsModel.reservations!.reversed.toList();
    if (reservations.isEmpty) {
      return const Center(child: Text('You do not have a reservation yet.'));
    } else {
      return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: reservations.length,
        itemBuilder: (BuildContext context, int index) {
          ReservationModel reservation = reservations[index];

          String formattedDate =
              DateFormat('yyyy-MM-dd – kk:mm').format(reservation.dateTime!);

          return Padding(
            padding: const EdgeInsets.only(bottom: 7),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              child: ListTile(
                title: Text(
                  reservation.shopName!,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Text(
                  formattedDate,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          );
        },
      );
    }
  }

  ListView tabView1() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: _viewModel.ordersModel!.orders!.length,
      itemBuilder: (BuildContext context, int index) {
        _viewModel.ordersModel!.orders =
            _viewModel.ordersModel!.orders!.reversed.toList();
        OrderModel order = _viewModel.ordersModel!.orders![index];
        String? name = '';
        String? photoUrl = '';

        _viewModel.productsModel.products!.forEach((element) {
          if (element.id == order.id) {
            name = element.name;
            photoUrl = element.photo;
          }
        });

        return Padding(
          padding: const EdgeInsets.only(bottom: 7),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            child: ListTile(
              title: Text(
                name!,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: CircleAvatar(
                radius: 30,
                child: CachedNetworkImage(
                  imageUrl: photoUrl!,
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
              ),
              subtitle: Text(order.amount.toString()),
              trailing: Text(
                r'$ ' '${order.amount! * order.price!}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Expanded appBar() {
    return Expanded(
      flex: 1,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
        ),
        clipBehavior: Clip.hardEdge,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _viewModel.userModel.name!,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _viewModel.userModel.email!,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(text: 'You have '),
                        TextSpan(
                            text: r'$'
                                '${_viewModel.userModel.credit.toString()}',
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            )),
                        const TextSpan(text: ' left.'),
                      ],
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(flex: 1, child: profilePicture()),
          ],
        ),
      ),
    );
  }

  CircleAvatar profilePicture() {
    return CircleAvatar(
      radius: 40,
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
}
