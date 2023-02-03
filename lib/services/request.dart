import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pachub/Utils/appstring.dart';
import 'package:pachub/app_function/MyAppFunction.dart';
import 'package:pachub/models/Profile_model.dart';
import 'package:pachub/models/admin_athletes_model.dart';
import 'package:pachub/models/AllChatModel/all_chat_list_model.dart';
import 'package:pachub/models/bookmark_model.dart';
import 'package:pachub/models/dashbaord_recent_activities.dart';
import 'package:pachub/models/dashboard_card_count_coach_athelte.dart';
import 'package:pachub/models/dashboard_total_amount_model.dart';
import 'package:pachub/models/manage_subscription_model.dart';
import 'package:pachub/models/mychatlistmodel/mychatlistmodel.dart';
import 'package:pachub/models/pending_payment_List_model.dart';
import 'package:pachub/models/selectsportsmodel.dart';
import 'package:pachub/models/solicited_user_model.dart';
import 'package:pachub/models/stats_model.dart';
import 'package:pachub/view/login/login_view.dart';
import '../Utils/constant.dart';
import '../config/preference.dart';
import '../models/unbookmarkmodel.dart';
import '../models/new_allchatlist_model.dart';

class Services {
  final String? url;
  final  body;
  var header;

  Services({this.url, this.body, this.header});

  Future<http.Response> ForgotPasswordRequest() {
    return http
        .post(Uri.parse(AppConstant.FORGOT_PASSWORD), body: body)
        .timeout(Duration(minutes: 2));
  }

  Future<http.Response> ChangePasswordRequest() {
    return http
        .post(Uri.parse(AppConstant.CHANGE_PASSWORD),
            headers: header, body: body)
        .timeout(Duration(minutes: 2));
  }
}

/// Get Api

Future<TotalAmountModel?> getAdminDashboardCardCounting(String? accessToken) async {
  var client = http.Client();

  try {
    http.Response data = await client.get(
      Uri.parse(AppConstant.MODE_DASHBAORD),
      headers: {"Authorization": "Bearer $accessToken"},
    );
    print('AdminDashboardCardCounting URL : ' + data.request.toString());
    print("AdminDashboardCardCounting Response:" + data.body);
    print("AdminDashboardCardCounting token $accessToken");
    // if(data.statusCode == 401) {
    //   return Get.offAll(Loginscreennew());
    // }

    return TotalAmountModel.fromJson(json.decode(data.body));
  } catch (val) {
    print(val);
  } finally {
    client.close();
  }
  return null;
}

Future<DashboardRecentActivities?> getRecentActivitiesApi(String? accessToken) async {
  var client = http.Client();

  try {
    http.Response data = await client.get(
      Uri.parse(AppConstant.RECENT_USERS),
      headers: {"Authorization": "Bearer $accessToken"},
    );
    print('RecentActivities URL : ' + data.request.toString());
    print("RecentActivities Response:" + data.body);
    print("RecentActivities token $accessToken");



    return DashboardRecentActivities.fromJson(json.decode(data.body));
  } catch (val) {
    print(val);
  } finally {
    client.close();
  }
  return null;
}

Future<AdminAthletesModel?> getAthleteListApi(String? accessToken, int page, int limit, String roleId) async {
  var client = http.Client();

  try {
    http.Response data = await client.post(
      Uri.parse(AppConstant.ADMIN_USERS),

      body: {
        "roleID": roleId,
      },
      headers: {"Authorization": "Bearer $accessToken"},
    );
    print('AthleteList URL : ' + data.request.toString());
    print("AthleteList Response:" + data.body);
    print("AthleteList token $accessToken");




    return AdminAthletesModel.fromJson(json.decode(data.body));
  } catch (val) {
    print(val);
  } finally {
    client.close();
  }
  return null;
}



