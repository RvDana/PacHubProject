import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:pachub/common_widget/bottom_bar.dart';
import 'package:pachub/routes/app_pages.dart';
import 'package:pachub/routes/app_routes.dart';
import 'package:pachub/view/login/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Utils/appstring.dart';
import 'config/preference.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  PreferenceUtils.init().then((value) {});
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    PreferenceUtils.remove("selectedIndex");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppString.app_name,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: AppRoutes.INITIAL,
      getPages: AppPages.pages,
      home: PreferenceUtils.getBool("isLogin")==true ? BottomBar(selectedIndex: 0) : Loginscreennew(),

    );
  }
}

