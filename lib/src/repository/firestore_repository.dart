import 'package:cupcoffee/src/models/favorites_model.dart';
import 'package:cupcoffee/src/models/shops_model.dart';
import 'package:cupcoffee/src/models/user_model.dart';
import 'package:cupcoffee/src/service/firestore_service.dart';
import 'package:get/get.dart';

import '../models/basket_model.dart';
import '../models/orders_model.dart';
import '../models/products_model.dart';
import '../models/reservation_model.dart';

class FirestoreRepository {
  final FirestoreService _service = Get.find();

  Future<ProductsModel> getProducts() async {
    return await _service.getProducts();
  }

  Future<ShopsModel> getShops() async {
    return await _service.getShops();
  }

  Future<UserModel?> getUser() async {
    return await _service.getUser();
  }

  Future<UserModel> setUser(UserModel userModel) async {
    return await _service.setUser(userModel);
  }

  @override
  Future<BasketModel?> getBasket() async {
    return await _service.getBasket();
  }

  @override
  Future<BasketModel?> setBasket(BasketModel basketModel) async {
    return await _service.setBasket(basketModel);
  }

  @override
  Future<OrdersModel?> getOrders() async {
    return await _service.getOrders();
  }

  @override
  Future<OrdersModel?> setOrders(OrdersModel ordersModel) async {
    return await _service.setOrders(ordersModel);
  }

  @override
  Future<FavoritesModel?> getFavorites() async {
    return await _service.getFavorites();
  }

  @override
  Future<FavoritesModel?> setFavorites(FavoritesModel favoritesModel) async {
    return await _service.setFavorites(favoritesModel);
  }

  Future<int?> checkCouponCodes(String coupon) async {
    return await _service.checkCouponCodes(coupon);
  }

  @override
  Future<ReservationsModel?> getReservations() async {
    return await _service.getReservations();
  }

  @override
  Future<ReservationsModel?> setReservations(
      ReservationsModel reservationsModel) async {
    return await _service.setReservations(reservationsModel);
  }
}