Future<AdminAthletesModel?> getSearchByDateAthleteListApi(String? accessToken, int page, int limit, String roleId, String? stDate, String? edDate) async {
  var client = http.Client();

  try {
    http.Response data = await client.post(
      Uri.parse(
        "${AppConstant.ADMIN_USERS}page=$page&size=$limit",
      ),
      body: {
        "roleID": roleId,
        "startDate": stDate,
        "endDate": edDate
      },
      headers: {"Authorization": "Bearer $accessToken"},
    );
    print('SearchByDateAthleteList URL : ' + data.request.toString());
    print("SearchByDateAthleteList Response:" + data.body);
    print("SearchByDateAthleteList token $accessToken");

    // if(data.statusCode == 401) {
    //   return Get.offAll(Loginscreennew());
    // }


    return AdminAthletesModel.fromJson(json.decode(data.body));
  } catch (val) {
    print(val);
  } finally {
    client.close();
  }
  return null;
}


Future<ProfileModel?> getManageProfile(String? accessToken, String? userId) async {
  var client = http.Client();

  try {
    http.Response data = await client.get(
      Uri.parse("${AppConstant.mamage_profile}/$userId"),
      headers: {"Authorization": "Bearer $accessToken"},
    );
    print('ManageProfile URL : ' + data.request.toString());
    print("ManageProfile Response:" + data.body);
    print("ManageProfile token $accessToken");

    // if(data.statusCode == 401) {
    //   return Get.offAll(Loginscreennew());
    // }


    return ProfileModel.fromJson(json.decode(data.body));
  } catch (val) {
    print(val);
  } finally {
    client.close();
  }
  return null;
}



Future<BookmarkModel?> getBookMarkList(String? accessToken, int page, int limit) async {
  var client = http.Client();

  try {
    http.Response data = await client.get(
      Uri.parse("${AppConstant.BOOK_MARK}page=$page&size=$limit"),
      headers: {"Authorization": "Bearer $accessToken"},
    );

    print('bookmark URL : ' + data.request.toString());
    print("bookmark Response:" + data.body);
    print("bookmark token $accessToken");

    // if(data.statusCode == 401) {
    //   return Get.offAll(Loginscreennew());
    // }
 /* var resData = json.decode(data.body);
    if(resData['statusCode'] == 200) {
      print('ManageSubscription URL : ' + data.request.toString());
      print("ManageSubscription Response:" + data.body);
      print("ManageSubscription token $accessToken");
       var uniqueRole = resData['data'].map((item) => item['role']).toSet().toList();
      var uniMap = {};
      uniqueRole.forEach((item) {
      uniMap[item] = resData['data'].where((element) => element['role'] == item).toList();
      });

      print("UNIMAP DaTA : "  + uniMap.toString());
      return uniMap;
    } else  if(data.statusCode == 401) {
      return Get.offAll(Loginscreennew());
    }*/


    return BookmarkModel.fromJson(json.decode(data.body));
  } catch (val) {
    print(val);
  } finally {
    client.close();
  }
  return null;
}



/// Post Api

postAssignTrainer(BuildContext context, int? userID, String clientTrainerID) async {
  MyApplication.getInstance()!
      .checkConnectivity(context)
      .then((internet) async {
    if (internet != null && internet) {
      try {
        Dio dio = Dio();
        var params = {
          "userID":[userID],
          "client_trainerID":clientTrainerID
        };
        print("$params");
        var response = await dio.post(AppConstant.assign_trainer_athletes,
            data: params,
            options: Options(
                followRedirects: false,
                headers:{
                  "Authorization": "Bearer ${PreferenceUtils.getString("accesstoken")}"
                }
            ));
        if (response.statusCode == 200) {
          print("response ====<> ${response.data}");
          MyApplication.getInstance()?.showInGreenSnackBar(response.data["Message"], context);
          Get.back();
        }
        // else if(response.statusCode == 401) {
        //   return Get.offAll(Loginscreennew());
        // }
        else {
          MyApplication.getInstance()?.showInSnackBar(response.data["Message"], context);
          Get.back();
        }
      } on DioError catch (e) {
        if (e is DioError) {
          MyApplication.getInstance()?.showInSnackBar(e.response!.data["Message"], context);
        }
        Get.back();
      }
    } else {
      MyApplication.getInstance()
          ?.showInSnackBar(AppString.no_connection, context);
    }
  });
}

