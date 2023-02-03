import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pachub/Utils/appcolors.dart';
import 'package:pachub/Utils/appstring.dart';
import 'package:pachub/Utils/constant.dart';
import 'package:pachub/Utils/images.dart';
import 'package:pachub/common_widget/TextField.dart';
import 'package:pachub/common_widget/appbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:expandable/expandable.dart';
import 'package:pachub/common_widget/nodatafound_page.dart';
import 'package:pachub/common_widget/textstyle.dart';
import 'package:pachub/models/Profile_model.dart';
import 'package:pachub/models/dashboard_total_amount_model.dart';
import 'package:pachub/services/request.dart';
import 'package:pachub/view/dashboard/tab_deatil_screen.dart';
import 'package:pachub/view/dashboard/view_count_deatils.dart';
import 'package:pachub/view/login/login_view.dart';
import '../../app_function/MyAppFunction.dart';
import '../../common_widget/customloader.dart';
import '../../common_widget/loading_overlay.dart';
import '../../config/preference.dart';
import '../../models/dashbaord_recent_activities.dart';
import 'package:http/http.dart' as http;
import '../../models/dashboard_card_count_coach_athelte.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? clientTrainerID;
  String? role;
  bool isLoading = false;
  String? accessToken;
  List? trainerList;
  String? trainer;
  final _formKey = GlobalKey<FormState>();
  TextEditingController userController = TextEditingController();
  TextEditingController plyeridController = TextEditingController();
  TextEditingController approvalCommentController = TextEditingController();
  List itemList = [];
  List Dashboard_viewCard_count_List = [];
  String? id;
  bool _isFirstLoadRunning = false;
  String? startdate;
  String? expiredate;
  String? enddate;
  int? differenceInDays;


  @override
  void initState() {
    getTrainerList("1");
    get_Dashboard_Card_count_coach_athelte_dio_api();
    super.initState();
    setState(() {
      accessToken = PreferenceUtils.getString("accesstoken");
      clientTrainerID = PreferenceUtils.getString("client_trainerID");
      role = PreferenceUtils.getString("role");
    });
    if(role == "Advisor" || role == "Coach / Recruiter") {
      getMY_PLAN_AND_FEATURES();
    }
  }

  @override
  void dispose() {
    approvalCommentController.clear();
    super.dispose();
  }

  Future getTrainerList(String? clientID) async {
    await http.post(
      Uri.parse(AppConstant.TRAINER_USERS),
      body: {"clientID": clientID},
      headers: {
        "Authorization": "Bearer ${PreferenceUtils.getString("accesstoken")}"
      },
    ).then((response) {
      var data = json.decode(response.body);
      setState(() {
        trainerList = data['trainer'];
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
        edgeOffset: 20,
        onRefresh: () async {
          await Future.delayed(Duration(milliseconds: 1500));
          setState(() {
            getAdminDashboardCardCounting(accessToken);
            getRecentActivitiesApi(accessToken);
          });
        },
        child: Scaffold(
          appBar: Appbar(
            text: AppString.dashbaord,
            onClick: () {
              Scaffold.of(context).openDrawer();
            },
          ),
          drawer: const Drawer(),
          body: role == "admin"
              ? ListView(
                  children: [
                    _buildUserCards(),
                    _buildPendingList(),
                  ],
                )
              : role == "Coach / Recruiter"
                  ? ListView(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     const SizedBox(height: 17),
                      check_plan_expire_onsevendays(),
                      _build_Cards_coach(),
                      SizedBox(height: 30),
                      const Center(child: Text("No Recent Activities")),
                    ],
                  )
                  : role == "Advisor"
                      ? ListView(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 17),
                          check_plan_expire_onsevendays(),
                          _build_Cards_advisor(),
                          SizedBox(height: 30),
                          const Center(
                              child: Text("No Recent Activities")),
                        ],
                      )
                      : role == "Athlete" && PreferenceUtils.getString("plan_login") == "Free"
                          ? ListView(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 17),
                              _build_Cards_Athelete_free(),
                              SizedBox(height: 15),
                              const Center(
                                  child: Text("No Recent Activities")),
                            ],
                          )
                          : role == "Athlete" && PreferenceUtils.getString("plan_login") == "Gold"
                              ? ListView(
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 17),
                                  _build_Cards_Athelete(),
                                  SizedBox(height: 15),
                                  const Center(
                                      child:
                                          Text("No Recent Activities")),
                                ],
                              )
                              : role == "Athlete" && PreferenceUtils.getString("plan_login") == "Platinum"
                                  ? ListView(
                                    // crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 17),
                                      _build_Cards_Athelete(),
                                      SizedBox(height: 15),
                                      const Center(
                                          child: Text(
                                              "No Recent Activities")),
                                    ],
                                  )
                                  : Center(
                                      child: Container(
                                          child: Text("No Recent Activities")),
                                    ),
        ),
      ),
    );
  }

  _buildPendingList() {
    return FutureBuilder<DashboardRecentActivities?>(
        future: getRecentActivitiesApi(accessToken),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            const Center(
              child: Text("No Data Found"),
            );
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Container();
            case ConnectionState.done:
              if (snapshot.hasData) {
                List<RecentUsers>? recentUsers = snapshot.data?.recentUsers;
                if (recentUsers != null) {
                  return snapshot.data?.count != 0
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTextView(),
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: recentUsers.length,
                              itemBuilder: (context, index) {
                                final item = recentUsers[index];
                                DateTime complainDate =
                                    DateTime.parse(item.joiningDate.toString());
                                String displayname =
                                    "${item.displayName.toString()}";

                                return Container(
                                  margin: const EdgeInsets.only(
                                      bottom: 10, left: 5, right: 5),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        side: const BorderSide(width: 0.1),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      CommonText(
                                                          text: displayname
                                                                  .toTitleCase() ??
                                                              "",
                                                          fontSize: 15,
                                                          color: AppColors
                                                              .black_txcolor,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 8),
                                                  _CommonRow(
                                                      "REQUEST DATE : ",
                                                      DateFormat('yMMMd').format(
                                                              complainDate) ??
                                                          ""),
                                                  const SizedBox(height: 8),
                                                  _CommonRow("SUBSCRIPTION : ",
                                                      item.subscription ?? ""),
                                                  const SizedBox(height: 8),
                                                  item.price != null
                                                      ? _CommonRow(
                                                          "PRICE : ",
                                                          item.price
                                                                  .toString() ??
                                                              "")
                                                      : _CommonRow(
                                                          "PRICE : ", ""),
                                                  const SizedBox(height: 8),
                                                  item.solicitedName != null
                                                      ? _CommonRow(
                                                          "SOLICITED NAME : ",
                                                          item.solicitedName
                                                                  .toString() ??
                                                              "")
                                                      : _CommonRow(
                                                          "SOLICITED NAME : ",
                                                          ""),
                                                  const SizedBox(height: 8),
                                                  _CommonRow(
                                                      "SPORT : ",
                                                      item.sport.toString() ??
                                                          ""),
                                                  const SizedBox(height: 8),
                                                  item.age != null
                                                      ? _CommonRow(
                                                          "AGE : ",
                                                          item.age.toString() ??
                                                              "")
                                                      : _CommonRow(
                                                          "AGE : ", ""),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                          height: 20,
                                                          width: 64.52,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: AppColors
                                                                .onHold,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16),
                                                          ),
                                                          child: Center(
                                                            child: CommonText(
                                                              text: item.status
                                                                  .toString(),
                                                              fontSize: 10,
                                                              color: AppColors
                                                                  .onHoldTextColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          )),
                                                      item.subscription ==
                                                                  "Gold" ||
                                                              item.subscription ==
                                                                  "Platinum"
                                                          ? StatefulBuilder(
                                                              builder: (context,
                                                                  setState) {
                                                              return SizedBox(
                                                                width: 20,
                                                                child:
                                                                    PopupMenuButton(
                                                                  iconSize: 18,
                                                                  itemBuilder:
                                                                      (context) {
                                                                    return [
                                                                      PopupMenuItem<
                                                                          int>(
                                                                        value:
                                                                            0,
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            SvgPicture.asset(profile_icon,
                                                                                color: AppColors.black_txcolor),
                                                                            const SizedBox(width: 10),
                                                                            CommonText(
                                                                                text: AppString.userDetail,
                                                                                fontSize: 15,
                                                                                color: AppColors.black_txcolor,
                                                                                fontWeight: FontWeight.w400),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      PopupMenuItem<
                                                                          int>(
                                                                        value:
                                                                            1,
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            SvgPicture.asset(approveIcon,
                                                                                color: AppColors.black_txcolor),
                                                                            const SizedBox(width: 10),
                                                                            CommonText(
                                                                                text: AppString.approveRequest,
                                                                                fontSize: 15,
                                                                                color: AppColors.black_txcolor,
                                                                                fontWeight: FontWeight.w400),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      PopupMenuItem<
                                                                          int>(
                                                                        value:
                                                                            2,
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              double.infinity,
                                                                          height:
                                                                              30,
                                                                          color:
                                                                              AppColors.dark_red,
                                                                          child:
                                                                              Center(
                                                                            child: CommonText(
                                                                                text: AppString.cancelSubscription,
                                                                                fontSize: 15,
                                                                                color: AppColors.white,
                                                                                fontWeight: FontWeight.w500),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ];
                                                                  },
                                                                  onSelected:
                                                                      (value) async {
                                                                    if (value ==
                                                                        0) {
                                                                      if (kDebugMode) {
                                                                        print(
                                                                            "My account menu is selected.");
                                                                      }
                                                                      await manageAditionalInformationList("${item.userID}");
                                                                      _admin_UserDetail("${item.userID}");
                                                                    }
                                                                    // if (value == 1) {
                                                                    //   if (kDebugMode) {
                                                                    //     print("My account menu is selected.");
                                                                    //   }
                                                                    //   _assignTrainer("${item.displayName}", item.userID,);
                                                                    // }
                                                                    if (value ==
                                                                        1) {
                                                                      if (kDebugMode) {
                                                                        print(
                                                                            "My account menu is selected.");
                                                                      }
                                                                      _approveRequest(
                                                                          item.displayName
                                                                              .toString(),
                                                                          item
                                                                              .userID,
                                                                          item.subscription
                                                                              .toString(),
                                                                          item.status
                                                                              .toString(),
                                                                          item.role
                                                                              .toString());
                                                                      approvalCommentController
                                                                          .clear();
                                                                    }
                                                                    if (value ==
                                                                        2) {
                                                                      if (kDebugMode) {
                                                                        print(
                                                                            "My account menu is selected.");
                                                                      }
                                                                      _cancelSubscriptionRequest(
                                                                          item.displayName
                                                                              .toString(),
                                                                          item.userID
                                                                              .toString());
                                                                      approvalCommentController
                                                                          .clear();
                                                                    }
                                                                  },
                                                                ),
                                                              );
                                                            })
                                                          : StatefulBuilder(
                                                              builder: (context,
                                                                  setState) {
                                                              return SizedBox(
                                                                width: 20,
                                                                child:
                                                                    PopupMenuButton(
                                                                        iconSize:
                                                                            18,
                                                                        itemBuilder:
                                                                            (context) {
                                                                          return [
                                                                            PopupMenuItem<int>(
                                                                              value: 0,
                                                                              child: Row(
                                                                                children: [
                                                                                  SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                                  const SizedBox(width: 10),
                                                                                  CommonText(text: AppString.userDetail, fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            PopupMenuItem<int>(
                                                                              value: 1,
                                                                              child: Row(
                                                                                children: [
                                                                                  SvgPicture.asset(approveIcon, color: AppColors.black_txcolor),
                                                                                  const SizedBox(width: 10),
                                                                                  Center(
                                                                                    child: CommonText(text: AppString.approveRequest, fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w500),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            PopupMenuItem<int>(
                                                                              value: 2,
                                                                              child: Container(
                                                                                width: double.infinity,
                                                                                height: 30,
                                                                                color: AppColors.dark_red,
                                                                                child: Center(
                                                                                  child: CommonText(text: AppString.cancelSubscription, fontSize: 15, color: AppColors.white, fontWeight: FontWeight.w400),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ];
                                                                        },
                                                                        onSelected:
                                                                            (value) async {
                                                                          if (value ==
                                                                              0) {
                                                                            if (kDebugMode) {
                                                                              print("My account menu is selected.");
                                                                            }
                                                                            await manageAditionalInformationList("${item.userID}");
                                                                            _admin_UserDetail("${item.userID}");
                                                                          }
                                                                          if (value ==
                                                                              1) {
                                                                            if (kDebugMode) {
                                                                              print("My account menu is selected.");
                                                                            }
                                                                            _approveRequest(
                                                                                item.displayName.toString(),
                                                                                item.userID,
                                                                                item.subscription.toString(),
                                                                                item.status.toString(),
                                                                                item.role.toString());
                                                                            approvalCommentController.clear();
                                                                          }
                                                                          if (value ==
                                                                              2) {
                                                                            if (kDebugMode) {
                                                                              print("My account menu is selected.");
                                                                            }
                                                                            _cancelSubscriptionRequest(item.displayName.toString(),
                                                                                item.userID.toString());
                                                                            approvalCommentController.clear();
                                                                          }
                                                                        }),
                                                              );
                                                            }),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        )
                      : const Padding(
                          padding: EdgeInsets.only(top: 15),
                          child: Center(
                            child: Text("No Data Found"),
                          ),
                        );
                }
              } else {
                return const Center(
                  child: Text("No Data Found"),
                );
              }
          }
          return const Center(
            child: Text("No Data Found"),
          );
        });
  }

  _buildUserCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FutureBuilder<TotalAmountModel?>(
            future: getAdminDashboardCardCounting(accessToken),
            builder: (context, snapshot) {
              final overlay = LoadingOverlay.of(context);
              if (snapshot.hasError)
                const Center(
                  child: NoDataFound(),
                );
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: CustomLoader());
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    List<TotalUserAmount>? totalUserAmount =
                        snapshot.data?.userDetails?.totalUserAmount;
                    List<TotalActiveUser>? totalActiveUser =
                        snapshot.data?.userDetails?.totalActiveUser;
                    List<TotalPending>? totalPending =
                        snapshot.data?.userDetails?.totalPending;
                    return Column(
                      children: [
                        if (totalActiveUser!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 25),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: totalActiveUser.length.compareTo(0),
                              itemBuilder: (context, index) {
                                var totalActiveItem = totalActiveUser[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: _buildTotalCard(
                                      "Active Users",
                                      totalActiveItem.total.toString(),
                                      contactIcon,
                                      AppColors.contacts_card_color,
                                      _detailTotalActive,
                                      AppColors.white),
                                );
                              },
                            ),
                          ),
                        if (totalActiveUser.isEmpty)
                          Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _buildTotalBlankCard(
                                  "Active Users",
                                  "",
                                  contactIcon,
                                  AppColors.contacts_card_color,
                                  AppColors.white)),
                        if (totalUserAmount!.isNotEmpty)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: totalUserAmount.length.compareTo(0),
                            itemBuilder: (context, index) {
                              var totalAmountItem = totalUserAmount[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: _buildTotalCard(
                                    "Subscription Revenue",
                                    "\$ ${totalAmountItem.amount}",
                                    revenueIcon,
                                    AppColors.matches_card_color,
                                    _detailTotalAmount,
                                    AppColors.white),
                              );
                            },
                          ),
                        if (totalUserAmount.isEmpty)
                          Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _buildTotalBlankCard(
                                  "Subscription Revenue",
                                  "",
                                  contactIcon,
                                  AppColors.contacts_card_color,
                                  AppColors.white)),
                        if (totalPending!.isNotEmpty)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: totalPending.length.compareTo(0),
                            itemBuilder: (context, index) {
                              var totalPendingItem = totalPending[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: _buildTotalCard(
                                    "New Requests",
                                    "${totalPendingItem.total}",
                                    contactIcon,
                                    AppColors.black,
                                    _detailTotalPending,
                                    AppColors.white),
                              );
                            },
                          ),
                        if (totalPending.isEmpty)
                          Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _buildTotalBlankCard(
                                  "New Requests",
                                  "",
                                  contactIcon,
                                  AppColors.black,
                                  AppColors.white)),
                      ],
                    );
                  } else {
                    return const Center(
                      child: NoDataFound(),
                    );
                  }
              }
              return const Center(
                child: NoDataFound(),
              );
            }),
      ],
    );
  }

  _build_Cards_coach() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FutureBuilder<DashboardAthleteCouchCount?>(
            future: get_Dashboard_Card_count_coach_athelte(accessToken),
            builder: (context, snapshot) {
              if (snapshot.hasError)
                const Center(
                  child: NoDataFound(),
                );
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: CustomLoader());
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    List<ViewCount>? totalviewcount = snapshot.data?.viewCount;
                    List<BookMarkCount>? totalbookmarkcount =
                        snapshot.data?.bookMarkCount;
                    if (snapshot.data != null) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: totalviewcount!.isEmpty
                                ? _build_Card_Coach_athelete_free_common(
                                    "Profile Viewed By Athlete",
                                    "0",
                                    contact_icon,
                                    AppColors.contacts_card_color,
                                    AppColors.white,
                                  )
                                : totalviewcount.length == 1
                                ? _build_Card_Coach_athelete_common(
                              "Profile Viewed By Athlete",
                              totalviewcount.first.roleName == "Athlete" ? "${totalviewcount.first.roleWiseViewTotal}" : "0",
                              contact_icon,
                              AppColors.contacts_card_color,
                              AppColors.white,
                                  () {
                                _dashboard_Athelete_userDetail();
                              },
                            )
                                : Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Column(
                                  children: [
                                    _build_Card_Coach_athelete_common(
                                      "Profile Viewed By Athlete",
                                      "${totalviewcount[0].roleName != "Athlete" || totalviewcount[0].roleWiseViewTotal == null ? "0" : totalviewcount[0].roleWiseViewTotal}",
                                      contact_icon,
                                      AppColors.contacts_card_color,
                                      AppColors.white,
                                          () {
                                        _dashboard_Athelete_userDetail();
                                      },
                                    ),
                                  ],
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: totalviewcount.isEmpty
                                ? _build_Card_Coach_athelete_free_common(
                                    "Profile Viewed By Specialist",
                                    "0",
                                    baseball_icon,
                                    AppColors.matches_card_color,
                                    AppColors.white,
                                  )
                                : totalviewcount.length == 1
                                ? _build_Card_Coach_athelete_common(
                              "Profile Viewed By Specialist",
                              totalviewcount.first.roleName == "Advisor" ? "${totalviewcount.first.roleWiseViewTotal}"  : "0",
                              baseball_icon,
                              AppColors.matches_card_color,
                              AppColors.white,
                                  () {
                                _dashboard_Specialist_userDetail();
                              },
                            )
                                : Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Column(
                                  children: [
                                    _build_Card_Coach_athelete_common(
                                      "Profile Viewed By Specialist",
                                      "${totalviewcount[1].roleName != "Advisor" || totalviewcount[1].roleWiseViewTotal == null ? "0" : totalviewcount[1].roleWiseViewTotal}",
                                      baseball_icon,
                                      AppColors.matches_card_color,
                                      AppColors.white,
                                          () {
                                        _dashboard_Specialist_userDetail();
                                      },
                                    ),
                                  ],
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10, top: 0),
                            child: totalbookmarkcount!.isEmpty
                                ? _build_Card_athelete_profilebookmark_nodata(
                              "Profile Bookmarked By",
                              "Athelete: ",
                              "0",
                              "Specialist: ",
                              "0",
                              contactIcon,
                              AppColors.black,
                              AppColors.white,
                            )
                                : totalbookmarkcount.length == 1
                                ? _build_Card_Coach_athelete_profilebookmark(
                              "Profile Bookmarked By",
                              "Athelete: ",
                              totalbookmarkcount.first.roleName == "Athlete" && totalbookmarkcount.first.roleTotal != null ? totalbookmarkcount.first.roleTotal.toString() : "0",
                              "Specialist: ",
                              totalbookmarkcount.first.roleName == "Advisor" && totalbookmarkcount.first.roleTotal != null ? totalbookmarkcount.first.roleTotal.toString() : "0",
                              contactIcon,
                              AppColors.black,
                              AppColors.white,
                                  () {
                                _dashboard_Bookmarked_userDetail();
                              },
                            )
                                : Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10),
                              child: Container(
                                height: 130,
                                width: Get.width,
                                decoration: BoxDecoration(
                                  color: AppColors.black,
                                  borderRadius:
                                  BorderRadius.circular(12),
                                  image: const DecorationImage(
                                    image: AssetImage(dashboardVector),
                                    alignment: Alignment.topRight,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 14),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                            contactIcon,
                                            color: AppColors.white,
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Expanded(
                                            child: CommonText(
                                                text:
                                                "Profile Bookmarked By",
                                                fontSize: 18,
                                                color: AppColors
                                                    .contacts_text_color,
                                                fontWeight:
                                                FontWeight.w600),
                                          ),
                                          PreferenceUtils.getString(
                                              "plan_login") ==
                                              "Free"
                                              ? Container()
                                              : InkWell(
                                            onTap: () {
                                              _dashboard_Bookmarked_userDetail();
                                            },
                                            child: Container(
                                              height: 15,
                                              width: 15,
                                              child: SvgPicture
                                                  .asset(
                                                dotIcon,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 15),
                                      ListView.builder(
                                          shrinkWrap: true,
                                          itemCount:
                                          totalbookmarkcount.length,
                                          itemBuilder:
                                              (context, index) {
                                            var totalbookmark =
                                            totalbookmarkcount[
                                            index];
                                            return Column(
                                              children: [
                                                if (totalbookmark.roleName == "Athlete")
                                                  Row(
                                                    children: [
                                                      CommonText(
                                                          text:
                                                          "Athelete: ",
                                                          fontSize: 16,
                                                          color:
                                                          AppColors
                                                              .white,
                                                          fontWeight:
                                                          FontWeight
                                                              .w700),
                                                      CommonText(
                                                          text: totalbookmark
                                                              .roleTotal
                                                              .toString(),
                                                          fontSize: 16,
                                                          color:
                                                          AppColors
                                                              .white,
                                                          fontWeight:
                                                          FontWeight
                                                              .w700),
                                                    ],
                                                  ),
                                                if (totalbookmark.roleName == "Advisor")
                                                  Row(
                                                    children: [
                                                      CommonText(
                                                          text:
                                                          "Specialist: ",
                                                          fontSize: 16,
                                                          color:
                                                          AppColors
                                                              .white,
                                                          fontWeight:
                                                          FontWeight
                                                              .w700),
                                                      CommonText(
                                                          text: totalbookmark
                                                              .roleTotal
                                                              .toString(),
                                                          fontSize: 16,
                                                          color:
                                                          AppColors
                                                              .white,
                                                          fontWeight:
                                                          FontWeight
                                                              .w700),
                                                    ],
                                                  ),
                                              ],
                                            );
                                          }),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                        ],
                      );
                    }
                  } else {
                    return const Center(
                      child: NoDataFound(),
                    );
                  }
              }
              return const Center(
                child: NoDataFound(),
              );
            }),
      ],
    );
  }

  _build_Cards_advisor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FutureBuilder<DashboardAthleteCouchCount?>(
            future: get_Dashboard_Card_count_coach_athelte(accessToken),
            builder: (context, snapshot) {
              if (snapshot.hasError)
                const Center(
                  child: NoDataFound(),
                );
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: CustomLoader());
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    List<ViewCount>? totalviewcount = snapshot.data?.viewCount;
                    List<BookMarkCount>? totalbookmarkcount =
                        snapshot.data?.bookMarkCount;
                    if (snapshot.data != null) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: totalviewcount!.isEmpty
                                ? _build_Card_Coach_athelete_free_common(
                              "Profile Viewed By Athlete",
                              "0",
                              contact_icon,
                              AppColors.contacts_card_color,
                              AppColors.white,
                            )
                                : totalviewcount.length == 1
                                ? _build_Card_Coach_athelete_common(
                              "Profile Viewed By Athlete",
                              totalviewcount.first.roleName == "Athlete" ? "${totalviewcount.first.roleWiseViewTotal}" : "0",
                              contact_icon,
                              AppColors.contacts_card_color,
                              AppColors.white,
                                  () {
                                _dashboard_Athelete_userDetail();
                              },
                            )
                                : Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Column(
                                  children: [
                                    _build_Card_Coach_athelete_common(
                                      "Profile Viewed By Athlete",
                                      "${totalviewcount[0].roleName != "Athlete" || totalviewcount[0].roleWiseViewTotal == null ? "0" : totalviewcount[0].roleWiseViewTotal}",
                                      contact_icon,
                                      AppColors.contacts_card_color,
                                      AppColors.white,
                                          () {
                                        _dashboard_Athelete_userDetail();
                                      },
                                    ),
                                  ],
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: totalviewcount.isEmpty
                                ? _build_Card_Coach_athelete_free_common(
                              "Profile Viewed By Coach/Recruiter",
                              "0",
                              baseball_icon,
                              AppColors.matches_card_color,
                              AppColors.white,
                            )
                                : totalviewcount.length == 1
                                ? _build_Card_Coach_athelete_common(
                              "Profile Viewed By Coach/Recruiter",
                              totalviewcount.first.roleName == "Coach / Recruiter" ? "${totalviewcount.first.roleWiseViewTotal}" : "0",
                              baseball_icon,
                              AppColors.matches_card_color,
                              AppColors.white,
                                  () {
                                    _dashboard_CoachRecruiter_userDetail();
                              },
                            )
                                : Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Column(
                                  children: [
                                    _build_Card_Coach_athelete_common(
                                      "Profile Viewed By Coach/Recruiter",
                                      "${totalviewcount[1].roleName != "Coach / Recruiter" || totalviewcount[1].roleWiseViewTotal == null ? "0" : totalviewcount[1].roleWiseViewTotal}",
                                      baseball_icon,
                                      AppColors.matches_card_color,
                                      AppColors.white,
                                          () {
                                            _dashboard_CoachRecruiter_userDetail();
                                      },
                                    ),
                                  ],
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10, top: 0),
                            child: totalbookmarkcount!.isEmpty
                                ? _build_Card_athelete_profilebookmark_nodata(
                                    "Profile Bookmarked By",
                                    "Athelete: ",
                                    "0",
                                    "Coach / Recruiter: ",
                                    "0",
                                    contactIcon,
                                    AppColors.black,
                                    AppColors.white,
                                  )
                                : totalbookmarkcount.isEmpty ||
                                        totalbookmarkcount.length == 1
                                    ? _build_Card_Coach_athelete_profilebookmark(
                                        "Profile Bookmarked By",
                                        "Athlete : ",
                                        totalbookmarkcount.first.roleName ==
                                                    "Athlete" &&
                                                totalbookmarkcount
                                                        .first.roleTotal !=
                                                    null
                                            ? totalbookmarkcount.first.roleTotal
                                                .toString()
                                            : "0",
                                        "Coach / Recruiter: ",
                                        totalbookmarkcount.first.roleName ==
                                                    "Coach / Recruiter" &&
                                                totalbookmarkcount
                                                        .first.roleTotal !=
                                                    null
                                            ? totalbookmarkcount.first.roleTotal
                                                .toString()
                                            : "0",
                                        contactIcon,
                                        AppColors.black,
                                        AppColors.white,
                                        () {
                                          _dashboard_Bookmarked_userDetail();
                                        },
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Container(
                                          height: 130,
                                          width: Get.width,
                                          decoration: BoxDecoration(
                                            color: AppColors.black,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            image: const DecorationImage(
                                              image:
                                                  AssetImage(dashboardVector),
                                              alignment: Alignment.topRight,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 24, vertical: 14),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      contactIcon,
                                                      color: AppColors.white,
                                                    ),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    Expanded(
                                                      child: CommonText(
                                                          text:
                                                              "Profile Bookmarked By",
                                                          fontSize: 18,
                                                          color: AppColors
                                                              .contacts_text_color,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    PreferenceUtils.getString(
                                                                "plan_login") ==
                                                            "Free"
                                                        ? Container()
                                                        : InkWell(
                                                            onTap: () {
                                                              _dashboard_Bookmarked_userDetail();
                                                            },
                                                            child: Container(
                                                              height: 15,
                                                              width: 15,
                                                              child: SvgPicture
                                                                  .asset(
                                                                dotIcon,
                                                              ),
                                                            ),
                                                          ),
                                                  ],
                                                ),
                                                SizedBox(height: 15),
                                                ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        totalbookmarkcount
                                                            .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      var totalbookmark =
                                                          totalbookmarkcount[
                                                              index];
                                                      return Column(
                                                        children: [
                                                          if (totalbookmark
                                                                  .roleName ==
                                                              "Athlete")
                                                            Row(
                                                              children: [
                                                                CommonText(
                                                                    text:
                                                                        "Athlete: ",
                                                                    fontSize:
                                                                        16,
                                                                    color: AppColors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                                CommonText(
                                                                    text: totalbookmark
                                                                        .roleTotal
                                                                        .toString(),
                                                                    fontSize:
                                                                        16,
                                                                    color: AppColors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                              ],
                                                            ),
                                                          if (totalbookmark
                                                                  .roleName ==
                                                              "Coach / Recruiter")
                                                            Row(
                                                              children: [
                                                                CommonText(
                                                                    text:
                                                                        "Coach / Recruiter: ",
                                                                    fontSize:
                                                                        16,
                                                                    color: AppColors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                                CommonText(
                                                                    text: totalbookmark
                                                                        .roleTotal
                                                                        .toString(),
                                                                    fontSize:
                                                                        16,
                                                                    color: AppColors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                              ],
                                                            ),
                                                        ],
                                                      );
                                                    }),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                          ),
                        ],
                      );
                    }
                  } else {
                    return const Center(
                      child: NoDataFound(),
                    );
                  }
              }
              return const Center(
                child: NoDataFound(),
              );
            }),
      ],
    );
  }

  _build_Cards_Athelete() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FutureBuilder<DashboardAthleteCouchCount?>(
            future: get_Dashboard_Card_count_coach_athelte(accessToken),
            builder: (context, snapshot) {
              final overlay = LoadingOverlay.of(context);
              if (snapshot.hasError)
                const Center(
                  child: NoDataFound(),
                );
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: CustomLoader());
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    List<ViewCount>? totalviewcount = snapshot.data?.viewCount;
                    List<BookMarkCount>? totalbookmarkcount = snapshot.data?.bookMarkCount;
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: totalviewcount!.isEmpty
                              ? _build_Card_Coach_athelete_free_common(
                                  "Profile Viewed By Coach/Recruiter",
                                  "0",
                                  contact_icon,
                                  AppColors.contacts_card_color,
                                  AppColors.white,
                                )
                              : totalviewcount.length == 1
                              ? _build_Card_Coach_athelete_common(
                            "Profile Viewed By Coach/Recruiter",
                            totalviewcount.first.roleName == "Coach / Recruiter"? "${totalviewcount.first.roleWiseViewTotal}" : "0",
                            contact_icon,
                            AppColors.contacts_card_color,
                            AppColors.white,
                                () {
                              _dashboard_CoachRecruiter_userDetail();
                            },
                          )
                              : Padding(
                              padding:
                              const EdgeInsets.only(bottom: 10),
                              child: Column(
                                children: [
                                  _build_Card_Coach_athelete_common(
                                    "Profile Viewed By Coach/Recruiter",
                                    "${totalviewcount[0].roleName != "Coach / Recruiter" || totalviewcount[0].roleWiseViewTotal == null ? "0" : totalviewcount[0].roleWiseViewTotal}",
                                    contact_icon,
                                    AppColors.contacts_card_color,
                                    AppColors.white,
                                        () {
                                      _dashboard_CoachRecruiter_userDetail();
                                    },
                                  ),
                                ],
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: totalviewcount.isEmpty
                              ? _build_Card_Coach_athelete_free_common(
                                  "Profile Viewed By Specialist",
                                  "0",
                                  baseball_icon,
                                  AppColors.matches_card_color,
                                  AppColors.white,
                                )
                              : totalviewcount.length == 1
                              ? _build_Card_Coach_athelete_common(
                            "Profile Viewed By Specialist",
                            totalviewcount.first.roleName == "Advisor"? "${totalviewcount.first.roleWiseViewTotal}" : "0",
                            contact_icon,
                            AppColors.contacts_card_color,
                            AppColors.white,
                                () {
                                  _dashboard_Specialist_userDetail();
                            },
                          )
                              : Padding(
                            padding:
                            const EdgeInsets.only(bottom: 10),
                            child: _build_Card_Coach_athelete_common(
                              "Profile Viewed By Specialist",
                              "${totalviewcount[1].roleName != "Advisor" || totalviewcount[1].roleWiseViewTotal == null ? "0" : totalviewcount[1].roleWiseViewTotal}",
                              baseball_icon,
                              AppColors.matches_card_color,
                              AppColors.white,
                                  () {
                                _dashboard_Specialist_userDetail();
                              },
                            ),
                          ),
                         /* ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: totalviewcount.length.compareTo(0),
                                  itemBuilder: (context, index) {
                                    var totalViewcount = totalviewcount[index];
                                    print(
                                        "Length ========>>>>>> ${totalViewcount.roleWiseViewTotal}");
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: _build_Card_Coach_athelete_common(
                                        "Profile Viewed By Specialist",
                                        "${totalViewcount.roleName != "Advisor" || totalViewcount.roleWiseViewTotal == null ? "0" : totalViewcount.roleWiseViewTotal}",
                                        baseball_icon,
                                        AppColors.matches_card_color,
                                        AppColors.white,
                                        () {
                                          _dashboard_Specialist_userDetail();
                                        },
                                      ),
                                    );
                                  },
                                ),*/
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10, top: 0),
                          child: totalbookmarkcount!.isEmpty
                              ? _build_Card_athelete_profilebookmark_nodata(
                                  "Profile Bookmarked By",
                                  "Coach/Recruiter: ",
                                  "0",
                                  "Specialist: ",
                                  "0",
                                  contactIcon,
                                  AppColors.black,
                                  AppColors.white,
                                )
                              : totalbookmarkcount.length == 1
                                  ? _build_Card_Coach_athelete_profilebookmark(
                                      "Profile Bookmarked By",
                                      "Specialist: ",
                                      totalbookmarkcount.first.roleName == "Advisor" && totalbookmarkcount.first.roleTotal != null ? totalbookmarkcount.first.roleTotal.toString() : "0",
                                      "Coach / Recruiter: ",
                                      totalbookmarkcount.first.roleName == "Coach / Recruiter" && totalbookmarkcount.first.roleTotal != null ? totalbookmarkcount.first.roleTotal.toString() : "0",
                                      contactIcon,
                                      AppColors.black,
                                      AppColors.white,
                                      () {
                                        _dashboard_Bookmarked_userDetail();
                                      },
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: Container(
                                        height: 130,
                                        width: Get.width,
                                        decoration: BoxDecoration(
                                          color: AppColors.black,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          image: const DecorationImage(
                                            image: AssetImage(dashboardVector),
                                            alignment: Alignment.topRight,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    contactIcon,
                                                    color: AppColors.white,
                                                  ),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Expanded(
                                                    child: CommonText(
                                                        text:
                                                            "Profile Bookmarked By",
                                                        fontSize: 18,
                                                        color: AppColors
                                                            .contacts_text_color,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  PreferenceUtils.getString("plan_login") == "Free"
                                                      ? Container()
                                                      : InkWell(
                                                          onTap: () {
                                                            _dashboard_Bookmarked_userDetail();
                                                          },
                                                          child: Container(
                                                            height: 15,
                                                            width: 15,
                                                            child: SvgPicture
                                                                .asset(
                                                              dotIcon,
                                                            ),
                                                          ),
                                                        ),
                                                ],
                                              ),
                                              SizedBox(height: 15),
                                              ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      totalbookmarkcount.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    var totalbookmark =
                                                        totalbookmarkcount[
                                                            index];
                                                    return Column(
                                                      children: [
                                                        if (totalbookmark.roleName == "Coach / Recruiter")
                                                          Row(
                                                            children: [
                                                              CommonText(
                                                                  text:
                                                                      "Coach/Recruiter : ",
                                                                  fontSize: 16,
                                                                  color:
                                                                      AppColors
                                                                          .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                              CommonText(
                                                                  text: totalbookmark
                                                                      .roleTotal
                                                                      .toString(),
                                                                  fontSize: 16,
                                                                  color:
                                                                      AppColors
                                                                          .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                            ],
                                                          ),
                                                        if (totalbookmark.roleName == "Advisor")
                                                          Row(
                                                            children: [
                                                              CommonText(
                                                                  text:
                                                                      "Specialist: ",
                                                                  fontSize: 16,
                                                                  color:
                                                                      AppColors
                                                                          .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                              CommonText(
                                                                  text: totalbookmark
                                                                      .roleTotal
                                                                      .toString(),
                                                                  fontSize: 16,
                                                                  color:
                                                                      AppColors
                                                                          .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                            ],
                                                          ),
                                                      ],
                                                    );
                                                  }),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                        ),
                      ],
                    );
                  } else {
                    return const Center(
                      child: NoDataFound(),
                    );
                  }
              }
              return const Center(
                child: NoDataFound(),
              );
            }),
      ],
    );
  }

  _build_Cards_Athelete_free() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FutureBuilder<DashboardAthleteCouchCount?>(
            future: get_Dashboard_Card_count_coach_athelte(accessToken),
            builder: (context, snapshot) {
              final overlay = LoadingOverlay.of(context);
              if (snapshot.hasError)
                const Center(
                  child: NoDataFound(),
                );
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: CustomLoader());
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    List<ViewCount>? totalviewcount = snapshot.data?.viewCount;
                    List<BookMarkCount>? totalbookmarkcount = snapshot.data?.bookMarkCount;
                    if (snapshot.data != null) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: totalviewcount!.isEmpty
                                ? _build_Card_Coach_athelete_free_common(
                                    "Profile Viewed By Coach/Recruiter",
                                    "0",
                                    contact_icon,
                                    AppColors.contacts_card_color,
                                    AppColors.white,
                                  )
                                : totalviewcount.length == 1
                                ? _build_Card_Coach_athelete_common(
                              "Profile Viewed By Coach/Recruiter",
                               totalviewcount.first.roleName == "Coach / Recruiter" ? "${totalviewcount.first.roleWiseViewTotal}": "0",
                              contact_icon,
                              AppColors.contacts_card_color,
                              AppColors.white,
                                  () {
                                _dashboard_CoachRecruiter_userDetail();
                              },
                            )
                                : Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 10),
                                child: Column(
                                  children: [
                                    _build_Card_Coach_athelete_common(
                                      "Profile Viewed By Coach/Recruiter",
                                      "${totalviewcount[0].roleName != "Coach / Recruiter" || totalviewcount[0].roleWiseViewTotal == null ? "0" : totalviewcount[0].roleWiseViewTotal}",
                                      contact_icon,
                                      AppColors.contacts_card_color,
                                      AppColors.white,
                                          () {
                                        _dashboard_CoachRecruiter_userDetail();
                                      },
                                    ),
                                  ],
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: totalviewcount.isEmpty
                                ? _build_Card_Coach_athelete_free_common(
                                    "Profile Viewed By Specialist",
                                    "0",
                                    baseball_icon,
                                    AppColors.matches_card_color,
                                    AppColors.white,
                                  )
                                : totalviewcount.length == 1
                                ? _build_Card_Coach_athelete_common(
                              "Profile Viewed By Specialist",
                              totalviewcount.first.roleName == "Advisor" ? "${totalviewcount.first.roleWiseViewTotal}": "0",
                              contact_icon,
                              AppColors.contacts_card_color,
                              AppColors.white,
                                  () {
                                    _dashboard_Specialist_userDetail();
                              },
                            )
                                : Padding(
                              padding:
                              const EdgeInsets.only(bottom: 10),
                              child:
                              _build_Card_Coach_athelete_common(
                                "Profile Viewed By Specialist",
                                "${totalviewcount[1].roleName != "Advisor" || totalviewcount[1].roleWiseViewTotal == null ? "0" : totalviewcount[1].roleWiseViewTotal}",
                                baseball_icon,
                                AppColors.matches_card_color,
                                AppColors.white,
                                    () {
                                  _dashboard_Specialist_userDetail();
                                },
                              ),
                            ),
                          /*  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount:
                                        totalviewcount.length.compareTo(0),
                                    itemBuilder: (context, index) {
                                      var totalViewcount =
                                          totalviewcount[index];
                                      print(
                                          "Length ========>>>>>> ${totalViewcount.roleWiseViewTotal}");
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child:
                                            _build_Card_Coach_athelete_common(
                                          "Profile Viewed By Specialist",
                                          "${totalViewcount.roleName != "Advisor" || totalViewcount.roleWiseViewTotal == null ? "0" : totalViewcount.roleWiseViewTotal}",
                                          baseball_icon,
                                          AppColors.matches_card_color,
                                          AppColors.white,
                                          () {
                                            _dashboard_Specialist_userDetail();
                                          },
                                        ),
                                      );
                                    },
                                  ),*/
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10, top: 0),
                            child: totalbookmarkcount!.isEmpty
                                ? _build_Card_athelete_profilebookmark_nodata(
                                    "Profile Bookmarked By",
                                    "Coach/Recruiter: ",
                                    "0",
                                    "Specialist: ",
                                    "0",
                                    contactIcon,
                                    AppColors.black,
                                    AppColors.white,
                                  )
                                : totalbookmarkcount.length == 1
                                    ? _build_Card_Coach_athelete_profilebookmark(
                                        "Profile Bookmarked By",
                                        "Specialist : ",
                                        totalbookmarkcount.first.roleName ==
                                                    "Advisor" &&
                                                totalbookmarkcount
                                                        .first.roleTotal !=
                                                    null
                                            ? totalbookmarkcount.first.roleTotal
                                                .toString()
                                            : "0",
                                        "Coach / Recruiter : ",
                                        totalbookmarkcount.first.roleName ==
                                                    "Coach / Recruiter" &&
                                                totalbookmarkcount
                                                        .first.roleTotal !=
                                                    null
                                            ? totalbookmarkcount.first.roleTotal
                                                .toString()
                                            : "0",
                                        contactIcon,
                                        AppColors.black,
                                        AppColors.white,
                                        () {
                                          _dashboard_Bookmarked_userDetail();
                                        },
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Container(
                                          height: 130,
                                          width: Get.width,
                                          decoration: BoxDecoration(
                                            color: AppColors.black,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            image: const DecorationImage(
                                              image:
                                                  AssetImage(dashboardVector),
                                              alignment: Alignment.topRight,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 24, vertical: 14),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      contactIcon,
                                                      color: AppColors.white,
                                                    ),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    Expanded(
                                                      child: CommonText(
                                                          text:
                                                              "Profile Bookmarked By",
                                                          fontSize: 18,
                                                          color: AppColors
                                                              .contacts_text_color,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    PreferenceUtils.getString(
                                                                "plan_login") ==
                                                            "Free"
                                                        ? Container()
                                                        : InkWell(
                                                            onTap: () {
                                                              _dashboard_Bookmarked_userDetail();
                                                            },
                                                            child: Container(
                                                              height: 15,
                                                              width: 15,
                                                              child: SvgPicture
                                                                  .asset(
                                                                dotIcon,
                                                              ),
                                                            ),
                                                          ),
                                                  ],
                                                ),
                                                SizedBox(height: 15),
                                                ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        totalbookmarkcount
                                                            .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      var totalbookmark =
                                                          totalbookmarkcount[
                                                              index];
                                                      return Column(
                                                        children: [
                                                          if (totalbookmark
                                                                  .roleName ==
                                                              "Coach / Recruiter")
                                                            Row(
                                                              children: [
                                                                CommonText(
                                                                    text:
                                                                        "Coach/Recruiter : ",
                                                                    fontSize:
                                                                        16,
                                                                    color: AppColors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                                CommonText(
                                                                    text: totalbookmark
                                                                        .roleTotal
                                                                        .toString(),
                                                                    fontSize:
                                                                        16,
                                                                    color: AppColors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                              ],
                                                            ),
                                                          if (totalbookmark
                                                                  .roleName ==
                                                              "Advisor")
                                                            Row(
                                                              children: [
                                                                CommonText(
                                                                    text:
                                                                        "Specialist: ",
                                                                    fontSize:
                                                                        16,
                                                                    color: AppColors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                                CommonText(
                                                                    text: totalbookmark
                                                                        .roleTotal
                                                                        .toString(),
                                                                    fontSize:
                                                                        16,
                                                                    color: AppColors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                              ],
                                                            ),
                                                        ],
                                                      );
                                                    }),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                          ),
                        ],
                      );
                    }
                  } else {
                    return const Center(
                      child: NoDataFound(),
                    );
                  }
              }
              return const Center(
                child: NoDataFound(),
              );
            }),
      ],
    );
  }

  _build_Card_athelete_profilebookmark_nodata(
    String title,
    String title_athlete,
    String numbers_ath,
    String title_specilist,
    String numbers_specialist,
    image,
    color,
    iconColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: 130,
        width: Get.width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          image: const DecorationImage(
            image: AssetImage(dashboardVector),
            alignment: Alignment.topRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    image,
                    color: iconColor,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: CommonText(
                        text: title,
                        fontSize: 18,
                        color: AppColors.contacts_text_color,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  CommonText(
                      text: title_athlete,
                      fontSize: 16,
                      color: AppColors.white,
                      fontWeight: FontWeight.w700),
                  CommonText(
                      text: numbers_ath,
                      fontSize: 16,
                      color: AppColors.white,
                      fontWeight: FontWeight.w700),
                ],
              ),
              Row(
                children: [
                  CommonText(
                      text: title_specilist,
                      fontSize: 16,
                      color: AppColors.white,
                      fontWeight: FontWeight.w700),
                  CommonText(
                      text: numbers_specialist,
                      fontSize: 16,
                      color: AppColors.white,
                      fontWeight: FontWeight.w700),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  build_Card_athelete_profilebookmark_freethelete(
      String title,
      String title_athlete,
      String numbers_ath,
      String title_specilist,
      String numbers_specialist,
      image,
      color,
      iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: 130,
        width: Get.width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          image: const DecorationImage(
            image: AssetImage(dashboardVector),
            alignment: Alignment.topRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    image,
                    color: iconColor,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  CommonText(
                      text: title,
                      fontSize: 18,
                      color: AppColors.contacts_text_color,
                      fontWeight: FontWeight.w600),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  CommonText(
                      text: title_athlete,
                      fontSize: 16,
                      color: AppColors.white,
                      fontWeight: FontWeight.w700),
                  CommonText(
                      text: numbers_ath,
                      fontSize: 16,
                      color: AppColors.white,
                      fontWeight: FontWeight.w700),
                ],
              ),
              Row(
                children: [
                  CommonText(
                      text: title_specilist,
                      fontSize: 16,
                      color: AppColors.white,
                      fontWeight: FontWeight.w700),
                  CommonText(
                      text: numbers_specialist,
                      fontSize: 16,
                      color: AppColors.white,
                      fontWeight: FontWeight.w700),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  build_Card_athelete_profilebookmark(
      String title,
      String title_athlete,
      String numbers_ath,
      String title_specilist,
      String numbers_specialist,
      image,
      color,
      iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: 130,
        width: Get.width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          image: const DecorationImage(
            image: AssetImage(dashboardVector),
            alignment: Alignment.topRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    image,
                    color: iconColor,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  CommonText(
                      text: title,
                      fontSize: 18,
                      color: AppColors.contacts_text_color,
                      fontWeight: FontWeight.w600),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  CommonText(
                      text: title_athlete,
                      fontSize: 16,
                      color: AppColors.white,
                      fontWeight: FontWeight.w700),
                  CommonText(
                      text: numbers_ath,
                      fontSize: 16,
                      color: AppColors.white,
                      fontWeight: FontWeight.w700),
                ],
              ),
              Row(
                children: [
                  CommonText(
                      text: title_specilist,
                      fontSize: 16,
                      color: AppColors.white,
                      fontWeight: FontWeight.w700),
                  CommonText(
                      text: numbers_specialist,
                      fontSize: 16,
                      color: AppColors.white,
                      fontWeight: FontWeight.w700),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildTotalCard(
      String title, String numbers, image, color, onClick, iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: 130,
        width: Get.width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          image: const DecorationImage(
            image: AssetImage(dashboardVector),
            alignment: Alignment.topRight,
          ),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 24, right: 20, top: 14, bottom: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset(
                    image,
                    color: iconColor,
                  ),
                  InkWell(
                    onTap: onClick,
                    child: Container(
                      height: 15,
                      width: 15,
                      child: SvgPicture.asset(
                        dotIcon,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              CommonText(
                  text: title,
                  fontSize: 14,
                  color: AppColors.contacts_text_color,
                  fontWeight: FontWeight.w600),
              const SizedBox(height: 3),
              CommonText(
                  text: numbers,
                  fontSize: 24,
                  color: AppColors.white,
                  fontWeight: FontWeight.w700),
            ],
          ),
        ),
      ),
    );
  }

  _buildTotalBlankCard(String title, String numbers, image, color, iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: 130,
        width: Get.width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          image: const DecorationImage(
            image: AssetImage(dashboardVector),
            alignment: Alignment.topRight,
          ),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 24, right: 20, top: 14, bottom: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset(
                    image,
                    color: iconColor,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              CommonText(
                  text: title,
                  fontSize: 14,
                  color: AppColors.contacts_text_color,
                  fontWeight: FontWeight.w600),
              const SizedBox(height: 3),
              CommonText(
                  text: numbers,
                  fontSize: 24,
                  color: AppColors.white,
                  fontWeight: FontWeight.w700),
            ],
          ),
        ),
      ),
    );
  }

  _build_Card_Coach_athelete_common(
      String title, String numbers, image, color, iconColor, onClick) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: 130,
        width: Get.width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          image: const DecorationImage(
            image: AssetImage(dashboardVector),
            alignment: Alignment.topRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    image,
                    height: 45,
                    width: 45,
                    color: iconColor,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: CommonText(
                        text: title,
                        fontSize: 18,
                        color: AppColors.contacts_text_color,
                        fontWeight: FontWeight.w600),
                  ),
                  numbers == "0"
                      ? Container()
                      : PreferenceUtils.getString("plan_login") == "Free"
                          ? Container()
                          : InkWell(
                              onTap: onClick,
                              child: Container(
                                height: 15,
                                width: 15,
                                child: SvgPicture.asset(
                                  dotIcon,
                                ),
                              ),
                            ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 10, top: 20),
                child: CommonText(
                    text: numbers,
                    fontSize: 20,
                    color: AppColors.white,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _build_Card_Coach_athelete_free_common(
      String title, String numbers, image, color, iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: 130,
        width: Get.width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          image: const DecorationImage(
            image: AssetImage(dashboardVector),
            alignment: Alignment.topRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    image,
                    height: 45,
                    width: 45,
                    color: iconColor,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: CommonText(
                        text: title,
                        fontSize: 18,
                        color: AppColors.contacts_text_color,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 10, top: 20),
                child: CommonText(
                    text: numbers,
                    fontSize: 20,
                    color: AppColors.white,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _build_Card_Coach_athelete_profilebookmark(
      String title,
      String title_athlete,
      String numbers_ath,
      String title_specilist,
      String numbers_specialist,
      image,
      color,
      iconColor,
      onClick) {
    print("total ====>> $numbers_ath");
    print("total ====>> $numbers_specialist");
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: 130,
        width: Get.width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          image: const DecorationImage(
            image: AssetImage(dashboardVector),
            alignment: Alignment.topRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    image,
                    color: iconColor,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: CommonText(
                        text: title,
                        fontSize: 18,
                        color: AppColors.contacts_text_color,
                        fontWeight: FontWeight.w600),
                  ),
                  PreferenceUtils.getString("plan_login") == "Free"
                      ? Container()
                      : InkWell(
                          onTap: onClick,
                          child: Container(
                            height: 15,
                            width: 15,
                            child: SvgPicture.asset(
                              dotIcon,
                            ),
                          ),
                        ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  CommonText(
                      text: title_athlete,
                      fontSize: 16,
                      color: AppColors.white,
                      fontWeight: FontWeight.w700),
                  CommonText(
                      text: numbers_ath,
                      fontSize: 16,
                      color: AppColors.white,
                      fontWeight: FontWeight.w700),
                ],
              ),
              Row(
                children: [
                  CommonText(
                      text: title_specilist,
                      fontSize: 16,
                      color: AppColors.white,
                      fontWeight: FontWeight.w700),
                  CommonText(
                      text: numbers_specialist,
                      fontSize: 16,
                      color: AppColors.white,
                      fontWeight: FontWeight.w700),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _detailTotalActive() async {
    final shouldPop = await showDialog(
      context: context,
      builder: (context) => Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        elevation: 0.0,
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FutureBuilder<TotalAmountModel?>(
                  future: getAdminDashboardCardCounting(accessToken),
                  builder: (context, snapshot) {
                    if (snapshot.hasError)
                      const Center(
                        child: NoDataFound(),
                      );
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(child: CustomLoader());
                      case ConnectionState.done:
                        if (snapshot.hasData) {
                          List<TotalActiveUser>? totalActiveUser =
                              snapshot.data?.userDetails?.totalActiveUser;
                          if (totalActiveUser != null) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      CommonText(
                                          text: "Active Users",
                                          fontSize: 18,
                                          color: AppColors.black,
                                          fontWeight: FontWeight.bold),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Divider(thickness: 1),
                                  SizedBox(height: 20),
                                  SingleChildScrollView(
                                    scrollDirection : Axis.horizontal,
                                    child: DataTable(
                                      headingRowColor:
                                          MaterialStateProperty.resolveWith(
                                              (states) => AppColors
                                                  .drawer_bottom_text_color),
                                      columns: const [
                                        DataColumn(
                                          label: CommonText(
                                              text: "ROLE",
                                              fontSize: 14,
                                              color: AppColors.white,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        DataColumn(
                                          label: CommonText(
                                              text: "SPORT",
                                              fontSize: 14,
                                              color: AppColors.white,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        DataColumn(
                                          label: CommonText(
                                              text: "SUBSCRIPTION\nTYPE",
                                              fontSize: 14,
                                              color: AppColors.white,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        DataColumn(
                                          label: CommonText(
                                              text: "ACTIVE\nUSER",
                                              fontSize: 14,
                                              color: AppColors.white,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                      rows: List.generate(totalActiveUser.length,
                                          (index) {
                                        var totalActiveItem =
                                            totalActiveUser[index];
                                        return DataRow(
                                          cells: [
                                            DataCell(
                                              CommonText(
                                                  text: totalActiveItem.name
                                                      .toString(),
                                                  fontSize: 14,
                                                  color: AppColors.black_txcolor,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            DataCell(
                                              CommonText(
                                                  text: totalActiveItem.sport
                                                      .toString(),
                                                  fontSize: 14,
                                                  color: AppColors.black_txcolor,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            DataCell(
                                              CommonText(
                                                  text: totalActiveItem.plan
                                                      .toString(),
                                                  fontSize: 14,
                                                  color: AppColors.black_txcolor,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            DataCell(
                                              Center(
                                                child: CommonText(
                                                    text:
                                                        "${totalActiveItem.activeUser}",
                                                    fontSize: 14,
                                                    color:
                                                        AppColors.black_txcolor,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Divider(thickness: 1),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          height: 35,
                                          width: 80,
                                          decoration: BoxDecoration(
                                            color: AppColors
                                                .drawer_bottom_text_color,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: const Center(
                                            child: CommonText(
                                                text: "Close",
                                                fontSize: 15,
                                                color: AppColors.white,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }
                        } else {
                          return const Center(
                            child: NoDataFound(),
                          );
                        }
                    }
                    return const Center(
                      child: NoDataFound(),
                    );
                  }),
            ],
          ),
        ),
      ),
    );

    return shouldPop ?? false;
  }

  Future<bool> _detailTotalAmount() async {
    final shouldPop = await showDialog(
      context: context,
      builder: (context) => Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        elevation: 0.0,
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FutureBuilder<TotalAmountModel?>(
                  future: getAdminDashboardCardCounting(accessToken),
                  builder: (context, snapshot) {
                    if (snapshot.hasError)
                      const Center(
                        child: NoDataFound(),
                      );
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(child: CustomLoader());
                      case ConnectionState.done:
                        if (snapshot.hasData) {
                          List<TotalUserAmount>? totalUserAmount =
                              snapshot.data?.userDetails?.totalUserAmount;
                          if (totalUserAmount != null) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      CommonText(
                                          text: "Subscription Revenue",
                                          fontSize: 18,
                                          color: AppColors.black,
                                          fontWeight: FontWeight.bold),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Divider(thickness: 1),
                                  SizedBox(height: 20),
                                  SingleChildScrollView(
                                    scrollDirection : Axis.horizontal,
                                    child: DataTable(
                                      headingRowColor:
                                          MaterialStateProperty.resolveWith(
                                              (states) => AppColors
                                                  .drawer_bottom_text_color),
                                      columns: const [
                                        DataColumn(
                                          label: CommonText(
                                              text: "ROLE",
                                              fontSize: 15,
                                              color: AppColors.white,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        DataColumn(
                                          label: CommonText(
                                              text: "SPORT",
                                              fontSize: 15,
                                              color: AppColors.white,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        DataColumn(
                                          label: CommonText(
                                              text: "SUBSCRIPTION\nTYPE",
                                              fontSize: 15,
                                              color: AppColors.white,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        DataColumn(
                                          label: CommonText(
                                              text: "AMOUNT",
                                              fontSize: 15,
                                              color: AppColors.white,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                      rows: List.generate(totalUserAmount.length,
                                          (index) {
                                        var totalAmountItem =
                                            totalUserAmount[index];
                                        return DataRow(
                                          cells: [
                                            DataCell(
                                              CommonText(
                                                  text: totalAmountItem.roleName
                                                      .toString(),
                                                  fontSize: 14,
                                                  color: AppColors.black_txcolor,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            DataCell(
                                              CommonText(
                                                  text: totalAmountItem.sport
                                                      .toString(),
                                                  fontSize: 14,
                                                  color: AppColors.black_txcolor,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            DataCell(
                                              CommonText(
                                                  text: totalAmountItem.plan
                                                      .toString(),
                                                  fontSize: 14,
                                                  color: AppColors.black_txcolor,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            DataCell(
                                              CommonText(
                                                  text:
                                                      "\$${totalAmountItem.roleTotal}",
                                                  fontSize: 14,
                                                  color: AppColors.black_txcolor,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        );
                                      }),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Divider(thickness: 1),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          height: 35,
                                          width: 80,
                                          decoration: BoxDecoration(
                                            color: AppColors
                                                .drawer_bottom_text_color,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: const Center(
                                            child: CommonText(
                                                text: "Close",
                                                fontSize: 15,
                                                color: AppColors.white,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }
                        } else {
                          return const Center(
                            child: NoDataFound(),
                          );
                        }
                    }
                    return const Center(
                      child: NoDataFound(),
                    );
                  }),
            ],
          ),
        ),
      ),
    );

    return shouldPop ?? false;
  }

  Future<bool> _detailTotalPending() async {
    final shouldPop = await showDialog(
      context: context,
      builder: (context) => Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        elevation: 0.0,
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FutureBuilder<TotalAmountModel?>(
                  future: getAdminDashboardCardCounting(accessToken),
                  builder: (context, snapshot) {
                    if (snapshot.hasError)
                      const Center(
                        child: NoDataFound(),
                      );
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(child: CustomLoader());
                      case ConnectionState.done:
                        if (snapshot.hasData) {
                          List<TotalPending>? totalPending =
                              snapshot.data?.userDetails?.totalPending;
                          if (totalPending != null) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      CommonText(
                                          text: "Total Pending",
                                          fontSize: 18,
                                          color: AppColors.black,
                                          fontWeight: FontWeight.bold),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Divider(thickness: 1),
                                  SizedBox(height: 20),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                      headingRowColor:
                                          MaterialStateProperty.resolveWith(
                                              (states) => AppColors
                                                  .drawer_bottom_text_color),
                                      columns: const [
                                        DataColumn(
                                          label: CommonText(
                                              text: "USER",
                                              fontSize: 14,
                                              color: AppColors.white,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        DataColumn(
                                          label: CommonText(
                                              text: "SPORT",
                                              fontSize: 14,
                                              color: AppColors.white,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        DataColumn(
                                          label: CommonText(
                                              text: "SUBSCRIPTION\nTYPE",
                                              fontSize: 14,
                                              color: AppColors.white,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        DataColumn(
                                          label: CommonText(
                                              text: "TOTAL PENDING\nUSER",
                                              fontSize: 14,
                                              color: AppColors.white,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                      rows: List.generate(totalPending.length,
                                          (index) {
                                        var totalPendingItem =
                                            totalPending[index];
                                        return DataRow(
                                          cells: [
                                            DataCell(
                                              CommonText(
                                                  text: totalPendingItem.name
                                                      .toString(),
                                                  fontSize: 14,
                                                  color:
                                                      AppColors.black_txcolor,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            DataCell(
                                              CommonText(
                                                  text: totalPendingItem.sport
                                                      .toString(),
                                                  fontSize: 14,
                                                  color:
                                                  AppColors.black_txcolor,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            DataCell(
                                              CommonText(
                                                  text: totalPendingItem.plan
                                                      .toString(),
                                                  fontSize: 14,
                                                  color:
                                                      AppColors.black_txcolor,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            DataCell(
                                              CommonText(
                                                  text:
                                                      "${totalPendingItem.pendingUser}",
                                                  fontSize: 14,
                                                  color:
                                                      AppColors.black_txcolor,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        );
                                      }),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Divider(thickness: 1),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          height: 35,
                                          width: 80,
                                          decoration: BoxDecoration(
                                            color: AppColors
                                                .drawer_bottom_text_color,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: const Center(
                                            child: CommonText(
                                                text: "Close",
                                                fontSize: 15,
                                                color: AppColors.white,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }
                        } else {
                          return const Center(
                            child: NoDataFound(),
                          );
                        }
                    }
                    return const Center(
                      child: NoDataFound(),
                    );
                  }),
            ],
          ),
        ),
      ),
    );

    return shouldPop ?? false;
  }

  _buildTextView() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: CommonText(
        text: AppString.pendingRequest,
        fontSize: 15,
        color: AppColors.black_txcolor,
        fontWeight: FontWeight.w500,
      ),
    );
  }
  check_plan_expire_onsevendays(){
    print("this counting function called");
    return Column(
      children: [
        differenceInDays!= null?differenceInDays ==1?
        Padding(
          padding: EdgeInsets.only(top: 0, bottom: 10,left: 10),
          child: Row(
            children:  [
              Expanded(
                child: CommonText(
                    text:"Your plan will be expired after"+ " ${differenceInDays??" "} day,Please subscribe your plan on webportal.",
                    fontSize: 16,
                    color: AppColors.orange,
                    fontWeight: FontWeight.w700),
              ),
            ],),
        ):differenceInDays!= null?differenceInDays==0?Padding(
          padding: EdgeInsets.only(left: 10,bottom: 10),
          child: CommonText(
              text:"Your plan will be expired tomorrow, Please subscribe your plan on webportal.",
              fontSize: 16,
              color: AppColors.orange,
              fontWeight: FontWeight.w700),
        ):differenceInDays!= null?differenceInDays!<0?Padding(
          padding: EdgeInsets.only(left: 10,bottom: 10),
          child: Container(),
        ): differenceInDays!= null?differenceInDays!<=7?Padding(
          padding: EdgeInsets.only(top: 0,bottom: 10,left: 10),
          child: Row(
            children:  [
              Expanded(
                child: CommonText(
                    text:"Your plan will be expired after"+ " ${differenceInDays??" "} days,Please subscribe your plan on webportal.",
                    fontSize: 16,
                    color: AppColors.orange,
                    fontWeight: FontWeight.w700),
              ),
            ],),
        ):Container():Container():Container():Container() : Container(),
      ],
    );
  }

  /////////////////////////////////////TODO UPDATE PLAN AND FEATURES//////////////////////////
  getMY_PLAN_AND_FEATURES() async {
    //DateFormat('yMMMd').format(DateTime.parse(athleteuserdetails["DOB"].toString() ?? ""))
    MyApplication.getInstance()!
        .checkConnectivity(context)
        .then((internet) async {
      if (internet != null && internet) {
        try {
          Dio dio = Dio();
          var response = await dio.get(AppConstant.my_plans_and_features,
              options: Options(
                  followRedirects: false,
                  headers:{
                    "Authorization": "Bearer ${PreferenceUtils.getString("accesstoken")}"
                  }
              ));
          if (response.statusCode == 200) {
            print("errror message home ======>>> ${response.data["Message"]}");
            print("getMY_PLAN_AND_FEATURES Response:====<> ${response.data}");
            startdate=DateFormat('yyyy-MM-dd').format(DateTime.parse(response.data["myPlansAndFeatures"]["effectiveDate"].toString() ?? ""));
            enddate=DateFormat('yyyy-MM-dd').format(DateTime.parse(response.data["myPlansAndFeatures"]["expireDate"].toString() ?? ""));
            print("this is start date ====<> ${startdate}");
            print("this is end date====<> ${enddate}");
            DateTime dateTimeNow = DateTime.now();
            String date = DateFormat("yyyy-MM-dd").format(DateTime.now());
            print("this is current date $dateTimeNow");
            DateTime dateTimeCreatedAt = DateTime.parse("${startdate}");
            DateTime dateTimeCreatedAtend = DateTime.parse("${enddate}");
            differenceInDays = dateTimeCreatedAtend.difference(dateTimeNow).inDays;
            print('this is the date difference for startdate $differenceInDays');
            /*if(date!=startdate){
          DateTime dateTimeCreatedAt = DateTime.parse("${startdate}");
          DateTime dateTimeCreatedAtend = DateTime.parse("${enddate}");
          differenceInDays = dateTimeCreatedAtend.difference(dateTimeCreatedAt).inDays;
          print('this is the date difference for startdate $differenceInDays');
          }
          else{
            DateTime dateTimeCreatedAtend = DateTime.parse("${enddate}");
            differenceInDays = dateTimeCreatedAtend.difference(dateTimeNow).inDays;
            print('this is the date end difference $differenceInDays');
          }*/
            setState(() {
            });
          }

          // else if(response.statusCode == 401) {
          //   return Get.offAll(Loginscreennew());
          // }
          else {
            // MyApplication.getInstance()?.showInSnackBar(response.data["Message"], context);
            print("this is error of plan and feature ${response.data["Message"]}");
          }
        } on DioError catch (e) {
          if (e is DioError) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => Loginscreennew()));
            // MyApplication.getInstance()?.showInSnackBar(e.response!.data["Message"], context);
            print("this is error of plan and feature ${e.response!.data["Message"]}");
          }
        }
      } else {
        MyApplication.getInstance()?.showInSnackBar(AppString.no_connection, context);
      }
    });
  }

  Future<bool> _admin_UserDetail(String userId) async {
    print("value ====  $userId");
    id = userId;
    print("Id data ====  $id");

    final shouldPop = await showDialog(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          elevation: 0.0,
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: SingleChildScrollView(
            child: FutureBuilder<ProfileModel?>(
              future: getManageProfile(accessToken, userId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  const Center(
                    child: NoDataFound(),
                  );
                }
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(child: CustomLoader());
                  case ConnectionState.done:
                    if (snapshot.hasData) {
                      Userdetails? userdetails = snapshot.data?.userdetails;
                      if (userdetails != null) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(1000.0),
                                    child: CachedNetworkImage(
                                      height: 70,
                                      width: 70,
                                      fit: BoxFit.cover,
                                      imageUrl: "${userdetails.picturePathS3}",
                                      placeholder: (context, url) =>
                                          CustomLoader(),
                                      errorWidget: (context, url, error) =>
                                          SvgPicture.asset(
                                        userProfile_image,
                                        height: 70,
                                        width: 70,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CommonText(
                                            text: "${userdetails.displayName}",
                                            fontSize: 18,
                                            color: AppColors.black_txcolor,
                                            fontWeight: FontWeight.w500),
                                        const SizedBox(height: 5),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 2),
                                              child: SvgPicture.asset(
                                                locationIcon,
                                                color: AppColors.black,
                                              ),
                                            ),
                                            SizedBox(width: 3),
                                            Expanded(
                                              child: CommonText(
                                                  text:
                                                      "${userdetails.streetAddress},${userdetails.city}, ${userdetails.landMark ?? ""} ${userdetails.state} ${userdetails.zipcode}",
                                                  fontSize: 15,
                                                  color:
                                                      AppColors.black_txcolor,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 2),
                                              child: SvgPicture.asset(
                                                emailIcon,
                                                color: AppColors.black,
                                              ),
                                            ),
                                            SizedBox(width: 3),
                                            Expanded(
                                              child: CommonText(
                                                  text:
                                                      "${userdetails.userEmail}",
                                                  fontSize: 15,
                                                  color:
                                                      AppColors.black_txcolor,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              call_icon,
                                              color: AppColors.black,
                                            ),
                                            const SizedBox(width: 3),
                                            CommonText(
                                                text: "${userdetails.contact}",
                                                fontSize: 15,
                                                color: AppColors.black_txcolor,
                                                fontWeight: FontWeight.w400),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 10),
                              const Divider(color: AppColors.grey_hint_color),
                              _isFirstLoadRunning
                                  ? Align(
                                      alignment: Alignment.center,
                                      child: CustomLoader(),
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: itemList.length.compareTo(0),
                                      itemBuilder: (context, index) {
                                        print("List Of tab length ==-===<><. ${itemList.length}");
                                        var group = groupBy(itemList,
                                                (e) => e["displayGroup"])
                                            .map((key, value) => MapEntry(
                                                key,
                                                value
                                                    .map((e) =>
                                                        e["displayGroup"])
                                                    .whereNotNull()));

                                        print(">>>>>>>>>>>>> $group");
                                        print(">>>>>>>>>>>>> ${group.length}");
                                        return TabAdminHomeDetailScreen(
                                            userId, group.length, group);
                                      }),
                              const Divider(color: AppColors.grey_hint_color),
                              const SizedBox(width: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 35,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        color: AppColors.dark_blue_button_color,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Center(
                                        child: CommonText(
                                            text: "Close",
                                            fontSize: 15,
                                            color: AppColors.white,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      } else {
                        return const Center(
                          child: NoDataFound(),
                        );
                      }
                    } else {
                      return Container(
                        height: 100,
                        child: const Center(
                          child: NoDataFound(),
                        ),
                      );
                    }
                }
                return Container(
                  height: 100,
                  child: const Center(
                    child: NoDataFound(),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );

    return shouldPop ?? false;
  }

  Future<bool> _dashboard_Athelete_userDetail() async {
    final shouldPop = await showDialog(
      context: context,
      builder: (context) => ViewAtheleteCountDetails(),
    );

    return shouldPop ?? false;
  }

  Future<bool> _dashboard_CoachRecruiter_userDetail() async {
    final shouldPop = await showDialog(
      context: context,
      builder: (context) => ViewCoachListCountDetails(),
    );

    return shouldPop ?? false;
  }

  Future<bool> _dashboard_Specialist_userDetail() async {
    final shouldPop = await showDialog(
      context: context,
      builder: (context) => ViewSpecialistCountDetails(),
    );

    return shouldPop ?? false;
  }

  Future<bool> _dashboard_Bookmarked_userDetail() async {
    final shouldPop = await showDialog(
      context: context,
      builder: (context) => ViewBookMarkedCountDetails(),
    );

    return shouldPop ?? false;
  }

  Future<bool> _approveRequest(String displayName, int? userID, String subscription, String status, String role) async {
    userController.text = displayName;
    final shouldPop = await showDialog(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          elevation: 0.0,
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText(
                            text: AppString.approveRequest,
                            fontSize: 18,
                            color: AppColors.black,
                            fontWeight: FontWeight.bold),
                        const SizedBox(height: 15),
                        const Divider(color: AppColors.grey_hint_color),
                        const SizedBox(height: 10),
                        TextFieldView2(
                          controller: userController,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return AppString.userName_validation;
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                          type: TextInputType.text,
                          text: "user",
                        ),
                        subscription == "Gold" || subscription == "Platinum"
                            ? const SizedBox(height: 10)
                            : Container(),
                        subscription == "Gold" || subscription == "Platinum"
                            ? TextFieldView(
                                controller: plyeridController,
                                textInputAction: TextInputAction.next,
                                type: TextInputType.text,
                                text: "Player ID",
                              )
                            : Container(),
                        const SizedBox(height: 10),
                        subscription == "Free"
                            ? Container()
                            : StatefulBuilder(builder: (context, setState) {
                                return DropdownButtonHideUnderline(
                                  child: DropdownButtonFormField2<String>(
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(
                                          left: 0,
                                          right: 10,
                                          bottom: 15,
                                          top: 15),
                                      enabledBorder: OutlineInputBorder(
                                          //<-- SEE HERE
                                          borderSide: BorderSide(
                                              color: AppColors.grey_hint_color,
                                              width: 1),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      errorBorder: OutlineInputBorder(
                                        //<-- SEE HERE
                                        borderSide: BorderSide(
                                            color: AppColors.dark_red,
                                            width: 1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    value: trainer,
                                    isExpanded: true,
                                    validator: (value) =>
                                        value == null ? ' ' : null,
                                    //itemHeight: 50.0,
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.grey[700]),
                                    items: trainerList?.map((item) {
                                      PreferenceUtils.setString(
                                          "client_trainerID",
                                          item['TrainerID'].toString());
                                      return DropdownMenuItem(
                                        value: item['TrainerID'].toString(),
                                        child: CommonText(
                                            text: item['TrainerName'],
                                            fontSize: 13,
                                            color: AppColors.black,
                                            fontWeight: FontWeight.w500),
                                      );
                                    }).toList(),
                                    hint: const CommonText(
                                        text: "Select Trainer",
                                        fontSize: 15,
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w500),
                                    onChanged: (String? newValue) {
                                      setState(() => trainer = newValue);
                                      if (kDebugMode) {
                                        print(trainer.toString());
                                      }
                                    },
                                  ),
                                );
                              }),
                        const SizedBox(height: 10),
                        TextFieldDetailView(
                          controller: approvalCommentController,
                          textInputAction: TextInputAction.next,
                          type: TextInputType.text,
                          text: "Approval Comment",
                        ),
                        const SizedBox(height: 15),
                        const Divider(color: AppColors.grey_hint_color),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const CommonText(
                                  text: "Cancel",
                                  fontSize: 15,
                                  color: AppColors.dark_blue_button_color,
                                  fontWeight: FontWeight.w500),
                            ),
                            GestureDetector(
                              onTap: () {
                                print(
                                    " approve =======<><><> $clientTrainerID");
                                print("$status");
                                print("trainer id ? $trainer");

                                setState(() {
                                  if (_formKey.currentState!.validate()) {
                                    if (subscription == "Free") {
                                      postApproveRequest(context, userID,
                                          status, clientTrainerID.toString());
                                    } else if (subscription == "Gold" ||
                                        subscription == "Platinum") {
                                      postApproveRequest2(
                                          context,
                                          userID,
                                          status,
                                          clientTrainerID.toString(),
                                          plyeridController.text.toString(),
                                          trainer,
                                          approvalCommentController.text ?? "");
                                    } else {
                                      postApproveRequest3(
                                          context,
                                          userID,
                                          status,
                                          trainer,
                                          approvalCommentController.text ?? "");
                                    }
                                  }
                                });
                              },
                              child: Container(
                                height: 35,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: AppColors.dark_blue_button_color,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Center(
                                  child: CommonText(
                                      text: AppString.approved,
                                      fontSize: 15,
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return shouldPop ?? false;
  }

  Future<bool> _cancelSubscriptionRequest(String displayName, String? userID) async {
    userController.text = displayName;
    final shouldPop = await showDialog(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          elevation: 0.0,
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText(
                            text: AppString.cancelSubscription,
                            fontSize: 18,
                            color: AppColors.black,
                            fontWeight: FontWeight.bold),
                        const SizedBox(height: 15),
                        const Divider(color: AppColors.grey_hint_color),
                        const SizedBox(height: 10),
                        TextFieldView2(
                          controller: userController,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return AppString.userName_validation;
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                          type: TextInputType.text,
                          text: "user",
                        ),
                        const SizedBox(height: 10),
                        TextFieldDetailView(
                          controller: approvalCommentController,
                          textInputAction: TextInputAction.next,
                          type: TextInputType.text,
                          text: "Reject Comment",
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        const Divider(color: AppColors.grey_hint_color),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const CommonText(
                                  text: "Cancel",
                                  fontSize: 15,
                                  color: AppColors.dark_blue_button_color,
                                  fontWeight: FontWeight.w500),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  postAdminReject(context, userID,
                                      approvalCommentController.text);
                                }
                              },
                              child: Container(
                                height: 35,
                                width: 80,
                                decoration: BoxDecoration(
                                  color: AppColors.dark_red,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: CommonText(
                                      text: AppString.reject,
                                      fontSize: 15,
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return shouldPop ?? false;
  }

  Widget _buildTrainerDropdown() {
    return StatefulBuilder(builder: (context, setState) {
      return Container(
          height: 46,
          //width: 180,
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(
              color: AppColors.grey_hint_color,
              width: 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              itemPadding: const EdgeInsets.only(left: 14, right: 14),
              dropdownMaxHeight: 200,
              dropdownWidth: 200,
              dropdownPadding: null,
              dropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.white,
              ),
              value: trainer,
              underline: Container(),
              isExpanded: true,
              //itemHeight: 50.0,
              style: TextStyle(fontSize: 15.0, color: Colors.grey[700]),
              items: trainerList?.map((item) {
                PreferenceUtils.setString(
                    "client_trainerID", item['TrainerID'].toString());
                return DropdownMenuItem(
                  value: item['TrainerID'].toString(),
                  child: CommonText(
                      text: item['TrainerName'],
                      fontSize: 13,
                      color: AppColors.black,
                      fontWeight: FontWeight.w500),
                );
              }).toList(),
              hint: const CommonText(
                  text: "select trainer",
                  fontSize: 15,
                  color: AppColors.black,
                  fontWeight: FontWeight.w500),
              onChanged: (String? newValue) {
                setState(() => trainer = newValue);
                if (kDebugMode) {
                  print(trainer.toString());
                }
              },
            ),
          ));
    });
  }

  manageAditionalInformationList(String userId) async {
    log('this is Manage_Profile  api call', name: "Manage_Profile");
    try {
      Dio dio = Dio();
      var response = await dio.get("${AppConstant.mamage_profile}/$userId",
          options: Options(followRedirects: false, headers: {
            "Authorization":
                "Bearer ${PreferenceUtils.getString("accesstoken")}"
          }));
      print("-----this is url $response");
      if (response.statusCode == 200) {
        print("+++++this is manageprofile ${response.data}");
        itemList = response.data["attribute"];
        // uniquelist = response.data["attribute"].where((value) => models.add(value["displayGroup"])).toList();
        print("+++++this is item ${response.data["attribute"]}");
      } else {
        //setState(() => _isFirstLoadRunning = false);
      }
    } catch (e) {
      print(e);
      //setState(() => _isFirstLoadRunning = false);
    }
  }

  get_Dashboard_Card_count_coach_athelte_dio_api() async {
    log('this is Dashboard_Card_count  api call', name: "Dashboard_Card_count");
    try {
      Dio dio = Dio();
      var response = await dio.get(
          AppConstant.COACH_athlete_Dashboard_card_count,
          options: Options(followRedirects: false, headers: {
            "Authorization":
                "Bearer ${PreferenceUtils.getString("accesstoken")}"
          }));
      print("-----this is url $response");
      if (response.statusCode == 200) {
        print("+++++this is Dashboard_Card_count ${response.data}");
        Dashboard_viewCard_count_List = response.data["viewCount"];
        // uniquelist = response.data["attribute"].where((value) => models.add(value["displayGroup"])).toList();
        print(
            "+++++this is Dashboard_Card_count $Dashboard_viewCard_count_List");
      } else {
        //setState(() => _isFirstLoadRunning = false);
      }
    } catch (e) {
      print(e);
      //setState(() => _isFirstLoadRunning = false);
    }
  }

  _CommonRow(text, text2) {
    return Row(
      children: [
        CommonText(
            text: text,
            fontSize: 12,
            color: AppColors.black_txcolor,
            fontWeight: FontWeight.bold),
        CommonText(
            text: text2,
            fontSize: 12,
            color: AppColors.black_txcolor,
            fontWeight: FontWeight.w500),
      ],
    );
  }
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}
