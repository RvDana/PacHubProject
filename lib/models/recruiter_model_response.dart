class RecruiterData {
  int? statusCode;
  String? message;
  List<Result>? result;

  RecruiterData({this.statusCode, this.message, this.result});

  RecruiterData.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['Message'];
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
    data['Message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  int? userID;
  String? userEmail;
  String? profileName;
  String? displayName;
  String? address;
  String? contact;
  String? bio;
  String? zipcode;
  String? organizationLandmark;
  String? organizationName;
  String? organizationCity;
  String? organizationState;
  String? organizationAddress;
  String? organizationZipcode;
  String? joinDate;
  String? divisionName;
  String? city;
  String? subscription;
  String? role;
  int? hideEmail;
  int? hidePhone;
  Null? coachRole;
  String? sport;
  bool? isBookMarked;

  Result(
      {this.userID,
        this.userEmail,
        this.profileName,
        this.displayName,
        this.address,
        this.contact,
        this.bio,
        this.zipcode,
        this.organizationLandmark,
        this.organizationName,
        this.organizationCity,
        this.organizationState,
        this.organizationAddress,
        this.organizationZipcode,
        this.joinDate,
        this.divisionName,
        this.city,
        this.subscription,
        this.role,
        this.hideEmail,
        this.hidePhone,
        this.coachRole,
        this.sport,
        this.isBookMarked});

  Result.fromJson(Map<String, dynamic> json) {
    userID = json['userID'];
    userEmail = json['userEmail'];
    profileName = json['profileName'];
    displayName = json['displayName'];
    address = json['address'];
    contact = json['contact'];
    bio = json['bio'];
    zipcode = json['zipcode'];
    organizationLandmark = json['organizationLandmark'];
    organizationName = json['organizationName'];
    organizationCity = json['organizationCity'];
    organizationState = json['organizationState'];
    organizationAddress = json['organizationAddress'];
    organizationZipcode = json['organizationZipcode'];
    joinDate = json['joinDate'];
    divisionName = json['divisionName'];
    city = json['city'];
    subscription = json['subscription'];
    role = json['role'];
    hideEmail = json['hideEmail'];
    hidePhone = json['hidePhone'];
    coachRole = json['coachRole'];
    sport = json['sport'];
    isBookMarked = json['isBookMarked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userID'] = this.userID;
    data['userEmail'] = this.userEmail;
    data['profileName'] = this.profileName;
    data['displayName'] = this.displayName;
    data['address'] = this.address;
    data['contact'] = this.contact;
    data['bio'] = this.bio;
    data['zipcode'] = this.zipcode;
    data['organizationLandmark'] = this.organizationLandmark;
    data['organizationName'] = this.organizationName;
    data['organizationCity'] = this.organizationCity;
    data['organizationState'] = this.organizationState;
    data['organizationAddress'] = this.organizationAddress;
    data['organizationZipcode'] = this.organizationZipcode;
    data['joinDate'] = this.joinDate;
    data['divisionName'] = this.divisionName;
    data['city'] = this.city;
    data['subscription'] = this.subscription;
    data['role'] = this.role;
    data['hideEmail'] = this.hideEmail;
    data['hidePhone'] = this.hidePhone;
    data['coachRole'] = this.coachRole;
    data['sport'] = this.sport;
    data['isBookMarked'] = this.isBookMarked;
    return data;
  }
}
