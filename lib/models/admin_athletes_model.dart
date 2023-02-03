class AdminAthletesModel {
  int? statusCode;
  String? message;
  List<Records>? records;
  int? counts;

  AdminAthletesModel({this.statusCode, this.message, this.records, this.counts});

  AdminAthletesModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['Message'];
    if (json['Records'] != null) {
      records = <Records>[];
      json['Records'].forEach((v) {
        records!.add(new Records.fromJson(v));
      });
    }
    counts = json['counts'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['Message'] = this.message;
    if (this.records != null) {
      data['Records'] = this.records!.map((v) => v.toJson()).toList();
    }
    data['counts'] = this.counts;
    return data;
  }
}

class Records {
  int? userID;
  String? displayName;
  String? joiningDate;
  String? approvalDate;
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
  int? trainerID;


  Records(
      {this.userID,
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
        this.trainerID,
      });

  Records.fromJson(Map<String, dynamic> json) {
    userID = json['userID'];
    displayName = json['displayName'];
    joiningDate = json['joiningDate'];
    approvalDate = json['approvalDate'];
    profileLink = json['profileLink'];
    bio = json['bio'];
    image = json['image'];
    playerId = json["playerID"] == null ? null : json["playerID"];
    status = json['status'];
    role = json['role'];
    email = json['email'];
    subscription = json['subscription'];
    active = json['active'];
    price = json['price'];
    comment = json["comment"] == null ? null : json["comment"];
    expiredAt = json['expiredAt'];
    sport = json['sport'];
    age = json['age'];
    solicitedName = json['solicitedName'];
    trainerName = json['trainerName'];
    trainerID = json['trainerID'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userID'] = this.userID;
    data['displayName'] = this.displayName;
    data['joiningDate'] = this.joiningDate;
    data['approvalDate'] = this.approvalDate;
    data['profileLink'] = this.profileLink;
    data['bio'] = this.bio;
    data['image'] = this.image;
    data['playerID'] = this.playerId;
    data['status'] = this.status;
    data['role'] = this.role;
    data['email'] = this.email;
    data['subscription'] = this.subscription;
    data['active'] = this.active;
    data['price'] = this.price;
    data['comment'] = this.comment;
    data['expiredAt'] = this.expiredAt;
    data['sport'] = this.sport;
    data['age'] = this.age;
    data['solicitedName'] = this.solicitedName;
    data['trainerName'] = this.trainerName;
    data['trainerID'] = this.trainerID;
    return data;
  }
}
