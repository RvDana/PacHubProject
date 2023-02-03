import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Utils/appcolors.dart';
import '../Utils/appstring.dart';

class MyApplication {
  static MyApplication? _instance;

  static MyApplication? getInstance() {
    if (_instance == null) {
      _instance = MyApplication();
    }

    return _instance;
  }


  Future<bool> checkConnectivity(BuildContext context) async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      showInSnackBar(AppString.no_connection, context,);
      return false;
    }
  }

  Future<void> showInSnackBar(String value, context) async {
    Fluttertoast.showToast(
        msg: ("$value"),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppColors.dark_red,
        textColor: AppColors.white,
        fontSize: 16.0
    );
  }
  Future<void> showInGreenSnackBar(String value, context) async {
    Fluttertoast.showToast(
        msg: ("$value"),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: AppColors.white,
        fontSize: 16.0
    );
  }
}


