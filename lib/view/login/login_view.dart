import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:pachub/common_widget/loading_overlay.dart';
import 'package:pachub/view/login/forgot_password.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Utils/appcolors.dart';
import '../../Utils/appstring.dart';
import '../../Utils/constant.dart';
import '../../Utils/images.dart';
import '../../app_function/MyAppFunction.dart';
import '../../common_widget/TextField.dart';
import '../../common_widget/button.dart';
import '../../common_widget/textstyle.dart';
import '../../config/preference.dart';
import '../../models/login_response_model_new.dart';

class Loginscreennew extends StatefulWidget {
  LoginDataModel? logindata;
  List menudata = [];

  @override
  State<Loginscreennew> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreennew> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  bool _passwordVisible = true;
  List menudatadisplay = [];
  bool loding = false;

  bool _isChecked_Rememeberme =false;

  @override
  void initState() {
    _loadUserEmailPassword();
    /*emailTextController.addListener(() {
      setState(() {});
    });*/
    super.initState();
  }

  void _submit() async {
    var emails =PreferenceUtils.setString("Email",emailTextController.text.toString());
    var pas=PreferenceUtils.setString("password",passwordTextController.text.toString());
    print("this is email $emails");
    print("this is pas $pas");
    getlogin(emailTextController.text, passwordTextController.text);

    /*final overlay = LoadingOverlay.of(context);
    await overlay.during(Future.delayed(Duration(seconds: 3), () {
      setState(() {
        //Navigator.of(context).pop();
        Navigator.pop(context);
        getlogin(emailTextController.text, passwordTextController.text);
      });
      //Navigator.pop(context);
    }));*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container (
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(splashbackimage),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 260),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 38, left: 30, right: 30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildColumnView(),
                      const SizedBox(height: 25),
                      _buildButtonView(context: context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _toggle() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  _buildColumnView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CommonText(
          text: AppString.welcome,
          fontSize: 18,
          color: AppColors.orange,
          fontWeight: FontWeight.w700,
        ),
        const SizedBox(height: 10),
        const CommonText(
          text: AppString.pleaselogin,
          fontSize: 24,
          color: AppColors.black_txcolor,
          fontWeight: FontWeight.w400,
        ),
        const SizedBox(height: 5),
        Row(
          children: const [
            CommonText(
              text: AppString.pachubtx,
              fontSize: 24,
              color: AppColors.black_txcolor,
              fontWeight: FontWeight.bold,
            ),
            CommonText(
              text: AppString.id,
              fontSize: 24,
              color: AppColors.black_txcolor,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
        const SizedBox(height: 25),
        TextFieldView(
          controller: emailTextController,
          validator: (val) {
            if (val!.isEmpty) {
              return AppString.username_validation;
            } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(val)) {
              return AppString.email_validation;
            }
            return null;
          },
          textInputAction: TextInputAction.next,
          type: TextInputType.emailAddress,
          text: AppString.email_user,
        ),
        const SizedBox(height: 16),
        TextFieldPasswordView(
            controller: passwordTextController,
            validator: (val) {
              if (val!.isEmpty) {
                return AppString.password_validation;
              }
              return null;
            },
            textInputAction: TextInputAction.done,
            type: TextInputType.text,
            text: AppString.password,
            image: _passwordVisible ? hidePassword:showPassword,
            obscureText: _passwordVisible,
            Onclick: _toggle,
                /*() {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            }*/
            ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            checkbox_Rememberme(),
           /* Expanded(
              child: CheckboxListTile(
                title: CommonText(
                    text: "Remember Me",
                    fontSize: 14,
                    color:
                    AppColors.stats_title_blue,
                    fontWeight: FontWeight.w400),
                value: _isChecked_Rememeberme,
                onChanged: (newValue) {
                  setState(() {
                    _isChecked_Rememeberme = newValue!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
              ),
            ),*/
            GestureDetector(
              onTap: () {
                Get.to(ForgotPassword());
              },
              child: const CommonText(
                text: AppString.forgotpassword,
                fontSize: 14,
                color: AppColors.blue_text_Color,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget checkbox_Rememberme() {
    return Container(
      height: 15,
      child: Row(
        children: [
                 Checkbox(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4.0))),
                  onChanged: (bool? value) {
                    setState(() {
                      _isChecked_Rememeberme = value!;
                      PreferenceUtils.setBool("remember_me",_isChecked_Rememeberme);
                      print("this is checkboxvalue==>$_isChecked_Rememeberme");
                    });
                  },
                  value: _isChecked_Rememeberme,
                  activeColor: Colors.blueAccent,
                ),
          const CommonText(
              text: "Remember Me",
              fontSize: 14,
              color:
              AppColors.stats_title_blue,
              fontWeight: FontWeight.w400),

        ],

      ),
    );
  }

  //TODO THIS IS REMEMBER ME FUNCTIONALITY
  void _loadUserEmailPassword() async {
    try {
      var _remeberMe = PreferenceUtils.getBool("remember_me") ?? false;
      var _email = PreferenceUtils.getString("Email") ?? "";
      var _password = PreferenceUtils.getString("password") ?? "";
      print("this is the rememver data $_remeberMe");
      print("+++++tis is email $_email");
      print("+++++tis is Password $_password");
      if (_remeberMe) {
        setState(() {
          _isChecked_Rememeberme = true;
        });
        emailTextController.text = _email ?? "";
        passwordTextController.text = _password ?? "";
      }
    } catch (e)
    {
      print("somthing not right in this code");
    }
  }