postChangeTrainer(BuildContext context, int? userID, String clientTrainerID) async {
  MyApplication.getInstance()!
      .checkConnectivity(context)
      .then((internet) async {
    if (internet != null && internet) {
      try {
        Dio dio = Dio();
        var params = {
          "userID":[userID],
          "client_trainerID":clientTrainerID
        };
        print("data2 ===<><>< $params");
        var response = await dio.post(AppConstant.assign_trainer_athletes,
            data: params,
            options: Options(
                followRedirects: false,
                headers:{
                  "Authorization": "Bearer ${PreferenceUtils.getString("accesstoken")}"
                }
            ));
        if (response.statusCode == 200) {
          print("response ====<> ${response.data}");
          MyApplication.getInstance()?.showInGreenSnackBar(response.data["Message"], context);
          Get.back();
        }
        // else if(response.statusCode == 401) {
        //   return Get.offAll(Loginscreennew());
        // }
        else {
          MyApplication.getInstance()?.showInSnackBar(response.data["Message"], context);
          Get.back();
        }
      } on DioError catch (e) {
        if (e is DioError) {
          MyApplication.getInstance()?.showInSnackBar(e.response!.data["Message"], context);
        }
        Get.back();
      }
    } else {
      MyApplication.getInstance()
          ?.showInSnackBar(AppString.no_connection, context);
    }
  });
}

postUpdatePlayerId(BuildContext context, String playerID, String userId) async {
  MyApplication.getInstance()!
      .checkConnectivity(context)
      .then((internet) async {
    if (internet != null && internet) {
      try {
        Dio dio = Dio();
        var params = {
          "userID": userId,
          "playerID": playerID
        };
        print("player update ===<<>< $params");
        var response = await dio.post(AppConstant.update_playerid,
            data: params,
            options: Options(
                followRedirects: false,
                headers:{
                  "Authorization": "Bearer ${PreferenceUtils.getString("accesstoken")}"
                }
            ));
        if (response.statusCode == 200) {
          print("response ====<> ${response.data}");
          MyApplication.getInstance()?.showInGreenSnackBar(response.data["Message"], context);
          Navigator.pop(context);
        }
        // else if(response.statusCode == 401) {
        //   return Get.offAll(Loginscreennew());
        // }
        else {
          MyApplication.getInstance()?.showInSnackBar(response.data["Message"], context);
          Navigator.pop(context);
        }
      } on DioError catch (e) {
        if (e is DioError) {
          MyApplication.getInstance()?.showInSnackBar(e.response!.data["Message"], context);
        }
        Navigator.pop(context);
      }
    } else {
      MyApplication.getInstance()
          ?.showInSnackBar(AppString.no_connection, context);
    }
  });
}



postApproveRequest(BuildContext context, int? userID, String status, String clientTrainerID) async {
  print("$status");
  MyApplication.getInstance()!
      .checkConnectivity(context)
      .then((internet) async {
    if (internet != null && internet) {
      try {
        Dio dio = Dio();
        var params =  {
          "userID":[userID],
          "status": "Approved",
          // "client_trainerID": clientTrainerID
        };
        print("=========<><> $params");
        var response = await dio.post(AppConstant.admin_Approval,
            data: params,
            options: Options(
                followRedirects: false,
                headers:{
                  "Authorization": "Bearer ${PreferenceUtils.getString("accesstoken")}"
                }
            ));
        if (response.statusCode == 200) {
          print("response ====<> ${response.data}");
          MyApplication.getInstance()?.showInGreenSnackBar(response.data["Message"], context);
          Navigator.pop(context);
        }
        // else if(response.statusCode == 401) {
        //   return Get.offAll(Loginscreennew());
        // }
        else {
          MyApplication.getInstance()?.showInSnackBar(response.data["Message"], context);
          Navigator.pop(context);
        }
      } on DioError catch (e) {
        if (e is DioError) {
          MyApplication.getInstance()?.showInSnackBar(e.response!.data["Message"], context);
        }
        Navigator.pop(context);
      }
    } else {
      MyApplication.getInstance()
          ?.showInSnackBar(AppString.no_connection, context);
    }
  });
}

