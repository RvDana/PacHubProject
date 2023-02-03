import 'package:flutter/material.dart';
import 'package:pachub/Utils/appcolors.dart';
import 'package:pachub/Utils/appstring.dart';
import 'package:pachub/common_widget/appbar.dart';
import 'package:pachub/view/profile/Tabscreen/additional_details_screen.dart';
import 'package:pachub/view/profile/Tabscreen/gallery_screen.dart';
import 'package:pachub/view/profile/Tabscreen/personal_details_screen.dart';
import 'package:pachub/view/profile/Tabscreen/primary_skils_screen.dart';
import 'package:pachub/view/profile/Tabscreen/videos_screen.dart';
import 'package:get/get.dart';

import '../../config/preference.dart';

class AthleteProfileScreen extends StatefulWidget {
  const AthleteProfileScreen({Key? key}) : super(key: key);

  @override
  State<AthleteProfileScreen> createState() => _AthleteProfileScreenState();
}

class _AthleteProfileScreenState extends State<AthleteProfileScreen> with SingleTickerProviderStateMixin {
  bool selected = false;
  TabController? tabController;
  List<String> tabName = const <String>[
    AppString.personalDetails,
    AppString.primarySkills,
    AppString.additionalDetails,
    AppString.videos,
    AppString.gallery,
    AppString.milestones,
  ];

  @override
  void initState() {
    tabController = TabController(length: 6, vsync: this);
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Appbar(
          text: AppString.profile,
          onClick: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        drawer: const Drawer(),
        body:
        Column(
          children: [
            const SizedBox(height: 11),
            _buildTabBar(),
            const SizedBox(height: 5),
            const Divider(color: AppColors.grey_hint_color, thickness: 0.5),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: const [
                  AthletePersonalDetailsScreen(),
                  PrimarySkilsScreen(),
                  AthleteAdditionalDetailsScreen(),
                  VideosScreen(),
                  GalleryScreen(),
                  AdvisorAdditionalDetailsScreen(),
                ],
              ),
            ),
          ],
        )
    );
  }

  _buildTabBar() {
    return Container(
      width: Get.width,
      height: 30,
      decoration: const BoxDecoration(
        color: AppColors.white,
      ),
      child: TabBar(
        indicatorSize: TabBarIndicatorSize.label,
        unselectedLabelColor: AppColors.black_txcolor,
        labelColor: AppColors.white,
        padding: const EdgeInsets.symmetric(horizontal: 11),
        labelPadding: const EdgeInsets.symmetric(horizontal: 5),
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppColors.orange,
        ),
        splashBorderRadius: BorderRadius.circular(15),
        isScrollable: true,
        controller: tabController,
        tabs: List.generate(tabName.length, (index) {
          return Tab(
            child: Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: AppColors.orange, width: 1)),
              child: Align(
                alignment: Alignment.center,
                child: Text(tabName[index]),
              ),
            ),
          );
        }),
      ),
    );
  }

}

class FREEAthleteProfileScreen extends StatefulWidget {
  const FREEAthleteProfileScreen({Key? key}) : super(key: key);

  @override
  State<FREEAthleteProfileScreen> createState() => FREEAthleteProfileScreenstate();
}

class FREEAthleteProfileScreenstate extends State<FREEAthleteProfileScreen> with SingleTickerProviderStateMixin {
  bool selected = false;
  TabController? tabController;
  List<String> tabName = const <String>[
    AppString.personalDetails,
    AppString.primarySkills,
    AppString.additionalDetails,
  ];

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Appbar(
          text: AppString.profile,
          onClick: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        drawer: const Drawer(),
        body: Column(
          children: [
            const SizedBox(height: 11),
            _buildTabBar(),
            const SizedBox(height: 5),
            const Divider(color: AppColors.grey_hint_color, thickness: 0.5),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: const [
                  AthletePersonalDetailsScreen(),
                  PrimarySkilsScreen(),
                  FreeAthleteAdditionalDetailsScreen(),
                ],
              ),
            ),
          ],
        )
    );
  }

  _buildTabBar() {
    return Container(
      width: Get.width,
      height: 30,
      decoration: const BoxDecoration(
        color: AppColors.white,
      ),
      child: TabBar(
        indicatorSize: TabBarIndicatorSize.label,
        unselectedLabelColor: AppColors.black_txcolor,
        labelColor: AppColors.white,
        padding: const EdgeInsets.symmetric(horizontal: 11),
        labelPadding: const EdgeInsets.symmetric(horizontal: 5),
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppColors.orange,
        ),
        splashBorderRadius: BorderRadius.circular(15),
        isScrollable: true,
        controller: tabController,
        tabs: List.generate(tabName.length, (index) {
          return Tab(
            child: Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: AppColors.orange, width: 1)),
              child: Align(
                alignment: Alignment.center,
                child: Text(tabName[index]),
              ),
            ),
          );
        }),
      ),
    );
  }
}



