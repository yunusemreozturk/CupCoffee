import 'package:cloud_firestore/cloud_firestore.dart';

class ReservationsModel {
  List<ReservationModel>? reservations;

  ReservationsModel({this.reservations});

  ReservationsModel.fromJson(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    if (snapshot.data()?['reservations'] != null) {
      final v = snapshot.data()?['reservations'];
      final List<ReservationModel> arr0 = [];

      v.forEach((v) {
        arr0.add(ReservationModel.fromJson(v));
      });

      reservations = arr0;
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (reservations != null) {
      final v = reservations;
      final arr0 = [];

      v!.forEach((v) {
        arr0.add(v.toJson());
      });

      data['reservations'] = arr0;
    }
    return data;
  }
}

class ReservationModel {
  DateTime? dateTime;
  int? shopId;
  String? shopName;

  ReservationModel({this.dateTime, this.shopId, this.shopName});

  ReservationModel.fromJson(Map<String, dynamic> json)
      : shopName = json['shopName'],
        shopId = json['shopId'],
        dateTime = json['dateTime']?.toDate();

  Map<String, dynamic> toJson() {
    return {
      if (shopId != null) 'shopId': shopId,
      if (shopName != null) 'shopName': shopName,
      if (dateTime != null) 'dateTime': dateTime,
    };
  }
}