  _buildButtonView({required BuildContext context}) {
    return Button(
      textColor: (emailTextController.text.isEmpty ||
              passwordTextController.text.isEmpty)
          ? AppColors.grey_hint_color
          : AppColors.white,
      color: (emailTextController.text.isEmpty ||
              passwordTextController.text.isEmpty)
          ? AppColors.ligt_grey_color
          : AppColors.blue_text_Color,
      text: AppString.login,
      onClick: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        if (_formKey.currentState!.validate()) {
          //loginViewController.apiLogin(context: context);
          _submit();
        }
      },
    );
  }

  getlogin(String email, String _password) async {
    log('this is call login api call', name: "login");
    print('Email =====>  $email');
    print('Email =====>  $_password');
    /*setState(() {
      loding = true;
    });*/

    MyApplication.getInstance()!
        .checkConnectivity(context)
        .then((internet) async {
      if (internet != null && internet) {
        try {
          Dio dio = Dio();
          var params = {
            "userEmail": email,
            "password": _password,
            "isMobile":true
          };
          var response = await dio.post(AppConstant.MODE_LOGIN,
              data: params,
              options: Options(
                followRedirects: false,
              ));
          print("response ====<> ${AppConstant.MODE_LOGIN}");
          if (response.statusCode == 200) {
            print("response ====<> ${response.data}");
            var token = response.data["loginUser"]["access_token"];
            print("token ===<> $token");
            final encodedPayload = token.split('.')[1];
            var payloadData =
            utf8.fuse(base64).decode(base64.normalize(encodedPayload));
            print(payloadData);
            Map<String, dynamic> usermap = jsonDecode(payloadData);
            widget.logindata = LoginDataModel.fromJson(usermap);
            print("this is user id ${widget.logindata!.roleName}");
            print("this is user  ${widget.logindata!.menu![0].displayName}");
            PreferenceUtils.setBool("isLogin", true);
            PreferenceUtils.setString("role", widget.logindata!.roleName.toString());
            PreferenceUtils.setString("plan_login", widget.logindata!.plan.toString());
            log(PreferenceUtils.getString("plan_login").toString(), name: "this is plan----");
            PreferenceUtils.setString("loginDisplayName", widget.logindata!.displayName.toString());
            PreferenceUtils.setString("image", widget.logindata!.image.toString());
            PreferenceUtils.setString("loginEmail", widget.logindata!.email.toString());
            log(PreferenceUtils.getString("loginEmail").toString(), name: "this is loginEmail");
            log(PreferenceUtils.getString("role").toString(), name: "this is storedrole");
            PreferenceUtils.setString("loginData", jsonEncode(widget.logindata));
            PreferenceUtils.setString("accesstoken", response.data["loginUser"]["access_token"]);
            log(PreferenceUtils.getString("accesstoken").toString(), name: "this is storetoken");
            PreferenceUtils.setInt("userID", widget.logindata!.userID!);
            PreferenceUtils.setString("sport", widget.logindata!.sport.toString());
            log(PreferenceUtils.getInt("userID").toString(), name: "this is userid**");
            if (mounted) {
              setState(() {
                for (int i = 0; i < widget.logindata!.menu!.length; i++) {
                  widget.menudata.add(widget.logindata!.menu![i].displayName);
                  print("====${widget.menudata.toString()}");
                }
                menudatadisplay.map((e) {}).toList();
              });
            }
            Get.toNamed('/bottomBar');
          } else  {
            loding = false;
            Get.back();
          }
        } on DioError catch (e) {
          if (e is DioError) {
            MyApplication.getInstance()?.showInSnackBar(e.response!.data["Message"], context);
          }
          Get.back();
          loding = false;
        }
      } else {
        MyApplication.getInstance()?.showInSnackBar(AppString.no_connection, context);
      }
    });
  }
}

// class DioExceptions implements Exception {
// DioExceptions.fromDioError(DioError dioError) {
// switch (dioError.type) {
// case DioErrorType.cancel:
// message = "Request to API server was cancelled";
// break;
// case DioErrorType.connectTimeout:
// message = "Connection timeout with API server";
// break;
// case DioErrorType.other:
// message = "Connection to API server failed due to internet connection";
// break;
// case DioErrorType.receiveTimeout:
// message = "Receive timeout in connection with API server";
// break;
// case DioErrorType.response:
// message =
// _handleError(dioError.response!.statusCode!, dioError.response!.data);
// break;
// case DioErrorType.sendTimeout:
// message = "Send timeout in connection with API server";
// break;
// default:
// message = "Something went wrong";
// break;
// }
// }
// String? message;
//
// String _handleError(int statusCode, dynamic error) {
// switch (statusCode) {
// case 400:
// return "User With Provided Email Does not exist!";
// case 404:
// return error["message"];
// case 500:
// return "Error occured while Processing the Request";
// default:
// return 'Oops something went wrong';
// }
// }
// @override
// String toString() => message!;
// }



