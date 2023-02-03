// To parse this JSON data, do
//
//     final allchatlistModel = allchatlistModelFromJson(jsonString);

import 'dart:convert';

AllchatlistModel allchatlistModelFromJson(String str) => AllchatlistModel.fromJson(json.decode(str));

String allchatlistModelToJson(AllchatlistModel data) => json.encode(data.toJson());

class AllchatlistModel {
  AllchatlistModel({
    this.statusCode,
    this.chats,
    this.favoriteMessage,
    this.deletedMessage,
    this.unReadMessages,
  });

  int? statusCode;
  List<Chat>? chats;
  List<FavoriteMessage>? favoriteMessage;
  List<dynamic>? deletedMessage;
  UnReadMessages? unReadMessages;

  factory AllchatlistModel.fromJson(Map<String, dynamic> json) => AllchatlistModel(
    statusCode: json["statusCode"],
    chats: List<Chat>.from(json["chats"].map((x) => Chat.fromJson(x))),
    favoriteMessage: List<FavoriteMessage>.from(json["favoriteMessage"].map((x) => FavoriteMessage.fromJson(x))),
    deletedMessage: List<dynamic>.from(json["deletedMessage"].map((x) => x)),
    unReadMessages: UnReadMessages.fromJson(json["unReadMessages"]),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "chats": List<dynamic>.from(chats!.map((x) => x.toJson())),
    "favoriteMessage": List<dynamic>.from(favoriteMessage!.map((x) => x.toJson())),
    "deletedMessage": List<dynamic>.from(deletedMessage!.map((x) => x)),
    "unReadMessages": unReadMessages?.toJson(),
  };
}

class Chat {
  Chat({
    this.id,
    this.senderId,
    this.receiverId,
    this.text,
    this.isArchive,
    this.isDeleted,
    this.createdDate,
    this.displayName,
    this.picturePathS3,
    this.modifiedDate,
  });

  int? id;
  int? senderId;
  int? receiverId;
  String? text;
  int? isArchive;
  int? isDeleted;
  DateTime? createdDate;
  String? displayName;
  String? picturePathS3;
  DateTime? modifiedDate;

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
    id: json["id"],
    senderId: json["senderID"],
    receiverId: json["receiverID"],
    text: json["text"],
    isArchive: json["isArchive"],
    isDeleted: json["isDeleted"],
    createdDate: DateTime.parse(json["createdDate"]),
    displayName: json["displayName"],
    picturePathS3: json["picturePathS3"],
    modifiedDate: json["modifiedDate"] == null ? null : DateTime.parse(json["modifiedDate"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "senderID": senderId,
    "receiverID": receiverId,
    "text": text,
    "isArchive": isArchive,
    "isDeleted": isDeleted,
    "createdDate": createdDate?.toIso8601String(),
    "displayName": displayName,
    "picturePathS3": picturePathS3,
    "modifiedDate": modifiedDate == null ? null : modifiedDate?.toIso8601String(),
  };
}


class FavoriteMessage {
  FavoriteMessage({
    this.id,
    this.senderId,
    this.receiverId,
    this.text,
    this.isArchive,
    this.isDeleted,
    this.createdDate,
    this.displayName,
    this.picturePathS3,
    this.modifiedDate,
  });

  int? id;
  int? senderId;
  int? receiverId;
  String? text;
  int? isArchive;
  int? isDeleted;
  DateTime? createdDate;
  String? displayName;
  String? picturePathS3;
  DateTime? modifiedDate;

  factory FavoriteMessage.fromJson(Map<String, dynamic> json) => FavoriteMessage(
    id: json["id"],
    senderId: json["senderID"],
    receiverId: json["receiverID"],
    text: json["text"],
    isArchive: json["isArchive"],
    isDeleted: json["isDeleted"],
    createdDate: DateTime.parse(json["createdDate"]),
    displayName: json["displayName"],
    picturePathS3: json["picturePathS3"],
    modifiedDate: json["modifiedDate"] == null ? null : DateTime.parse(json["modifiedDate"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "senderID": senderId,
    "receiverID": receiverId,
    "text": text,
    "isArchive": isArchive,
    "isDeleted": isDeleted,
    "createdDate": createdDate?.toIso8601String(),
    "displayName": displayName,
    "picturePathS3": picturePathS3,
    "modifiedDate": modifiedDate == null ? null : modifiedDate?.toIso8601String(),
  };
}

class UnReadMessages {
  UnReadMessages({
    this.unReadMessages,
  });

  int? unReadMessages;

  factory UnReadMessages.fromJson(Map<String, dynamic> json) => UnReadMessages(
    unReadMessages: json["unReadMessages"],
  );

  Map<String, dynamic> toJson() => {
    "unReadMessages": unReadMessages,
  };
}
