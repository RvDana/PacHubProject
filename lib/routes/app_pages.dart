import 'package:get/get.dart';
import 'package:pachub/view/bookmark/bookmark.dart';
import 'package:pachub/view/collegerecruiters/college_recruiters_detail_page.dart';
import 'package:pachub/view/login/login_view.dart';
import 'package:pachub/view/profile/Tabscreen/videos_screen.dart';
import 'package:pachub/view/profile/profile.dart';

import '../common_widget/bottom_bar.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.INITIAL,
      page: () => Loginscreennew(),
      //binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.Bottom,
      page: () => BottomBar(selectedIndex: 0),
    ),
    GetPage(
      name: AppRoutes.Recuriters,
      page: () => BottomBar(selectedIndex: 1),
    ),
    GetPage(
      name: AppRoutes.Advisors,
      page: () => BottomBar(selectedIndex: 2),
    ),
    GetPage(
      name: AppRoutes.Message,
      page: () => BottomBar(selectedIndex: 3),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => BottomBar(selectedIndex: 4),
    ),
    GetPage(
      name: AppRoutes.bookmarks,
      page: () => BottomBar(selectedIndex: 5),
    ),
    GetPage(
      name: AppRoutes.manageSubscription,
      page: () => BottomBar(selectedIndex: 6),
    ),
    GetPage(
      name: AppRoutes.changePassword,
      page: () => BottomBar(selectedIndex: 7),
    ),
    // GetPage(
    //   name: AppRoutes.VideoPlayScreen,
    //   page: () => VideoPlayScreen(),
    // ),
    // GetPage(
    //   name: AppRoutes.callegeRecruitersDetailPage,
    //   page: () =>  CallegeRecruitersDetailPage(),
    // ),
  ];
}