class CoachProfileScreen extends StatefulWidget {
  const CoachProfileScreen({Key? key}) : super(key: key);

  @override
  State<CoachProfileScreen> createState() => _CoachProfileScreenState();
}

class _CoachProfileScreenState extends State<CoachProfileScreen> with SingleTickerProviderStateMixin {
  bool selected = false;
  TabController? tabController;
  List<String> tabName = const <String>[
    AppString.personalDetails,
    AppString.desiredPositions,
    AppString.videos,
  ];

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Appbar(
          text: AppString.profile,
          onClick: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        drawer: const Drawer(),
        body: Column(
          children: [
            const SizedBox(height: 11),
            _buildTabBar(),
            const SizedBox(height: 5),
            const Divider(color: AppColors.grey_hint_color, thickness: 0.5),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children:  [
                  PersonalDetailsScreen(),
                  CoachAdditionalDetailsScreen(),
                  VideosScreen(),
                ],
              ),
            ),
          ],
        ));
  }

  _buildTabBar() {
    return Container(
      width: Get.width,
      height: 30,
      decoration: const BoxDecoration(
        color: AppColors.white,
      ),
      child: TabBar(
        indicatorSize: TabBarIndicatorSize.label,
        unselectedLabelColor: AppColors.black_txcolor,
        labelColor: AppColors.white,
        padding: const EdgeInsets.symmetric(horizontal: 11),
        labelPadding: const EdgeInsets.symmetric(horizontal: 5),
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppColors.orange,
        ),
        splashBorderRadius: BorderRadius.circular(15),
        isScrollable: true,
        controller: tabController,
        tabs: List.generate(tabName.length, (index) {
          return Tab(
            child: Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: AppColors.orange, width: 1)),
              child: Align(
                alignment: Alignment.center,
                child: Text(tabName[index]),
              ),
            ),
          );
        }),
      ),
    );
  }
}



class AdvisorProfileScreen extends StatefulWidget {
  const AdvisorProfileScreen({Key? key}) : super(key: key);

  @override
  State<AdvisorProfileScreen> createState() => _AdvisorProfileScreenState();
}

class _AdvisorProfileScreenState extends State<AdvisorProfileScreen> with SingleTickerProviderStateMixin {
  bool selected = false;
  TabController? tabController;
  List<String> tabName = const <String>[
    AppString.personalDetails,
    AppString.videos,
    AppString.milestones,
  ];

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Appbar(
          text: AppString.profile,
          onClick: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        drawer: const Drawer(),
        body: Column(
          children: [
            const SizedBox(height: 11),
            _buildTabBar(),
            const SizedBox(height: 5),
            const Divider(color: AppColors.grey_hint_color, thickness: 0.5),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: const [
                  PersonalDetailsScreen(),
                  VideosScreen(),
                  AdvisorAdditionalDetailsScreen(),
                ],
              ),
            ),
          ],
        ));
  }

  _buildTabBar() {
    return Container(
      width: Get.width,
      height: 30,
      decoration: const BoxDecoration(
        color: AppColors.white,
      ),
      child: TabBar(
        indicatorSize: TabBarIndicatorSize.label,
        unselectedLabelColor: AppColors.black_txcolor,
        labelColor: AppColors.white,
        padding: const EdgeInsets.symmetric(horizontal: 11),
        labelPadding: const EdgeInsets.symmetric(horizontal: 5),
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppColors.orange,
        ),
        splashBorderRadius: BorderRadius.circular(15),
        isScrollable: true,
        controller: tabController,
        tabs: List.generate(tabName.length, (index) {
          return Tab(
            child: Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: AppColors.orange, width: 1)),
              child: Align(
                alignment: Alignment.center,
                child: Text(tabName[index]),
              ),
            ),
          );
        }),
      ),
    );
  }
}
