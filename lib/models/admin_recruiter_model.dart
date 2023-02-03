// To parse this JSON data, do
//
//     final adminRecruiterModel = adminRecruiterModelFromJson(jsonString);

import 'dart:convert';

AdminRecruiterModel adminRecruiterModelFromJson(String str) =>
    AdminRecruiterModel.fromJson(json.decode(str));

String adminRecruiterModelToJson(AdminRecruiterModel data) =>
    json.encode(data.toJson());

class AdminRecruiterModel {
  AdminRecruiterModel({
    this.statusCode,
    this.message,
    this.records,
    this.counts,
  });

  int? statusCode;
  String? message;
  List<Record>? records;
  int? counts;

  factory AdminRecruiterModel.fromJson(Map<String, dynamic> json) =>
      AdminRecruiterModel(
        statusCode: json["statusCode"],
        message: json["Message"],
        records:
            List<Record>.from(json["Records"].map((x) => Record.fromJson(x))),
        counts: json["counts"],
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "Message": message,
        "Records": List<dynamic>.from(records!.map((x) => x.toJson())),
        "counts": counts,
      };
}

class Record {
  Record({
    this.userId,
    this.displayName,
    this.joiningDate,
    this.approvalDate,
    this.profileLink,
    this.bio,
    this.image,
    this.playerId,
    this.status,
    this.role,
    this.email,
    this.subscription,
    this.active,
    this.price,
    this.comment,
    this.expiredAt,
    this.sport,
    this.age,
    this.solicitedName,
    this.trainerName,
    this.trainerId,
  });

  int? userId;
  String? displayName;
  DateTime? joiningDate;
  DateTime? approvalDate;
  String? profileLink;
  String? bio;
  String? image;
  int? playerId;
  String? status;
  String? role;
  String? email;
  String? subscription;
  bool? active;
  int? price;
  String? comment;
  String? expiredAt;
  String? sport;
  int? age;
  String? solicitedName;
  String? trainerName;
  int? trainerId;

  factory Record.fromJson(Map<String, dynamic> json) => Record(
        userId: json["userID"],
        displayName: json["displayName"],
        joiningDate: DateTime.parse(json["joiningDate"]),
        approvalDate: json["approvalDate"] == null
            ? null
            : DateTime.parse(json["approvalDate"]),
        profileLink: json["profileLink"],
        bio: json["bio"] == null ? null : json["bio"],
        image: json["image"] == null ? null : json["image"],
        playerId: json["playerID"] == null ? null : json["playerID"],
        status: json["status"],
        role: json["role"],
        email: json["email"],
        subscription: json["subscription"],
        active: json["active"] == null ? null : json["active"],
        price: json["price"],
        comment: json["comment"] == null ? null : json["comment"],
        expiredAt: json['expiredAt'],
        sport: json['sport'],
        age: json['age'],
        solicitedName: json['solicitedName'],
        trainerName: json["trainerName"] == null ? null : json["trainerName"],
        trainerId: json["trainerID"] == null ? null : json["trainerID"],
      );

  Map<String, dynamic> toJson() => {
        "userID": userId,
        "displayName": displayName,
        "joiningDate": joiningDate.toString(),
        "approvalDate": approvalDate == null ? null : approvalDate.toString(),
        "profileLink": profileLink,
        "bio": bio == null ? null : bio,
        "image": image == null ? null : image,
        "playerID": playerId == null ? null : playerId,
        "status": status,
        "role": role,
        "email": email,
        "subscription": subscription,
        "active": active,
        "price": price,
        "comment": comment == null ? null : comment,
        "expiredAt": expiredAt,
        "sport": sport,
        "age": age,
        "solicitedName": solicitedName,
        "trainerName": trainerName == null ? null : trainerName,
        "trainerID": trainerId == null ? null : trainerId,
      };
}
