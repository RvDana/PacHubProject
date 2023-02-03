import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dynamic_fa_icons/dynamic_fa_icons.dart';
import 'package:flutter/material.dart';
import 'package:bottom_indicator_bar_fork/bottom_indicator_bar_fork.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pachub/Utils/appstring.dart';
import 'package:pachub/common_widget/customloader.dart';
import 'package:pachub/common_widget/drawer.dart';
import 'package:pachub/common_widget/textstyle.dart';
import 'package:pachub/config/preference.dart';
import 'package:pachub/models/login_response_model_new.dart';
import 'package:pachub/view/Athletes/athletes.dart';
import 'package:pachub/view/Pending%20Payments/pending_payment_page.dart';
import 'package:pachub/view/Settings/setting_screen.dart';
import 'package:pachub/view/bookmark/bookmark.dart';
import 'package:pachub/view/collegerecruiters/college_recruiters_page.dart';
import 'package:pachub/view/profile/profile.dart';
import 'package:pachub/view/solicitor/solicitor.dart';
import '../Utils/appcolors.dart';
import '../Utils/images.dart';
import '../view/adviser/adviser.dart';
import '../view/chat/chatscreen.dart';
import '../view/dashboard/homescreen.dart';
import '../view/login/login_view.dart';
import 'nodatafound_page.dart';

class BottomBar extends StatefulWidget {
  int selectedIndex;

  BottomBar({required this.selectedIndex});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  bool _expanded = false;
  int currentPage = 0;
  bool isSelected = false;
  String _title = "Dashbaord";
  late LoginDataModel loginDataModel;
  List<Menu> items = [];
  int isSelectedIndex = 0;
  String? role;
  String? displayName;
  String? email;
  String? image;
  bool selected = false;



  void _onItemTapped(int index) {
    setState(() {
      widget.selectedIndex = index;
      currentPage = widget.selectedIndex;
      print(currentPage);
    });
  }

  @override
  void initState() {
    _onItemTapped(widget.selectedIndex);
    loginDataModel = LoginDataModel.fromJson(
        jsonDecode(PreferenceUtils.getString("loginData")));
    items.addAll(loginDataModel.menu!);
    setState(() {
      isSelectedIndex = PreferenceUtils.getBool("isLogin")==true ? PreferenceUtils.getInt("selectedIndex") : PreferenceUtils.getInt("0");
      displayName = PreferenceUtils.getString("loginDisplayName");
      email = PreferenceUtils.getString("loginEmail");
      role = PreferenceUtils.getString("role");
      image = PreferenceUtils.getString("image");
    });
    super.initState();
  }

