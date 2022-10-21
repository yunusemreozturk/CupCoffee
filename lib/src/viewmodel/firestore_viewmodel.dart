import 'package:cupcoffee/src/models/basket_model.dart';
import 'package:cupcoffee/src/models/favorites_model.dart';
import 'package:cupcoffee/src/models/orders_model.dart';
import 'package:cupcoffee/src/models/reservation_model.dart';
import 'package:cupcoffee/src/models/shops_model.dart';
import 'package:cupcoffee/src/repository/firestore_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/theme.dart';
import '../models/products_model.dart';
import '../models/user_model.dart';

enum FirestoreViewModelState { idle, busy }

enum Paying { idle, processing, confirmed, error }

class FirestoreViewModel extends GetxController {
  final FirestoreRepository _repository = Get.find();

  Rx<ProductsModel> _productsModel = ProductsModel().obs;
  Rx<ShopsModel> _shopsModel = ShopsModel().obs;
  Rx<UserModel> _userModel = UserModel().obs;
  OrdersModel? ordersModel = OrdersModel(orders: []);
  BasketModel? basketModel = BasketModel(basket: []);
  Rx<FavoritesModel?> favoritesModel = FavoritesModel(favorites: []).obs;
  ReservationsModel reservationsModel = ReservationsModel(reservations: []);

  Rx<FirestoreViewModelState> _state = FirestoreViewModelState.idle.obs;
  Rx<Paying> _payingState = Paying.idle.obs;

  ProductsModel get productsModel => _productsModel.value;

  ShopsModel get shopsModel => _shopsModel.value;

  UserModel get userModel => _userModel.value;

  FirestoreViewModelState get state => _state.value;

  Paying get payingState => _payingState.value;

  set payingState(Paying value) {
    _payingState.value = value;
  }

  @override
  void onInit() async {
    await getProducts();
    await getShops();
    await getUser();
    await getBasket();
    await getOrders();
    await getFavorites();

    super.onInit();
  }

  Future<ProductsModel?> getProducts() async {
    try {
      _state.value = FirestoreViewModelState.busy;
      _productsModel.value = await _repository.getProducts();

      return _productsModel.value;
    } catch (e) {
      print('Error: FirestoreViewModel(getProducts): ${e.toString()}');
    } finally {
      _state.value = FirestoreViewModelState.idle;
    }
  }

  Future<ShopsModel?> getShops() async {
    try {
      _state.value = FirestoreViewModelState.busy;
      _shopsModel.value = await _repository.getShops();

      return _shopsModel.value;
    } catch (e) {
      print('Error: FirestoreViewModel(getShops): ${e.toString()}');
    } finally {
      _state.value = FirestoreViewModelState.idle;
    }
  }

  Future addToBasket({
    required ProductModel productModel,
    required int productAmount,
    required int sizeSelect,
  }) async {
    try {
      _state.value = FirestoreViewModelState.busy;

      if (basketModel!.basket!.isEmpty) {
        basketModel!.basket!.add(
          OrderModel(
            id: productModel.id,
            amount: productAmount,
            size: productModel.sizes![sizeSelect],
            price: productModel.price,
          ),
        );
      } else {
        bool tempBool = false;

        for (var map in basketModel!.basket!) {
          if (map.toJson()['productId'] == productModel.id &&
              map.toJson()['sizes'] == productModel.sizes![sizeSelect]) {
            tempBool = true;
          }
        }

        if (tempBool) {
          basketModel!.basket!.forEach((element) {
            if (element.id == productModel.id &&
                element.size == productModel.sizes![sizeSelect]) {
              int temp = element.amount!;
              temp += productAmount;
              element.amount = temp;
            }
          });
        } else {
          basketModel!.basket!.add(
            OrderModel(
              id: productModel.id,
              amount: productAmount,
              size: productModel.sizes![sizeSelect],
              price: productModel.price,
            ),
          );
        }
      }
    } catch (e) {
      print('Error: FirestoreViewModel(addToBasket): ${e.toString()}');
    } finally {
      _state.value = FirestoreViewModelState.idle;
      await setBasket(basketModel!);
    }
  }

  Future<void> payNow(context) async {
    try {
      Get.back();
      _payingState.value = Paying.processing;

      basketModel?.basket?.forEach((element) {
        int credit = userModel.credit!;
        credit -= element.price!.toInt() * element.amount!;
        userModel.credit = credit;
      });

      basketModel?.basket?.forEach((element) {
        ordersModel?.orders?.add(element);
      });

      basketModel = BasketModel(basket: []);

      await setBasket(basketModel!);
      await setUser(userModel);
      await setOrders(ordersModel!);
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      print('Error: FirestoreViewModel(payNow): ${e.toString()}');
    } finally {
      _payingState.value = Paying.confirmed;
    }
  }

  Future<UserModel?> getUser() async {
    try {
      _state.value = FirestoreViewModelState.busy;
      _userModel.value = (await _repository.getUser())!;

      return _userModel.value;
    } catch (e) {
      print('Error: FirestoreViewModel(getUser): ${e.toString()}');
    } finally {
      _state.value = FirestoreViewModelState.idle;
    }
  }

