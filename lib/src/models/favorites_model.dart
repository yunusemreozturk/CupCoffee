import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupcoffee/src/models/products_model.dart';

class FavoritesModel {
  List<ProductModel>? favorites;

  FavoritesModel({this.favorites});

  FavoritesModel.fromJson(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    if (snapshot.data()?['favorites'] != null) {
      final v = snapshot.data()?['favorites'];
      final List<ProductModel> arr0 = [];

      v.forEach((v) {
        arr0.add(ProductModel.fromJson(v));
      });

      favorites = arr0;
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (favorites != null) {
      final v = favorites;
      final arr0 = [];

      v!.forEach((v) {
        arr0.add(v.toJson());
      });

      data['favorites'] = arr0;
    }
    return data;
  }
}
