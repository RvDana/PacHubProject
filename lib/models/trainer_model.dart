class TrainerModel {
  int? statusCode;
  List<Trainer>? trainer;

  TrainerModel({this.statusCode, this.trainer});

  TrainerModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    if (json['trainer'] != null) {
      trainer = <Trainer>[];
      json['trainer'].forEach((v) {
        trainer!.add(new Trainer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    if (this.trainer != null) {
      data['trainer'] = this.trainer!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Trainer {
  int? trainerID;
  String? trainerName;

  Trainer({this.trainerID, this.trainerName});

  Trainer.fromJson(Map<String, dynamic> json) {
    trainerID = json['TrainerID'];
    trainerName = json['TrainerName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TrainerID'] = this.trainerID;
    data['TrainerName'] = this.trainerName;
    return data;
  }
}
