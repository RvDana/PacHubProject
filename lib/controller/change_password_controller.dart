import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pachub/app_function/MyAppFunction.dart';
import '../Utils/constant.dart';
import '../common_widget/bottom_bar.dart';
import '../config/preference.dart';
import '../services/request.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;

import '../view/login/login_view.dart';

class ChangePasswordController extends GetxController {
  TextEditingController currentPasswordTextController = TextEditingController();
  TextEditingController newPasswordTextController = TextEditingController();
  bool isLoading = false;
  static Services? request;

  ChangePasswordController();


  @override
  void onInit() {
    currentPasswordTextController = TextEditingController();
    newPasswordTextController = TextEditingController();
    super.onInit();
  }

  Future changePassword({required BuildContext context, required String currentpassword,required String newPassword }) async {
    Services request = Services(url: AppConstant.CHANGE_PASSWORD,header:{ "Authorization":
    "Bearer ${PreferenceUtils.getString("accesstoken")}"}, body: {
      "currentPassword": currentpassword,
      "newPassword": newPassword,
    });
    request.ChangePasswordRequest().then((value) {
      print("stat =======<> ${value.statusCode}");
      print("body =====<> ${value.body}");
      if (value.statusCode == 200) {
        var res = jsonDecode(value.body);
        MyApplication.getInstance()?.showInGreenSnackBar(res["Message"], context);
        Navigator.push(context,
            MaterialPageRoute(
                builder: (_) => BottomBar(selectedIndex: 6)));
        print("body =====<> ${res["Message"]}");
        currentpassword.isEmpty;
        newPassword.isEmpty;
      } if (value.statusCode == 401) {
        return Get.offAll(Loginscreennew());
      }else if(value.statusCode == 403) {
        var res = jsonDecode(value.body);
        MyApplication.getInstance()?.showInSnackBar(res["Message"], context);
      }
      print(value.body);
    }).catchError((onError) {
      update();
    });
  }

  @override
  void onClose() {
    currentPasswordTextController.dispose();
    newPasswordTextController.dispose();
    super.onClose();
  }
}
