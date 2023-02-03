import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pachub/Utils/appcolors.dart';
import 'package:pachub/config/preference.dart';
import 'package:pachub/view/bookmark/Tabs/coache_tab.dart';
import 'package:pachub/view/bookmark/Tabs/athletes_tab.dart';
import 'package:pachub/view/bookmark/Tabs/advisors_tab.dart';

import '../../Utils/appstring.dart';
import '../../common_widget/appbar.dart';
import '../../common_widget/drawer.dart';

class BookMarkScreen extends StatefulWidget {
  BookMarkScreen({Key? key}) : super(key: key);

  @override
  State<BookMarkScreen> createState() => _BookMarkScreenState();
}

class _BookMarkScreenState extends State<BookMarkScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  String? roleName;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    roleName = PreferenceUtils.getString("role");
    super.initState();
  }

  List<String> coachTabName = const <String>[
    AppString.athletesName,
    AppString.speciallists,
  ];


  List<String> advisorTabName = const <String>[
    AppString.athletesName,
    AppString.choachrecuiters,
  ];

  List<String> athleteTabName = const <String>[
    AppString.choachrecuiters,
    AppString.speciallists,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(
        text: AppString.bookmarks,
        onClick: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      drawer: const Drawer(
        child: AppDrawer(),
      ),
      body: Column(
        children: [
          if (roleName == "Coach / Recruiter")
            _buildCoachTabBar(),
          if (roleName == "Advisor")
            _buildAdvisorTabBar(),
          if (roleName == "Athlete")
            _buildAthletesTabBar(),
        ],
      ),
    );
  }

  _buildCoachTabBar() {
    return Expanded(child: Column(
      children: [
        Container(
          color: AppColors.drawer_bottom_text_color,
          height: 45,
          width: Get.width,
          child: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: AppColors.orange,
            indicatorWeight: 4,
            unselectedLabelColor: AppColors.grey_text_color,
            labelColor: AppColors.white,
            isScrollable: false,
            controller: tabController,
            tabs: List.generate(coachTabName.length, (index) {
              return Tab(
                child: Text(
                  coachTabName[index],
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
            children: [
              AthletesTab(),
              AdvisorsTab(),
            ],
          ),
        ),
      ],
    ),);
  }

  _buildAdvisorTabBar() {
    return Expanded(child: Column(
      children: [
        Container(
          color: AppColors.drawer_bottom_text_color,
          height: 45,
          width: Get.width,
          child: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: AppColors.orange,
            indicatorWeight: 4,
            unselectedLabelColor: AppColors.grey_text_color,
            labelColor: AppColors.white,
            isScrollable: false,
            controller: tabController,
            tabs: List.generate(advisorTabName.length, (index) {
              return Tab(
                child: Text(
                  advisorTabName[index],
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
            children: [
              AthletesTab(),
              CoachesTab(),
            ],
          ),
        ),
      ],
    ),);
  }

  _buildAthletesTabBar() {
    return Expanded(
      child: Column(
        children: [
          Container(
            color: AppColors.drawer_bottom_text_color,
            height: 45,
            width: Get.width,
            child: TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: AppColors.orange,
              indicatorWeight: 4,
              unselectedLabelColor: AppColors.grey_text_color,
              labelColor: AppColors.white,
              isScrollable: false,
              controller: tabController,
              tabs: List.generate(athleteTabName.length, (index) {
                return Tab(
                  child: Text(
                    athleteTabName[index],
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
              children: [
                CoachesTab(),
                AdvisorsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
