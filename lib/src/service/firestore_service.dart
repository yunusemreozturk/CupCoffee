import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupcoffee/src/models/basket_model.dart';
import 'package:cupcoffee/src/models/favorites_model.dart';
import 'package:cupcoffee/src/models/orders_model.dart';
import 'package:cupcoffee/src/models/products_model.dart';
import 'package:cupcoffee/src/models/reservation_model.dart';
import 'package:cupcoffee/src/models/shops_model.dart';

import '../models/coupon_model.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<ProductsModel> getProducts() async {
    try {
      return ProductsModel.fromJson(
          await _firestore.collection('products').doc('tr').get());
    } catch (e) {
      print('Error: FirestoreService(getProducts): ${e.toString()}');
      return ProductsModel();
    }
  }

  @override
  Future<ShopsModel> getShops() async {
    try {
      return ShopsModel.fromJson(
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
          .collection('user_info')
          .doc('orders')
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

  @override
  Future<FavoritesModel?> getFavorites() async {
    try {
      return FavoritesModel.fromJson(await _firestore
          .collection('users')
          .doc('si0PVF7DXKklNExU1dDY')
          .collection('user_info')
          .doc('favorites')
          .get());
    } catch (e) {
      print('Error: FirestoreService(getBasket): ${e.toString()}');
    }
  }

  @override
  Future<FavoritesModel?> setFavorites(FavoritesModel favoritesModel) async {
    try {
      await _firestore
          .collection('users')
          .doc('si0PVF7DXKklNExU1dDY')
          .collection('user_info')
          .doc('favorites')
          .set(favoritesModel.toJson());

      return favoritesModel;
    } catch (e) {
      print('Error: FirestoreService(setBasket): ${e.toString()}');
    }
  }

  Future<int?> checkCouponCodes(String coupon) async {
    try {
      final couponsModel = CouponsModel.fromJson(
          await _firestore.collection('coupon_codes').doc('tr').get());
      int? temp;

      couponsModel.coupons!.forEach((element) {
        if (element.code == coupon) {
          temp = element.discountAmount!;
        }
      });

      return temp;
    } catch (e) {
      print('Error: FirestoreService(checkCouponCodes): ${e.toString()}');
    }
  }

  @override
  Future<ReservationsModel?> getReservations() async {
    try {
      return ReservationsModel.fromJson(await _firestore
          .collection('users')
          .doc('si0PVF7DXKklNExU1dDY')
          .collection('user_info')
          .doc('reservations')
          .get());
    } catch (e) {
      print('Error: FirestoreService(getReservations): ${e.toString()}');
    }
  }

  @override
  Future<ReservationsModel?> setReservations(
      ReservationsModel reservationsModel) async {
    try {
      await _firestore
          .collection('users')
          .doc('si0PVF7DXKklNExU1dDY')
          .collection('user_info')
          .doc('reservations')
          .set(reservationsModel.toJson());

      return reservationsModel;
    } catch (e) {
      print('Error: FirestoreService(setReservations): ${e.toString()}');
    }
  }
}
