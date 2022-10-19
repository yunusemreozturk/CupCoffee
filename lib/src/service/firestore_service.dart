import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupcoffee/src/models/products_model.dart';
import 'package:cupcoffee/src/models/shops_model.dart';

import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<ProductsModel> getProducts() async {
    try {
      return ProductsModel.fromMap(
          await _firestore.collection('products').doc('tr').get());
    } catch (e) {
      print('Error: FirestoreService(getProducts): ${e.toString()}');
      return ProductsModel();
    }
  }

  @override
  Future<UserModel> getUser() async {
    try {
      return UserModel.fromMap(
          await _firestore.collection('users').doc('si0PVF7DXKklNExU1dDY').get());
    } catch (e) {
      print('Error: FirestoreService(getProducts): ${e.toString()}');
      return UserModel();
    }
  }

  @override
  Future<ShopsModel> getShops() async {
    try {
      return ShopsModel.fromMap(
          await _firestore.collection('shops').doc('tr').get());
    } catch (e) {
      print('Error: FirestoreService(getShops): ${e.toString()}');
      return ShopsModel();
    }
  }

  @override
  Future setProducts(ProductsModel productsModel) async {
    try {
      await _firestore
          .collection('products')
          .doc('tr')
          .set(productsModel.toJson());

    } catch (e) {
      print('Error: FirestoreService(setProducts): ${e.toString()}');
      return ProductsModel();
    }
  }
}