postApproveRequest2(BuildContext context, int? userID, String status, String clientTrainerID, String playerID, String? trainer, String comment) async {
  print("$status");
  MyApplication.getInstance()!
      .checkConnectivity(context)
      .then((internet) async {
    if (internet != null && internet) {
      try {
        Dio dio = Dio();
        var params =  {
          "userID":[userID],
          "status": "Approved",
          "client_trainerID": trainer,
          "playerID":playerID,
          "comment": comment,
        };
        print("=========<><> $params");
        var response = await dio.post(AppConstant.admin_Approval,
            data: params,
            options: Options(
                followRedirects: false,
                headers:{
                  "Authorization": "Bearer ${PreferenceUtils.getString("accesstoken")}"
                }
            ));
        if (response.statusCode == 200) {
          print("response ====<> ${response.data}");
          MyApplication.getInstance()?.showInGreenSnackBar(response.data["Message"], context);
          Navigator.pop(context);
        }
        // else if(response.statusCode == 401) {
        //   return Get.offAll(Loginscreennew());
        // }
        else {
          MyApplication.getInstance()?.showInSnackBar(response.data["Message"], context);
          Navigator.pop(context);
        }
      } on DioError catch (e) {
        if (e is DioError) {
          MyApplication.getInstance()?.showInSnackBar(e.response!.data["Message"], context);
        }
        Navigator.pop(context);
      }
    } else {
      MyApplication.getInstance()
          ?.showInSnackBar(AppString.no_connection, context);
    }
  });
}

postApproveRequest3(BuildContext context, int? userID, String status, String? trainer, String comment) async {
  print("$status");
  MyApplication.getInstance()!
      .checkConnectivity(context)
      .then((internet) async {
    if (internet != null && internet) {
      try {
        Dio dio = Dio();
        var params =  {
          "userID":[userID],
          "status": "Approved",
          "client_trainerID": trainer,
          "comment": comment,
        };
        print("=========<><> $params");
        var response = await dio.post(AppConstant.admin_Approval,
            data: params,
            options: Options(
                followRedirects: false,
                headers:{
                  "Authorization": "Bearer ${PreferenceUtils.getString("accesstoken")}"
                }
            ));
        if (response.statusCode == 200) {
          print("response ====<> ${response.data}");
          MyApplication.getInstance()?.showInGreenSnackBar(response.data["Message"], context);
          Navigator.pop(context);
        }
        // else if(response.statusCode == 401) {
        //   return Get.offAll(Loginscreennew());
        // }
        else {
          MyApplication.getInstance()?.showInSnackBar(response.data["Message"], context);
          Navigator.pop(context);
        }
      } on DioError catch (e) {
        if (e is DioError) {
          MyApplication.getInstance()?.showInSnackBar(e.response!.data["Message"], context);
        }
        Navigator.pop(context);
      }
    } else {
      MyApplication.getInstance()
          ?.showInSnackBar(AppString.no_connection, context);
    }
  });
}



