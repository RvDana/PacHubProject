class BookmarkModel {
  int? statusCode;
  List<BookMarkList>? bookMarkList;

  BookmarkModel({this.statusCode, this.bookMarkList});

  BookmarkModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    if (json['bookMarkList'] != null) {
      bookMarkList = <BookMarkList>[];
      json['bookMarkList'].forEach((v) {
        bookMarkList!.add(new BookMarkList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    if (this.bookMarkList != null) {
      data['bookMarkList'] = this.bookMarkList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BookMarkList {
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
  String? organizationName;
  String? organizationAddress;
  String? organizationLandmark;
  String? organizationCity;
  int? organizationStateID;
  String? organizationState;
  String? organizationZipcode;
  String? joinDate;
  String? role;
  String? plan;
  String? committedTo;
  String? ageAtDraft;
  String? currentSchool;
  int? hideEmail;
  int? hidePhone;
  String? coachRole;
  String? positionPlayed;
  String? hittingPosition;
  String? throwingPosition;
  String? uploadTranscript;
  String? educationGpa;
  String? nCAAID;
  int? graduatingYear;
  int? isPreferred;

  BookMarkList(
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
        this.organizationName,
        this.organizationAddress,
        this.organizationLandmark,
        this.organizationCity,
        this.organizationStateID,
        this.organizationState,
        this.organizationZipcode,
        this.joinDate,
        this.role,
        this.plan,
        this.committedTo,
        this.ageAtDraft,
        this.currentSchool,
        this.hideEmail,
        this.hidePhone,
        this.coachRole,
        this.positionPlayed,
        this.hittingPosition,
        this.throwingPosition,
        this.uploadTranscript,
        this.educationGpa,
        this.nCAAID,
        this.graduatingYear,
        this.isPreferred});

  BookMarkList.fromJson(Map<String, dynamic> json) {
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
    organizationName = json['organizationName'];
    organizationAddress = json['organizationAddress'];
    organizationLandmark = json['organizationLandmark'];
    organizationCity = json['organizationCity'];
    organizationStateID = json['organizationStateID'];
    organizationState = json['organizationState'];
    organizationZipcode = json['organizationZipcode'];
    joinDate = json['joinDate'];
    role = json['role'];
    plan = json['plan'];
    committedTo = json['committedTo'];
    ageAtDraft = json['ageAtDraft'];
    currentSchool = json['currentSchool'];
    hideEmail = json['hideEmail'];
    hidePhone = json['hidePhone'];
    coachRole = json['coachRole'];
    positionPlayed = json['positionPlayed'];
    hittingPosition = json['hittingPosition'];
    throwingPosition = json['throwingPosition'];
    uploadTranscript = json['uploadTranscript'];
    educationGpa = json['educationGpa'];
    nCAAID = json['NCAAID'];
    graduatingYear = json['graduatingYear'];
    isPreferred = json['isPreferred'];
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
    data['organizationName'] = this.organizationName;
    data['organizationAddress'] = this.organizationAddress;
    data['organizationLandmark'] = this.organizationLandmark;
    data['organizationCity'] = this.organizationCity;
    data['organizationStateID'] = this.organizationStateID;
    data['organizationState'] = this.organizationState;
    data['organizationZipcode'] = this.organizationZipcode;
    data['joinDate'] = this.joinDate;
    data['role'] = this.role;
    data['plan'] = this.plan;
    data['committedTo'] = this.committedTo;
    data['ageAtDraft'] = this.ageAtDraft;
    data['currentSchool'] = this.currentSchool;
    data['hideEmail'] = this.hideEmail;
    data['hidePhone'] = this.hidePhone;
    data['coachRole'] = this.coachRole;
    data['positionPlayed'] = this.positionPlayed;
    data['hittingPosition'] = this.hittingPosition;
    data['throwingPosition'] = this.throwingPosition;
    data['uploadTranscript'] = this.uploadTranscript;
    data['educationGpa'] = this.educationGpa;
    data['NCAAID'] = this.nCAAID;
    data['graduatingYear'] = this.graduatingYear;
    data['isPreferred'] = this.isPreferred;
    return data;
  }
}
