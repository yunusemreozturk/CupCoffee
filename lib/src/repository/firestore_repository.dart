import 'package:cupcoffee/src/models/shops_model.dart';
import 'package:cupcoffee/src/service/firestore_service.dart';
import 'package:get/get.dart';

import '../models/products_model.dart';

class FirestoreRepository {
  final FirestoreService _service = Get.find();

  Future<ProductsModel> getProducts()async  {
    return await _service.getProducts();
  }

  Future<ShopsModel> getShops()async  {
    return await _service.getShops();
  }
}
