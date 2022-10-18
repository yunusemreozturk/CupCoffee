import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupcoffee/src/models/products_model.dart';
import 'package:cupcoffee/src/models/shops_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<ProductsModel> getProducts() async {
    try {
      return ProductsModel.fromMap(
          await _firestore.collection('products').doc('tr').get());
    } catch (e) {
      print(
          'Error: FirestoreService(getProducts): ${e.toString()}');
      return ProductsModel();
    }
  }


  @override
  Future<ShopsModel> getShops() async {
    try {
      return ShopsModel.fromMap(
          await _firestore.collection('shops').doc('tr').get());
    } catch (e) {
      print(
          'Error: FirestoreService(getShops): ${e.toString()}');
      return ShopsModel();
    }
  }
}
