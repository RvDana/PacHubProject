class PendingPaymentListModel{
  int? statusCode;
  List<Result>? result;

  PendingPaymentListModel({this.statusCode, this.result});

  PendingPaymentListModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(new Result.fromJson(v));
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

class Result {
  String? displayName;
  String? userEmail;
  int? userID;
  String? role;
  String? subscription;
  int? price;
  String? status;
  String? joiningDate;
  String? sport;
  int? age;
  String? solicitedName;

  Result(
      {this.displayName,
        this.userEmail,
        this.userID,
        this.role,
        this.subscription,
        this.price,
        this.status,
        this.joiningDate,
        this.sport,
        this.age,
        this.solicitedName});

  Result.fromJson(Map<String, dynamic> json) {
    displayName = json['displayName'];
    userEmail = json['userEmail'];
    userID = json['userID'];
    role = json['role'];
    subscription = json['subscription'];
    price = json['price'];
    status = json['status'];
    joiningDate = json['joiningDate'];
    sport = json['sport'];
    age = json['age'];
    solicitedName = json['solicitedName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['displayName'] = this.displayName;
    data['userEmail'] = this.userEmail;
    data['userID'] = this.userID;
    data['role'] = this.role;
    data['subscription'] = this.subscription;
    data['price'] = this.price;
    data['status'] = this.status;
    data['joiningDate'] = this.joiningDate;
    data['sport'] = this.sport;
    data['age'] = this.age;
    data['solicitedName'] = this.solicitedName;
    return data;
  }
}
