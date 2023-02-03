import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pachub/Utils/appcolors.dart';
import 'package:pachub/Utils/images.dart';
import 'package:pachub/common_widget/TextField.dart';
import 'package:pachub/common_widget/button.dart';

import '../../../Utils/appstring.dart';
import '../../../common_widget/bottom_bar.dart';
import '../../../controller/change_password_controller.dart';
import '../setting_screen.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  TextEditingController confirmPasswordController = TextEditingController();
  bool _currentPasswordVisible = true;
  bool _newPasswordVisible = true;
  bool _confirmPasswordVisible = true;
  final _formKey = GlobalKey<FormState>();
  final changepasswordViewController = Get.put(ChangePasswordController());


  @override
  void dispose() {
    changepasswordViewController.currentPasswordTextController.clear();
    changepasswordViewController.newPasswordTextController.clear();
    confirmPasswordController.clear();
    // TODO: implement dispose
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildColum(),
                const SizedBox(height: 25),
                _buildButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildColum() {
    return Column(
      children: [
        TextFieldPasswordView(
            controller: changepasswordViewController.currentPasswordTextController,
            validator: (val) {
              if (val!.isEmpty) {
                return AppString.currentPassword_validation;
              }
              return null;
            },
            textInputAction: TextInputAction.next,
            type: TextInputType.text,
            text: AppString.currentPassword,
            image: _currentPasswordVisible ? hidePassword : showPassword,
            obscureText: _currentPasswordVisible,
            Onclick: () {
              setState(() {
                _currentPasswordVisible = !_currentPasswordVisible;
              });
            }),
        const SizedBox(height: 16),
        TextFieldPasswordView(
            controller: changepasswordViewController.newPasswordTextController,
            validator: (val) {
              RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
              if (val!.isEmpty) {
                return AppString.New_Password_validation;
              } else {
                if (!regex.hasMatch(val)) {
                  return 'Password must include upper case,lower case,\nspecial character and minimum 8 character long';
                } else {
                  return null;
                }
              }
            },
            textInputAction: TextInputAction.next,
            type: TextInputType.text,
            text: AppString.newPassword,
            image: _newPasswordVisible ? hidePassword : showPassword,
            obscureText: _newPasswordVisible,
            Onclick: () {
              setState(() {
                _newPasswordVisible = !_newPasswordVisible;
              });
            }),
        const SizedBox(height: 16),
        TextFieldPasswordView(
            controller: confirmPasswordController,
            validator: (val) {
              RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
              if (val!.isEmpty) {
                return AppString.confirm_Password_validation;
              } else {
                if (!regex.hasMatch(val)) {
                  return 'Password must include upper case,lower case,\nspecial character and minimum 8 character long';
                } else {
                  return null;
                }
              }
            },
            textInputAction: TextInputAction.done,
            type: TextInputType.text,
            text: AppString.confirmPassword,
            image: _confirmPasswordVisible ? hidePassword : showPassword,
            obscureText: _confirmPasswordVisible,
            Onclick: () {
              setState(() {
                _confirmPasswordVisible = !_confirmPasswordVisible;
              });
            }),
      ],
    );
  }

  _buildButton() {
    return Button(
      color: (changepasswordViewController.currentPasswordTextController.text.isEmpty ||
          changepasswordViewController.newPasswordTextController.text.isEmpty ||
              confirmPasswordController.text.isEmpty)
          ? AppColors.ligt_grey_color
          : AppColors.blue_text_Color,
      text: AppString.save,
      textColor: (changepasswordViewController.currentPasswordTextController.text.isEmpty ||
          changepasswordViewController.newPasswordTextController.text.isEmpty ||
              confirmPasswordController.text.isEmpty)
          ? AppColors.grey_hint_color
          : AppColors.white,
      onClick: () {
        setState(() {
          if (_formKey.currentState!.validate()) {
             changepasswordViewController.changePassword(context: context, currentpassword: changepasswordViewController.currentPasswordTextController.text, newPassword: changepasswordViewController.newPasswordTextController.text);
          }
        });

      },
    );
  }
}
