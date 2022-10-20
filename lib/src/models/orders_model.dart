import 'package:cloud_firestore/cloud_firestore.dart';

class OrdersModel {
  List<OrderModel>? orders = [];

  OrdersModel({required this.orders});

  OrdersModel.fromJson(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    if (snapshot.data()?['orders'] != null) {
      final v = snapshot.data()?['orders'];
      final List<OrderModel> arr0 = [];

      v.forEach((v) {
        arr0.add(OrderModel.fromJson(v));
      });

      orders = arr0;
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (orders != null) {
      final v = orders;
      final arr0 = [];

      v!.forEach((v) {
        arr0.add(v.toJson());
      });

      data['orders'] = arr0;
    }
    return data;
  }
}

class OrderModel {
  int? id;
  int? amount;
  int? size;
  int? price;

  OrderModel({this.id, this.amount, this.size, this.price});

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json['productId']?.toInt();
    amount = json['amount']?.toInt();
    size = json['sizes'];
    price = json['price']?.toInt();
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'productId': id,
      if (amount != null) 'amount': amount,
      if (size != null) 'sizes': size,
      if (price != null) 'price': price,
    };
  }
}