  Future<UserModel?> setUser(UserModel userModel) async {
    try {
      _state.value = FirestoreViewModelState.busy;
      _userModel.value = await _repository.setUser(userModel);

      return _userModel.value;
    } catch (e) {
      print('Error: FirestoreViewModel(setUser): ${e.toString()}');
    } finally {
      _state.value = FirestoreViewModelState.busy;
    }
  }

  Future<BasketModel?> getBasket() async {
    try {
      _state.value = FirestoreViewModelState.busy;
      basketModel = (await _repository.getBasket())!;

      return basketModel;
    } catch (e) {
      print('Error: FirestoreViewModel(getBasket): ${e.toString()}');
    } finally {
      _state.value = FirestoreViewModelState.idle;
    }
  }

  Future<BasketModel?> setBasket(BasketModel basket) async {
    try {
      _state.value = FirestoreViewModelState.busy;
      basketModel = (await _repository.setBasket(basket))!;

      return basketModel;
    } catch (e) {
      print('Error: FirestoreViewModel(setBasket): ${e.toString()}');
    } finally {
      _state.value = FirestoreViewModelState.idle;
    }
  }

  Future<OrdersModel?> getOrders() async {
    try {
      _state.value = FirestoreViewModelState.busy;
      ordersModel = (await _repository.getOrders())!;

      return ordersModel;
    } catch (e) {
      print('Error: FirestoreViewModel(getOrders): ${e.toString()}');
    } finally {
      _state.value = FirestoreViewModelState.idle;
    }
  }

  Future<OrdersModel?> setOrders(OrdersModel orders) async {
    try {
      _state.value = FirestoreViewModelState.busy;
      ordersModel = await _repository.setOrders(orders);

      return ordersModel;
    } catch (e) {
      print('Error: FirestoreViewModel(setOrders): ${e.toString()}');
    } finally {
      _state.value = FirestoreViewModelState.idle;
    }
  }

  Future<ReservationsModel?> getReservations() async {
    try {
      _state.value = FirestoreViewModelState.busy;
      reservationsModel = (await _repository.getReservations())!;

      return reservationsModel;
    } catch (e) {
      print('Error: FirestoreViewModel(getOrders): ${e.toString()}');
    } finally {
      _state.value = FirestoreViewModelState.idle;
    }
  }

  Future<ReservationsModel?> setReservations(
      ReservationModel reservation) async {
    try {
      _state.value = FirestoreViewModelState.busy;

      if (reservationsModel.reservations!.isEmpty) {
        reservationsModel.reservations!.add(reservation);
        Get.snackbar(
          'Successful',
          'Reservation received.',
          backgroundColor: themeData.colorScheme.secondary,
          colorText: Colors.white,
        );

        reservationsModel =
            (await _repository.setReservations(reservationsModel))!;
      } else {
        bool tempBool = true;

        reservationsModel.reservations!.forEach((element) {
          if (element.shopId == reservation.shopId) {
            tempBool = false;
            Get.snackbar(
              'Unsuccessful',
              'You already have a reservation.',
              backgroundColor: themeData.colorScheme.secondary,
              colorText: Colors.white,
            );
          }
        });

        if (tempBool) {
          reservationsModel.reservations!.add(reservation);
          Get.snackbar(
            'Successful',
            'Reservation received.',
            backgroundColor: themeData.colorScheme.secondary,
            colorText: Colors.white,
          );

          reservationsModel =
              (await _repository.setReservations(reservationsModel))!;
        }
      }
      return reservationsModel;
    } catch (e) {
      print('Error: FirestoreViewModel(setReservations): ${e.toString()}');
    } finally {
      _state.value = FirestoreViewModelState.idle;
    }
  }

  Future<FavoritesModel?> getFavorites() async {
    try {
      _state.value = FirestoreViewModelState.busy;
      favoritesModel.value = (await _repository.getFavorites())!;

      return favoritesModel.value;
    } catch (e) {
      print('Error: FirestoreViewModel(getFavorites): ${e.toString()}');
    } finally {
      _state.value = FirestoreViewModelState.idle;
    }
  }

  Future<FavoritesModel?> addFavorites(ProductModel favorite) async {
    try {
      if (favoritesModel.value!.favorites!.isEmpty) {
        favoritesModel.value!.favorites!.add(favorite);
      } else {
        bool tempBool = false;

        for (var map in favoritesModel.value!.favorites!) {
          if (map.toJson()['productId'] == favorite.id) {
            tempBool = true;
          }
        }

        if (!tempBool) {
          favoritesModel.value!.favorites!.add(favorite);
        }
      }

      favoritesModel.value =
          (await _repository.setFavorites(favoritesModel.value!))!;

      return favoritesModel.value;
    } catch (e) {
      print('Error: FirestoreViewModel(addFavorites): ${e.toString()}');
    }
  }

  Future<FavoritesModel?> deleteFavorites(ProductModel favorite) async {
    try {
      favoritesModel.value!.favorites!
          .removeWhere((element) => element.id == favorite.id);

      favoritesModel.value =
          (await _repository.setFavorites(favoritesModel.value!))!;

      return favoritesModel.value;
    } catch (e) {
      print('Error: FirestoreViewModel(addFavorites): ${e.toString()}');
    }
  }

  Future<int?> checkCouponCodes(String coupon) async {
    try {
      return await _repository.checkCouponCodes(coupon);
    } catch (e) {
      print('Error: FirestoreViewModel(checkCouponCodes): ${e.toString()}');
    }
  }
}
