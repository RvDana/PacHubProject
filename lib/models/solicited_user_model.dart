class SolicitedUserModel {
  int? statusCode;
  List<Result>? resultSolicitedUserList;

  SolicitedUserModel({this.statusCode, this.resultSolicitedUserList});

  SolicitedUserModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    if (json['result'] != null) {
      resultSolicitedUserList = <Result>[];
      json['result'].forEach((v) {
        resultSolicitedUserList!.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    if (this.resultSolicitedUserList != null) {
      data['result'] = this.resultSolicitedUserList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  String? roleName;
  String? plan;
  int? users;
  int? amount;
  String? sport;

  Result({this.roleName, this.plan, this.users, this.amount, this.sport});

  Result.fromJson(Map<String, dynamic> json) {
    roleName = json['role_name'];
    plan = json['plan'];
    users = json['users'];
    amount = json['amount'];
    sport = json['sport'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['role_name'] = this.roleName;
    data['plan'] = this.plan;
    data['users'] = this.users;
    data['amount'] = this.amount;
    data['sport'] = this.sport;
    return data;
  }
}
