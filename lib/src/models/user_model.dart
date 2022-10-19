import 'package:cloud_firestore/cloud_firestore.dart';

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
  });

  UserModel.fromMap(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : id = snapshot.data()?['id'],
        name = snapshot.data()?['name'],
        credit = snapshot.data()?['credit'],
        email = snapshot.data()?['email'],
        photoUrl = snapshot.data()?['photoUrl'];

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (credit != null) 'credit': credit,
      if (email != null) 'email': email,
      if (photoUrl != null) 'photoUrl': photoUrl,
    };
  }
}
