class CoachDataTableModel {
  List<Catcher>? catcher;
  List<Pitcher>? pitcher;

  CoachDataTableModel({this.catcher, this.pitcher});

  CoachDataTableModel.fromJson(Map<String, dynamic> json) {
    if (json['Catcher'] != null) {
      catcher = <Catcher>[];
      json['Catcher'].forEach((v) {
        catcher!.add(new Catcher.fromJson(v));
      });
    }
    if (json['Pitcher'] != null) {
      pitcher = <Pitcher>[];
      json['Pitcher'].forEach((v) {
        pitcher!.add(new Pitcher.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.catcher != null) {
      data['Catcher'] = this.catcher!.map((v) => v.toJson()).toList();
    }
    if (this.pitcher != null) {
      data['Pitcher'] = this.pitcher!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Catcher {
  int? id;
  String? value;
  int? userID;
  String? dataType;
  String? fieldType;
  String? columnName;
  String? displayName;
  String? displayGroup;
  int? displayLevel;

  Catcher(
      {this.id,
        this.value,
        this.userID,
        this.dataType,
        this.fieldType,
        this.columnName,
        this.displayName,
        this.displayGroup,
        this.displayLevel});

  Catcher.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'];
    userID = json['userID'];
    dataType = json['dataType'];
    fieldType = json['fieldType'];
    columnName = json['columnName'];
    displayName = json['displayName'];
    displayGroup = json['displayGroup'];
    displayLevel = json['displayLevel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['value'] = this.value;
    data['userID'] = this.userID;
    data['dataType'] = this.dataType;
    data['fieldType'] = this.fieldType;
    data['columnName'] = this.columnName;
    data['displayName'] = this.displayName;
    data['displayGroup'] = this.displayGroup;
    data['displayLevel'] = this.displayLevel;
    return data;
  }
}

class Pitcher {
  int? id;
  String? value;
  int? userID;
  String? dataType;
  String? fieldType;
  String? columnName;
  String? displayName;
  String? displayGroup;
  int? displayLevel;

  Pitcher(
      {this.id,
        this.value,
        this.userID,
        this.dataType,
        this.fieldType,
        this.columnName,
        this.displayName,
        this.displayGroup,
        this.displayLevel});

  Pitcher.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'];
    userID = json['userID'];
    dataType = json['dataType'];
    fieldType = json['fieldType'];
    columnName = json['columnName'];
    displayName = json['displayName'];
    displayGroup = json['displayGroup'];
    displayLevel = json['displayLevel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['value'] = this.value;
    data['userID'] = this.userID;
    data['dataType'] = this.dataType;
    data['fieldType'] = this.fieldType;
    data['columnName'] = this.columnName;
    data['displayName'] = this.displayName;
    data['displayGroup'] = this.displayGroup;
    data['displayLevel'] = this.displayLevel;
    return data;
  }
}

