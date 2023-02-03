import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_date_range_picker/custom_date_range_picker.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:pachub/Utils/appcolors.dart';
import 'package:pachub/Utils/appstring.dart';
import 'package:pachub/Utils/images.dart';
import 'package:pachub/common_widget/TextField.dart';
import 'package:pachub/common_widget/appbar.dart';
import 'package:pachub/common_widget/customloader.dart';
import 'package:pachub/common_widget/textstyle.dart';
import 'package:pachub/config/preference.dart';
import 'package:pachub/models/Profile_model.dart';
import 'package:pachub/models/admin_athletes_model.dart';
import 'package:pachub/models/coach_athelete_model.dart';
import 'package:pachub/services/request.dart';
import 'package:pachub/view/Athletes/date_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:readmore/readmore.dart';
import 'package:http/http.dart' as http;

import '../../Utils/constant.dart';
import '../../app_function/MyAppFunction.dart';
import '../../common_widget/button.dart';
import '../../common_widget/nodatafound_page.dart';
import '../../models/stats_model.dart';

class Athletes extends StatefulWidget {
  const Athletes({Key? key}) : super(key: key);

  @override
  State<Athletes> createState() => _AthletesState();
}

class _AthletesState extends State<Athletes> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController userController = TextEditingController();
  TextEditingController playerController = TextEditingController();
  TextEditingController SendMessageController = TextEditingController();
  TextEditingController plyeridController = TextEditingController();
  TextEditingController approvalCommentController = TextEditingController();
  TextEditingController Search_Value_Controller = TextEditingController();
  TextEditingController dateController = TextEditingController();
  String? value;
  String? status_dropdown_value = "All";
  String? search_position_selecte_value;
  String? search_field_seletected_value;
  String? search_condition_selected_value;
  String? search_field_other_seletected_value;
  String? search_field_default_seletected_value;
  String searchString = "";
  String searchDateString = "";
  DateTime? startDate;
  DateTime? endDate;
  String? stDate;
  String? edDate;
  var athleteuserdetails = {};
  late String _localPath;
  late bool _permissionReady;
  late TargetPlatform? platform;
  String? userId;
  String? clientTrainerID;
  bool isaddtap = false;
  var counter = 0;
  List search_additional_counter_list = [];
  int index = 0;
  final List<String> itemsStatus_dropdown = [
    'All',
    'Approved',
    'Rejected',
    'Pending',
  ];
  final List<String> itemsPosition_dropdown = [
    'Pitcher',
    'In Field',
    'Out Field',
    'Catcher',
    'Universal',
  ];
  final List<String> itemsCondition_dropdown = [
    'Equals',
    'Not Equals',
    'Less Equal',
    'Greter Equal',
  ];
  final List<String> itemsField_if_Pitcher_selected_dropdown = [
    "THROWS",
    "ERA",
    "SO",
    "BB",
    "IP",
  ];
  final List<String> itemsField_if_othervalue_selected_dropdown = [
    "BATS",
    "AVG",
    "THROWS",
    "HITS",
    "SO",
    "BB",
  ];
  final List<String> itemsfield_multiple_selected_dropdown = [
    "THROWS",
    "ERA",
    "SO",
    "BB",
    "IP",
    "BATS",
    "AVG",
    "HITS",
  ];


  @override
  void dispose() {
    playerController.dispose();
    SendMessageController.dispose();
    super.dispose();
  }

  String? accessToken;
  int _page = 0;
  final int _limit = 30;
  String? dropDownValue;
  List Coach_Athleteslist = [];
  List<CoachAteleteResult> Coach_AthletesModel = [];
  bool _isFirstLoadRunning = false;
  List? trainerList;
  String? trainer;
  List athleteItemList = [];


  Future getTrainerList(String? clientID) async {
    await http.post(
      Uri.parse(AppConstant.TRAINER_USERS),
      body: {"clientID": clientID},
      headers: {"Authorization": "Bearer $accessToken"},
    ).then((response) {
      var data = json.decode(response.body);
      setState(() {
        trainerList = data['trainer'];
      });
    });
  }



  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      platform = TargetPlatform.android;
    } else {
      platform = TargetPlatform.iOS;
    }
    accessToken = PreferenceUtils.getString("accesstoken");
    userId = PreferenceUtils.getInt("userid").toString();
    getTrainerList("1");
    super.initState();
    Coach_athletes_getlist();
    manageAditionalInformationList(userId);
    getSearchByDateAthleteListApi(accessToken, _page, _limit, "2", stDate, edDate);
  }



  manageAditionalInformationList(String? userId) async {
    log('this is Manage_Profile  api call', name: "Manage_Profile");
    MyApplication.getInstance()!
        .checkConnectivity(context)
        .then((internet) async {
      if (internet != null && internet) {
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
            setState(() {
              athleteItemList = response.data["attribute"];
              print("+++++this is item ${response.data["attribute"]}");
            });
          } else {
            //setState(() => _isFirstLoadRunning = false);
          }
        } catch (e) {
          print(e);
          //setState(() => _isFirstLoadRunning = false);
        }
      } else {
        MyApplication.getInstance()!
            .showInSnackBar(AppString.no_connection, context);
      }
    });
  }
  late final Future  myFuture = getSearchByDateAthleteListApi(accessToken, _page, _limit, "2", stDate, edDate);
  late final Future  myFutureList  = getAthleteListApi(accessToken, _page, _limit, "2");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Appbar(
          text: AppString.athletesName,
          onClick: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        drawer: const Drawer(),
        body: showlistrolewise());
  }

  Widget Adminathleterole() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 45,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(top: 0),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.grey_hint_color),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {
                                searchString = value.toLowerCase();
                              });
                            },
                            onEditingComplete: () {},
                            decoration: InputDecoration(
                              contentPadding:
                              EdgeInsets.only(left: 10, bottom: 5),
                              border: InputBorder.none,
                              hintText: "Search",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Container(
                    height: 45,
                    width: 120,
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    decoration: BoxDecoration(
                      borderRadius:
                      const BorderRadius.all(Radius.circular(10.0)),
                      color: AppColors.white,
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
                        value: status_dropdown_value,
                        underline: Container(),
                        isExpanded: true,
                        //itemHeight: 50.0,
                        icon: Icon(Icons.keyboard_arrow_down,
                            size: 25, color: AppColors.grey_text_color),
                        style: TextStyle(
                            fontSize: 15.0, color: Colors.grey[700]),
                        items: itemsStatus_dropdown.map((item) {
                          return DropdownMenuItem(
                            value: item,
                            child: CommonText(
                                text: item,
                                fontSize: 13,
                                color: AppColors.black,
                                fontWeight: FontWeight.w500),
                          );
                        }).toList(),
                        hint: const CommonText(
                            text: "All",
                            fontSize: 15,
                            color: AppColors.black,
                            fontWeight: FontWeight.w500),
                        onChanged: (newValue) {
                          setState(() =>
                          status_dropdown_value = newValue);
                          if (kDebugMode) {
                            print(
                                "this is serach postion selected==> $status_dropdown_value");
                          }
                        },
                      ),
                    )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Container(
              height: 45,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(top: 0),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.grey_hint_color),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: dateController,
                      readOnly: true,
                      onTap: ()  {
                        showCustomDateRangePicker(
                          context,
                          dismissible: true,
                          minimumDate: DateTime.now().subtract(const Duration(days: 365)),
                          maximumDate: DateTime.now().add(const Duration(days: 365)),
                          endDate: endDate,
                          startDate: startDate,
                          onApplyClick: (start, end) {
                            setState(() {
                              endDate = end;
                              startDate = start;
                              dateController.text = '${startDate != null ? DateFormat("yMMMMd").format(startDate!) : '-'} to ${endDate != null ? DateFormat("yMMMMd").format(endDate!) : '-'}';
                              stDate = startDate != null ? DateFormat("yyyy-MM-dd").format(startDate!) : '-';
                              edDate = startDate != null ? DateFormat("yyyy-MM-dd").format(endDate!) : '-';
                            });
                          },
                          onCancelClick: () {
                            setState(() {
                              endDate = null;
                              startDate = null;
                              dateController.text = "";
                            });
                          },
                        );
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10, bottom: 5),
                        border: InputBorder.none,
                        hintText: "Search by date range",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          dateController.text.isEmpty ?
          FutureBuilder(
            future: myFutureList,
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
                    List<Records>? records = snapshot.data?.records;
                    if (records != null) {
                      if (status_dropdown_value == "All") {
                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(top: 5),
                          shrinkWrap: true,
                          itemCount: records.length,
                          itemBuilder: (context, index) {
                            final item = records[index];
                            DateTime joiningDate =
                            DateTime.parse(item.joiningDate.toString());
                            return item.displayName!.toLowerCase().contains(searchString) ||
                                item.subscription!.toLowerCase().contains(searchString)
                                ? Container(
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
                                        MainAxisAlignment
                                            .spaceBetween,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            children: [
                                              CommonText(
                                                  text:
                                                  "${item.displayName}",
                                                  fontSize: 15,
                                                  color: AppColors
                                                      .black_txcolor,
                                                  fontWeight:
                                                  FontWeight.bold),
                                              const SizedBox(height: 5),
                                              CommonText(
                                                  text:
                                                  "joiningDate : ${DateFormat('yMMMd').format(joiningDate)}",
                                                  fontSize: 13,
                                                  color: AppColors
                                                      .black_txcolor,
                                                  fontWeight:
                                                  FontWeight.normal),
                                              const SizedBox(height: 5),
                                              CommonText(
                                                  text:
                                                  "subscription : ${item.subscription}",
                                                  fontSize: 13,
                                                  color: AppColors
                                                      .black_txcolor,
                                                  fontWeight:
                                                  FontWeight.normal),
                                              const SizedBox(height: 5),
                                              CommonText(
                                                  text: "price: \$${item.price}",
                                                  fontSize: 13,
                                                  color: AppColors
                                                      .black_txcolor,
                                                  fontWeight:
                                                  FontWeight.normal),
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
                                                        color: item.status ==
                                                            "Pending"
                                                            ? AppColors
                                                            .orange
                                                            : item.status ==
                                                            "Rejected"
                                                            ? AppColors
                                                            .rejected
                                                            : AppColors
                                                            .approvedbackground_Color,
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            16),
                                                      ),
                                                      child: Center(
                                                        child: CommonText(
                                                          text: item
                                                              .status
                                                              .toString(),
                                                          fontSize: 10,
                                                          color: item.status ==
                                                              "Pending"
                                                              ? AppColors
                                                              .onHold
                                                              : item.status ==
                                                              "Rejected"
                                                              ? AppColors
                                                              .onHoldTextColor
                                                              : AppColors
                                                              .approvedtext_Color,
                                                          fontWeight:
                                                          FontWeight
                                                              .w400,
                                                        ),
                                                      )),
                                                  item.status == "Pending"
                                                      ? SizedBox(
                                                    width: 20,
                                                    child: item.subscription ==
                                                        "Free"
                                                        ? PopupMenuButton(
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
                                                            (value) {
                                                          if (value ==
                                                              0) {
                                                            _admin_UserDeatil("${item.userID}");
                                                          }
                                                          if (value ==
                                                              1) {
                                                            _approveRequest(
                                                                item.displayName.toString(),
                                                                item.userID,
                                                                item.subscription.toString(),
                                                                item.status.toString());
                                                          }
                                                          if (value ==
                                                              2) {
                                                            _cancelSubscriptionRequest(item.displayName.toString(),
                                                                item.userID.toString());
                                                          }
                                                        })
                                                        : PopupMenuButton(
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
                                                                  SvgPicture.asset(userPlusIcon, color: AppColors.black_txcolor),
                                                                  const SizedBox(width: 10),
                                                                  Center(
                                                                    child: CommonText(text: AppString.assignTrainer, fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w500),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            PopupMenuItem<int>(
                                                              value: 2,
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
                                                              value: 3,
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
                                                            (value) {
                                                          if (value ==
                                                              0) {
                                                            _admin_UserDeatil("${item.userID}");
                                                          }
                                                          if (value ==
                                                              1) {
                                                            _assignTrainer(item.displayName.toString(),
                                                                item.userID);
                                                          }
                                                          if (value ==
                                                              2) {
                                                            _approveRequest(
                                                                item.displayName.toString(),
                                                                item.userID,
                                                                item.subscription.toString(),
                                                                item.status.toString());
                                                          }
                                                          if (value ==
                                                              3) {
                                                            _cancelSubscriptionRequest(item.displayName.toString(),
                                                                item.userID.toString());
                                                          }
                                                        }),
                                                  )
                                                      : item.subscription ==
                                                      "Platinum" ||
                                                      item.subscription ==
                                                          "Gold"
                                                      ? Container(
                                                    width: 20,
                                                    child: PopupMenuButton(
                                                        iconSize: 18,
                                                        itemBuilder: (context) {
                                                          return [
                                                            PopupMenuItem<int>(
                                                              value: 0,
                                                              child: Row(
                                                                children: [
                                                                  SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                  const SizedBox(width: 10),
                                                                  const CommonText(text: "User Details", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                ],
                                                              ),
                                                            ),
                                                            PopupMenuItem<int>(
                                                              value: 1,
                                                              child: Row(
                                                                children: [
                                                                  SvgPicture.asset(addUserIcon, color: AppColors.black_txcolor),
                                                                  const SizedBox(width: 10),
                                                                  const CommonText(text: "Change Trainer", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                ],
                                                              ),
                                                            ),
                                                          ];
                                                        },
                                                        onSelected: (value) {
                                                          if (value ==
                                                              0) {
                                                            print("My account menu is selected.");
                                                            _admin_UserDeatil("${item.userID}");
                                                          } else if (value ==
                                                              1) {
                                                            print("Settings menu is selected.");
                                                            _changeTrainer(
                                                                "${item.displayName}",
                                                                "${item.trainerName}",
                                                                item.userID,
                                                                item.trainerID.toString());
                                                          }
                                                        }),
                                                  )
                                                      : item.subscription ==
                                                      "Free"
                                                      ? Container(
                                                    width:
                                                    20,
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
                                                                const CommonText(text: "User Details", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                              ],
                                                            ),
                                                          ),
                                                        ];
                                                      },
                                                      onSelected:
                                                          (value) {
                                                        if (value ==
                                                            0) {
                                                          print("My account menu is selected.");
                                                          _admin_UserDeatil("${item.userID}");
                                                        }
                                                      },
                                                    ),
                                                  )
                                                      : Container(
                                                    width:
                                                    20,
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
                                                                const CommonText(text: "User Details", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                              ],
                                                            ),
                                                          ),
                                                        ];
                                                      },
                                                      onSelected:
                                                          (value) {
                                                        if (value ==
                                                            0) {
                                                          print("My account menu is selected.");
                                                          _admin_UserDeatil("${item.userID}");
                                                        }
                                                      },
                                                    ),
                                                  ),
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
                            )
                                : Container();
                          },
                        );
                      } else if (status_dropdown_value == "Approved") {
                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(top: 5),
                          shrinkWrap: true,
                          itemCount: records.length,
                          itemBuilder: (context, index) {
                            final item = records[index];
                            DateTime joiningDate =
                            DateTime.parse(item.joiningDate.toString());
                            return item.displayName!
                                .toLowerCase()
                                .contains(searchString) ||
                                item.subscription!
                                    .toLowerCase()
                                    .contains(searchString)
                                ? item.status == "Approved"
                                ? Container(
                              margin: const EdgeInsets.only(
                                  bottom: 10, left: 5, right: 5),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    side:
                                    const BorderSide(width: 0.1),
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
                                        MainAxisAlignment
                                            .spaceBetween,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .start,
                                            children: [
                                              CommonText(
                                                  text:
                                                  "${item.displayName}",
                                                  fontSize: 15,
                                                  color: AppColors
                                                      .black_txcolor,
                                                  fontWeight:
                                                  FontWeight
                                                      .bold),
                                              const SizedBox(
                                                  height: 5),
                                              CommonText(
                                                  text:
                                                  "joiningDate : ${DateFormat('yMMMd').format(joiningDate)}",
                                                  fontSize: 13,
                                                  color: AppColors
                                                      .black_txcolor,
                                                  fontWeight:
                                                  FontWeight
                                                      .normal),
                                              const SizedBox(
                                                  height: 5),
                                              CommonText(
                                                  text:
                                                  "subscription : ${item.subscription}",
                                                  fontSize: 13,
                                                  color: AppColors
                                                      .black_txcolor,
                                                  fontWeight:
                                                  FontWeight
                                                      .normal),
                                              const SizedBox(
                                                  height: 5),
                                              CommonText(
                                                  text:
                                                  "price: \$${item.price}",
                                                  fontSize: 13,
                                                  color: AppColors
                                                      .black_txcolor,
                                                  fontWeight:
                                                  FontWeight
                                                      .normal),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .start,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                      height: 20,
                                                      width: 64.52,
                                                      decoration:
                                                      BoxDecoration(
                                                        color: item.status ==
                                                            "Pending"
                                                            ? AppColors
                                                            .orange
                                                            : item.status ==
                                                            "Rejected"
                                                            ? AppColors
                                                            .rejected
                                                            : AppColors
                                                            .approvedbackground_Color,
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            16),
                                                      ),
                                                      child: Center(
                                                        child:
                                                        CommonText(
                                                          text: item
                                                              .status
                                                              .toString(),
                                                          fontSize:
                                                          10,
                                                          color: item.status ==
                                                              "Pending"
                                                              ? AppColors
                                                              .onHold
                                                              : item.status ==
                                                              "Rejected"
                                                              ? AppColors.onHoldTextColor
                                                              : AppColors.approvedtext_Color,
                                                          fontWeight:
                                                          FontWeight
                                                              .w400,
                                                        ),
                                                      )),
                                                  item.status ==
                                                      "Pending"
                                                      ? SizedBox(
                                                    width: 20,
                                                    child: item.subscription ==
                                                        "Free"
                                                        ? PopupMenuButton(
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
                                                            (value) {
                                                          if (value == 0) {
                                                            _admin_UserDeatil("${item.userID}");
                                                          }
                                                          if (value == 1) {
                                                            _approveRequest(item.displayName.toString(), item.userID, item.subscription.toString(), item.status.toString());
                                                          }
                                                          if (value == 2) {
                                                            _cancelSubscriptionRequest(item.displayName.toString(), item.userID.toString());
                                                          }
                                                        })
                                                        : PopupMenuButton(
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
                                                                  SvgPicture.asset(userPlusIcon, color: AppColors.black_txcolor),
                                                                  const SizedBox(width: 10),
                                                                  Center(
                                                                    child: CommonText(text: AppString.assignTrainer, fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w500),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            PopupMenuItem<int>(
                                                              value: 2,
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
                                                              value: 3,
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
                                                            (value) {
                                                          if (value == 0) {
                                                            _admin_UserDeatil("${item.userID}");
                                                          }
                                                          if (value == 1) {
                                                            _assignTrainer(item.displayName.toString(), item.userID);
                                                          }
                                                          if (value == 2) {
                                                            _approveRequest(item.displayName.toString(), item.userID, item.subscription.toString(), item.status.toString());
                                                          }
                                                          if (value == 3) {
                                                            _cancelSubscriptionRequest(item.displayName.toString(), item.userID.toString());
                                                          }
                                                        }),
                                                  )
                                                      : item.subscription ==
                                                      "Platinum" ||
                                                      item.subscription ==
                                                          "Gold"
                                                      ? Container(
                                                    width:
                                                    20,
                                                    child: PopupMenuButton(
                                                        iconSize: 18,
                                                        itemBuilder: (context) {
                                                          return [
                                                            PopupMenuItem<int>(
                                                              value: 0,
                                                              child: Row(
                                                                children: [
                                                                  SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                  const SizedBox(width: 10),
                                                                  const CommonText(text: "User Details", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                ],
                                                              ),
                                                            ),
                                                            PopupMenuItem<int>(
                                                              value: 1,
                                                              child: Row(
                                                                children: [
                                                                  SvgPicture.asset(addUserIcon, color: AppColors.black_txcolor),
                                                                  const SizedBox(width: 10),
                                                                  const CommonText(text: "Change Trainer", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                ],
                                                              ),
                                                            ),
                                                          ];
                                                        },
                                                        onSelected: (value) {
                                                          if (value == 0) {
                                                            print("My account menu is selected.");
                                                            _admin_UserDeatil("${item.userID}");
                                                          } else if (value == 1) {
                                                            print("Settings menu is selected.");
                                                            _changeTrainer("${item.displayName}", "${item.trainerName}", item.userID, item.trainerID.toString());
                                                          }
                                                        }),
                                                  )
                                                      : item.subscription ==
                                                      "Free"
                                                      ? Container(
                                                    width:
                                                    20,
                                                    child:
                                                    PopupMenuButton(
                                                      iconSize: 18,
                                                      itemBuilder: (context) {
                                                        return [
                                                          PopupMenuItem<int>(
                                                            value: 0,
                                                            child: Row(
                                                              children: [
                                                                SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                const SizedBox(width: 10),
                                                                const CommonText(text: "User Details", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                              ],
                                                            ),
                                                          ),
                                                        ];
                                                      },
                                                      onSelected: (value) {
                                                        if (value == 0) {
                                                          print("My account menu is selected.");
                                                          _admin_UserDeatil("${item.userID}");
                                                        }
                                                      },
                                                    ),
                                                  )
                                                      : Container(
                                                    width:
                                                    20,
                                                    child:
                                                    PopupMenuButton(
                                                      iconSize: 18,
                                                      itemBuilder: (context) {
                                                        return [
                                                          PopupMenuItem<int>(
                                                            value: 0,
                                                            child: Row(
                                                              children: [
                                                                SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                const SizedBox(width: 10),
                                                                const CommonText(text: "User Details", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                              ],
                                                            ),
                                                          ),
                                                        ];
                                                      },
                                                      onSelected: (value) {
                                                        if (value == 0) {
                                                          print("My account menu is selected.");
                                                          _admin_UserDeatil("${item.userID}");
                                                        }
                                                      },
                                                    ),
                                                  ),
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
                            )
                                : Container()
                                : Container();
                          },
                        );
                      } else if (status_dropdown_value == "Rejected") {
                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(top: 5),
                          shrinkWrap: true,
                          itemCount: records.length,
                          itemBuilder: (context, index) {
                            final item = records[index];
                            DateTime joiningDate =
                            DateTime.parse(item.joiningDate.toString());
                            return item.displayName!
                                .toLowerCase()
                                .contains(searchString) ||
                                item.subscription!
                                    .toLowerCase()
                                    .contains(searchString)
                                ? item.status == "Rejected"
                                ? Container(
                              margin: const EdgeInsets.only(
                                  bottom: 10, left: 5, right: 5),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    side:
                                    const BorderSide(width: 0.1),
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
                                        MainAxisAlignment
                                            .spaceBetween,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .start,
                                            children: [
                                              CommonText(
                                                  text:
                                                  "${item.displayName}",
                                                  fontSize: 15,
                                                  color: AppColors
                                                      .black_txcolor,
                                                  fontWeight:
                                                  FontWeight
                                                      .bold),
                                              const SizedBox(
                                                  height: 5),
                                              CommonText(
                                                  text:
                                                  "joiningDate : ${DateFormat('yMMMd').format(joiningDate)}",
                                                  fontSize: 13,
                                                  color: AppColors
                                                      .black_txcolor,
                                                  fontWeight:
                                                  FontWeight
                                                      .normal),
                                              const SizedBox(
                                                  height: 5),
                                              CommonText(
                                                  text:
                                                  "subscription : ${item.subscription}",
                                                  fontSize: 13,
                                                  color: AppColors
                                                      .black_txcolor,
                                                  fontWeight:
                                                  FontWeight
                                                      .normal),
                                              const SizedBox(
                                                  height: 5),
                                              CommonText(
                                                  text:
                                                  "price: \$${item.price}",
                                                  fontSize: 13,
                                                  color: AppColors
                                                      .black_txcolor,
                                                  fontWeight:
                                                  FontWeight
                                                      .normal),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .start,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                      height: 20,
                                                      width: 64.52,
                                                      decoration:
                                                      BoxDecoration(
                                                        color: item.status ==
                                                            "Pending"
                                                            ? AppColors
                                                            .orange
                                                            : item.status ==
                                                            "Rejected"
                                                            ? AppColors
                                                            .rejected
                                                            : AppColors
                                                            .approvedbackground_Color,
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            16),
                                                      ),
                                                      child: Center(
                                                        child:
                                                        CommonText(
                                                          text: item
                                                              .status
                                                              .toString(),
                                                          fontSize:
                                                          10,
                                                          color: item.status ==
                                                              "Pending"
                                                              ? AppColors
                                                              .onHold
                                                              : item.status ==
                                                              "Rejected"
                                                              ? AppColors.onHoldTextColor
                                                              : AppColors.approvedtext_Color,
                                                          fontWeight:
                                                          FontWeight
                                                              .w400,
                                                        ),
                                                      )),
                                                  item.status ==
                                                      "Pending"
                                                      ? SizedBox(
                                                    width: 20,
                                                    child: item.subscription ==
                                                        "Free"
                                                        ? PopupMenuButton(
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
                                                            (value) {
                                                          if (value == 0) {
                                                            _admin_UserDeatil("${item.userID}");
                                                          }
                                                          if (value == 1) {
                                                            _approveRequest(item.displayName.toString(), item.userID, item.subscription.toString(), item.status.toString());
                                                          }
                                                          if (value == 2) {
                                                            _cancelSubscriptionRequest(item.displayName.toString(), item.userID.toString());
                                                          }
                                                        })
                                                        : PopupMenuButton(
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
                                                                  SvgPicture.asset(userPlusIcon, color: AppColors.black_txcolor),
                                                                  const SizedBox(width: 10),
                                                                  Center(
                                                                    child: CommonText(text: AppString.assignTrainer, fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w500),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            PopupMenuItem<int>(
                                                              value: 2,
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
                                                              value: 3,
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
                                                            (value) {
                                                          if (value == 0) {
                                                            _admin_UserDeatil("${item.userID}");
                                                          }
                                                          if (value == 1) {
                                                            _assignTrainer(item.displayName.toString(), item.userID);
                                                          }
                                                          if (value == 2) {
                                                            _approveRequest(item.displayName.toString(), item.userID, item.subscription.toString(), item.status.toString());
                                                          }
                                                          if (value == 3) {
                                                            _cancelSubscriptionRequest(item.displayName.toString(), item.userID.toString());
                                                          }
                                                        }),
                                                  )
                                                      : item.subscription ==
                                                      "Platinum" ||
                                                      item.subscription ==
                                                          "Gold"
                                                      ? Container(
                                                    width:
                                                    20,
                                                    child: PopupMenuButton(
                                                        iconSize: 18,
                                                        itemBuilder: (context) {
                                                          return [
                                                            PopupMenuItem<int>(
                                                              value: 0,
                                                              child: Row(
                                                                children: [
                                                                  SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                  const SizedBox(width: 10),
                                                                  const CommonText(text: "User Details", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                ],
                                                              ),
                                                            ),
                                                            PopupMenuItem<int>(
                                                              value: 1,
                                                              child: Row(
                                                                children: [
                                                                  SvgPicture.asset(addUserIcon, color: AppColors.black_txcolor),
                                                                  const SizedBox(width: 10),
                                                                  const CommonText(text: "Change Trainer", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                ],
                                                              ),
                                                            ),
                                                          ];
                                                        },
                                                        onSelected: (value) {
                                                          if (value == 0) {
                                                            print("My account menu is selected.");
                                                            _admin_UserDeatil("${item.userID}");
                                                          } else if (value == 1) {
                                                            print("Settings menu is selected.");
                                                            _changeTrainer("${item.displayName}", "${item.trainerName}", item.userID, item.trainerID.toString());
                                                          }
                                                        }),
                                                  )
                                                      : item.subscription ==
                                                      "Free"
                                                      ? Container(
                                                    width:
                                                    20,
                                                    child:
                                                    PopupMenuButton(
                                                      iconSize: 18,
                                                      itemBuilder: (context) {
                                                        return [
                                                          PopupMenuItem<int>(
                                                            value: 0,
                                                            child: Row(
                                                              children: [
                                                                SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                const SizedBox(width: 10),
                                                                const CommonText(text: "User Details", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                              ],
                                                            ),
                                                          ),
                                                        ];
                                                      },
                                                      onSelected: (value) {
                                                        if (value == 0) {
                                                          print("My account menu is selected.");
                                                          _admin_UserDeatil("${item.userID}");
                                                        }
                                                      },
                                                    ),
                                                  )
                                                      : Container(
                                                    width:
                                                    20,
                                                    child:
                                                    PopupMenuButton(
                                                      iconSize: 18,
                                                      itemBuilder: (context) {
                                                        return [
                                                          PopupMenuItem<int>(
                                                            value: 0,
                                                            child: Row(
                                                              children: [
                                                                SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                const SizedBox(width: 10),
                                                                const CommonText(text: "User Details", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                              ],
                                                            ),
                                                          ),
                                                        ];
                                                      },
                                                      onSelected: (value) {
                                                        if (value == 0) {
                                                          print("My account menu is selected.");
                                                          _admin_UserDeatil("${item.userID}");
                                                        }
                                                      },
                                                    ),
                                                  ),
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
                            )
                                : Container()
                                : Container();
                          },
                        );
                      } else if (status_dropdown_value == "Pending") {
                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(top: 5),
                          shrinkWrap: true,
                          itemCount: records.length,
                          itemBuilder: (context, index) {
                            final item = records[index];
                            DateTime joiningDate =
                            DateTime.parse(item.joiningDate.toString());
                            return item.displayName!
                                .toLowerCase()
                                .contains(searchString) ||
                                item.subscription!
                                    .toLowerCase()
                                    .contains(searchString)
                                ? item.status == "Pending"
                                ? Container(
                              margin: const EdgeInsets.only(
                                  bottom: 10, left: 5, right: 5),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    side:
                                    const BorderSide(width: 0.1),
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
                                        MainAxisAlignment
                                            .spaceBetween,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .start,
                                            children: [
                                              CommonText(
                                                  text:
                                                  "${item.displayName}",
                                                  fontSize: 15,
                                                  color: AppColors
                                                      .black_txcolor,
                                                  fontWeight:
                                                  FontWeight
                                                      .bold),
                                              const SizedBox(
                                                  height: 5),
                                              CommonText(
                                                  text:
                                                  "joiningDate : ${DateFormat('yMMMd').format(joiningDate)}",
                                                  fontSize: 13,
                                                  color: AppColors
                                                      .black_txcolor,
                                                  fontWeight:
                                                  FontWeight
                                                      .normal),
                                              const SizedBox(
                                                  height: 5),
                                              CommonText(
                                                  text:
                                                  "subscription : ${item.subscription}",
                                                  fontSize: 13,
                                                  color: AppColors
                                                      .black_txcolor,
                                                  fontWeight:
                                                  FontWeight
                                                      .normal),
                                              const SizedBox(
                                                  height: 5),
                                              CommonText(
                                                  text:
                                                  "price: \$${item.price}",
                                                  fontSize: 13,
                                                  color: AppColors
                                                      .black_txcolor,
                                                  fontWeight:
                                                  FontWeight
                                                      .normal),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .start,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                      height: 20,
                                                      width: 64.52,
                                                      decoration:
                                                      BoxDecoration(
                                                        color: item.status ==
                                                            "Pending"
                                                            ? AppColors
                                                            .orange
                                                            : item.status ==
                                                            "Rejected"
                                                            ? AppColors
                                                            .rejected
                                                            : AppColors
                                                            .approvedbackground_Color,
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            16),
                                                      ),
                                                      child: Center(
                                                        child:
                                                        CommonText(
                                                          text: item
                                                              .status
                                                              .toString(),
                                                          fontSize:
                                                          10,
                                                          color: item.status ==
                                                              "Pending"
                                                              ? AppColors
                                                              .onHold
                                                              : item.status ==
                                                              "Rejected"
                                                              ? AppColors.onHoldTextColor
                                                              : AppColors.approvedtext_Color,
                                                          fontWeight:
                                                          FontWeight
                                                              .w400,
                                                        ),
                                                      )),
                                                  item.status ==
                                                      "Pending"
                                                      ? SizedBox(
                                                    width: 20,
                                                    child: item.subscription ==
                                                        "Free"
                                                        ? PopupMenuButton(
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
                                                            (value) {
                                                          if (value == 0) {
                                                            _admin_UserDeatil("${item.userID}");
                                                          }
                                                          if (value == 1) {
                                                            _approveRequest(item.displayName.toString(), item.userID, item.subscription.toString(), item.status.toString());
                                                          }
                                                          if (value == 2) {
                                                            _cancelSubscriptionRequest(item.displayName.toString(), item.userID.toString());
                                                          }
                                                        })
                                                        : PopupMenuButton(
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
                                                                  SvgPicture.asset(userPlusIcon, color: AppColors.black_txcolor),
                                                                  const SizedBox(width: 10),
                                                                  Center(
                                                                    child: CommonText(text: AppString.assignTrainer, fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w500),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            PopupMenuItem<int>(
                                                              value: 2,
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
                                                              value: 3,
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
                                                            (value) {
                                                          if (value == 0) {
                                                            _admin_UserDeatil("${item.userID}");
                                                          }
                                                          if (value == 1) {
                                                            _assignTrainer(item.displayName.toString(), item.userID);
                                                          }
                                                          if (value == 2) {
                                                            _approveRequest(item.displayName.toString(), item.userID, item.subscription.toString(), item.status.toString());
                                                          }
                                                          if (value == 3) {
                                                            _cancelSubscriptionRequest(item.displayName.toString(), item.userID.toString());
                                                          }
                                                        }),
                                                  )
                                                      : item.subscription ==
                                                      "Platinum" ||
                                                      item.subscription ==
                                                          "Gold"
                                                      ? Container(
                                                    width:
                                                    20,
                                                    child: PopupMenuButton(
                                                        iconSize: 18,
                                                        itemBuilder: (context) {
                                                          return [
                                                            PopupMenuItem<int>(
                                                              value: 0,
                                                              child: Row(
                                                                children: [
                                                                  SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                  const SizedBox(width: 10),
                                                                  const CommonText(text: "User Details", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                ],
                                                              ),
                                                            ),
                                                            PopupMenuItem<int>(
                                                              value: 1,
                                                              child: Row(
                                                                children: [
                                                                  SvgPicture.asset(addUserIcon, color: AppColors.black_txcolor),
                                                                  const SizedBox(width: 10),
                                                                  const CommonText(text: "Change Trainer", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                ],
                                                              ),
                                                            ),
                                                          ];
                                                        },
                                                        onSelected: (value) {
                                                          if (value == 0) {
                                                            print("My account menu is selected.");
                                                            _admin_UserDeatil("${item.userID}");
                                                          } else if (value == 1) {
                                                            print("Settings menu is selected.");
                                                            _changeTrainer("${item.displayName}", "${item.trainerName}", item.userID, item.trainerID.toString());
                                                          }
                                                        }),
                                                  )
                                                      : item.subscription ==
                                                      "Free"
                                                      ? Container(
                                                    width:
                                                    20,
                                                    child:
                                                    PopupMenuButton(
                                                      iconSize: 18,
                                                      itemBuilder: (context) {
                                                        return [
                                                          PopupMenuItem<int>(
                                                            value: 0,
                                                            child: Row(
                                                              children: [
                                                                SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                const SizedBox(width: 10),
                                                                const CommonText(text: "User Details", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                              ],
                                                            ),
                                                          ),
                                                        ];
                                                      },
                                                      onSelected: (value) {
                                                        if (value == 0) {
                                                          print("My account menu is selected.");
                                                          _admin_UserDeatil("${item.userID}");
                                                        }
                                                      },
                                                    ),
                                                  )
                                                      : Container(
                                                    width:
                                                    20,
                                                    child:
                                                    PopupMenuButton(
                                                      iconSize: 18,
                                                      itemBuilder: (context) {
                                                        return [
                                                          PopupMenuItem<int>(
                                                            value: 0,
                                                            child: Row(
                                                              children: [
                                                                SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                const SizedBox(width: 10),
                                                                const CommonText(text: "User Details", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                              ],
                                                            ),
                                                          ),
                                                        ];
                                                      },
                                                      onSelected: (value) {
                                                        if (value == 0) {
                                                          print("My account menu is selected.");
                                                          _admin_UserDeatil("${item.userID}");
                                                        }
                                                      },
                                                    ),
                                                  ),
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
                            )
                                : Container()
                                : Container();
                          },
                        );
                      }
                    }
                  } else {
                    return const Center(
                      child: NoDataFound(),
                    );
                  }
              }
              return const Center(
                child: NoDataFound(),
              );;
            },
          ):
          FutureBuilder(
            future: myFuture,
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
                    List<Records>? records = snapshot.data?.records;
                    if (records != null) {
                      if (status_dropdown_value == "All") {
                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(top: 5),
                          shrinkWrap: true,
                          itemCount: records.length,
                          itemBuilder: (context, index) {
                            final item = records[index];
                            DateTime joiningDate = DateTime.parse(item.joiningDate.toString());
                            return item.displayName!.toLowerCase().contains(searchString) ||
                                item.subscription!.toLowerCase().contains(searchString)
                                ? Container(
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
                                        MainAxisAlignment
                                            .spaceBetween,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            children: [
                                              CommonText(
                                                  text:
                                                  "${item.displayName}",
                                                  fontSize: 15,
                                                  color: AppColors
                                                      .black_txcolor,
                                                  fontWeight:
                                                  FontWeight.bold),
                                              const SizedBox(height: 5),
                                              CommonText(
                                                  text:
                                                  "joiningDate : ${DateFormat('yMMMd').format(joiningDate)}",
                                                  fontSize: 13,
                                                  color: AppColors
                                                      .black_txcolor,
                                                  fontWeight:
                                                  FontWeight.normal),
                                              const SizedBox(height: 5),
                                              CommonText(
                                                  text:
                                                  "subscription : ${item.subscription}",
                                                  fontSize: 13,
                                                  color: AppColors
                                                      .black_txcolor,
                                                  fontWeight:
                                                  FontWeight.normal),
                                              const SizedBox(height: 5),
                                              CommonText(
                                                  text: "price: \$${item.price}",
                                                  fontSize: 13,
                                                  color: AppColors
                                                      .black_txcolor,
                                                  fontWeight:
                                                  FontWeight.normal),
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
                                                        color: item.status ==
                                                            "Pending"
                                                            ? AppColors
                                                            .orange
                                                            : item.status ==
                                                            "Rejected"
                                                            ? AppColors
                                                            .rejected
                                                            : AppColors
                                                            .approvedbackground_Color,
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            16),
                                                      ),
                                                      child: Center(
                                                        child: CommonText(
                                                          text: item
                                                              .status
                                                              .toString(),
                                                          fontSize: 10,
                                                          color: item.status ==
                                                              "Pending"
                                                              ? AppColors
                                                              .onHold
                                                              : item.status ==
                                                              "Rejected"
                                                              ? AppColors
                                                              .onHoldTextColor
                                                              : AppColors
                                                              .approvedtext_Color,
                                                          fontWeight:
                                                          FontWeight
                                                              .w400,
                                                        ),
                                                      )),
                                                  item.status == "Pending"
                                                      ? SizedBox(
                                                    width: 20,
                                                    child: item.subscription ==
                                                        "Free"
                                                        ? PopupMenuButton(
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
                                                        onSelected: (value) {
                                                          if (value == 0) {
                                                            _admin_UserDeatil("${item.userID}");
                                                          }
                                                          if (value == 1) {
                                                            _approveRequest(
                                                                item.displayName.toString(),
                                                                item.userID,
                                                                item.subscription.toString(),
                                                                item.status.toString());
                                                          }
                                                          if (value == 2) {
                                                            _cancelSubscriptionRequest(item.displayName.toString(),
                                                                item.userID.toString());
                                                          }
                                                        })
                                                        : PopupMenuButton(
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
                                                                  SvgPicture.asset(userPlusIcon, color: AppColors.black_txcolor),
                                                                  const SizedBox(width: 10),
                                                                  Center(
                                                                    child: CommonText(text: AppString.assignTrainer, fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w500),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            PopupMenuItem<int>(
                                                              value: 2,
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
                                                              value: 3,
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
                                                        onSelected: (value) {
                                                          if (value == 0) {
                                                            _admin_UserDeatil("${item.userID}");
                                                          }
                                                          if (value == 1) {
                                                            _assignTrainer(item.displayName.toString(), item.userID);
                                                          }
                                                          if (value == 2) {
                                                            _approveRequest(item.displayName.toString(),
                                                                item.userID,
                                                                item.subscription.toString(),
                                                                item.status.toString());
                                                          }
                                                          if (value == 3) {
                                                            _cancelSubscriptionRequest(item.displayName.toString(),
                                                                item.userID.toString());
                                                          }
                                                        }),
                                                  )
                                                      : item.subscription ==
                                                      "Platinum" ||
                                                      item.subscription ==
                                                          "Gold"
                                                      ? Container(
                                                    width: 20,
                                                    child: PopupMenuButton(
                                                        iconSize: 18,
                                                        itemBuilder: (context) {
                                                          return [
                                                            PopupMenuItem<int>(
                                                              value: 0,
                                                              child: Row(
                                                                children: [
                                                                  SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                  const SizedBox(width: 10),
                                                                  const CommonText(text: "User Details", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                ],
                                                              ),
                                                            ),
                                                            PopupMenuItem<int>(
                                                              value: 1,
                                                              child: Row(
                                                                children: [
                                                                  SvgPicture.asset(addUserIcon, color: AppColors.black_txcolor),
                                                                  const SizedBox(width: 10),
                                                                  const CommonText(text: "Change Trainer", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                ],
                                                              ),
                                                            ),
                                                          ];
                                                        },
                                                        onSelected: (value) {
                                                          if (value == 0) {
                                                            print("My account menu is selected.");
                                                            _admin_UserDeatil("${item.userID}");
                                                          } else if (value == 1) {
                                                            print("Settings menu is selected.");
                                                            _changeTrainer(
                                                                "${item.displayName}",
                                                                "${item.trainerName}",
                                                                item.userID,
                                                                item.trainerID.toString());
                                                          }
                                                        }),
                                                  )
                                                      : item.subscription == "Free"
                                                      ? Container(
                                                    width:
                                                    20,
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
                                                                const CommonText(text: "User Details", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                              ],
                                                            ),
                                                          ),
                                                        ];
                                                      },
                                                      onSelected: (value) {
                                                        if (value == 0) {
                                                          print("My account menu is selected.");
                                                          _admin_UserDeatil("${item.userID}");
                                                        }
                                                      },
                                                    ),
                                                  )
                                                      : Container(
                                                    width:
                                                    20,
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
                                                                const CommonText(text: "User Details", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                              ],
                                                            ),
                                                          ),
                                                        ];
                                                      },
                                                      onSelected: (value) {
                                                        if (value == 0) {
                                                          print("My account menu is selected.");
                                                          _admin_UserDeatil("${item.userID}");
                                                        }
                                                      },
                                                    ),
                                                  ),
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
                            )
                                : Container();
                          },
                        );
                      } else if (status_dropdown_value == "Approved") {
                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(top: 5),
                          shrinkWrap: true,
                          itemCount: records.length,
                          itemBuilder: (context, index) {
                            final item = records[index];
                            DateTime joiningDate =
                            DateTime.parse(item.joiningDate.toString());
                            return item.displayName!
                                .toLowerCase()
                                .contains(searchString) ||
                                item.subscription!
                                    .toLowerCase()
                                    .contains(searchString)
                                ? item.status == "Approved"
                                ? Container(
                              margin: const EdgeInsets.only(
                                  bottom: 10, left: 5, right: 5),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    side:
                                    const BorderSide(width: 0.1),
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
                                        MainAxisAlignment
                                            .spaceBetween,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .start,
                                            children: [
                                              CommonText(
                                                  text:
                                                  "${item.displayName}",
                                                  fontSize: 15,
                                                  color: AppColors
                                                      .black_txcolor,
                                                  fontWeight:
                                                  FontWeight
                                                      .bold),
                                              const SizedBox(
                                                  height: 5),
                                              CommonText(
                                                  text:
                                                  "joiningDate : ${DateFormat('yMMMd').format(joiningDate)}",
                                                  fontSize: 13,
                                                  color: AppColors
                                                      .black_txcolor,
                                                  fontWeight:
                                                  FontWeight
                                                      .normal),
                                              const SizedBox(
                                                  height: 5),
                                              CommonText(
                                                  text:
                                                  "subscription : ${item.subscription}",
                                                  fontSize: 13,
                                                  color: AppColors
                                                      .black_txcolor,
                                                  fontWeight:
                                                  FontWeight
                                                      .normal),
                                              const SizedBox(
                                                  height: 5),
                                              CommonText(
                                                  text:
                                                  "price: \$${item.price}",
                                                  fontSize: 13,
                                                  color: AppColors
                                                      .black_txcolor,
                                                  fontWeight:
                                                  FontWeight
                                                      .normal),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .start,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                      height: 20,
                                                      width: 64.52,
                                                      decoration:
                                                      BoxDecoration(
                                                        color: item.status ==
                                                            "Pending"
                                                            ? AppColors
                                                            .orange
                                                            : item.status ==
                                                            "Rejected"
                                                            ? AppColors
                                                            .rejected
                                                            : AppColors
                                                            .approvedbackground_Color,
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            16),
                                                      ),
                                                      child: Center(
                                                        child:
                                                        CommonText(
                                                          text: item
                                                              .status
                                                              .toString(),
                                                          fontSize:
                                                          10,
                                                          color: item.status ==
                                                              "Pending"
                                                              ? AppColors
                                                              .onHold
                                                              : item.status ==
                                                              "Rejected"
                                                              ? AppColors.onHoldTextColor
                                                              : AppColors.approvedtext_Color,
                                                          fontWeight:
                                                          FontWeight
                                                              .w400,
                                                        ),
                                                      )),
                                                  item.status ==
                                                      "Pending"
                                                      ? SizedBox(
                                                    width: 20,
                                                    child: item.subscription ==
                                                        "Free"
                                                        ? PopupMenuButton(
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
                                                            (value) {
                                                          if (value == 0) {
                                                            _admin_UserDeatil("${item.userID}");
                                                          }
                                                          if (value == 1) {
                                                            _approveRequest(item.displayName.toString(), item.userID, item.subscription.toString(), item.status.toString());
                                                          }
                                                          if (value == 2) {
                                                            _cancelSubscriptionRequest(item.displayName.toString(), item.userID.toString());
                                                          }
                                                        })
                                                        : PopupMenuButton(
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
                                                                  SvgPicture.asset(userPlusIcon, color: AppColors.black_txcolor),
                                                                  const SizedBox(width: 10),
                                                                  Center(
                                                                    child: CommonText(text: AppString.assignTrainer, fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w500),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            PopupMenuItem<int>(
                                                              value: 2,
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
                                                              value: 3,
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
                                                            (value) {
                                                          if (value == 0) {
                                                            _admin_UserDeatil("${item.userID}");
                                                          }
                                                          if (value == 1) {
                                                            _assignTrainer(item.displayName.toString(), item.userID);
                                                          }
                                                          if (value == 2) {
                                                            _approveRequest(item.displayName.toString(), item.userID, item.subscription.toString(), item.status.toString());
                                                          }
                                                          if (value == 3) {
                                                            _cancelSubscriptionRequest(item.displayName.toString(), item.userID.toString());
                                                          }
                                                        }),
                                                  )
                                                      : item.subscription ==
                                                      "Platinum" ||
                                                      item.subscription ==
                                                          "Gold"
                                                      ? Container(
                                                    width:
                                                    20,
                                                    child: PopupMenuButton(
                                                        iconSize: 18,
                                                        itemBuilder: (context) {
                                                          return [
                                                            PopupMenuItem<int>(
                                                              value: 0,
                                                              child: Row(
                                                                children: [
                                                                  SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                  const SizedBox(width: 10),
                                                                  const CommonText(text: "User Details", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                ],
                                                              ),
                                                            ),
                                                            PopupMenuItem<int>(
                                                              value: 1,
                                                              child: Row(
                                                                children: [
                                                                  SvgPicture.asset(addUserIcon, color: AppColors.black_txcolor),
                                                                  const SizedBox(width: 10),
                                                                  const CommonText(text: "Change Trainer", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                ],
                                                              ),
                                                            ),
                                                          ];
                                                        },
                                                        onSelected: (value) {
                                                          if (value == 0) {
                                                            print("My account menu is selected.");
                                                            _admin_UserDeatil("${item.userID}");
                                                          } else if (value == 1) {
                                                            print("Settings menu is selected.");
                                                            _changeTrainer("${item.displayName}", "${item.trainerName}", item.userID, item.trainerID.toString());
                                                          }
                                                        }),
                                                  )
                                                      : item.subscription ==
                                                      "Free"
                                                      ? Container(
                                                    width:
                                                    20,
                                                    child:
                                                    PopupMenuButton(
                                                      iconSize: 18,
                                                      itemBuilder: (context) {
                                                        return [
                                                          PopupMenuItem<int>(
                                                            value: 0,
                                                            child: Row(
                                                              children: [
                                                                SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                const SizedBox(width: 10),
                                                                const CommonText(text: "User Details", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                              ],
                                                            ),
                                                          ),
                                                        ];
                                                      },
                                                      onSelected: (value) {
                                                        if (value == 0) {
                                                          print("My account menu is selected.");
                                                          _admin_UserDeatil("${item.userID}");
                                                        }
                                                      },
                                                    ),
                                                  )
                                                      : Container(
                                                    width:
                                                    20,
                                                    child:
                                                    PopupMenuButton(
                                                      iconSize: 18,
                                                      itemBuilder: (context) {
                                                        return [
                                                          PopupMenuItem<int>(
                                                            value: 0,
                                                            child: Row(
                                                              children: [
                                                                SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                const SizedBox(width: 10),
                                                                const CommonText(text: "User Details", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                              ],
                                                            ),
                                                          ),
                                                        ];
                                                      },
                                                      onSelected: (value) {
                                                        if (value == 0) {
                                                          print("My account menu is selected.");
                                                          _admin_UserDeatil("${item.userID}");
                                                        }
                                                      },
                                                    ),
                                                  ),
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
                            )
                                : Container()
                                : Container();
                          },
                        );
                      } else if (status_dropdown_value == "Rejected") {
                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(top: 5),
                          shrinkWrap: true,
                          itemCount: records.length,
                          itemBuilder: (context, index) {
                            final item = records[index];
                            DateTime joiningDate =
                            DateTime.parse(item.joiningDate.toString());
                            return item.displayName!
                                .toLowerCase()
                                .contains(searchString) ||
                                item.subscription!
                                    .toLowerCase()
                                    .contains(searchString)
                                ? item.status == "Rejected"
                                ? Container(
                              margin: const EdgeInsets.only(
                                  bottom: 10, left: 5, right: 5),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    side:
                                    const BorderSide(width: 0.1),
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
                                        MainAxisAlignment
                                            .spaceBetween,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .start,
                                            children: [
                                              CommonText(
                                                  text:
                                                  "${item.displayName}",
                                                  fontSize: 15,
                                                  color: AppColors
                                                      .black_txcolor,
                                                  fontWeight:
                                                  FontWeight
                                                      .bold),
                                              const SizedBox(
                                                  height: 5),
                                              CommonText(
                                                  text:
                                                  "joiningDate : ${DateFormat('yMMMd').format(joiningDate)}",
                                                  fontSize: 13,
                                                  color: AppColors
                                                      .black_txcolor,
                                                  fontWeight:
                                                  FontWeight
                                                      .normal),
                                              const SizedBox(
                                                  height: 5),
                                              CommonText(
                                                  text:
                                                  "subscription : ${item.subscription}",
                                                  fontSize: 13,
                                                  color: AppColors
                                                      .black_txcolor,
                                                  fontWeight:
                                                  FontWeight
                                                      .normal),
                                              const SizedBox(
                                                  height: 5),
                                              CommonText(
                                                  text:
                                                  "price: \$${item.price}",
                                                  fontSize: 13,
                                                  color: AppColors
                                                      .black_txcolor,
                                                  fontWeight:
                                                  FontWeight
                                                      .normal),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .start,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                      height: 20,
                                                      width: 64.52,
                                                      decoration:
                                                      BoxDecoration(
                                                        color: item.status ==
                                                            "Pending"
                                                            ? AppColors
                                                            .orange
                                                            : item.status ==
                                                            "Rejected"
                                                            ? AppColors
                                                            .rejected
                                                            : AppColors
                                                            .approvedbackground_Color,
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            16),
                                                      ),
                                                      child: Center(
                                                        child:
                                                        CommonText(
                                                          text: item
                                                              .status
                                                              .toString(),
                                                          fontSize:
                                                          10,
                                                          color: item.status ==
                                                              "Pending"
                                                              ? AppColors
                                                              .onHold
                                                              : item.status ==
                                                              "Rejected"
                                                              ? AppColors.onHoldTextColor
                                                              : AppColors.approvedtext_Color,
                                                          fontWeight:
                                                          FontWeight
                                                              .w400,
                                                        ),
                                                      )),
                                                  item.status == "Pending"
                                                      ? SizedBox(
                                                    width: 20,
                                                    child: item.subscription ==
                                                        "Free"
                                                        ? PopupMenuButton(
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
                                                            (value) {
                                                          if (value == 0) {
                                                            _admin_UserDeatil("${item.userID}");
                                                          }
                                                          if (value == 1) {
                                                            _approveRequest(item.displayName.toString(), item.userID, item.subscription.toString(), item.status.toString());
                                                          }
                                                          if (value == 2) {
                                                            _cancelSubscriptionRequest(item.displayName.toString(), item.userID.toString());
                                                          }
                                                        })
                                                        : PopupMenuButton(
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
                                                                  SvgPicture.asset(userPlusIcon, color: AppColors.black_txcolor),
                                                                  const SizedBox(width: 10),
                                                                  Center(
                                                                    child: CommonText(text: AppString.assignTrainer, fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w500),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            PopupMenuItem<int>(
                                                              value: 2,
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
                                                              value: 3,
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
                                                            (value) {
                                                          if (value == 0) {
                                                            _admin_UserDeatil("${item.userID}");
                                                          }
                                                          if (value == 1) {
                                                            _assignTrainer(item.displayName.toString(), item.userID);
                                                          }
                                                          if (value == 2) {
                                                            _approveRequest(item.displayName.toString(), item.userID, item.subscription.toString(), item.status.toString());
                                                          }
                                                          if (value == 3) {
                                                            _cancelSubscriptionRequest(item.displayName.toString(), item.userID.toString());
                                                          }
                                                        }),
                                                  )
                                                      : item.subscription ==
                                                      "Platinum" ||
                                                      item.subscription ==
                                                          "Gold"
                                                      ? Container(
                                                    width:
                                                    20,
                                                    child: PopupMenuButton(
                                                        iconSize: 18,
                                                        itemBuilder: (context) {
                                                          return [
                                                            PopupMenuItem<int>(
                                                              value: 0,
                                                              child: Row(
                                                                children: [
                                                                  SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                  const SizedBox(width: 10),
                                                                  const CommonText(text: "User Details", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                ],
                                                              ),
                                                            ),
                                                            PopupMenuItem<int>(
                                                              value: 1,
                                                              child: Row(
                                                                children: [
                                                                  SvgPicture.asset(addUserIcon, color: AppColors.black_txcolor),
                                                                  const SizedBox(width: 10),
                                                                  const CommonText(text: "Change Trainer", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                ],
                                                              ),
                                                            ),
                                                          ];
                                                        },
                                                        onSelected: (value) {
                                                          if (value == 0) {
                                                            print("My account menu is selected.");
                                                            _admin_UserDeatil("${item.userID}");
                                                          } else if (value == 1) {
                                                            print("Settings menu is selected.");
                                                            _changeTrainer("${item.displayName}", "${item.trainerName}", item.userID, item.trainerID.toString());
                                                          }
                                                        }),
                                                  )
                                                      : item.subscription ==
                                                      "Free"
                                                      ? Container(
                                                    width:
                                                    20,
                                                    child:
                                                    PopupMenuButton(
                                                      iconSize: 18,
                                                      itemBuilder: (context) {
                                                        return [
                                                          PopupMenuItem<int>(
                                                            value: 0,
                                                            child: Row(
                                                              children: [
                                                                SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                const SizedBox(width: 10),
                                                                const CommonText(text: "User Details", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                              ],
                                                            ),
                                                          ),
                                                        ];
                                                      },
                                                      onSelected: (value) {
                                                        if (value == 0) {
                                                          print("My account menu is selected.");
                                                          _admin_UserDeatil("${item.userID}");
                                                        }
                                                      },
                                                    ),
                                                  )
                                                      : Container(
                                                    width:
                                                    20,
                                                    child:
                                                    PopupMenuButton(
                                                      iconSize: 18,
                                                      itemBuilder: (context) {
                                                        return [
                                                          PopupMenuItem<int>(
                                                            value: 0,
                                                            child: Row(
                                                              children: [
                                                                SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                const SizedBox(width: 10),
                                                                const CommonText(text: "User Details", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                              ],
                                                            ),
                                                          ),
                                                        ];
                                                      },
                                                      onSelected: (value) {
                                                        if (value == 0) {
                                                          print("My account menu is selected.");
                                                          _admin_UserDeatil("${item.userID}");
                                                        }
                                                      },
                                                    ),
                                                  ),
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
                            )
                                : Container()
                                : Container();
                          },
                        );
                      } else if (status_dropdown_value == "Pending") {
                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(top: 5),
                          shrinkWrap: true,
                          itemCount: records.length,
                          itemBuilder: (context, index) {
                            final item = records[index];
                            DateTime joiningDate =
                            DateTime.parse(item.joiningDate.toString());
                            return item.displayName!
                                .toLowerCase()
                                .contains(searchString) ||
                                item.subscription!
                                    .toLowerCase()
                                    .contains(searchString)
                                ? item.status == "Pending"
                                ? Container(
                              margin: const EdgeInsets.only(
                                  bottom: 10, left: 5, right: 5),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    side:
                                    const BorderSide(width: 0.1),
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
                                        MainAxisAlignment
                                            .spaceBetween,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .start,
                                            children: [
                                              CommonText(
                                                  text:
                                                  "${item.displayName}",
                                                  fontSize: 15,
                                                  color: AppColors
                                                      .black_txcolor,
                                                  fontWeight:
                                                  FontWeight
                                                      .bold),
                                              const SizedBox(
                                                  height: 5),
                                              CommonText(
                                                  text:
                                                  "joiningDate : ${DateFormat('yMMMd').format(joiningDate)}",
                                                  fontSize: 13,
                                                  color: AppColors
                                                      .black_txcolor,
                                                  fontWeight:
                                                  FontWeight
                                                      .normal),
                                              const SizedBox(
                                                  height: 5),
                                              CommonText(
                                                  text:
                                                  "subscription : ${item.subscription}",
                                                  fontSize: 13,
                                                  color: AppColors
                                                      .black_txcolor,
                                                  fontWeight:
                                                  FontWeight
                                                      .normal),
                                              const SizedBox(
                                                  height: 5),
                                              CommonText(
                                                  text:
                                                  "price: \$${item.price}",
                                                  fontSize: 13,
                                                  color: AppColors
                                                      .black_txcolor,
                                                  fontWeight:
                                                  FontWeight
                                                      .normal),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .start,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                      height: 20,
                                                      width: 64.52,
                                                      decoration:
                                                      BoxDecoration(
                                                        color: item.status ==
                                                            "Pending"
                                                            ? AppColors
                                                            .orange
                                                            : item.status ==
                                                            "Rejected"
                                                            ? AppColors
                                                            .rejected
                                                            : AppColors
                                                            .approvedbackground_Color,
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            16),
                                                      ),
                                                      child: Center(
                                                        child:
                                                        CommonText(
                                                          text: item
                                                              .status
                                                              .toString(),
                                                          fontSize:
                                                          10,
                                                          color: item.status ==
                                                              "Pending"
                                                              ? AppColors
                                                              .onHold
                                                              : item.status ==
                                                              "Rejected"
                                                              ? AppColors.onHoldTextColor
                                                              : AppColors.approvedtext_Color,
                                                          fontWeight:
                                                          FontWeight
                                                              .w400,
                                                        ),
                                                      )),
                                                  item.status == "Pending"
                                                      ? SizedBox(
                                                    width: 20,
                                                    child: item.subscription ==
                                                        "Free"
                                                        ? PopupMenuButton(
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
                                                            (value) {
                                                          if (value == 0) {
                                                            _admin_UserDeatil("${item.userID}");
                                                          }
                                                          if (value == 1) {
                                                            _approveRequest(item.displayName.toString(), item.userID, item.subscription.toString(), item.status.toString());
                                                          }
                                                          if (value == 2) {
                                                            _cancelSubscriptionRequest(item.displayName.toString(), item.userID.toString());
                                                          }
                                                        })
                                                        : PopupMenuButton(
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
                                                                  SvgPicture.asset(userPlusIcon, color: AppColors.black_txcolor),
                                                                  const SizedBox(width: 10),
                                                                  Center(
                                                                    child: CommonText(text: AppString.assignTrainer, fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w500),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            PopupMenuItem<int>(
                                                              value: 2,
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
                                                              value: 3,
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
                                                            (value) {
                                                          if (value == 0) {
                                                            _admin_UserDeatil("${item.userID}");
                                                          }
                                                          if (value == 1) {
                                                            _assignTrainer(item.displayName.toString(), item.userID);
                                                          }
                                                          if (value == 2) {
                                                            _approveRequest(item.displayName.toString(), item.userID, item.subscription.toString(), item.status.toString());
                                                          }
                                                          if (value == 3) {
                                                            _cancelSubscriptionRequest(item.displayName.toString(), item.userID.toString());
                                                          }
                                                        }),
                                                  )
                                                      : item.subscription ==
                                                      "Platinum" ||
                                                      item.subscription ==
                                                          "Gold"
                                                      ? Container(
                                                    width:
                                                    20,
                                                    child: PopupMenuButton(
                                                        iconSize: 18,
                                                        itemBuilder: (context) {
                                                          return [
                                                            PopupMenuItem<int>(
                                                              value: 0,
                                                              child: Row(
                                                                children: [
                                                                  SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                  const SizedBox(width: 10),
                                                                  const CommonText(text: "User Details", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                ],
                                                              ),
                                                            ),
                                                            PopupMenuItem<int>(
                                                              value: 1,
                                                              child: Row(
                                                                children: [
                                                                  SvgPicture.asset(addUserIcon, color: AppColors.black_txcolor),
                                                                  const SizedBox(width: 10),
                                                                  const CommonText(text: "Change Trainer", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                ],
                                                              ),
                                                            ),
                                                          ];
                                                        },
                                                        onSelected: (value) {
                                                          if (value == 0) {
                                                            print("My account menu is selected.");
                                                            _admin_UserDeatil("${item.userID}");
                                                          } else if (value == 1) {
                                                            print("Settings menu is selected.");
                                                            _changeTrainer("${item.displayName}", "${item.trainerName}", item.userID, item.trainerID.toString());
                                                          }
                                                        }),
                                                  )
                                                      : item.subscription ==
                                                      "Free"
                                                      ? Container(
                                                    width:
                                                    20,
                                                    child:
                                                    PopupMenuButton(
                                                      iconSize: 18,
                                                      itemBuilder: (context) {
                                                        return [
                                                          PopupMenuItem<int>(
                                                            value: 0,
                                                            child: Row(
                                                              children: [
                                                                SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                const SizedBox(width: 10),
                                                                const CommonText(text: "User Details", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                              ],
                                                            ),
                                                          ),
                                                        ];
                                                      },
                                                      onSelected: (value) {
                                                        if (value == 0) {
                                                          print("My account menu is selected.");
                                                          _admin_UserDeatil("${item.userID}");
                                                        }
                                                      },
                                                    ),
                                                  )
                                                      : Container(
                                                    width:
                                                    20,
                                                    child:
                                                    PopupMenuButton(
                                                      iconSize: 18,
                                                      itemBuilder: (context) {
                                                        return [
                                                          PopupMenuItem<int>(
                                                            value: 0,
                                                            child: Row(
                                                              children: [
                                                                SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                const SizedBox(width: 10),
                                                                const CommonText(text: "User Details", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                              ],
                                                            ),
                                                          ),
                                                        ];
                                                      },
                                                      onSelected: (value) {
                                                        if (value == 0) {
                                                          print("My account menu is selected.");
                                                          _admin_UserDeatil("${item.userID}");
                                                        }
                                                      },
                                                    ),
                                                  ),
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
                            )
                                : Container()
                                : Container();
                          },
                        );
                      }
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
            },
          ),
        ],
      ),
    );
  }

  Future<bool> _assignTrainer(String displayName, int? userID) async {
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
                            text: AppString.assignTrainer,
                            fontSize: 18,
                            color: AppColors.black,
                            fontWeight: FontWeight.bold),
                        const SizedBox(height: 15),
                        const Divider(color: AppColors.grey_hint_color),
                        const SizedBox(height: 10),
                        TextFieldView(
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
                        // const SizedBox(height: 10),
                        // TextFieldView(
                        //   controller:  playerController,
                        //   textInputAction: TextInputAction.next,
                        //   type: TextInputType.text,
                        //   text: "player ID (optional)",
                        // ),
                        // const SizedBox(height: 10),
                        const SizedBox(height: 10),
                        _buildTrainerDropdown(""),
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
                                  print("user Id  ========<> $userID");
                                  trainer == null ? postAssignTrainer(context, userID, clientTrainerID.toString()) :
                                  postAssignTrainer(context, userID, trainer.toString());
                                  // assignTrainerViewController.postAssignTrainer(context, userID.toString(), "1604899", "2");
                                }
                              },
                              child: Container(
                                height: 35,
                                width: 80,
                                decoration: BoxDecoration(
                                  color: AppColors.dark_blue_button_color,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: CommonText(
                                      text: AppString.assign,
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

  Future<bool> _approveRequest(String displayName, int? userID, String subscription, String status) async {
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
                        TextFieldView(
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
                            : _buildTrainerDropdown(""),
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
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    postApproveRequest(context, userID, status, clientTrainerID.toString());
                                  });
                                  Get.back();
                                }
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

  Widget showlistrolewise() {
    if ((PreferenceUtils.getString('role') == "admin")) {
      //return LeaveRequest_Listview_BUilder_ForMnager();
      return Adminathleterole();
    }
    /* else if((PreferenceUtils.getString('role') == "employee")){
    return LeaveRequest_Listview_BUilder_ForMnager();
    //return all_EMP_MANG_LeaveRequest_Listview_BUilder_forcompony();
  }*/
    else {
      return whole_coaches_widget_main(index);
    }
  }

  Widget whole_coaches_widget_main(index) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          whole_search_widget_coach_athlet(index),
          Expanded(child: Coaches_listView_builder()),
        ],
      ),
    );
  }

  _buildRow(image, text, color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(image),
        const SizedBox(width: 10),
        Expanded(
          child: CommonText(
            text: text,
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Future<bool> _admin_UserDeatil(String userId) async {
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
                  Container(
                    height: 100,
                    child: const Center(
                      child: Text("No Data Found")
                    ),
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
                                      height: 60,
                                      width: 60,
                                      fit: BoxFit.cover,
                                      imageUrl: "${userdetails.picturePathS3}",
                                      placeholder: (context, url) =>
                                          CustomLoader(),
                                      errorWidget: (context, url, error) =>
                                          SvgPicture.asset(
                                            userProfile_image,
                                            height: 60,
                                            width: 60,
                                          ),
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
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
                                            SvgPicture.asset(
                                              locationIcon,
                                              color: AppColors.black,
                                            ),
                                            const SizedBox(width: 3),
                                            Expanded(
                                              child: CommonText(
                                                  text:
                                                  "${userdetails.streetAddress}, ${userdetails.city}, ${userdetails.state}, ${userdetails.zipcode}",
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
                              const SizedBox(height: 10),
                              const Divider(color: AppColors.grey_hint_color),
                              userdetails.bio != null
                                  ? Center(
                                child: ReadMoreText(
                                  "${userdetails.bio}",
                                  trimLines: 7,
                                  style: const TextStyle(
                                      color: AppColors.grey_text_color),
                                  colorClickableText:
                                  AppColors.blue_text_Color,
                                  trimMode: TrimMode.Line,
                                  trimCollapsedText: '...view more',
                                  trimExpandedText: ' view less',
                                ),
                              )
                                  : const Center(
                                  child: Text("No more details found")),
                              const Divider(color: AppColors.grey_hint_color),
                              const SizedBox(height: 10),
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
                        return const SizedBox(
                          height: 50,
                          child: Center(
                            child: Text("No Data Found"),
                          ),
                        );
                      }
                    } else {
                      return Container(
                        height: 100,
                        child: const Center(
                          child: Text("No Data Found"),
                        ),
                      );
                    }
                }
                return Container(
                  height: 100,
                  child: const Center(
                    child: Text("No Data Found"),
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

  Future<bool> _changeTrainer(String displayName, String trainerName, int? userID, String? trainerID) async {
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
                        const CommonText(
                            text: "Chnage Trainer",
                            fontSize: 18,
                            color: AppColors.black,
                            fontWeight: FontWeight.bold),
                        const SizedBox(height: 15),
                        const Divider(color: AppColors.grey_hint_color),
                        const SizedBox(height: 10),
                        TextFieldView(
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
                        _buildTrainerDropdown(trainerName),
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
                                  trainer == null ? postChangeTrainer(context, userID, trainerID.toString()) :
                                  postChangeTrainer(context, userID, trainer.toString());
                                  Get.back();
                                }
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
                                      text: "Change",
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
                        TextFieldView(
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
                                  setState(() {
                                    postAdminReject(context, userID, approvalCommentController.text);
                                  });
                                  Get.back();
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

  Widget _buildTrainerDropdown(String trName) {
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
                return DropdownMenuItem(
                  value: item['TrainerID'].toString(),
                  child: CommonText(
                      text: item['TrainerName'],
                      fontSize: 13,
                      color: AppColors.black,
                      fontWeight: FontWeight.w500),
                );
              }).toList(),
              hint: CommonText(
                  text: trName != null ? "Select Trainer" : trName,
                  fontSize: 15,
                  color: AppColors.black,
                  fontWeight: FontWeight.w500),
              onChanged: (String? newValue) {
                setState(() => trainer = newValue);
                print(trainer.toString());
              },
            ),
          ));
    });
  }

  Widget Coach_Listview_BUilder() {
    return Coach_AthletesModel.length == 0
        ? const Center(
      child: Text("No any data found"),
    )
        : StatefulBuilder(builder: (context, setState) {
      return RefreshIndicator(
        child: ListView.builder(
            shrinkWrap: true,
            //scrollDirection: Axis.horizontal,
            //physics: NeverScrollableScrollPhysics(),
            physics: const ClampingScrollPhysics(),
            itemCount: Coach_AthletesModel.length,
            itemBuilder: (context, index) {
              /*setState(() {
                                         );*/
              return Coach_Athelete_Raw(index);
            }),
        onRefresh: () {
          return Future.delayed(
            const Duration(seconds: 1),
                () {
              //get_leave_arequest();
              setState(() {});
            },
          );
        },
      );
    });
  }

  Widget Coaches_listView_builder() {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: _isFirstLoadRunning
                    ? Align(
                  alignment: Alignment.center,
                  child: CustomLoader(),
                )
                    : Coach_AthletesModel.isEmpty
                    ? const Align(
                  alignment: Alignment.center,
                  child: NoDataFound(),
                )
                    : ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    //itemCount: datalist.length,
                    itemCount: Coach_AthletesModel.length,
                    itemBuilder: (context, index) {
                      PreferenceUtils.setInt(
                          "userid", Coach_AthletesModel[index].userID!);
                      log(PreferenceUtils.getInt("userid").toString(),
                          name: "this is stored userid");
                      return InkWell(
                          onTap: () {
                            // Get.to(const CollegeRecruitersDetailPage());
                          },
                          child: Coach_Athelete_Raw(index));
                    })),
            // when the _loadMore function is running
            /*if (_isLoadMoreRunning == true)
              Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 40),
                  child: Center(
                    child: CustomLoader(),
                  )),
*/
            // When nothing else to load
            /* if (_hasNextPage == false)
              Container(
                padding: const EdgeInsets.only(top: 30, bottom: 40),
                color: Colors.amber,
                child: const Center(
                  child: Text('You have fetched all of the content'),
                ),
              ),*/
          ]),
    );
  }

  Widget Coach_Athelete_Raw(int index) {
    return Container(
        margin: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
        child: Card(
          margin: const EdgeInsets.only(top: 8, bottom: 8),
          shape: RoundedRectangleBorder(
              side: const BorderSide(width: 0.1),
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 50,
                  width: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(1000.0),
                    child: CachedNetworkImage(
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                      imageUrl: "${Coach_AthletesModel[index].image}",
                      placeholder: (context, url) => CustomLoader(),
                      errorWidget: (context, url, error) => SizedBox(
                          height: 50,
                          width: 50,
                          child: Image.asset(avatarImage)),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, top: 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText(
                            text: Coach_AthletesModel[index].displayName ??
                                "",
                            fontSize: 16,
                            color: AppColors.black_txcolor,
                            fontWeight: FontWeight.w700),
                        const SizedBox(height: 5),
                        Coach_AthletesModel[index].bio == ""
                            ? const CommonText(
                            text: "",
                            fontSize: 10,
                            color: AppColors.grey_hint_color,
                            fontWeight: FontWeight.w400)
                            : CommonText(
                            text:
                            "${Coach_AthletesModel[index].bio ?? ""}",
                            fontSize: 10,
                            color: AppColors.grey_hint_color,
                            fontWeight: FontWeight.w400),
                        const SizedBox(height: 9),
                        _buildRow(
                          location_icon,
                          "${Coach_AthletesModel[index].address}, ${Coach_AthletesModel[index].city}, ${Coach_AthletesModel[index].state}, ${Coach_AthletesModel[index].zipcode}" ??
                              "",
                          AppColors.black_txcolor,
                        ),
                        const SizedBox(height: 7),
                        _buildRow(
                          call_icon,
                          "${Coach_AthletesModel[index].contact ?? ""}",
                          AppColors.black_txcolor,
                        ),
                        const SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildRowPositions("Hitting : ",
                                  Coach_AthletesModel[index].hittingPosition),
                              const SizedBox(width: 10),
                              _buildRowPositions("Throwing :",
                                  Coach_AthletesModel[index].throwingPosition),
                              const SizedBox(width: 10),
                              _buildRowPositions(
                                  "Graduating Year : ",
                                  Coach_AthletesModel[index]
                                      .graduatingYear
                                      .toString()),
                              const SizedBox(width: 10),
                              _buildRowPositions("GPA :",
                                  Coach_AthletesModel[index].educationGpa),
                            ],
                          ),
                        ),
                        const SizedBox(height: 7),
                        Coach_AthletesModel[index].uploadTranscript != null
                            ? GestureDetector(
                          onTap: () async {
                            _permissionReady = await _checkPermission();
                            if (_permissionReady) {
                              await _prepareSaveDir();
                              print("Downloading");
                              try {
                                File file = new File(
                                    "${Coach_AthletesModel[index].uploadTranscript}");
                                var path = file.path;
                                var filename = path.split("/").last;
                                print("@@@@@ ${filename}");
                                await Dio().download(
                                    "${Coach_AthletesModel[index].uploadTranscript}",
                                    _localPath + "/" + "$filename");
                                MyApplication.getInstance()!
                                    .showInGreenSnackBar(
                                    "Download Completed Please check storage",
                                    context);
                                print("Download Completed.");
                              } catch (e) {
                                print("Download Failed.\n\n" +
                                    e.toString());
                              }
                            }
                          },
                          child: const CommonText(
                              text: "Download Transcript",
                              fontSize: 13,
                              color: AppColors.blue_button_Color,
                              fontWeight: FontWeight.w500),
                        )
                            : Container(),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      height: 13,
                      width: 11,
                      child: Coach_AthletesModel[index].isBookMarked == false
                      //child: datalist[index]["isBookMarked"] == false
                          ? Image.asset(collegerecruitersave)
                          : Image.asset(bookmarktrue),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 20,
                      child: PopupMenuButton(
                        padding: EdgeInsets.zero,
                        iconSize: 18,
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem<int>(
                              value: 0,
                              child: Row(
                                children: [
                                  SvgPicture.asset(messageCircleIcon,
                                      color: AppColors.black_txcolor),
                                  const SizedBox(width: 10),
                                  const CommonText(
                                      text: "Send Message",
                                      fontSize: 15,
                                      color: AppColors.black_txcolor,
                                      fontWeight: FontWeight.w400),
                                ],
                              ),
                            ),
                            PopupMenuItem<int>(
                              value: 1,
                              child: Row(
                                children: [
                                  SvgPicture.asset(barchartIcon,
                                      color: AppColors.black_txcolor),
                                  const SizedBox(width: 10),
                                  const CommonText(
                                      text: "Stats",
                                      fontSize: 15,
                                      color: AppColors.black_txcolor,
                                      fontWeight: FontWeight.w400),
                                ],
                              ),
                            ),
                            PopupMenuItem<int>(
                              value: 2,
                              child: Row(
                                children: [
                                  SvgPicture.asset(briefcaseIcon,
                                      color: AppColors.black_txcolor),
                                  const SizedBox(width: 10),
                                  const CommonText(
                                      text: "Athlete Details",
                                      fontSize: 15,
                                      color: AppColors.black_txcolor,
                                      fontWeight: FontWeight.w400),
                                ],
                              ),
                            ),
                          ];
                        },
                        onSelected: (value) {
                          setState(() {
                            if (value == 0) {
                              SendMessageController.clear();
                              SendMessagedialog(
                                  Coach_AthletesModel[index].userID.toString());
                            } else if (value == 1) {
                              print("Send Message menu is selected.");
                              College_stats_dialog(Coach_AthletesModel[index]
                                  .playerID
                                  .toString());
                            } else {
                              _UserDetails(
                                Coach_AthletesModel[index].userID.toString(),
                                Coach_AthletesModel[index]
                                    .positionPlayed
                                    .toString(),
                                Coach_AthletesModel[index]
                                    .throwingPosition
                                    .toString(),
                                Coach_AthletesModel[index]
                                    .hittingPosition
                                    .toString(),
                              );
                            }
                          });
                        },
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  void Coach_athletes_getlist() async {
    log('this is call admincollege recruiter api call',
        name: "college recruiter");
    setState(() {
      _isFirstLoadRunning = true;
    });
    MyApplication.getInstance()!
        .checkConnectivity(context)
        .then((internet) async {
      if (internet != null && internet) {
        try {
          Dio dio = Dio();
          var response = await dio.post(
              "${AppConstant.Coach_athletes}page=$_page&size=$_limit",
              options: Options(followRedirects: false, headers: {
                "Authorization":
                "Bearer ${PreferenceUtils.getString("accesstoken")}"
              }));
          if (response.statusCode == 200) {
            print("+++++this is admin clg recruiter${response.data}");
            setState(() {
              Coach_Athleteslist = response.data["result"];
              print("=======this is data list${Coach_Athleteslist.toString()}");
              setState(() {
                for (Map<String, dynamic> i in Coach_Athleteslist) {
                  Coach_AthletesModel.add(CoachAteleteResult.fromJson(i));
                }
                _isFirstLoadRunning = false;
                print(
                    "=======this is data list of single item${Coach_AthletesModel[0].displayName}");
              });
            });
          } else {
            setState(() => _isFirstLoadRunning = false);
          }
        } catch (e) {
          print(e);
          setState(() => _isFirstLoadRunning = false);
        }
      } else {
        MyApplication.getInstance()!
            .showInSnackBar(AppString.no_connection, context);
      }
    });
  }

  Future<bool> SendMessagedialog(String userid) async {
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            CommonText(
                                text: AppString.sendMessage,
                                fontSize: 18,
                                color: AppColors.black_txcolor,
                                fontWeight: FontWeight.w700),
                            /*InkWell(
                            onTap: (){
                              Navigator.pop(context);
                            },
                              child: SvgPicture.asset(close)),*/
                          ]),
                      const SizedBox(width: 10),
                      const Divider(color: AppColors.grey_hint_color),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const CommonText(
                                text: AppString.sendMessage,
                                fontSize: 15,
                                color: AppColors.grey_text_color,
                                fontWeight: FontWeight.w400),
                            CommonText(
                                text: AppString.msgtxlength,
                                fontSize: 15,
                                color: AppColors.grey_text_color,
                                fontWeight: FontWeight.w400),
                          ]),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: SendMessageController,
                              keyboardType: TextInputType.multiline,
                              maxLength: null,
                              maxLines: 4,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                      borderSide: BorderSide(
                                          width: 1,
                                          color: AppColors.grey_hint_color)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                      borderSide: BorderSide(
                                          width: 1,
                                          color: AppColors.grey_hint_color))),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Divider(color: AppColors.grey_hint_color),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const CommonText(
                                text: "Cancel",
                                fontSize: 18,
                                color: AppColors.dark_blue_button_color,
                                fontWeight: FontWeight.w700),
                          ),
                          Container(
                            width: 150,
                            child: Button(
                              textColor: AppColors.white,
                              text: AppString.sendMessage,
                              color: AppColors.dark_blue_button_color,
                              onClick: () async {
                                SendMessageApi(accessToken, userid.toString(),
                                    SendMessageController.text, context);
                                Navigator.pop(context);
                              },
                            ),
                          )
                        ],
                      ),
                    ],
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

  Future<bool> _UserDetails(String userId, String positionPlayed, String throwingPosition, String hittingPosition) async {
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
            child: FutureBuilder(
              future: getManageProfile(accessToken, userId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  Container(
                    height: 100,
                    child: const Center(
                      child: Text("No Data Found"),
                    ),
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
                                        height: 60,
                                        width: 60,
                                        fit: BoxFit.cover,
                                        imageUrl: "${userdetails.picturePathS3}",
                                        placeholder: (context, url) =>
                                            CustomLoader(),
                                        errorWidget: (context, url, error) =>
                                            SvgPicture.asset(
                                              userProfile_image,
                                              height: 60,
                                              width: 60,
                                            ),
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          CommonText(
                                              text:
                                              "${userdetails.displayName}",
                                              fontSize: 18,
                                              color: AppColors.black_txcolor,
                                              fontWeight: FontWeight.w500),
                                          const SizedBox(height: 5),
                                          Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              SvgPicture.asset(
                                                locationIcon,
                                                color: AppColors.black,
                                              ),
                                              const SizedBox(width: 3),
                                              Expanded(
                                                child: CommonText(
                                                    text:
                                                    "${userdetails.streetAddress}, ${userdetails.city}, ${userdetails.state}, ${userdetails.zipcode}",
                                                    fontSize: 15,
                                                    color:
                                                    AppColors.black_txcolor,
                                                    fontWeight:
                                                    FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          Row(children: [
                                            SvgPicture.asset(
                                              emailIcon,
                                              color: AppColors.black,
                                            ),
                                            const SizedBox(width: 3),
                                            CommonText(
                                                text:
                                                "${userdetails.userEmail}",
                                                fontSize: 15,
                                                color: AppColors.black_txcolor,
                                                fontWeight: FontWeight.w400)
                                          ]),
                                          const SizedBox(height: 5),
                                          Row(children: [
                                            SvgPicture.asset(
                                              call_icon,
                                              color: AppColors.black,
                                            ),
                                            const SizedBox(width: 3),
                                            CommonText(
                                                text: "${userdetails.contact}",
                                                fontSize: 15,
                                                color: AppColors.black_txcolor,
                                                fontWeight: FontWeight.w400)
                                          ])
                                        ],
                                      ),
                                    )
                                  ]),
                              const SizedBox(height: 10),
                              const Divider(color: AppColors.grey_hint_color),
                              const SizedBox(height: 5),
                              const CommonText(
                                  text: "${AppString.primarySkills}:",
                                  fontSize: 15,
                                  color: AppColors.black_txcolor,
                                  fontWeight: FontWeight.w500),
                              const SizedBox(height: 5),
                              DataTable(
                                  headingRowColor: MaterialStateProperty.resolveWith((states) => AppColors.grey_hint_color),
                                  columns: _createPrimarySkilsColumns(),
                                  rows: <DataRow>[
                                    DataRow(
                                      cells: [
                                        DataCell(
                                          CommonText(
                                              text: "Position Played",
                                              fontSize: 11,
                                              color: AppColors.black_txcolor,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        DataCell(
                                          CommonText(
                                              text: positionPlayed.toString(),
                                              fontSize: 11,
                                              color: AppColors.black_txcolor,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    DataRow(
                                      cells: [
                                        DataCell(
                                          CommonText(
                                              text: "Throwing Position",
                                              fontSize: 11,
                                              color: AppColors.black_txcolor,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        DataCell(
                                          CommonText(
                                              text: throwingPosition.toString(),
                                              fontSize: 11,
                                              color: AppColors.black_txcolor,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        // DataCell(
                                        //   CommonText(
                                        //       text: hittingPosition.toString(),
                                        //       fontSize: 11,
                                        //       color: AppColors.black_txcolor,
                                        //       fontWeight: FontWeight.w500),
                                        // ),
                                      ],
                                    ),
                                    DataRow(
                                      cells: [
                                        DataCell(
                                          CommonText(
                                              text: "Hitting Position",
                                              fontSize: 11,
                                              color: AppColors.black_txcolor,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        DataCell(
                                          CommonText(
                                              text: hittingPosition.toString(),
                                              fontSize: 11,
                                              color: AppColors.black_txcolor,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        // DataCell(
                                        //   CommonText(
                                        //       text: hittingPosition.toString(),
                                        //       fontSize: 11,
                                        //       color: AppColors.black_txcolor,
                                        //       fontWeight: FontWeight.w500),
                                        // ),
                                      ],
                                    ),
                                  ]),
                              const Divider(color: AppColors.grey_hint_color),
                              const SizedBox(height: 10),
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
                        return const SizedBox(
                          height: 50,
                          child: Center(
                            child: Text("No Data Found"),
                          ),
                        );
                      }
                    } else {
                      return Container(
                        height: 100,
                        child: const Center(
                          child: Text("No Data Found"),
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

  Future<bool> College_stats_dialog(String playerId) async {
    print("player $playerId");
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
            child: FutureBuilder<StatsModel?>(
              future: StatsApi(playerId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  Container(
                    height: 100,
                    child: const Center(
                      child: NoDataFound(),
                    ),
                  );
                }
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(child: CustomLoader());
                  case ConnectionState.done:
                    if (snapshot.hasData) {
                      PlayerStats? playerStats = snapshot.data?.playerStats;
                      List<Pitchingstats>? pitchingstatslist = snapshot.data?.playerStats?.pitchingstatslist;
                      List<Battingstats>? battingstatslist = snapshot.data?.playerStats?.battingstatslist;
                      print("pitchingstats =====> ${pitchingstatslist}");
                      print("listBattingStats =====> ${battingstatslist}");
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(width: 15),
                            Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  const CommonText(
                                      text: AppString.playerstats,
                                      fontSize: 18,
                                      color: AppColors.black_txcolor,
                                      fontWeight: FontWeight.w800),
                                  InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: SvgPicture.asset(close)),
                                ]),
                            const SizedBox(height: 5),
                            const Divider(color: AppColors.grey_hint_color),
                            const SizedBox(height: 15),
                            CommonText(
                                text: "${playerStats?.playername}",
                                fontSize: 16,
                                color: AppColors.stats_title_blue,
                                fontWeight: FontWeight.w700),
                            const SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CommonText(
                                    text: AppString.leaugename,
                                    fontSize: 14,
                                    color: AppColors.black_txcolor,
                                    fontWeight: FontWeight.w500),
                                Expanded(
                                  child: Text(
                                    "${playerStats?.leaguename}",
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Montserrat',
                                      color: AppColors.grey_text_color,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CommonText(
                                    text: AppString.teamname,
                                    fontSize: 14,
                                    color: AppColors.black_txcolor,
                                    fontWeight: FontWeight.w500),
                                Expanded(
                                  child: CommonText(
                                      text: "${playerStats?.teamname}",
                                      fontSize: 14,
                                      color: AppColors.grey_text_color,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CommonText(
                                    text: AppString.bats,
                                    fontSize: 14,
                                    color: AppColors.black_txcolor,
                                    fontWeight: FontWeight.w500),
                                Expanded(
                                  child: CommonText(
                                      text: "${playerStats?.bats}",
                                      fontSize: 14,
                                      color: AppColors.grey_text_color,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CommonText(
                                    text: AppString.position_player_stata,
                                    fontSize: 14,
                                    color: AppColors.black_txcolor,
                                    fontWeight: FontWeight.w500),
                                Expanded(
                                  child: CommonText(
                                      text: "${playerStats?.position}",
                                      fontSize: 14,
                                      color: AppColors.grey_text_color,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CommonText(
                                    text: AppString.throws,
                                    fontSize: 14,
                                    color: AppColors.black_txcolor,
                                    fontWeight: FontWeight.w500),
                                Expanded(
                                  child: CommonText(
                                      text: "${playerStats?.throws}",
                                      fontSize: 14,
                                      color: AppColors.grey_text_color,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                            battingstatslist != null ? const SizedBox(height:  15) : Container(),
                            battingstatslist != null ? const CommonText(
                                text: "Batting Stats",
                                fontSize: 16,
                                color: AppColors.stats_title_blue,
                                fontWeight: FontWeight.w800) : Container(),
                            battingstatslist != null ? const SizedBox(height:  5) : Container(),
                            battingstatslist != null ?
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                  showBottomBorder: true,
                                  headingRowColor:
                                  MaterialStateProperty.resolveWith(
                                          (states) =>
                                      AppColors.grey_hint_color),
                                  columns: _createBattingStatsColumns(),
                                  rows: List.generate(battingstatslist.length,
                                          (index) {
                                        var battingstatsItem = battingstatslist[index];
                                        if (battingstatsItem != null) {
                                          return DataRow(
                                            cells: [
                                              DataCell(
                                                CommonText(
                                                    text:
                                                    "${battingstatsItem.name}",
                                                    fontSize: 11,
                                                    color:
                                                    AppColors.black_txcolor,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                              DataCell(
                                                CommonText(
                                                    text:
                                                    "${battingstatsItem.ab}",
                                                    fontSize: 11,
                                                    color:
                                                    AppColors.black_txcolor,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                              DataCell(
                                                CommonText(
                                                    text:
                                                    "${battingstatsItem.avg}",
                                                    fontSize: 11,
                                                    color:
                                                    AppColors.black_txcolor,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                              DataCell(
                                                CommonText(
                                                    text:
                                                    "${battingstatsItem.bb}",
                                                    fontSize: 11,
                                                    color:
                                                    AppColors.black_txcolor,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                              DataCell(
                                                CommonText(
                                                    text:
                                                    "${battingstatsItem.bib}",
                                                    fontSize: 11,
                                                    color:
                                                    AppColors.black_txcolor,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                              DataCell(
                                                CommonText(
                                                    text:
                                                    "${battingstatsItem.gp}",
                                                    fontSize: 11,
                                                    color:
                                                    AppColors.black_txcolor,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                              DataCell(
                                                CommonText(
                                                    text: "${battingstatsItem.h}",
                                                    fontSize: 11,
                                                    color:
                                                    AppColors.black_txcolor,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                              DataCell(
                                                CommonText(
                                                    text:
                                                    "${battingstatsItem.hr}",
                                                    fontSize: 11,
                                                    color:
                                                    AppColors.black_txcolor,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                              DataCell(
                                                CommonText(
                                                    text: "${battingstatsItem.r}",
                                                    fontSize: 11,
                                                    color:
                                                    AppColors.black_txcolor,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                              DataCell(
                                                CommonText(
                                                    text:
                                                    "${battingstatsItem.rbi}",
                                                    fontSize: 11,
                                                    color:
                                                    AppColors.black_txcolor,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                              DataCell(
                                                CommonText(
                                                    text:
                                                    "${battingstatsItem.sb}",
                                                    fontSize: 11,
                                                    color:
                                                    AppColors.black_txcolor,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                              DataCell(
                                                CommonText(
                                                    text:
                                                    "${battingstatsItem.so}",
                                                    fontSize: 11,
                                                    color:
                                                    AppColors.black_txcolor,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                              DataCell(
                                                CommonText(
                                                    text:
                                                    "${battingstatsItem.trib}",
                                                    fontSize: 11,
                                                    color:
                                                    AppColors.black_txcolor,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                              DataCell(
                                                CommonText(
                                                    text:
                                                    "${battingstatsItem.x2b}",
                                                    fontSize: 11,
                                                    color:
                                                    AppColors.black_txcolor,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                              DataCell(
                                                CommonText(
                                                    text:
                                                    "${battingstatsItem.x3b}",
                                                    fontSize: 11,
                                                    color:
                                                    AppColors.black_txcolor,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                            ],
                                          );
                                        } else {
                                          return const DataRow(
                                            cells: [],
                                          );
                                        }
                                      })
                              ),
                            )
                                : Container(),
                            pitchingstatslist != null ? const SizedBox(height:  15) : Container(),
                            pitchingstatslist != null ? const CommonText(
                                text: "Pitching Stats",
                                fontSize: 16,
                                color: AppColors.stats_title_blue,
                                fontWeight: FontWeight.w800) : Container(),
                            pitchingstatslist != null ? const SizedBox(height:  5) : Container(),
                            pitchingstatslist != null ?
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                showBottomBorder: true,
                                headingRowColor:
                                MaterialStateProperty.resolveWith(
                                        (states) =>
                                    AppColors.grey_hint_color),
                                columns: _createPitchingStatsColumns(),
                                rows: List.generate(pitchingstatslist.length,
                                        (index) {
                                      var pitchingstatsItem = pitchingstatslist[index];
                                      if (pitchingstatsItem != null) {
                                        return DataRow(
                                          cells: [
                                            DataCell(
                                              CommonText(
                                                  text: "${pitchingstatsItem.name}",
                                                  fontSize: 11,
                                                  color:
                                                  AppColors.black_txcolor,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            DataCell(
                                              CommonText(
                                                  text: "${pitchingstatsItem.bb}",
                                                  fontSize: 11,
                                                  color:
                                                  AppColors.black_txcolor,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            DataCell(
                                              CommonText(
                                                  text: "${pitchingstatsItem.er}",
                                                  fontSize: 11,
                                                  color:
                                                  AppColors.black_txcolor,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            DataCell(
                                              CommonText(
                                                  text: "${pitchingstatsItem.era}",
                                                  fontSize: 11,
                                                  color:
                                                  AppColors.black_txcolor,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            DataCell(
                                              CommonText(
                                                  text: "${pitchingstatsItem.gp}",
                                                  fontSize: 11,
                                                  color:
                                                  AppColors.black_txcolor,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            DataCell(
                                              CommonText(
                                                  text: "${pitchingstatsItem.gs}",
                                                  fontSize: 11,
                                                  color:
                                                  AppColors.black_txcolor,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            DataCell(
                                              CommonText(
                                                  text: "${pitchingstatsItem.h}",
                                                  fontSize: 11,
                                                  color:
                                                  AppColors.black_txcolor,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            DataCell(
                                              CommonText(
                                                  text: "${pitchingstatsItem.ip}",
                                                  fontSize: 11,
                                                  color:
                                                  AppColors.black_txcolor,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            DataCell(
                                              CommonText(
                                                  text: "${pitchingstatsItem.l}",
                                                  fontSize: 11,
                                                  color:
                                                  AppColors.black_txcolor,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            DataCell(
                                              CommonText(
                                                  text: "${pitchingstatsItem.sho}",
                                                  fontSize: 11,
                                                  color:
                                                  AppColors.black_txcolor,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            DataCell(
                                              CommonText(
                                                  text: "${pitchingstatsItem.so}",
                                                  fontSize: 11,
                                                  color:
                                                  AppColors.black_txcolor,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            DataCell(
                                              CommonText(
                                                  text: "${pitchingstatsItem.sv}",
                                                  fontSize: 11,
                                                  color:
                                                  AppColors.black_txcolor,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            DataCell(
                                              CommonText(
                                                  text: "${pitchingstatsItem.w}",
                                                  fontSize: 11,
                                                  color:
                                                  AppColors.black_txcolor,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        );
                                      } else {
                                        return const DataRow(
                                          cells: [],
                                        );
                                      }
                                    }),
                              ),
                            )
                                : Container(),
                          ],
                        ),
                      );
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

  _buildRowPositions(title, subTxt) {
    return Row(
      children: [
        CommonText(
            text: title,
            fontSize: 13,
            color: AppColors.black_txcolor,
            fontWeight: FontWeight.w500),
        CommonText(
            text: subTxt ?? "",
            fontSize: 13,
            color: AppColors.black_txcolor,
            fontWeight: FontWeight.normal),
      ],
    );
  }

  List<DataColumn> _createBattingStatsColumns() {
    return const [
      DataColumn(
          label: CommonText(
              text: 'SEASON NAME',
              fontSize: 12,
              color: AppColors.dark_blue_button_color,
              fontWeight: FontWeight.w600)),
      DataColumn(
          label: CommonText(
              text: 'AB',
              fontSize: 12,
              color: AppColors.dark_blue_button_color,
              fontWeight: FontWeight.w600)),
      DataColumn(
          label: CommonText(
              text: 'AVG',
              fontSize: 12,
              color: AppColors.dark_blue_button_color,
              fontWeight: FontWeight.w600)),
      DataColumn(
          label: CommonText(
              text: 'BB',
              fontSize: 12,
              color: AppColors.dark_blue_button_color,
              fontWeight: FontWeight.w600)),
      DataColumn(
          label: CommonText(
              text: 'BIB',
              fontSize: 12,
              color: AppColors.dark_blue_button_color,
              fontWeight: FontWeight.w600)),
      DataColumn(
          label: CommonText(
              text: 'GP',
              fontSize: 12,
              color: AppColors.dark_blue_button_color,
              fontWeight: FontWeight.w600)),
      DataColumn(
          label: CommonText(
              text: 'H',
              fontSize: 12,
              color: AppColors.dark_blue_button_color,
              fontWeight: FontWeight.w600)),
      DataColumn(
          label: CommonText(
              text: 'HR',
              fontSize: 12,
              color: AppColors.dark_blue_button_color,
              fontWeight: FontWeight.w600)),
      DataColumn(
          label: CommonText(
              text: 'R',
              fontSize: 12,
              color: AppColors.dark_blue_button_color,
              fontWeight: FontWeight.w600)),
      DataColumn(
          label: CommonText(
              text: 'RBI',
              fontSize: 12,
              color: AppColors.dark_blue_button_color,
              fontWeight: FontWeight.w600)),
      DataColumn(
          label: CommonText(
              text: 'SB',
              fontSize: 12,
              color: AppColors.dark_blue_button_color,
              fontWeight: FontWeight.w600)),
      DataColumn(
          label: CommonText(
              text: 'SO',
              fontSize: 12,
              color: AppColors.dark_blue_button_color,
              fontWeight: FontWeight.w600)),
      DataColumn(
          label: CommonText(
              text: 'TRIB',
              fontSize: 12,
              color: AppColors.dark_blue_button_color,
              fontWeight: FontWeight.w600)),
      DataColumn(
          label: CommonText(
              text: 'X_2B',
              fontSize: 12,
              color: AppColors.dark_blue_button_color,
              fontWeight: FontWeight.w600)),
      DataColumn(
          label: CommonText(
              text: 'X_3B',
              fontSize: 12,
              color: AppColors.dark_blue_button_color,
              fontWeight: FontWeight.w600)),
    ];
  }

  List<DataColumn> _createPitchingStatsColumns() {
    return const [
      DataColumn(
          label: CommonText(
              text: 'SEASON NAME',
              fontSize: 12,
              color: AppColors.dark_blue_button_color,
              fontWeight: FontWeight.w600)),
      DataColumn(
          label: CommonText(
              text: 'BB',
              fontSize: 12,
              color: AppColors.dark_blue_button_color,
              fontWeight: FontWeight.w600)),
      DataColumn(
          label: CommonText(
              text: 'ER',
              fontSize: 12,
              color: AppColors.dark_blue_button_color,
              fontWeight: FontWeight.w600)),
      DataColumn(
          label: CommonText(
              text: 'ERA',
              fontSize: 12,
              color: AppColors.dark_blue_button_color,
              fontWeight: FontWeight.w600)),
      DataColumn(
          label: CommonText(
              text: 'GP',
              fontSize: 12,
              color: AppColors.dark_blue_button_color,
              fontWeight: FontWeight.w600)),
      DataColumn(
          label: CommonText(
              text: 'GS',
              fontSize: 12,
              color: AppColors.dark_blue_button_color,
              fontWeight: FontWeight.w600)),
      DataColumn(
          label: CommonText(
              text: 'H',
              fontSize: 12,
              color: AppColors.dark_blue_button_color,
              fontWeight: FontWeight.w600)),
      DataColumn(
          label: CommonText(
              text: 'IP',
              fontSize: 12,
              color: AppColors.dark_blue_button_color,
              fontWeight: FontWeight.w600)),
      DataColumn(
          label: CommonText(
              text: 'L',
              fontSize: 12,
              color: AppColors.dark_blue_button_color,
              fontWeight: FontWeight.w600)),
      DataColumn(
          label: CommonText(
              text: 'SHO',
              fontSize: 12,
              color: AppColors.dark_blue_button_color,
              fontWeight: FontWeight.w600)),
      DataColumn(
          label: CommonText(
              text: 'SO',
              fontSize: 12,
              color: AppColors.dark_blue_button_color,
              fontWeight: FontWeight.w600)),
      DataColumn(
          label: CommonText(
              text: 'SV',
              fontSize: 12,
              color: AppColors.dark_blue_button_color,
              fontWeight: FontWeight.w600)),
      DataColumn(
          label: CommonText(
              text: 'W',
              fontSize: 12,
              color: AppColors.dark_blue_button_color,
              fontWeight: FontWeight.w600)),
    ];
  }

  List<DataColumn> _createPrimarySkilsColumns() {
    return const [
      DataColumn(
          label: CommonText(
              text: 'ATTRIBUTE NAME',
              fontSize: 12,
              color: AppColors.dark_blue_button_color,
              fontWeight: FontWeight.w600)),
      DataColumn(
          label: CommonText(
              text: 'DESCRIPTION',
              fontSize: 12,
              color: AppColors.dark_blue_button_color,
              fontWeight: FontWeight.w600)),
    ];
  }

  Widget whole_search_widget_coach_athlet(index) {
    return Container(
        margin: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
        child: Card(
            margin: const EdgeInsets.only(top: 5, bottom: 8),
            shape: RoundedRectangleBorder(
                side: const BorderSide(width: 0.1),
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const CommonText(
                              text: AppString.searchfilter,
                              fontSize: 14,
                              color: AppColors.stats_title_blue,
                              fontWeight: FontWeight.w700),
                          //outlinebuton_search_apply()
                          seach_apply_clear_button()
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            search_postion_Dropdown(),
                            _renderWidget(),
                          ]),
                      SizedBox(
                        height: 10,
                      ),
                      search_additionalfield_add_listviewbuilder(index),
                      search_addtionalfield_raw_addbutton(),

                      /*counter == 0
                          ? search_addtionalfield_raw_addbutton()
                          : search_additionalfield_add_listviewbuilder()*/
                    ]),
              ),
            )));
  }
  _renderWidget() {
    print("###==>$search_position_selecte_value");
    if(search_position_selecte_value.toString() == "Pitcher") {
      return search_field_pitcher_Dropdown(); // this could be any Widget
    } else {
      return search_field_othervalue_Dropdown(); // this could be any Widget
    }
  }

  Widget search_postion_Dropdown() {
    return StatefulBuilder(builder: (context, setState) {
      return Container(
          height: 46,
          width: 150,
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
              dropdownWidth: 150,
              dropdownPadding: null,
              dropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.white,
              ),
              value: search_position_selecte_value,
              underline: Container(),
              isExpanded: true,
              //itemHeight: 50.0,
              icon: Icon(Icons.keyboard_arrow_down,
                  size: 25, color: AppColors.grey_text_color),
              style: TextStyle(fontSize: 15.0, color: Colors.grey[700]),
              items: itemsPosition_dropdown.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: CommonText(
                      text: item,
                      fontSize: 13,
                      color: AppColors.black,
                      fontWeight: FontWeight.w500),
                );
              }).toList(),
              hint: const CommonText(
                  text: "Position",
                  fontSize: 13,
                  color: AppColors.black,
                  fontWeight: FontWeight.w500),
              onChanged: (String? newValue) {
                setState(() {
                  changedDropDownState(newValue!);
                  search_position_selecte_value = newValue;

                } );
                if (kDebugMode) {
                  print(
                      "this is serach postion selected==>$search_position_selecte_value");
                }
              },
            ),
          ));
    });
  }

  Widget search_condition_Dropdown() {
    return StatefulBuilder(builder: (context, setState) {
      return Container(
          height: 46,
          width: 120,
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
              dropdownWidth: 150,
              dropdownPadding: null,
              dropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.white,
              ),
              value: search_condition_selected_value,
              underline: Container(),
              isExpanded: true,
              //itemHeight: 50.0,
              icon: Icon(Icons.keyboard_arrow_down,
                  size: 25, color: AppColors.grey_text_color),
              style: TextStyle(fontSize: 15.0, color: Colors.grey[700]),
              items: itemsCondition_dropdown.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: CommonText(
                      text: item,
                      fontSize: 13,
                      color: AppColors.black,
                      fontWeight: FontWeight.w500),
                );
              }).toList(),
              hint: const CommonText(
                  text: "Condition",
                  fontSize: 13,
                  color: AppColors.black,
                  fontWeight: FontWeight.w500),
              onChanged: (String? newValue) {
                setState(() => search_condition_selected_value = newValue);
                if (kDebugMode) {
                  print(search_condition_selected_value.toString());
                }
              },
            ),
          ));
    });
  }

  Widget outlinebuton_search_apply() {
    return OutlinedButton(
        child: const CommonText(
          text: "Apply",
          fontSize: 14,
          color: AppColors.dark_blue_button_color,
          fontWeight: FontWeight.w400,
        ),
        style: OutlinedButton.styleFrom(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          side: BorderSide(width: 1.0, color: AppColors.dark_blue_button_color),
        ),
        onPressed: () => null
      /*Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const NewScreen())),*/
    );
  }

  changedDropDownState(String selectedState) {
    setState(() {
      search_position_selecte_value = selectedState;
      if (selectedState.toString() == "Pitcher") {
        search_field_pitcher_Dropdown(); // this could be any Widget
      } else {
        search_field_othervalue_Dropdown(); // this could be any Widget
      }
    });
  }

  Widget search_field_pitcher_Dropdown() {
    return StatefulBuilder(builder: (context, setState) {
      return Container(
          height: 46,
          width: 150,
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
              dropdownWidth: 150,
              dropdownPadding: null,
              dropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.white,
              ),
              value: search_field_seletected_value,
              underline: Container(),
              isExpanded: true,
              //itemHeight: 50.0,
              icon: Icon(Icons.keyboard_arrow_down,
                  size: 25, color: AppColors.grey_text_color),

              style: TextStyle(fontSize: 13.0, color: Colors.grey[700]),
              items: itemsField_if_Pitcher_selected_dropdown.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: CommonText(
                      text: item,
                      fontSize: 13,
                      color: AppColors.black,
                      fontWeight: FontWeight.w500),
                );
              }).toList(),
              hint: const CommonText(
                  text: "Field",
                  fontSize: 13,
                  color: AppColors.black,
                  fontWeight: FontWeight.w500),
              onChanged: (String? newValue) {
                setState(() => search_field_seletected_value = newValue);
                if (kDebugMode) {
                  print(search_field_seletected_value.toString());
                }
              },
            ),
          ));
    });
  }


  Widget search_field_othervalue_Dropdown() {
    return StatefulBuilder(builder: (context, setState) {
      return Container(
          height: 46,
          width: 150,
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
              value: search_field_other_seletected_value,
              underline: Container(),
              isExpanded: true,
              //itemHeight: 50.0,
              icon: Icon(Icons.keyboard_arrow_down,
                  size: 25, color: AppColors.grey_text_color),
              style: TextStyle(fontSize: 15.0, color: Colors.grey[700]),
              items: itemsField_if_othervalue_selected_dropdown.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: CommonText(
                      text: item,
                      fontSize: 13,
                      color: AppColors.black,
                      fontWeight: FontWeight.w500),
                );
              }).toList(),
              hint: const CommonText(
                  text: "Field",
                  fontSize: 13,
                  color: AppColors.black,
                  fontWeight: FontWeight.w500),
              onChanged: (String? newValue) {
                setState(() => search_field_other_seletected_value = newValue);
                if (kDebugMode) {
                  print(search_field_other_seletected_value.toString());
                }
              },
            ),
          ));
    });
  }

  Widget search_field_default_Dropdown() {
    return StatefulBuilder(builder: (context, setState) {
      return Container(
          height: 46,
          width: 150,
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
              value: search_field_seletected_value,
              underline: Container(),
              isExpanded: true,
              //itemHeight: 50.0,
              icon: Icon(Icons.keyboard_arrow_down,
                  size: 25, color: AppColors.grey_text_color),
              style: TextStyle(fontSize: 15.0, color: Colors.grey[700]),
              items: itemsfield_multiple_selected_dropdown.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: CommonText(
                      text: item,
                      fontSize: 13,
                      color: AppColors.black,
                      fontWeight: FontWeight.w500),
                );
              }).toList(),
              hint: const CommonText(
                  text: "select Field",
                  fontSize: 15,
                  color: AppColors.black,
                  fontWeight: FontWeight.w500),
              onChanged: (String? newValue) {
                setState(() => search_field_seletected_value = newValue);
                if (kDebugMode) {
                  print(search_field_seletected_value.toString());
                }
              },
            ),
          ));
    });
  }

  Widget textfield_search_value() {
    return Container(
      width: 120,
      child: TextFieldView(
        controller: Search_Value_Controller,
        textInputAction: TextInputAction.next,
        type: TextInputType.number,
        text: "value",
      ),
    );
  }

  Widget outlinebutton_search_add() {
    return Card(
      shape: RoundedRectangleBorder(
          side: const BorderSide(
              width: 1, color: AppColors.dark_blue_button_color),
          borderRadius: BorderRadius.circular(10)),
      child: IconButton(
        iconSize: 15,
        icon: const Icon(
          Icons.add,
          color: AppColors.dark_blue_button_color,
        ),
        onPressed: () {
          setState(
                () {
              //count++;
              isaddtap == true;
              counter++;
              print("this is counter ===>$counter");
              search_additional_counter_list.add(counter - 1);
              print(
                  "this is additional list==>${search_additional_counter_list.toString()}");
            },
          );
          print("this is demo");
          //search_addtionalfield_raw_removebutton();
          // search_additionalfield_add_listviewbuilder();
          print("this is demo2");
        },
      ),
    );
  }

  Widget outlinebutton_search_remove(index) {
    return Card(
      shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: AppColors.dark_red),
          borderRadius: BorderRadius.circular(10)),
      child: IconButton(
        iconSize: 15,
        icon: const Icon(
          Icons.close,
          color: AppColors.dark_red,
        ),
        onPressed: () {
          setState(
                () {
              isaddtap == false;
              counter--;
              search_additional_counter_list.removeAt(index);
              //count++;
            },
          );
        },
      ),
    );
  }

  Widget search_addtionalfield_raw_addbutton() {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          search_condition_Dropdown(),
          textfield_search_value(),
          outlinebutton_search_add(),
        ]),
      ],
    );
  }

  Widget search_addtionalfield_raw_removebutton(index) {
    print("this demo34");
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      search_condition_Dropdown(),
      textfield_search_value(),
      outlinebutton_search_remove(index),
    ]);
  }

  Widget search_additionalfield_add_listviewbuilder(index) {
    print(
        "this is called listview==> ${search_additional_counter_list.length}");
    return Column(
      children: List.generate(
        growable: true,
        search_additional_counter_list.length,
            (index) {
          return search_addtionalfield_raw_removebutton(
              search_additional_counter_list[index]);
        },
      ),
    );
    /*ListView.builder(
        shrinkWrap: true,
        itemCount: search_additional_counter_list.length,
        itemBuilder: (context, index) {
          print("this is called listview inside==> ${search_additional_counter_list[index]}");
          //return search_addtionalfield_raw_addbutton();
          return search_addtionalfield_raw_removebutton();
        });*/
  }

  Future<bool> _checkPermission() async {
    if (platform == TargetPlatform.android) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath())!;

    print(_localPath);
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  Future<String?> _findLocalPath() async {
    if (platform == TargetPlatform.android) {
      return "/sdcard/download/";
    } else {
      var directory = await getApplicationDocumentsDirectory();
      return directory.path + Platform.pathSeparator + 'Download';
    }
  }

  Widget outlinebuton_search_clear() {
    return OutlinedButton(
        child: const CommonText(
          text: "Clear",
          fontSize: 14,
          color: AppColors.dark_red,
          fontWeight: FontWeight.w400,
        ),
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          side: BorderSide(width: 1.0, color: AppColors.dark_red),
        ),
        onPressed: () {
          setState(() {
            search_position_selecte_value = null;
            search_field_seletected_value = null;
            search_position_selecte_value = null;
            search_condition_selected_value = null;
            search_field_other_seletected_value = null;
            Search_Value_Controller.clear();
          });
          /*Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => const NewScreen())),*/
        }
    );
  }

  Widget seach_apply_clear_button() {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      outlinebuton_search_apply(),
      SizedBox(
        width: 5,
      ),
      outlinebuton_search_clear()
    ]);
  }
}
