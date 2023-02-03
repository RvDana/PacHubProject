class TotalAmountModel {
  int? statusCode;
  UserDetails? userDetails;

  TotalAmountModel({this.statusCode, this.userDetails});

  TotalAmountModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    userDetails = json['userDetails'] != null
        ? new UserDetails.fromJson(json['userDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    if (this.userDetails != null) {
      data['userDetails'] = this.userDetails!.toJson();
    }
    return data;
  }
}

class UserDetails {
  List<TotalUserAmount>? totalUserAmount;
  List<TotalActiveUser>? totalActiveUser;
  List<TotalPending>? totalPending;

  UserDetails({this.totalUserAmount, this.totalActiveUser, this.totalPending});

  UserDetails.fromJson(Map<String, dynamic> json) {
    if (json['totalUserAmount'] != null) {
      totalUserAmount = <TotalUserAmount>[];
      json['totalUserAmount'].forEach((v) {
        totalUserAmount!.add(new TotalUserAmount.fromJson(v));
      });
    }
    if (json['totalActiveUser'] != null) {
      totalActiveUser = <TotalActiveUser>[];
      json['totalActiveUser'].forEach((v) {
        totalActiveUser!.add(new TotalActiveUser.fromJson(v));
      });
    }
    if (json['totalPending'] != null) {
      totalPending = <TotalPending>[];
      json['totalPending'].forEach((v) {
        totalPending!.add(new TotalPending.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.totalUserAmount != null) {
      data['totalUserAmount'] =
          this.totalUserAmount!.map((v) => v.toJson()).toList();
    }
    if (this.totalActiveUser != null) {
      data['totalActiveUser'] =
          this.totalActiveUser!.map((v) => v.toJson()).toList();
    }
    if (this.totalPending != null) {
      data['totalPending'] = this.totalPending!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TotalUserAmount {
  int? amount;
  int? roleTotal;
  String? roleName;
  String? plan;
  String? sport;

  TotalUserAmount({this.amount, this.roleTotal, this.roleName, this.plan, this.sport});

  TotalUserAmount.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    roleTotal = json['role_total'];
    roleName = json['role_name'];
    plan = json['plan'];
    sport = json['sport'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['role_total'] = this.roleTotal;
    data['role_name'] = this.roleName;
    data['plan'] = this.plan;
    data['sport'] = this.sport;
    return data;
  }
}

class TotalActiveUser {
  int? activeUser;
  String? name;
  String? plan;
  String? sport;
  int? total;

  TotalActiveUser({this.activeUser, this.name, this.plan, this.sport, this.total});

  TotalActiveUser.fromJson(Map<String, dynamic> json) {
    activeUser = json['active_user'];
    name = json['name'];
    plan = json['plan'];
    sport = json['sport'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['active_user'] = this.activeUser;
    data['name'] = this.name;
    data['plan'] = this.plan;
    data['sport'] = this.sport;
    data['total'] = this.total;
    return data;
  }
}

class TotalPending {
  int? pendingUser;
  String? name;
  String? plan;
  String? sport;
  int? total;

  TotalPending({this.pendingUser, this.name, this.plan, this.sport, this.total});

  TotalPending.fromJson(Map<String, dynamic> json) {
    pendingUser = json['pending_user'];
    name = json['name'];
    plan = json['plan'];
    sport = json['sport'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pending_user'] = this.pendingUser;
    data['name'] = this.name;
    data['plan'] = this.plan;
    data['sport'] = this.sport;
    data['total'] = this.total;
    return data;
  }
}
