class newALLchatlistmodel {
  int? statusCode;
  List<Chats>? chats;
  List<FavoriteMessage_new>? favoriteMessage;
  List<DeletedMessage_new>? deletedMessage;
  UnReadMessages? unReadMessages;

  newALLchatlistmodel(
      {this.statusCode,
        this.chats,
        this.favoriteMessage,
        this.deletedMessage,
        this.unReadMessages});

  newALLchatlistmodel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    if (json['chats'] != null) {
      chats = <Chats>[];
      json['chats'].forEach((v) {
        chats!.add(new Chats.fromJson(v));
      });
    }
    if (json['favoriteMessage'] != null) {
      favoriteMessage = <FavoriteMessage_new>[];
      json['favoriteMessage'].forEach((v) {
        favoriteMessage!.add(new FavoriteMessage_new.fromJson(v));
      });
    }
    if (json['deletedMessage'] != null) {
      deletedMessage = <DeletedMessage_new>[];
      json['deletedMessage'].forEach((v) {
        deletedMessage!.add(new DeletedMessage_new.fromJson(v));
      });
    }
    unReadMessages = json['unReadMessages'] != null
        ? new UnReadMessages.fromJson(json['unReadMessages'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    if (this.chats != null) {
      data['chats'] = this.chats!.map((v) => v.toJson()).toList();
    }
    if (this.favoriteMessage != null) {
      data['favoriteMessage'] =
          this.favoriteMessage!.map((v) => v.toJson()).toList();
    }
    if (this.deletedMessage != null) {
      data['deletedMessage'] =
          this.deletedMessage!.map((v) => v.toJson()).toList();
    }
    if (this.unReadMessages != null) {
      data['unReadMessages'] = this.unReadMessages!.toJson();
    }
    return data;
  }
}

class Chats {
  int? senderID;
  int? receiverID;
  String? displayName;
  String? picturePathS3;

  Chats({this.senderID, this.receiverID, this.displayName, this.picturePathS3});

  Chats.fromJson(Map<String, dynamic> json) {
    senderID = json['senderID'];
    receiverID = json['receiverID'];
    displayName = json['displayName'];
    picturePathS3 = json['picturePathS3'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['senderID'] = this.senderID;
    data['receiverID'] = this.receiverID;
    data['displayName'] = this.displayName;
    data['picturePathS3'] = this.picturePathS3;
    return data;
  }
}
class FavoriteMessage_new {
  int? senderID;
  int? receiverID;
  String? displayName;
  String? picturePathS3;

  FavoriteMessage_new({this.senderID, this.receiverID, this.displayName, this.picturePathS3});

  FavoriteMessage_new.fromJson(Map<String, dynamic> json) {
    senderID = json['senderID'];
    receiverID = json['receiverID'];
    displayName = json['displayName'];
    picturePathS3 = json['picturePathS3'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['senderID'] = this.senderID;
    data['receiverID'] = this.receiverID;
    data['displayName'] = this.displayName;
    data['picturePathS3'] = this.picturePathS3;
    return data;
  }
}
class DeletedMessage_new {
  int? senderID;
  int? receiverID;
  String? displayName;
  String? picturePathS3;

  DeletedMessage_new({this.senderID, this.receiverID, this.displayName, this.picturePathS3});

  DeletedMessage_new.fromJson(Map<String, dynamic> json) {
    senderID = json['senderID'];
    receiverID = json['receiverID'];
    displayName = json['displayName'];
    picturePathS3 = json['picturePathS3'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['senderID'] = this.senderID;
    data['receiverID'] = this.receiverID;
    data['displayName'] = this.displayName;
    data['picturePathS3'] = this.picturePathS3;
    return data;
  }
}

class UnReadMessages {
  int? unReadMessages;

  UnReadMessages({this.unReadMessages});

  UnReadMessages.fromJson(Map<String, dynamic> json) {
    unReadMessages = json['unReadMessages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unReadMessages'] = this.unReadMessages;
    return data;
  }
}
