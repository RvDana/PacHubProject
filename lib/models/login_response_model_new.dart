class LoginDataModel {
  int? userID;
  String? displayName;
  String? email;
  String? roleName;
  String? image;
  int? roleID;
  List<Menu>? menu;
  int? iat;
  int? exp;
  String? plan;
  String? sport;

  LoginDataModel(
      {this.userID,
        this.displayName,
        this.email,
        this.roleName,
        this.image,
        this.roleID,
        this.menu,
        this.iat,
        this.exp,
        this.plan,
        this.sport,
      });

  LoginDataModel.fromJson(Map<String, dynamic> json) {
    userID = json['userID'];
    displayName = json['displayName'];
    email = json['email'];
    roleName = json['roleName'];
    image = json['image'];
    roleID = json['roleID'];
    if (json['Menu'] != null) {
      menu = <Menu>[];
      json['Menu'].forEach((v) {
        menu!.add(new Menu.fromJson(v));
      });
    }
    iat = json['iat'];
    exp = json['exp'];
    plan= json['plan'];
    sport= json['sport'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userID'] = this.userID;
    data['displayName'] = this.displayName;
    data['email'] = this.email;
    data['roleName'] = this.roleName;
    data['image'] = this.image;
    data['roleID'] = this.roleID;
    if (this.menu != null) {
      data['Menu'] = this.menu!.map((v) => v.toJson()).toList();
    }
    data['iat'] = this.iat;
    data['exp'] = this.exp;
    data['plan'] = this.plan;
    data['sport'] = this.sport;

    return data;
  }
}

class Menu {
  String? displayName;
  String? url;
  String? icon;

  Menu({this.displayName, this.url, this.icon});

  Menu.fromJson(Map<String, dynamic> json) {
    displayName = json['displayName'];
    url = json['url'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['displayName'] = this.displayName;
    data['url'] = this.url;
    data['icon'] = this.icon;
    return data;
  }
}
