class MYMessagechatlistingModel {
  int? statusCode;
  List<MychatResult>? result;

  MYMessagechatlistingModel({this.statusCode, this.result});

  MYMessagechatlistingModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    if (json['result'] != null) {
      result = <MychatResult>[];
      json['result'].forEach((v) {
        result!.add(new MychatResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MychatResult {
  int? senderID;
  int? messageID;
  String? message;
  String? status;
  String? time;
  bool? isRead;
  bool? isArchive;
  bool? isDeleted;

  MychatResult(
      {this.senderID,
        this.messageID,
        this.message,
        this.status,
        this.time,
        this.isRead,
        this.isArchive,
        this.isDeleted});

  MychatResult.fromJson(Map<String, dynamic> json) {
    senderID = json['senderID'];
    messageID = json['messageID'];
    message = json['message'];
    status = json['status'];
    time = json['time'];
    isRead = json['isRead'];
    isArchive = json['isArchive'];
    isDeleted = json['isDeleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['senderID'] = this.senderID;
    data['messageID'] = this.messageID;
    data['message'] = this.message;
    data['status'] = this.status;
    data['time'] = this.time;
    data['isRead'] = this.isRead;
    data['isArchive'] = this.isArchive;
    data['isDeleted'] = this.isDeleted;
    return data;
  }
}