postAdminReject(BuildContext context, String? userID, String comment) async {
  MyApplication.getInstance()!
      .checkConnectivity(context)
      .then((internet) async {
    if (internet != null && internet) {
      try {
        Dio dio = Dio();
        var params = {
          "userID":userID,
          "status": "Rejected",
          "comment": comment,
        };
        var response = await dio.post(AppConstant.admin_reject,
            data: params,
            options: Options(
                followRedirects: false,
                headers:{
                  "Authorization": "Bearer ${PreferenceUtils.getString("accesstoken")}"
                }
            ));
        if (response.statusCode == 200) {
          print("response ====<> ${response.data}");
          MyApplication.getInstance()?.showInGreenSnackBar(response.data["Message"], context);
          Navigator.pop(context);
        }
        // else if(response.statusCode == 401) {
        //   return Get.offAll(Loginscreennew());
        // }
        else {
          MyApplication.getInstance()?.showInSnackBar(response.data["Message"], context);
          Navigator.pop(context);
        }
      } on DioError catch (e) {
        if (e is DioError) {
          MyApplication.getInstance()?.showInSnackBar(e.response!.data["Message"], context);
        }
       Navigator.pop(context);
      }
    } else {
      MyApplication.getInstance()
          ?.showInSnackBar(AppString.no_connection, context);
    }
  });
}
 Future<StatsModel?>StatsApi(String playerlinkid) async {
  var client = http.Client();
  try {
    http.Response response = await client.post(
      Uri.parse(AppConstant.Stats),
      body: {"playerlinkid": playerlinkid},
        headers:{
          "Authorization": "Bearer ${PreferenceUtils.getString("accesstoken")}"
        }
        );
    if(response.statusCode == 200){
      print('Stats  URL : ${response.request}');
      print("Stats Response:${response.body}");
      var jsonResponse = json.decode(response.body);
      var data = jsonResponse['playerStats']['battingstats'];
      print("response battingList : $data");
    }
    return StatsModel.fromJson(json.decode(response.body));
  } catch (val) {
    print(val);
  } finally {
    client.close();
  }
  return null;
}


Future deletePost(String id, BuildContext context) async {
  var client = http.Client();
  try {
    http.Response data = await client.post(
        Uri.parse(AppConstant.Delete,),
        body: {"id": id},
        headers:{
          "Authorization": "Bearer ${PreferenceUtils.getString("accesstoken")}"
        }
    );
    if(data.statusCode == 200){
      print('delete  URL : ' + data.request.toString());
      print("delete Response:" + data.body);
      MyApplication.getInstance()?.showInGreenSnackBar("Message send Successfully!", context);
    } else {
      Get.back();
    }
    return StatsModel.fromJson(json.decode(data.body));
  } catch (val) {
    print(val);
  } finally {
    client.close();
  }
  return null;
}



///////////////////TODO MESSAGE API CALL///////////////////////////
SendMessageApi(String? accessToken,String receiverID,String text,BuildContext context) async {
  var client = http.Client();
  try {
    http.Response data = await client.post(
      Uri.parse(
        "${AppConstant.Message_send}",
      ),
      body: {"receiverID": receiverID,"text" : text},
      headers: {"Authorization": "Bearer $accessToken"},
    );
    if(data.statusCode == 200){
      print('sendmessage  URL : ' + data.request.toString());
      print("sendmessage Response:" + data.body);
      MyApplication.getInstance()?.showInGreenSnackBar("Message send Successfully!", context);
    }
    // else if(data.statusCode == 401) {
    //   return Get.offAll(Loginscreennew());
    // }
    //return AdminAthletesModel.fromJson(json.decode(data.body));
  } catch (val) {
    print(val);
  } finally {
    client.close();
  }
  return null;
}
Future<newALLchatlistmodel?> getallChatList(String? accessToken) async {
  var client = http.Client();

  try {
    http.Response data = await client.get(
      Uri.parse(AppConstant.Message_All_chat_listing),
      headers: {"Authorization": "Bearer $accessToken"},
    );
    print('chat all list URL : ' + data.request.toString());
    print("All chat list Response:" + data.body);

    // if(data.statusCode == 401) {
    //   return Get.offAll(Loginscreennew());
    // }

    return newALLchatlistmodel.fromJson(json.decode(data.body));
  } catch (val) {
    print(val);
  } finally {
    client.close();
  }
  return null;
}
Future<MYMessagechatlistingModel?>ChatMessageApi(String? accessToken,String receiverID) async {
  var client = http.Client();
  try {
    http.Response data = await client.post(
      Uri.parse(
        "${AppConstant.Message_chats}",
      ),
      body: {"receiverID": receiverID},
      headers: {"Authorization": "Bearer $accessToken"},
    );
    if(data.statusCode == 200){
      print('chatmsg  URL : ' + data.request.toString());
      print("chatmessage Response:" + data.body);
    }
    // else if(data.statusCode == 401) {
    //   return Get.offAll(Loginscreennew());
    // }

    return MYMessagechatlistingModel.fromJson(json.decode(data.body));
  } catch (val) {
    print(val);
  } finally {
    client.close();
  }
  return null;
}

