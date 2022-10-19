import 'package:cupcoffee/src/models/orders_model.dart';
import 'package:cupcoffee/src/models/shops_model.dart';
import 'package:cupcoffee/src/repository/firestore_repository.dart';
import 'package:get/get.dart';

import '../models/products_model.dart';

enum FirestoreViewModelState { idle, busy }

class FirestoreViewModel {
  final FirestoreRepository _repository = Get.find();

  Rx<ProductsModel> _productsModel = ProductsModel().obs;
  Rx<ShopsModel> _shopsModel = ShopsModel().obs;
  Rx<OrdersModel> _ordersModel = OrdersModel(orders: []).obs;
  Rx<FirestoreViewModelState> _state = FirestoreViewModelState.idle.obs;

  ProductsModel get productsModel => _productsModel.value;

  ShopsModel get shopsModel => _shopsModel.value;

  OrdersModel get ordersModel => _ordersModel.value;

  FirestoreViewModelState get state => _state.value;

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
}
