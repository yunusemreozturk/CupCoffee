import 'package:cloud_firestore/cloud_firestore.dart';

import 'orders_model.dart';

class BasketModel {
  List<OrderModel>? basket = [];

  BasketModel({required this.basket});

  BasketModel.fromJson(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    if (snapshot.data()?['basket'] != null) {
      final v = snapshot.data()?['basket'];
      final List<OrderModel> arr0 = [];

      v.forEach((v) {
        arr0.add(OrderModel.fromJson(v));
      });

      basket = arr0;
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (basket != null) {
      final v = basket;
      final arr0 = [];

      v!.forEach((v) {
        arr0.add(v.toJson());
      });

      data['basket'] = arr0;
    }
    return data;
  }
}
