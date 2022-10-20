import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupcoffee/src/models/orders_model.dart';

class UserModel {
  String? id;
  String? name;
  String? email;
  String? photoUrl;
  int? credit;

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
        photoUrl = snapshot.data()?['photoUrl'];

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (credit != null) 'credit': credit,
      if (email != null) 'email': email,
      if (photoUrl != null) 'photoUrl': photoUrl,
    };
  }
}
