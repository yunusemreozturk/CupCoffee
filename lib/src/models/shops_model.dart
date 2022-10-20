import 'package:cloud_firestore/cloud_firestore.dart';

class ShopsModel {
  List<ShopModel>? shops;

  ShopsModel({this.shops});

  ShopsModel.fromJson(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    if (snapshot.data()?['shops'] != null) {
      final v = snapshot.data()?['shops'];
      final List<ShopModel> arr0 = [];

      v.forEach((v) {
        arr0.add(ShopModel.fromJson(v));
      });

      shops = arr0;
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (shops != null) {
      final v = shops;
      final arr0 = [];

      v!.forEach((v) {
        arr0.add(v.toJson());
      });

      data['shops'] = arr0;
    }
    return data;
  }
}

class ShopModel {
  int? id;
  String? name;
  String? description;
  String? photo;
  String? star;
  String? subtitle;
  String? distance;

  ShopModel.fromJson(Map<String, dynamic> json) {
    id = json['shopId']?.toInt();
    name = json['name']?.toString();
    description = json['description'];
    subtitle = json['subtitle'];
    photo = json['photo']?.toString();
    star = json['star'];
    distance = json['distance'];
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'shopId': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (subtitle != null) 'subtitle': subtitle,
      if (photo != null) 'photo': photo,
      if (star != null) 'star': star,
    if (distance != null) 'distance': distance,
    };
  }
}