HARD_DeleteMessageApi(String? accessToken,String messageid,BuildContext context) async {
  var client = http.Client();
  try {
    http.Response data = await client.post(
      Uri.parse(
        "${AppConstant.Hard_delete_message}",
      ),
      body: {"messageID": messageid},
      headers: {"Authorization": "Bearer $accessToken"},
    );
    if(data.statusCode == 200){
      print('Delete msg  URL : ' + data.request.toString());
      print("Delete Response:" + data.body);
      MyApplication.getInstance()?.showInGreenSnackBar("Message deleted Successfully!", context);
    }
    // else  if(data.statusCode == 401) {
    //   return Get.offAll(Loginscreennew());
    // }
    //return StatsModel.fromJson(json.decode(data.body));
  } catch (val) {
    print(val);
  } finally {
    client.close();
  }
  return null;
}
DeleteMessageApi(String? accessToken,String messageid,BuildContext context) async {
  var client = http.Client();
  try {
    http.Response data = await client.post(
      Uri.parse(
        "${AppConstant.Message_delete}",
      ),
      body: {"messageID": messageid},
      headers: {"Authorization": "Bearer $accessToken"},
    );
    if(data.statusCode == 200){
      print('Delete msg  URL : ' + data.request.toString());
      print("Delete Response:" + data.body);
      MyApplication.getInstance()?.showInGreenSnackBar("Message deleted Successfully!", context);
    }
    // else  if(data.statusCode == 401) {
    //   return Get.offAll(Loginscreennew());
    // }
    //return StatsModel.fromJson(json.decode(data.body));
  } catch (val) {
    print(val);
  } finally {
    client.close();
  }
  return null;
}
FavouriteMessageApi(String? accessToken,String messageid,BuildContext context) async {
  var client = http.Client();
  try {
    http.Response data = await client.post(
      Uri.parse(
        "${AppConstant.Message_favourite}",
      ),
      body: {"messageID": messageid},
      headers: {"Authorization": "Bearer $accessToken"},
    );
    if(data.statusCode == 200){
      print('Favourite msg  URL : ' + data.request.toString());
      print("Favourite Response:" + data.body);
      MyApplication.getInstance()?.showInGreenSnackBar("Message favourite Successfully!!", context);
    }
    // else  if(data.statusCode == 401) {
    //   return Get.offAll(Loginscreennew());
    // }
    //return StatsModel.fromJson(json.decode(data.body));
  } catch (val) {
    print(val);
  } finally {
    client.close();
  }
  return null;
}
ReadMessageApi(int? messageid,BuildContext context) async {
  MyApplication.getInstance()!
      .checkConnectivity(context)
      .then((internet) async {
    if (internet != null && internet) {
      try {
        Dio dio = Dio();
        var params = {
          "messageID":[messageid],
        };
        var response = await dio.post(AppConstant.Message_read,
            data: params,
            options: Options(
                followRedirects: false,
                headers:{
                  "Authorization": "Bearer ${PreferenceUtils.getString("accesstoken")}"
                }
            )
        );
        if (response.statusCode == 200) {
          print(" message read response ====<> ${response.data}");
          //MyApplication.getInstance()?.showInSnackBar(response.data["Message"], context);
          Get.back();
        }
        // else if(response.statusCode == 401) {
        //   return Get.offAll(Loginscreennew());
        // }
        else {
          MyApplication.getInstance()?.showInSnackBar(response.data["Message"], context);
          Get.back();
        }
      } on DioError catch (e) {
        if (e is DioError) {
          MyApplication.getInstance()?.showInSnackBar(e.response!.data["Message"], context);
        }
        Get.back();
      }
    } else {
      MyApplication.getInstance()
          ?.showInSnackBar(AppString.no_connection, context);
    }
  });
}

