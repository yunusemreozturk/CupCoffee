import 'package:cloud_firestore/cloud_firestore.dart';

class OrdersModel {
  List<OrderModel> orders = [];

  OrdersModel({required this.orders});

  OrdersModel.fromMap(DocumentSnapshot<Map<String, dynamic>> snapshot) {
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
  int? productId;
  int? amount;
  List<int>? sizes;
  int? totalPrice;

  OrderModel({this.productId, this.amount, this.sizes, this.totalPrice});

  OrderModel.fromJson(Map<String, dynamic> json) {
    productId = json['productId']?.toInt();
    amount = json['amount']?.toInt();
    sizes = json['sizes'];
    totalPrice = json['totalPrice']?.toInt();
  }

  Map<String, dynamic> toJson() {
    return {
      if (productId != null) 'productId': productId,
      if (amount != null) 'amount': amount,
      if (sizes != null) 'sizes': sizes,
      if (totalPrice != null) 'totalPrice': totalPrice,
    };
  }
}
