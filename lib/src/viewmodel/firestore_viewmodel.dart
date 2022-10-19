import 'package:cupcoffee/src/app.dart';
import 'package:cupcoffee/src/models/orders_model.dart';
import 'package:cupcoffee/src/models/shops_model.dart';
import 'package:cupcoffee/src/repository/firestore_repository.dart';
import 'package:cupcoffee/src/service/firestore_service.dart';
import 'package:cupcoffee/src/view/main_pages/bottom_navigator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../models/products_model.dart';
import '../models/user_model.dart';

enum FirestoreViewModelState { idle, busy }

enum Paying { idle, processing, confirmed, error }

class FirestoreViewModel {
  final FirestoreRepository _repository = Get.find();

  Rx<ProductsModel> _productsModel = ProductsModel().obs;
  Rx<ShopsModel> _shopsModel = ShopsModel().obs;
  Rx<UserModel> _userModel = UserModel().obs;

  Rx<FirestoreViewModelState> _state = FirestoreViewModelState.idle.obs;
  Rx<Paying> _payingState = Paying.idle.obs;

  ProductsModel get productsModel => _productsModel.value;

  ShopsModel get shopsModel => _shopsModel.value;

  OrdersModel? get myBasket => _userModel.value.myBasket;

  OrdersModel? get orders => _userModel.value.orders;

  UserModel get userModel => _userModel.value;

  FirestoreViewModelState get state => _state.value;

  Paying get payingState => _payingState.value;

  set payingState(Paying value) {
    _payingState.value = value;
  }

  Future onStart() async {
    await getProducts();
    await getShops();
    await getUser();
    await Future.delayed(const Duration(milliseconds: 500));

    return true;
  }

  Future<ProductsModel> getProducts() async {
    try {
      _state.value = FirestoreViewModelState.busy;
      _productsModel.value = await _repository.getProducts();

      return _productsModel.value;
    } finally {
      _state.value = FirestoreViewModelState.busy;
    }
  }

  Future<UserModel> getUser() async {
    try {
      _state.value = FirestoreViewModelState.busy;
      _userModel.value = (await _repository.getUser())!;

      return _userModel.value;
    } finally {
      _state.value = FirestoreViewModelState.busy;
    }
  }

  Future<ShopsModel> getShops() async {
    try {
      _state.value = FirestoreViewModelState.busy;
      _shopsModel.value = await _repository.getShops();

      return _shopsModel.value;
    } finally {
      _state.value = FirestoreViewModelState.busy;
    }
  }

  Future addToBasket({
    required ProductModel productModel,
    required int productAmount,
    required int sizeSelect,
  }) async {
    try {
      _state.value = FirestoreViewModelState.busy;

      if (myBasket!.orders.isEmpty) {
        myBasket!.orders.add(
          OrderModel(
            id: productModel.id,
            amount: productAmount,
            size: productModel.sizes![sizeSelect],
            price: productModel.price,
          ),
        );
      } else {
        bool tempBool = false;

        for (var map in myBasket!.orders) {
          if (map.toJson()['productId'] == productModel.id &&
              map.toJson()['sizes'] == productModel.sizes![sizeSelect]) {
            tempBool = true;
          }
        }

        if (tempBool) {
          myBasket!.orders.forEach((element) {
            if (element.id == productModel.id &&
                element.size == productModel.sizes![sizeSelect]) {
              int temp = element.amount!;
              temp += productAmount;
              element.amount = temp;
            }
          });
        } else {
          myBasket!.orders.add(
            OrderModel(
              id: productModel.id,
              amount: productAmount,
              size: productModel.sizes![sizeSelect],
              price: productModel.price,
            ),
          );
        }
      }
    } finally {
      _state.value = FirestoreViewModelState.idle;
      await setUser(userModel);
    }
  }

  Future<void> payNow(context) async {
    try {
      Get.back();
      _payingState.value = Paying.processing;

      userModel.myBasket!.orders.forEach((element) {
        int credit = userModel.credit!;
        credit -= element.price! * element.amount!;
        userModel.credit = credit;
      });
      userModel.myBasket!.orders.forEach((element) {
        userModel.orders!.orders.add(element);
      });

      userModel.myBasket = OrdersModel(orders: []);

      await setUser(userModel);
      await Future.delayed(const Duration(seconds: 1));
    } finally {
      _payingState.value = Paying.confirmed;
    }
  }

  Future<UserModel> setUser(UserModel userModel) async {
    try {
      _state.value = FirestoreViewModelState.busy;
      _userModel.value = await _repository.setUser(userModel);

      return _userModel.value;
    } finally {
      _state.value = FirestoreViewModelState.busy;
    }
  }
}
