import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Utils/appstring.dart';
import '../Utils/constant.dart';
import '../app_function/MyAppFunction.dart';
import '../services/request.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;

class LoginController extends GetxController {

  TextEditingController? emailTextController;
  TextEditingController? passwordTextController;
   bool passwordVisible= true;
   bool isLoading = false;
 static Services? request;


  LoginController(this.passwordVisible);

  changeStatus() {
    if(passwordVisible){
      passwordVisible = false;
    }
    else {
      passwordVisible = true;
    }
    update();
  }


  @override
  void onInit() {
    emailTextController = TextEditingController();
    passwordTextController = TextEditingController();
    super.onInit();
  }

  Future <void> apiLogin({ required BuildContext context}) async {
       isLoading=true;
    Get.dialog(Center(child: CircularProgressIndicator()),
        barrierDismissible: false);
       Services request = Services(url: AppConstant.MODE_LOGIN, body: {
      'userEmail': emailTextController!.text,
      'password': passwordTextController!.text
    });
       isLoading = false;
       request.ForgotPasswordRequest().then((value) {
      Get.back();
      Get.toNamed('/bottombar');
      //Get.off(() => HomeScreen());
      print(value.body);
    }).catchError((onError) {
         isLoading = false;
         update();
         //showInSnackBar();
    });
  }



  @override
  void onClose() {
    emailTextController?.dispose();
    passwordTextController?.dispose();
    super.onClose();
  }
}