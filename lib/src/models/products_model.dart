import 'package:cloud_firestore/cloud_firestore.dart';

class ProductsModel {
  List<ProductModel>? products;

  ProductsModel({this.products});

  ProductsModel.fromJson(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    if (snapshot.data()?['products'] != null) {
      final v = snapshot.data()?['products'];
      final List<ProductModel> arr0 = [];

      v.forEach((v) {
        arr0.add(ProductModel.fromJson(v));
      });

      products = arr0;
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (products != null) {
      final v = products;
      final arr0 = [];

      v!.forEach((v) {
        arr0.add(v.toJson());
      });

      data['products'] = arr0;
    }
    return data;
  }
}

class ProductModel {
  int? shopId;
  int? id;
  String? name;
  String? description;
  String? photo;
  double? price;
  double? star;
  List? sizes;
  int? deliveryTime;
  String? location;

  ProductModel({
    this.shopId,
    this.id,
    this.name,
    this.description,
    this.photo,
    this.price,
    this.star,
    this.sizes,
    this.deliveryTime,
    this.location,
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    shopId = json['shopId']?.toInt();
    id = json['productId']?.toInt();
    name = json['name']?.toString();
    description = json['description'];
    photo = json['photo']?.toString();
    price = json['price'].toDouble();
    star = json['star'].toDouble();
    sizes = json['sizes'];
    deliveryTime = json['deliveryTime'];
    location = json['location']?.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      if (shopId != null) 'shopId': id,
      if (id != null) 'productId': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (photo != null) 'photo': photo,
      if (price != null) 'price': price,
      if (star != null) 'star': star,
      if (sizes != null) 'sizes': sizes,
      if (deliveryTime != null) 'deliveryTime': deliveryTime,
      if (location != null) 'location': location,
    };
  }
}
