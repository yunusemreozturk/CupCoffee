import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String? name;
  String? email;
  String? photoUrl;
  int? credit;
  Map? address;

  UserModel({
    this.id,
    this.name,
    this.credit,
    this.email,
    this.photoUrl,
    this.address,
  });

  UserModel.fromJson(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : id = snapshot.data()?['id'],
        name = snapshot.data()?['name'],
        credit = snapshot.data()?['credit'],
        email = snapshot.data()?['email'],
        address = snapshot.data()?['address'],
        photoUrl = snapshot.data()?['photoUrl'];

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (credit != null) 'credit': credit,
      if (email != null) 'email': email,
      if (address != null) 'address': address,
      if (photoUrl != null) 'photoUrl': photoUrl,
    };
  }
}
