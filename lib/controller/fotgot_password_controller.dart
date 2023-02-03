import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:pachub/app_function/MyAppFunction.dart';
import 'package:pachub/view/login/login_view.dart';
import '../Utils/constant.dart';
import '../services/request.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;

class ForgotPasswordController extends GetxController {
  TextEditingController emailTextController = TextEditingController();
  bool isLoading = false;
  static Request? request;

  ForgotPasswordController();

  changeStatus() {
    update();
  }

  @override
  void onInit() {
    emailTextController = TextEditingController();
    super.onInit();
  }

  Future apiForgotPassword({required BuildContext context, required String email}) async {
    Services request = Services(url: AppConstant.FORGOT_PASSWORD, body: {
      "email": email,
    });
    print("eamil =-=======<> $email");
    request.ForgotPasswordRequest().then((value) {
      print("stat =======<> ${value.statusCode}");
      print("body =====<> ${value.body}");
      if (value.statusCode == 200) {

        var res = jsonDecode(value.body);
        MyApplication.getInstance()?.showInSnackBar(res["message"], context);
        Get.back();
      } if (value.statusCode == 401) {
        return Get.offAll(Loginscreennew());
      }
      else {
        var res = jsonDecode(value.body);
        MyApplication.getInstance()?.showInSnackBar(res["message"], context);
      }
      print(value.body);
    }).catchError((onError) {
      update();
    });
  }

  @override
  void onClose() {
    emailTextController.dispose();
    super.onClose();
  }
}
