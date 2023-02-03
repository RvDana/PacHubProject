
import 'dart:convert';
BookmarkUnbookmarkModel demoFromJson(String str) => BookmarkUnbookmarkModel.fromJson(json.decode(str));

String demoToJson(BookmarkUnbookmarkModel data) => json.encode(data.toJson());

class BookmarkUnbookmarkModel {
  BookmarkUnbookmarkModel({
    this.statusCode,
    this.message,
  });

  int? statusCode;
  String? message;

  factory BookmarkUnbookmarkModel.fromJson(Map<String, dynamic> json) => BookmarkUnbookmarkModel(
    statusCode: json["statusCode"],
    message: json["Message"],
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "Message": message,
  };
}