/////////////////////////////////TODO DASHBOARD COACH ATHELETE CARD COUNT//////////////////////////////
Future<DashboardAthleteCouchCount?> get_Dashboard_Card_count_coach_athelte(String? accessToken) async {
  var client = http.Client();
  try {
    http.Response data = await client.get(
      Uri.parse(AppConstant.COACH_athlete_Dashboard_card_count),
      headers: {"Authorization": "Bearer $accessToken"},
    );
    print('Dashboard_Card_count_coach_athelte URL : ' + data.request.toString());
    print("Dashboard_Card_count_coach_athelte Response:" + data.body);
    print("Dashboard_Card_count_coach_athelte token $accessToken");


    return DashboardAthleteCouchCount.fromJson(json.decode(data.body));
  } catch (val) {
    print("value ====> $val");
  } finally {
    client.close();
  }
  return null;
}

/////////////////////////////////TODO SELECT SPORTS API//////////////////////////////

// Future<SelectSportsResult?> SelcteSportsList() async {
//   var client = http.Client();
//   try {
//     http.Response data = await client.get(
//       Uri.parse("${AppConstant.SELECTSPORTS}"),
//     );
//     print('SELECT SPORTS URL : ' + data.request.toString());
//     print("SELECT SPORTS Response:" + data.body);
//     return SelectSportsResult.fromJson(json.decode(data.body));
//   } catch (val) {
//     print(val);
//   } finally {
//     client.close();
//   }
//   return null;
// }


/////////////////////////////////////TODO MANAGE subscription//////////////////////////
Future<ManageSubscriptionModel?> getManageSubscription_ALL_LISTING(String? accessToken) async {
  var client = http.Client();

  try {
    http.Response data = await client.get(
      Uri.parse(AppConstant.Subscription_All_list_BILLING_HISTORY),
      headers: {"Authorization": "Bearer $accessToken"},
    );
    print('ManageSubscriptionAllListing URL : ' + data.request.toString());
    print("ManageSubscriptionAllListing Response:" + data.body);
    print("ManageSubscriptionAllListing token $accessToken");



    return ManageSubscriptionModel.fromJson(json.decode(data.body));
  } catch (val) {
    print("value =====>> $val");
  } finally {
    client.close();
  }
  return null;
}
Future Cancel_Subscription(String? accessToken) async {
  var client = http.Client();

  try {
    http.Response data = await client.get(
      Uri.parse(AppConstant.CANCEL_SUBSCRIPTION),
      headers: {"Authorization": "Bearer $accessToken"},
    );
    print('Canccel_Subscription URL : ' + data.request.toString());
    print("Canccel_Subscription Response:" + data.body);
    print("Canccel_Subscription token $accessToken");


    //return ManageSubscriptionModel.fromJson(json.decode(data.body));
  } catch (val) {
    print("value =====>> $val");
  } finally {
    client.close();
  }
  return null;
}