  setIndex(index) {
    setState(() {
      isSelectedIndex = index;
      PreferenceUtils.setInt("selectedIndex", index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: widget.selectedIndex,
        children: [
          if(PreferenceUtils.getString("role") == "admin")
            for (final tabItem in TabNavigationAdminItem.items) tabItem.page,
          if(PreferenceUtils.getString("role") == "Coach / Recruiter")
            for (final tabItem in TabNavigationCoachItem.items) tabItem.page,
          if(PreferenceUtils.getString("role") == "Advisor")
            for (final tabItem in TabNavigationAdvisorItem.items) tabItem.page,
          if(PreferenceUtils.getString("role") == "Athlete")
            for (final tabItem in TabNavigationAtheleteItem.items) tabItem.page,
        ],
      ),
      drawer:   Drawer(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      drawerImage,
                      height: 40,
                    ),
                    // if(menu!.isNotEmpty)
                    _buildListView(),
                    const SizedBox(height: 35),
                    const Divider(
                      color: AppColors.ligt_grey_color,
                      thickness: 1.5,
                    ),
                    const SizedBox(height: 22),
                    role == "admin"? Container() : _buildSettingsWidget(),
                    const SizedBox(height: 90),
                  ],
                ),
              ),
            ),
            _buildBottomView(),
          ],
        ),
      ),
      bottomNavigationBar: BottomIndicatorBar(
        onTap: _onItemTapped,
        items:  List.generate(4, (index) {
          return BottomIndicatorNavigationBarItem(
              icon: Column(
                children: [
                  items[index].displayName == "Manage Profile" ?
                    SvgPicture.asset(message_icon, color: widget.selectedIndex == index ? AppColors.dark_blue_button_color : AppColors.dark_blue_button_color) :

                  items[index].icon == "home"
                      ? SvgPicture.asset(home_icon, color:  widget.selectedIndex == index ? AppColors.dark_blue_button_color : AppColors.dark_blue_button_color,)
                      : items[index].icon == "message-circle"
                      ? SvgPicture.asset(message_icon, color: widget.selectedIndex == index ? AppColors.dark_blue_button_color : AppColors.dark_blue_button_color)
                      : items[index].icon == "pie-chart" ?
                  Image.asset(piChart_icon,height: 23, color:  widget.selectedIndex == index ? AppColors.dark_blue_button_color : AppColors.dark_blue_button_color)
                      : items[index].icon == "file-text" ?
                  Image.asset(fileText_icon,height: 23, color:  widget.selectedIndex == index ? AppColors.dark_blue_button_color : AppColors.dark_blue_button_color)
                      : items[index].icon == "bar-chart-2" ?
                  SvgPicture.asset(barchartIcon, color:  widget.selectedIndex == index ? AppColors.dark_blue_button_color : AppColors.dark_blue_button_color)
                      : FaIcon(
                    DynamicFaIcons.getIconFromName(
                        "${items[index].icon}"),
                    color:  widget.selectedIndex == index ? AppColors.dark_blue_button_color : AppColors.dark_blue_button_color,
                    size: 15,
                  ),
                ],
              ),
              label: "");
        }),
        indicatorColor: AppColors.orange,
        currentIndex: currentPage,
      ),
    );
  }
  _buildListView() {
    return items.isNotEmpty
        ? ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (BuildContext context, index) {
        return Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    setIndex(index);
                    if (items[index].displayName == "Dashboard") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BottomBar(selectedIndex: 0),
                          ));
                    } else if (items[index].displayName == "Home") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BottomBar(selectedIndex: 0),
                          ));
                    } else if (items[index].displayName == "Athletes") {
                      if (role == "admin") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    BottomBar(selectedIndex: 1)));
                      }
                      else if (role == "Advisor") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    BottomBar(selectedIndex: 2)));
                      }
                      else if (role == "Coach / Recruiter") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    BottomBar(selectedIndex: 1)));
                      }
                    } else if (items[index].displayName == "Coaches / Recruiters") {
                      if(role == "Advisor" || role == "Athlete") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => BottomBar(selectedIndex: 1)));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => BottomBar(selectedIndex: 2)));
                      }
                    } else if (items[index].displayName == "Specialists") {
                      if (role == "admin") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BottomBar(selectedIndex: 3),
                            ));
                      } else if(PreferenceUtils.getString("plan") == "Free") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BottomBar(selectedIndex: 3),
                            ));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BottomBar(selectedIndex: 2),
                            ));
                      }
                    } else if (items[index].displayName == "Manage Profile") {
                      if(PreferenceUtils.getString("plan") == "Free") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BottomBar(selectedIndex: 2),
                            ));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BottomBar(selectedIndex: 3),
                            ));
                      }

                    } else if (items[index].displayName == "Bookmarks") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BottomBar(selectedIndex: 4),
                          ));
                    } else if (items[index].displayName == "Messages") {
                      // PreferenceUtils.getString("plan") == "Free"
                      //     ? "" : Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (_) => BottomBar(selectedIndex: 3),
                      //     ));
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BottomBar(selectedIndex: 5),
                          ));
                    } else if (items[index].displayName == "Pending Payments") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BottomBar(selectedIndex: 4),
                          ));
                    }
                    else if (items[index].displayName == "Reports") {
                      setState(() {
                        selected = true;
                      });
                      isSelected ? Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BottomBar(selectedIndex: 5),
                          )) : "";
                    }
                  });
                },
                child:   Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child:  items[index].displayName == "Solicitor" ? Container() : items[index].displayName == "Reports" ?
                  ExpansionPanelList(
                    elevation: 0,
                    expandedHeaderPadding: EdgeInsets.all(0),
                    children: [
                      ExpansionPanel(
                        backgroundColor: Colors.transparent,
                        headerBuilder: (context, bool isExpanded) {
                          return  Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Row(
                              children: [
                                SvgPicture.asset(barchartIcon, color: AppColors.dark_blue_button_color),
                                const SizedBox(width: 12),
                                CommonText(
                                  text: "Reports",
                                  fontSize: 16,
                                  color: AppColors.black_txcolor,
                                  fontWeight: FontWeight.w400,
                                ),
                                // SvgPicture.asset(Images.dropdownIcon),
                              ],
                            ),
                          );
                        },
                        body: Container(
                          decoration: BoxDecoration(
                            color: isSelectedIndex == index  ? AppColors.dark_blue_button_color : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 25),
                            child: Row(
                              children: [
                                Image.asset(fileText_icon,height: 23, color: isSelectedIndex == index  ? AppColors.white :  AppColors.dark_blue_button_color ),
                                const SizedBox(width: 12),
                                CommonText(
                                  text: "Solicitor",
                                  fontSize: 16,
                                  color: isSelectedIndex == index  ? AppColors.white : AppColors.black_txcolor,
                                  fontWeight: FontWeight.w400,
                                ),
                                // SvgPicture.asset(Images.dropdownIcon),
                              ],
                            ),
                          ),
                        ),
                        isExpanded: _expanded,
                        canTapOnHeader: true,
                      ),
                    ],
                    expansionCallback: (panelIndex, isExpanded) {
                      _expanded = !_expanded;
                      setState(() {
                        isSelected = true;
                      });
                    },
                  ) :
                  items[index].displayName == "Manage Profile" ?
                  Container(
                    decoration: BoxDecoration(
                      color: widget.selectedIndex == index ? AppColors.dark_blue_button_color : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 22,),
                      child: Row(
                        children: [
                          SvgPicture.asset(message_icon, color: widget.selectedIndex == index ? AppColors.white : AppColors.dark_blue_button_color),
                          SizedBox(width: 12),
                          CommonText(
                            text: "Messages",
                            fontSize: 16,
                            color: widget.selectedIndex == index ? AppColors.white : AppColors.black_txcolor,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                    ),
                  ) :
                  items[index].displayName == "Messages" ?
                  Container(
                    decoration: BoxDecoration(
                      color: widget.selectedIndex == index ? AppColors.dark_blue_button_color : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 22,),
                      child: Row(
                        children: [
                            FaIcon(
                              DynamicFaIcons.getIconFromName(
                                  "${items[3].icon}"),
                              color:  widget.selectedIndex == index ? AppColors.white : AppColors.dark_blue_button_color,
                              size: 15,
                            ),
                          SizedBox(width: 12),
                          CommonText(
                            text: "Manage Profile",
                            fontSize: 16,
                            color: widget.selectedIndex == index ? AppColors.white : AppColors.black_txcolor,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                    ),
                  ) :
                  Container(
                    decoration: BoxDecoration(
                      color: widget.selectedIndex == index ? AppColors.dark_blue_button_color : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 22,),
                      child: Row(
                        children: [
                          items[index].icon == "home"
                              ? SvgPicture.asset(home_icon, color:  widget.selectedIndex == index ? AppColors.white : AppColors.dark_blue_button_color,)
                              : items[index].icon == "message-circle"
                              ? SvgPicture.asset(message_icon, color: widget.selectedIndex == index ? AppColors.white : AppColors.dark_blue_button_color)
                              : items[index].icon == "pie-chart" ?
                          Image.asset(piChart_icon,height: 23, color:  widget.selectedIndex == index ? AppColors.white : AppColors.dark_blue_button_color)
                              : items[index].icon == "file-text" ?
                          Image.asset(fileText_icon,height: 23, color:  widget.selectedIndex == index ? AppColors.white : AppColors.dark_blue_button_color)
                              : items[index].icon == "bar-chart-2" ?
                          SvgPicture.asset(barchartIcon, color:  widget.selectedIndex == index ? AppColors.white : AppColors.dark_blue_button_color)
                              : FaIcon(
                            DynamicFaIcons.getIconFromName(
                                "${items[index].icon}"),
                            color:  widget.selectedIndex == index ? AppColors.white : AppColors.dark_blue_button_color,
                            size: 15,
                          ),
                          SizedBox(width: 12),
                          CommonText(
                            text: items[index].displayName.toString(),
                            fontSize: 16,
                            color: widget.selectedIndex == index ? AppColors.white : AppColors.black_txcolor,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ) : const Center(
      child: NoDataFound(),
    );
  }

  _buildBottomView() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 90,
        width: double.infinity,
        color: AppColors.ligt_white_color,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(1000.0),
                child: CachedNetworkImage(
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                  imageUrl: "$image",
                  placeholder: (context, url) => CustomLoader(),
                  errorWidget: (context, url, error) =>
                      Image.asset(
                        avatarImage,
                        height: 40,
                        width: 40,
                      ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CommonTextspace(
                        text: displayName.toString(),
                        fontSize: 16,
                        color: AppColors.drawer_bottom_text_color,
                        fontWeight: FontWeight.w700),
                    Text(
                        email.toString(),
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                            fontSize: 11,
                            color: AppColors.grey_hint_color,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              GestureDetector(
                onTap: _backPressed,
                // onTap: showAlert(context),
                child: SvgPicture.asset(logoutImage),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildSettingsWidget() {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(
                builder: (_) => BottomBar(selectedIndex: 6)));
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 22),
        child: Row(
          children: [
            SvgPicture.asset(
              settings_icon,
              color: AppColors.black_txcolor,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CommonText(
                text: AppString.settings,
                fontSize: 16,
                color: AppColors.black_txcolor,
                fontWeight: FontWeight.w600,
              ),
            ),
            SvgPicture.asset(
              forewordIcon,
              color: AppColors.black_txcolor,
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _backPressed() async {
    final shouldPop = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0)),
            elevation: 0.0,
            backgroundColor: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: AppColors.dark_blue_button_color,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      )),
                  child: Center(
                    child: Text("logout",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            color: AppColors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Center(
                    child: Text(
                      AppString.logouttx,
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          PreferenceUtils.setBool("isLogin", false);
                          PreferenceUtils.remove('accesstoken');
                          PreferenceUtils.remove('sport');
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => Loginscreennew()),
                                  (Route<dynamic> route) => false);
                        },
                        child: Container(
                            padding: EdgeInsets.only(left: 3, right: 3),
                            height: 25,
                            width: 45.0,
                            decoration: BoxDecoration(
                              color: AppColors.dark_blue_button_color,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                                child: Text(
                                  "Yes",
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.center,
                                ))),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context, false);
                        },
                        child: Container(
                            padding: EdgeInsets.only(left: 3, right: 3),
                            height: 25,
                            width: 45.0,
                            decoration: BoxDecoration(
                              color: AppColors.dark_blue_button_color,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                                child: Text(
                                  "No",
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.center,
                                ))),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });

    return shouldPop ?? false;
  }
}

///Todo Amin Login Drower List //////
class TabNavigationAdminItem {
  final Widget page;
  final String? role;

  TabNavigationAdminItem({required this.page, this.role});

  static List<TabNavigationAdminItem> get items => [
    TabNavigationAdminItem(page: HomeScreen()),
    TabNavigationAdminItem(page: Athletes()),
    TabNavigationAdminItem(page: Recruiters()),
    TabNavigationAdminItem(page: Advisorscreen()),
    TabNavigationAdminItem(page:  PendingPaymentPage()),
    TabNavigationAdminItem(page:  Solicitor()),
  ];
}

///Todo Advisor Login Drower List //////
class TabNavigationAdvisorItem {
  final Widget page;
  final String? role;

  TabNavigationAdvisorItem({required this.page, this.role});

  static List<TabNavigationAdvisorItem> get items => [
    TabNavigationAdvisorItem(page: HomeScreen()),
    TabNavigationAdvisorItem(page: Recruiters()),
    TabNavigationAdvisorItem(page: Athletes()),
    TabNavigationAdvisorItem(page: ChatScreen()),
    TabNavigationAdvisorItem(page: BookMarkScreen()),
    TabNavigationAdvisorItem(page:  AdvisorProfileScreen()),
    TabNavigationAdvisorItem(page:  SettingScreen()),
  ];
}

///Todo Coach Login Drower List //////
class TabNavigationCoachItem {
  final Widget page;
  final String? role;

  TabNavigationCoachItem({required this.page, this.role});

  static List<TabNavigationCoachItem> get items => [
    TabNavigationCoachItem(page: HomeScreen(),),
    TabNavigationCoachItem(page: Athletes()),
    TabNavigationCoachItem(page: Advisorscreen()),
    TabNavigationCoachItem(page:  ChatScreen()),
    TabNavigationCoachItem(page: BookMarkScreen()),
    TabNavigationCoachItem(page:  CoachProfileScreen ()),
    TabNavigationCoachItem(page:  SettingScreen(),),
  ];
}

///Todo Athelete Login Drower List //////
class TabNavigationAtheleteItem {
  final Widget page;
  final String? role;

  TabNavigationAtheleteItem({required this.page, this.role});

  static List<TabNavigationAtheleteItem> get items => [
    TabNavigationAtheleteItem(page: HomeScreen()),
    TabNavigationAtheleteItem(page: Recruiters()),
    PreferenceUtils.getString("plan") == "Free" ?  TabNavigationAtheleteItem(page: ChatScreen()) : TabNavigationAtheleteItem(page: Advisorscreen()),
    PreferenceUtils.getString("plan") == "Free" ?  TabNavigationAtheleteItem(page: Advisorscreen()) : TabNavigationAtheleteItem(page: ChatScreen()),
    TabNavigationAtheleteItem(page: BookMarkScreen()),
    TabNavigationAtheleteItem(page: AthleteProfileScreen()),
    TabNavigationAtheleteItem(page: SettingScreen()),
  ];
}



