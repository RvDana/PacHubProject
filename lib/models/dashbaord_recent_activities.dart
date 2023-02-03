class DashboardRecentActivities {
  int? statusCode;
  String? message;
  List<RecentUsers>? recentUsers;
  int? count;

  DashboardRecentActivities({this.statusCode, this.message, this.recentUsers, this.count});

  DashboardRecentActivities.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['Message'];
    if (json['recentUsers'] != null) {
      recentUsers = <RecentUsers>[];
      json['recentUsers'].forEach((v) {
        recentUsers!.add(new RecentUsers.fromJson(v));
      });
    }
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['Message'] = this.message;
    if (this.recentUsers != null) {
      data['recentUsers'] = this.recentUsers!.map((v) => v.toJson()).toList();
    }
    data['count'] = this.count;
    return data;
  }
}

class RecentUsers {
  int? userID;
  String? joiningDate;
  String? displayName;
  String? subscription;
  int? price;
  String? bio;
  String? streetAddress;
  Null? image;
  String? status;
  String? role;
  String? email;
  String? sport;
  int? age;
  String? solicitedName;

  RecentUsers(
      {this.userID,
        this.joiningDate,
        this.displayName,
        this.subscription,
        this.price,
        this.bio,
        this.streetAddress,
        this.image,
        this.status,
        this.role,
        this.email,
        this.sport,
        this.age,
        this.solicitedName
      });

  RecentUsers.fromJson(Map<String, dynamic> json) {
    userID = json['userID'];
    joiningDate = json['joiningDate'];
    displayName = json['displayName'];
    subscription = json['subscription'];
    price = json['price'];
    bio = json['bio'];
    streetAddress = json['streetAddress'];
    image = json['image'];
    status = json['status'];
    role = json['role'];
    email = json['email'];
    sport = json['sport'];
    age = json['age'];
    solicitedName = json['solicitedName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userID'] = this.userID;
    data['joiningDate'] = this.joiningDate;
    data['displayName'] = this.displayName;
    data['subscription'] = this.subscription;
    data['price'] = this.price;
    data['bio'] = this.bio;
    data['streetAddress'] = this.streetAddress;
    data['image'] = this.image;
    data['status'] = this.status;
    data['role'] = this.role;
    data['email'] = this.email;
    data['sport'] = this.sport;
    data['age'] = this.age;
    data['solicitedName'] = this.solicitedName;
    return data;
  }
}
