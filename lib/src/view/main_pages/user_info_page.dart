import 'package:cached_network_image/cached_network_image.dart';
import 'package:cupcoffee/src/viewmodel/firestore_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../config/theme.dart';

class UserInfoPage extends StatelessWidget {
  final FirestoreViewModel _viewModel = Get.find();

  UserInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              appBar(),
              body(),
            ],
          ),
        ),
      ),
    );
  }

  Expanded body() {
    return Expanded(
      flex: 3,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
        ),
        child: ListView.builder(
          itemCount: _viewModel.ordersModel!.orders!.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(

            );
          },
        ),
      ),
    );
  }

  Expanded appBar() {
    return Expanded(
      flex: 1,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          // color: Colors.red,
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
