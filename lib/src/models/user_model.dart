import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupcoffee/src/models/orders_model.dart';

class UserModel {
  String? id;
  String? name;
  String? email;
  String? photoUrl;
  int? credit;
  // OrdersModel? myBasket = OrdersModel(orders: []);
  // OrdersModel? orders = OrdersModel(orders: []);

  UserModel({
    this.id,
    this.name,
    this.credit,
    this.email,
    this.photoUrl,
    // this.myBasket,
  });

  UserModel.fromJson(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : id = snapshot.data()?['id'],
        name = snapshot.data()?['name'],
        credit = snapshot.data()?['credit'],
        email = snapshot.data()?['email'],
        // myBasket = OrdersModel.fromMap(snapshot.data()?['myBasket']),
        // orders = OrdersModel.fromMap(snapshot.data()?['orders']),
        photoUrl = snapshot.data()?['photoUrl'];

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (credit != null) 'credit': credit,
      if (email != null) 'email': email,
      // if (myBasket != null) 'myBasket': myBasket?.toJson(),
      // if (orders != null) 'orders': orders?.toJson(),
      if (photoUrl != null) 'photoUrl': photoUrl,
    };
  }
}
