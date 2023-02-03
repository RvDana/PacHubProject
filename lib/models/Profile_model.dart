class ProfileModel {
  int? statusCode;
  Userdetails? userdetails;
  List<Attribute>? attribute;

  ProfileModel({this.statusCode, this.userdetails, this.attribute});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['StatusCode'];
    userdetails = json['userdetails'] != null
        ? Userdetails.fromJson(json['userdetails'])
        : null;
    if (json['attribute'].runtimeType == List) {
      json['attribute'].forEach((v) {
        attribute?.add(Attribute.fromJson(v));
      });
    } else {
      attribute?.add(Attribute.fromJson(json['attribute']));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['StatusCode'] = this.statusCode;
    if (this.userdetails != null) {
      data['userdetails'] = this.userdetails!.toJson();
    }
    if (this.attribute != null) {
      data['attribute'] = this.attribute!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Userdetails {
  int? userID;
  int? roleID;
  int? divID;
  String? firstName;
  String? lastName;
  String? displayName;
  String? profileName;
  String? picturePathS3;
  String? userEmail;
  String? bio;
  String? dOB;
  String? height;
  String? weight;
  String? contact;
  String? streetAddress;
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
  String? otherOrganizationName;
  String? committedTo;
  dynamic collegeName;
  dynamic colleges;
  int? subID;
  String? plan;

  Userdetails(
      {this.userID,
        this.roleID,
        this.divID,
        this.firstName,
        this.lastName,
        this.displayName,
        this.profileName,
        this.picturePathS3,
        this.userEmail,
        this.bio,
        this.dOB,
        this.height,
        this.weight,
        this.contact,
        this.streetAddress,
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
        this.otherOrganizationName,
        this.committedTo,
        this.collegeName,
        this.colleges,
        this.subID,
        this.plan});

  Userdetails.fromJson(Map<String, dynamic> json) {
    userID = json['userID'];
    roleID = json['roleID'];
    divID = json['divID'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    displayName = json['displayName'];
    profileName = json['profileName'];
    picturePathS3 = json['picturePathS3'];
    userEmail = json['userEmail'];
    bio = json['bio'];
    dOB = json['DOB'];
    height = json['height'];
    weight = json['weight'];
    contact = json['contact'];
    streetAddress = json['streetAddress'];
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
    otherOrganizationName = json['otherOrganizationName'];
    committedTo = json['committedTo'];
    collegeName = json['collegeName'];
    colleges = json['Colleges'];
    subID = json['subID'];
    plan = json['plan'];
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
    data['picturePathS3'] = this.picturePathS3;
    data['userEmail'] = this.userEmail;
    data['bio'] = this.bio;
    data['DOB'] = this.dOB;
    data['height'] = this.height;
    data['weight'] = this.weight;
    data['contact'] = this.contact;
    data['streetAddress'] = this.streetAddress;
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
    data['otherOrganizationName'] = this.otherOrganizationName;
    data['committedTo'] = this.committedTo;
    data['collegeName'] = this.collegeName;
    data['Colleges'] = this.colleges;
    data['subID'] = this.subID;
    data['plan'] = this.plan;
    return data;
  }
}

class Attribute {
  int? id;
  String? columnName;
  String? displayGroup;
  String? fieldType;
  String? displayName;
  String? dataType;
  int? level;
  int? roleID;
  List<Option>? options;
  String? childFields;
  List<Values>? value;

  Attribute(
      {this.id,
        this.columnName,
        this.displayGroup,
        this.fieldType,
        this.displayName,
        this.dataType,
        this.level,
        this.roleID,
        this.options,
        this.childFields,
        this.value});

  Attribute.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    columnName = json['columnName'];
    displayGroup = json['displayGroup'];
    fieldType = json['fieldType'];
    displayName = json['displayName'];
    dataType = json['dataType'];
    level = json['level'];
    roleID = json['roleID'];
    if (json['options'] != null) {
      options = <Option>[];
      json['options'].forEach((v) {
        options!.add(Option.fromJson(v));
      });
    }
    childFields = json['child_fields'];
    if (json['value'].runtimeType == List) {
      json['value'].forEach((v) {
        value?.add(Values.fromJson(v));
      });
    } else {
      value?.add(Values.fromJson(json['value']));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['columnName'] = this.columnName;
    data['displayGroup'] = this.displayGroup;
    data['fieldType'] = this.fieldType;
    data['displayName'] = this.displayName;
    data['dataType'] = this.dataType;
    data['level'] = this.level;
    data['roleID'] = this.roleID;
    if (this.options != null) {
      data['options'] = this.options!.map((v) => v.toJson()).toList();
    }
    data['child_fields'] = this.childFields;
    if (this.value != null) {
      data['value'] = this.value!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Option {
  int? id;
  String? name;

  Option({this.id, this.name});

  Option.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class Values {
  int? id;
  String? file;
  String? filePath;

  Values({this.id, this.file, this.filePath});

  Values.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    file = json['File'];
    filePath = json['FilePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['File'] = this.file;
    data['FilePath'] = this.filePath;
    return data;
  }
}
