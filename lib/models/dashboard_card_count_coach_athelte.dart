class DashboardAthleteCouchCount {
  int? statusCode;
  String? message;
  List<BookMarkCount>? bookMarkCount;
  List<BookMarkCountDetails>? bookMarkCountDetails;
  List<ViewCount>? viewCount;
  List<ViewCountDetails>? viewCountDetails;

  DashboardAthleteCouchCount(
      {this.statusCode,
        this.message,
        this.bookMarkCount,
        this.bookMarkCountDetails,
        this.viewCount,
        this.viewCountDetails});

  DashboardAthleteCouchCount.fromJson(Map<String, dynamic> json) {
    statusCode = json['StatusCode'];
    message = json['message'];
    if (json['bookMarkCount'] != null) {
      bookMarkCount = <BookMarkCount>[];
      json['bookMarkCount'].forEach((v) {
        bookMarkCount!.add(new BookMarkCount.fromJson(v));
      });
    }
    if (json['bookMarkCountDetails'] != null) {
      bookMarkCountDetails = <BookMarkCountDetails>[];
      json['bookMarkCountDetails'].forEach((v) {
        bookMarkCountDetails!.add(new BookMarkCountDetails.fromJson(v));
      });
    }
    if (json['viewCount'] != null) {
      viewCount = <ViewCount>[];
      json['viewCount'].forEach((v) {
        viewCount!.add(new ViewCount.fromJson(v));
      });
    }
    if (json['ViewCountDetails'] != null) {
      viewCountDetails = <ViewCountDetails>[];
      json['ViewCountDetails'].forEach((v) {
        viewCountDetails!.add(new ViewCountDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['StatusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.bookMarkCount != null) {
      data['bookMarkCount'] =
          this.bookMarkCount!.map((v) => v.toJson()).toList();
    }
    if (this.bookMarkCountDetails != null) {
      data['bookMarkCountDetails'] =
          this.bookMarkCountDetails!.map((v) => v.toJson()).toList();
    }
    if (this.viewCount != null) {
      data['viewCount'] = this.viewCount!.map((v) => v.toJson()).toList();
    }
    if (this.viewCountDetails != null) {
      data['ViewCountDetails'] =
          this.viewCountDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BookMarkCount {
  int? roleTotal;
  String? name;
  String? roleName;

  BookMarkCount({this.roleTotal,this.name,this.roleName});

  BookMarkCount.fromJson(Map<String, dynamic> json) {
    roleTotal = json['role_total'];
    name = json['name'];
    roleName = json['roleName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['role_total'] = this.roleTotal;
    data['name'] = this.name;
    data['roleName'] = this.roleName;
    return data;
  }
}

class BookMarkCountDetails {
  int? userID;
  String? userName;
  String? name;
  String? roleName;
  String? picturePathS3;

  BookMarkCountDetails(
      {this.userID, this.userName, this.name, this.roleName, this.picturePathS3});

  BookMarkCountDetails.fromJson(Map<String, dynamic> json) {
    userID = json['userID'];
    userName = json['userName'];
    name = json['name'];
    roleName = json['roleName'];
    picturePathS3 = json['picturePathS3'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userID'] = this.userID;
    data['userName'] = this.userName;
    data['name'] = this.name;
    data['roleName'] = this.roleName;
    data['picturePathS3'] = this.picturePathS3;
    return data;
  }
}

class ViewCount {
  int? roleWiseViewTotal;
  String? name;
  String? roleName;

  ViewCount({this.roleWiseViewTotal,this.name,this.roleName});

  ViewCount.fromJson(Map<String, dynamic> json) {
    roleWiseViewTotal = json['role_wise_view_total'];
    name = json['name'];
    roleName = json['roleName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['role_wise_view_total'] = this.roleWiseViewTotal;
    data['name'] = this.name;
    data['roleName'] = this.roleName;
    return data;
  }
}

class ViewCountDetails {
  int? userID;
  String? userName;
  String? name;
  String? roleName;
  String? picturePathS3;

  ViewCountDetails(
      {this.userID, this.userName, this.name,this.roleName, this.picturePathS3});

  ViewCountDetails.fromJson(Map<String, dynamic> json) {
    userID = json['userID'];
    userName = json['userName'];
    name = json['name'];
    roleName = json['roleName'];
    picturePathS3 = json['picturePathS3'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userID'] = this.userID;
    data['userName'] = this.userName;
    data['name'] = this.name;
    data['roleName'] = this.roleName;
    data['picturePathS3'] = this.picturePathS3;
    return data;
  }
}

