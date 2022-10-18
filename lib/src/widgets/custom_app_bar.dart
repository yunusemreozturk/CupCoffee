import 'package:flutter/cupertino.dart';

class CustomAppBar extends PreferredSize {
  final Widget child;
  final double height;

  CustomAppBar({Key? key, this.height = 40, required this.child})
      : super(key: key, child: child, preferredSize: Size.fromHeight(height));
}
