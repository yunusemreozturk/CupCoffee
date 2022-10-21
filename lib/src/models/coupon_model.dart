import 'package:cloud_firestore/cloud_firestore.dart';

class CouponsModel {
  List<CouponModel>? coupons;

  CouponsModel({this.coupons});

  CouponsModel.fromJson(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    if (snapshot.data()?['coupons'] != null) {
      final v = snapshot.data()?['coupons'];
      final List<CouponModel> arr0 = [];

      v.forEach((v) {
        arr0.add(CouponModel.fromJson(v));
      });

      coupons = arr0;
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (coupons != null) {
      final v = coupons;
      final arr0 = [];

      v!.forEach((v) {
        arr0.add(v.toJson());
      });

      data['coupons'] = arr0;
    }
    return data;
  }
}

class CouponModel {
  String? code;
  int? discountAmount;

  CouponModel({
    this.code,
    this.discountAmount,
  });

  CouponModel.fromJson(Map<String, dynamic> json)
      : code = json['code'],
        discountAmount = json['discountAmount'];

  Map<String, dynamic> toJson() {
    return {
      if (code != null) 'code': code,
      if (discountAmount != null) 'discountAmount': discountAmount,
    };
  }
}
