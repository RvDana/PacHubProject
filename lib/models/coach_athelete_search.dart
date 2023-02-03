class CoachAtheleteSearchModel {
  int? statusCode;
  List<DataSearch>? data;

  CoachAtheleteSearchModel({this.statusCode, this.data});

  CoachAtheleteSearchModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    if (json['Data'] != null) {
      data = <DataSearch>[];
      json['Data'].forEach((v) {
        data!.add(new DataSearch.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    if (this.data != null) {
      data['Data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataSearch {
  int? userID;
  int? roleID;
  int? divID;
  String? firstName;
  String? lastName;
  String? displayName;
  String? profileName;
  String? image;
  int? playerID;
  String? userEmail;
  String? bio;
  String? dOB;
  String? height;
  String? weight;
  String? contact;
  String? address;
  String? landMark;
  String? city;
  int? stateID;
  String? state;
  String? zipcode;
  String? joinDate;
  String? role;
  String? plan;
  String? positionPlayed;
  String? hittingPosition;
  String? throwingPosition;
  String? uploadTranscript;
  String? educationGpa;
  int? graduatingYear;
  bool? isBookMarked;


  DataSearch(
      {this.userID,
        this.roleID,
        this.divID,
        this.firstName,
        this.lastName,
        this.displayName,
        this.profileName,
        this.image,
        this.playerID,
        this.userEmail,
        this.bio,
        this.dOB,
        this.height,
        this.weight,
        this.contact,
        this.address,
        this.landMark,
        this.city,
        this.stateID,
        this.state,
        this.zipcode,
        this.joinDate,
        this.role,
        this.plan,
        this.positionPlayed,
        this.hittingPosition,
        this.throwingPosition,
        this.uploadTranscript,
        this.educationGpa,
        this.graduatingYear,
      this.isBookMarked});

  DataSearch.fromJson(Map<String, dynamic> json) {
    userID = json['userID'];
    roleID = json['roleID'];
    divID = json['divID'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    displayName = json['displayName'];
    profileName = json['profileName'];
    image = json['image'];
    playerID = json['playerID'];
    userEmail = json['userEmail'];
    bio = json['bio'];
    dOB = json['DOB'];
    height = json['height'];
    weight = json['weight'];
    contact = json['contact'];
    address = json['address'];
    landMark = json['landMark'];
    city = json['city'];
    stateID = json['stateID'];
    state = json['state'];
    zipcode = json['zipcode'];
    joinDate = json['joinDate'];
    role = json['role'];
    plan = json['plan'];
    positionPlayed = json['positionPlayed'];
    hittingPosition = json['hittingPosition'];
    throwingPosition = json['throwingPosition'];
    uploadTranscript = json['uploadTranscript'];
    educationGpa = json['educationGpa'];
    graduatingYear = json['graduatingYear'];
    isBookMarked = json['isBookMarked'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userID'] = this.userID;
    data['roleID'] = this.roleID;
    data['divID'] = this.divID;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['displayName'] = this.displayName;
    data['profileName'] = this.profileName;
    data['image'] = this.image;
    data['playerID'] = this.playerID;
    data['userEmail'] = this.userEmail;
    data['bio'] = this.bio;
    data['DOB'] = this.dOB;
    data['height'] = this.height;
    data['weight'] = this.weight;
    data['contact'] = this.contact;
    data['address'] = this.address;
    data['landMark'] = this.landMark;
    data['city'] = this.city;
    data['stateID'] = this.stateID;
    data['state'] = this.state;
    data['zipcode'] = this.zipcode;
    data['joinDate'] = this.joinDate;
    data['role'] = this.role;
    data['plan'] = this.plan;
    data['positionPlayed'] = this.positionPlayed;
    data['hittingPosition'] = this.hittingPosition;
    data['throwingPosition'] = this.throwingPosition;
    data['uploadTranscript'] = this.uploadTranscript;
    data['educationGpa'] = this.educationGpa;
    data['graduatingYear'] = this.graduatingYear;
    data['isBookMarked'] = this.isBookMarked;
    return data;
  }
}
