class ManageSubscriptionModel {
  int? statusCode;
  List<BillingHistory>? billingHistory;

  ManageSubscriptionModel({this.statusCode, this.billingHistory});

  ManageSubscriptionModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['StatusCode'];
    if (json['billingHistory'] != null) {
      billingHistory = <BillingHistory>[];
      json['billingHistory'].forEach((v) {
        billingHistory!.add(new BillingHistory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['StatusCode'] = this.statusCode;
    if (this.billingHistory != null) {
      data['billingHistory'] =
          this.billingHistory!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BillingHistory {
  int? subscriptionID;
  String? effectiveAt;
  bool? active;
  int? amount;
  String? plan;
  String? duration;
  String? displayName;

  BillingHistory(
      {this.subscriptionID,
        this.effectiveAt,
        this.active,
        this.amount,
        this.plan,
        this.duration,
        this.displayName
      });

  BillingHistory.fromJson(Map<String, dynamic> json) {
    subscriptionID = json['subscriptionID'];
    effectiveAt = json['effectiveAt'];
    active = json['active'];
    amount = json['amount'];
    plan = json['plan'];
    duration = json['duration'];
    displayName = json['displayName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subscriptionID'] = this.subscriptionID;
    data['effectiveAt'] = this.effectiveAt;
    data['active'] = this.active;
    data['amount'] = this.amount;
    data['plan'] = this.plan;
    data['duration'] = this.duration;
    data['displayName'] = this.displayName;
    return data;
  }
}