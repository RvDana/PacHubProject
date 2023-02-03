class SelectSportsModel {
  int? statusCode;
  List<SelectSportsResult>? result;

  SelectSportsModel({this.statusCode, this.result});

  SelectSportsModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    if (json['result'] != null) {
      result = <SelectSportsResult>[];
      json['result'].forEach((v) {
        result!.add(new SelectSportsResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SelectSportsResult {
  String? name;
  int? id;

  SelectSportsResult({this.name, this.id});

  SelectSportsResult.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    return data;
  }
}
