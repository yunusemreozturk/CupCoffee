import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupcoffee/src/models/basket_model.dart';
import 'package:cupcoffee/src/models/orders_model.dart';
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
  Future<UserModel?> getUser() async {
    try {
      return UserModel.fromJson(await _firestore
          .collection('users')
          .doc('si0PVF7DXKklNExU1dDY')
          .get());
    } catch (e) {
      print('Error: FirestoreService(getProducts): ${e.toString()}');
    }
  }

  @override
  Future<UserModel> setUser(UserModel userModel) async {
    try {
      await _firestore
          .collection('users')
          .doc('si0PVF7DXKklNExU1dDY')
          .set(userModel.toJson());

      return userModel;
    } catch (e) {
      print('Error: FirestoreService(setUser): ${e.toString()}');
      return UserModel();
    }
  }

  @override
  Future<BasketModel?> getBasket() async {
    try {
      return BasketModel.fromJson(await _firestore
          .collection('users')
          .doc('si0PVF7DXKklNExU1dDY')
          .collection('user_info')
          .doc('basket')
          .get());
    } catch (e) {
      print('Error: FirestoreService(getBasket): ${e.toString()}');
    }
  }

  @override
  Future<BasketModel?> setBasket(BasketModel basketModel) async {
    try {
      await _firestore
          .collection('users')
          .doc('si0PVF7DXKklNExU1dDY')
          .collection('user_info')
          .doc('basket')
          .set(basketModel.toJson());

      return basketModel;
    } catch (e) {
      print('Error: FirestoreService(setBasket): ${e.toString()}');
    }
  }

  @override
  Future<OrdersModel?> getOrders() async {
    try {
      return OrdersModel.fromJson(await _firestore
          .collection('users')
          .doc('si0PVF7DXKklNExU1dDY')
          .get());
    } catch (e) {
      print('Error: FirestoreService(getOrders): ${e.toString()}');
    }
  }

  @override
  Future<OrdersModel?> setOrders(OrdersModel ordersModel) async {
    try {
      await _firestore
          .collection('users')
          .doc('si0PVF7DXKklNExU1dDY')
          .collection('user_info')
          .doc('orders')
          .set(ordersModel.toJson());

      return ordersModel;
    } catch (e) {
      print('Error: FirestoreService(getOrders): ${e.toString()}');
    }
  }
}
