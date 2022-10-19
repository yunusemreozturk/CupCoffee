import 'package:cupcoffee/src/app.dart';
import 'package:cupcoffee/src/models/orders_model.dart';
import 'package:cupcoffee/src/models/shops_model.dart';
import 'package:cupcoffee/src/repository/firestore_repository.dart';
import 'package:cupcoffee/src/view/bottom_navigator.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../models/products_model.dart';

enum FirestoreViewModelState { idle, busy }

enum Paying { idle, processing, confirmed, error }

//todo: hata yakalamaları yap
class FirestoreViewModel {
  final FirestoreRepository _repository = Get.find();

  Rx<ProductsModel> _productsModel = ProductsModel().obs;
  Rx<ShopsModel> _shopsModel = ShopsModel().obs;
  Rx<OrdersModel> _ordersModel = OrdersModel(orders: []).obs;

  Rx<FirestoreViewModelState> _state = FirestoreViewModelState.idle.obs;
  Rx<Paying> _payingState = Paying.idle.obs;

  ProductsModel get productsModel => _productsModel.value;

  ShopsModel get shopsModel => _shopsModel.value;

  OrdersModel get ordersModel => _ordersModel.value;

  FirestoreViewModelState get state => _state.value;

  Paying get payingState => _payingState.value;

  set payingState(Paying value) {
    _payingState.value = value;
  }

  Future onStart() async {
    await getProducts();
    await getShops();
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

  Future<ShopsModel> getShops() async {
    try {
      _state.value = FirestoreViewModelState.busy;
      _shopsModel.value = await _repository.getShops();

      return _shopsModel.value;
    } finally {
      _state.value = FirestoreViewModelState.busy;
    }
  }

  Future addToCard({
    required ProductModel productModel,
    required int productAmount,
    required int sizeSelect,
  }) async {
    try {
      _state.value = FirestoreViewModelState.busy;

      if (ordersModel.orders.isEmpty) {
        ordersModel.orders.add(
          OrderModel(
            id: productModel.id,
            amount: productAmount,
            size: productModel.sizes![sizeSelect],
            totalPrice: productModel.price! * productAmount,
          ),
        );
      } else {
        bool tempBool = false;

        for (var map in ordersModel.orders) {
          if (map.toJson()['productId'] == productModel.id &&
              map.toJson()['sizes'] == productModel.sizes![sizeSelect]) {
            tempBool = true;
          }
        }

        if (tempBool) {
          ordersModel.orders.forEach((element) {
            if (element.id == productModel.id &&
                element.size == productModel.sizes![sizeSelect]) {
              int temp = element.amount!;
              temp += productAmount;
              element.totalPrice = temp * productModel.price!;
              element.amount = temp;
            }
          });
        } else {
          ordersModel.orders.add(
            OrderModel(
              id: productModel.id,
              amount: productAmount,
              size: productModel.sizes![sizeSelect],
              totalPrice: productModel.price! * productAmount,
            ),
          );
        }
      }
    } finally {
      _state.value = FirestoreViewModelState.idle;
    }
  }

  payNow(context) async {
    try {
      Get.back();
      _payingState.value = Paying.processing;
      await Future.delayed(const Duration(seconds: 2));


    } finally {
      _payingState.value = Paying.confirmed;
    }
  }
}