/////////////////////////////////////TODO MANAGE subscription//////////////////////////
Future<PendingPaymentListModel?> getPendingPayment_ALL_LISTING(String? accessToken) async {
  var client = http.Client();

  try {
    http.Response data = await client.get(
      Uri.parse(AppConstant.pendingPaymentguser),
      headers: {"Authorization": "Bearer $accessToken"},
    );
    print('PendingPayment URL : ' + data.request.toString());
    print("PendingPayment Response:" + data.body);
    print("PendingPayment token $accessToken");

    return PendingPaymentListModel.fromJson(json.decode(data.body));
  } catch (val) {
    print("value =====>> $val");
  } finally {
    client.close();
  }
  return null;
}
Future sendPaymentLink(String id, BuildContext context) async {
  var client = http.Client();
  try {
    http.Response data = await client.post(
        Uri.parse(AppConstant.paymentLink),
        body: {"userID": id},
        headers:{
          "Authorization": "Bearer ${PreferenceUtils.getString("accesstoken")}"
        }
    );
    if(data.statusCode == 200){
      print('sendPaymentLink  URL : ' + data.request.toString());
      print("sendPaymentLink Response:" + data.body);
      MyApplication.getInstance()?.showInGreenSnackBar("Repayment link send successfully!", context);
    }
    return StatsModel.fromJson(json.decode(data.body));
  } catch (val) {
    print("value =====>> $val");
  } finally {
    client.close();
  }
  return null;
}

Future <BookmarkUnbookmarkModel?>Unbookmarklisttickapi(String bookmarkid,context) async {
  var client = http.Client();
  try {
    http.Response data = await client.post(
        Uri.parse(AppConstant.BookMarkListTICK),
        body: {"bookMarkedID": bookmarkid},
        headers:{
          "Authorization": "Bearer ${PreferenceUtils.getString("accesstoken")}"
        }
    );
    if(data.statusCode == 200){
      //print('sendPaymentLink  URL : ' + data.request.toString());
      print("bookmarklist click Response:" + data.body);
      Map<String, dynamic> usermap = jsonDecode(data.body);
      BookmarkUnbookmarkModel  bookmarkModel;
      bookmarkModel = BookmarkUnbookmarkModel.fromJson(usermap);
      print("this is bookmark msg ${bookmarkModel.message}");
      MyApplication.getInstance()?.showInGreenSnackBar("${bookmarkModel.message}", context);
    }
    return BookmarkUnbookmarkModel.fromJson(json.decode(data.body));

  } catch (val) {
    print("value =====>> $val");
  } finally {
    client.close();
  }
  return null;
}

//////TODO Solicited List Api ////////

Future<SolicitedUserModel?>solicitedUser(int? solicited, String? stDate, String? edDate) async {
  print('start Date   : $stDate');
  print('first Date   : $edDate');

  var client = http.Client();
  try {
    http.Response response = await client.post(
        Uri.parse(AppConstant.solicited_use),
        body: {
          "solicitedID": solicited.toString(),
          "startDate": stDate.toString(),
          "endDate": edDate.toString(),
        },
        headers:{
          "Authorization": "Bearer ${PreferenceUtils.getString("accesstoken")}"
        }
    );
    if(response.statusCode == 200){
      print('solicited_user  URL : ${response.request}');
      print("solicited_user Response:${response.body}");
      var jsonResponse = json.decode(response.body);
      var data = jsonResponse['result'];
      print("response battingList : $data");
    }
    return SolicitedUserModel.fromJson(json.decode(response.body));
  } catch (val) {
    print(val);
  } finally {
    client.close();
  }
  return null;
}


Future<SolicitedUserModel?>solicitedUserTest(int id, String? stDate, String? edDate) async {
  print('solicited_user  Id : ${id}');
  print('solicited_user  stDate : ${stDate}');
  print('solicited_user  enDate : ${edDate}');

  var client = http.Client();
  try {
    http.Response response = await client.post(
        Uri.parse(AppConstant.solicited_use),
        body: {
          "solicitedID": id.toString(),
          "startDate": stDate,
          "endDate": edDate,
        },
        headers:{
          "Authorization": "Bearer ${PreferenceUtils.getString("accesstoken")}"
        }
    );
    if(response.statusCode == 200){
      print('solicited_user  URL : ${response.request}');
      print("solicited_user Response:${response.body}");
      var jsonResponse = json.decode(response.body);
      var data = jsonResponse['result'];
      print("response battingList : $data");
    }
    return SolicitedUserModel.fromJson(json.decode(response.body));
  } catch (val) {
    print(val);
  } finally {
    client.close();
  }
  return null;
}
