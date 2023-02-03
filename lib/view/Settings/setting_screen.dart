import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pachub/Utils/appcolors.dart';
import 'package:pachub/Utils/appstring.dart';
import 'package:pachub/common_widget/appbar.dart';
import 'package:pachub/common_widget/drawer.dart';
import 'package:pachub/view/Settings/Tabs/change_password.dart';
import 'package:pachub/view/Settings/Tabs/manage_subscription.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> with SingleTickerProviderStateMixin {
  TabController? tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  List<String> settingTabName = const <String>[
    AppString.managesubscription,
    AppString.changepassword,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(
        text: AppString.settings,
        onClick: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      drawer: const Drawer(
        child: AppDrawer(),
      ),
      body: Column(
        children: [
          Container(
            color: AppColors.drawer_bottom_text_color,
            height: 45,
            width: Get.width,
            child: TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: AppColors.orange,
              indicatorWeight: 4,
              unselectedLabelColor: AppColors.grey_hint_color,
              labelColor: AppColors.white,
              isScrollable: false,
              controller: tabController,
              tabs: List.generate(settingTabName.length, (index) {
                return Tab(
                  child: Text(
                    settingTabName[index],
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: const [
                ManageSubscription(),
                ChangePassword(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
