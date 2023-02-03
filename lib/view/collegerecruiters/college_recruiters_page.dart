import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:custom_date_range_picker/custom_date_range_picker.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pachub/common_widget/button.dart';
import 'package:pachub/models/Profile_model.dart';
import 'package:pachub/models/admin_athletes_model.dart';
import 'package:pachub/models/admin_recruiter_model.dart';
import 'package:pachub/services/request.dart';
import 'package:pachub/view/dashboard/homescreen.dart';
import 'package:pachub/view/dashboard/tab_deatil_screen.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Utils/appcolors.dart';
import '../../Utils/appstring.dart';
import '../../Utils/constant.dart';
import '../../Utils/images.dart';
import '../../app_function/MyAppFunction.dart';
import '../../common_widget/TextField.dart';
import '../../common_widget/appbar.dart';
import '../../common_widget/bottom_bar.dart';
import '../../common_widget/customloader.dart';
import '../../common_widget/drawer.dart';
import 'package:http/http.dart' as http;

import '../../common_widget/nodatafound_page.dart';
import '../../common_widget/textstyle.dart';
import '../../config/preference.dart';
import '../../models/recruiter_model_response.dart';

class Recruiters extends StatefulWidget {
  const Recruiters({Key? key}) : super(key: key);

  @override
  State<Recruiters> createState() => _RecruitersState();
}

class _RecruitersState extends State<Recruiters> {
  int _page = 0;
  final int _limit = 30;
  int selectingIndex = 10;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  late ScrollController _controller;
  List datalist = [];
  List<Result> searchList = [];
  List<Result> listModel = [];
  List adminClglist = [];
  List<Record> adminClgListModel = [];
  bool visiblity = false;
  TextEditingController searchcontroller = TextEditingController();
  List? trainerList;
  String? trainer;
  String searchDateString = "";
  DateTime? startDate;
  DateTime? endDate;
  String? stDate;
  String? edDate;
  final _formKey = GlobalKey<FormState>();
  TextEditingController userController = TextEditingController();
  TextEditingController plyeridController = TextEditingController();
  TextEditingController approvalCommentController = TextEditingController();
  TextEditingController SendMessageController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  String? accessToken;
  String? clientTrainerID;
  List itemList = [];
  List uniquelist = [];
  var models = <String>{};
  String? option = "1";
  List optionList = [];
  bool isaddtap = false;
  String? selectSportsDropDownValue;
  var group;



  // final List<String> optionAll_List = [
  //   "All Positions",
  //   "Pitcher",
  //   "Catcher",
  // ];
  List pitcherList = [];
  List catcherList = [];
  List outfieldList = [];
  List infieldList = [];
  List universalList = [];
  bool forceWebView = false;
  List selectSportsResult = [];
  List allSports = [{'name': "All Sports", 'id': 0}];
  List allSportsList = [];
  

  String searchString = "";
  String? search_position_selecte_value = "All Status";
  String? userId;
  final List<String> itemsStatus_dropdown = [
    'All Status',
    'Approved',
    'Rejected',
    'Pending',
  ];




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
  void initState() {
    setState(() {
      accessToken = PreferenceUtils.getString("accesstoken");
    });
    super.initState();
    admmingetcollegerecruiters(stDate, edDate);
    getTrainerList("1");
    SelcteSportsList();
    getcollegerecruiters();
  }

  // late final Future  myFuture = getSearchByDateAthleteListApi(accessToken, _page, _limit, "4", stDate, edDate);
  late final Future myFutureList =   getAthleteListApi(accessToken, _page, _limit, "4");


  @override
  void dispose() {
    SendMessageController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      edgeOffset: 20,
      onRefresh: () async{
        await Future.delayed(Duration(milliseconds: 1500));
        setState(() {
          getAthleteListApi(accessToken, _page, _limit, "4");
          getManageSubscription_ALL_LISTING(accessToken);
          getcollegerecruiters();
          admmingetcollegerecruiters(stDate, edDate);
          getTrainerList("1");
          SelcteSportsList();
        });
      },
      child: Scaffold(
        appBar: Appbar(
          text: AppString.choachrecuiters,
          onClick: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        body: _isFirstLoadRunning
            ? Center(
                child: CustomLoader(),
              )
            : PreferenceUtils.getString("plan_login") == "Free"
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context,
                                  MaterialPageRoute(
                                      builder: (_) => BottomBar(selectedIndex: 6)));
                            },
                            child: CommonText(
                                text: "Upgrade",
                                fontSize: 15,
                                color: AppColors.dark_blue_button_color,
                                fontWeight: FontWeight.w600),
                          ),
                          CommonText(
                              text: " Your Subscription",
                              fontSize: 15,
                              color: AppColors.black_txcolor,
                              fontWeight: FontWeight.w400),
                        ],
                      ),
                        SizedBox(height: 5,),
                        CommonText(
                            text: "ToView More Information.",
                            fontSize: 15,
                            color: AppColors.black_txcolor,
                            fontWeight: FontWeight.w400),
                      ],

                    ),
                  )
                : showlistrolewise(),
        drawer: const Drawer(
          child: AppDrawer(),
        ),
      ),
    );
  }

  Widget serachbarnew() {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(top: 0),
      decoration: BoxDecoration(
        color: const Color(0xffF0F0F0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: searchcontroller,
              onChanged: (string) {
                onSearchTextChanged(searchcontroller.text.toString());
              },
              /*onChanged: (string) {
                setState(() {
                  searchList = listModel
                      .where(
                        (u) => (u.organizationName!.toLowerCase().contains(
                      string.toLowerCase(),
                    )||  u.organizationCity!.toLowerCase().contains(
                          string.toLowerCase()
                        )||u.organizationState!.toLowerCase().contains(
                          string.toLowerCase(),
                        )                      ),
                  ).toList();
                });
                },*/
              onEditingComplete: () {},
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Search",
                suffixIcon: GestureDetector(
                  onTap: () {},
                  child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: SvgPicture.asset(serach_suffix_icon)),
                ),
                prefixIcon: GestureDetector(
                  onTap: () {},
                  child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: SvgPicture.asset(serach_icon)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget showlistrolewise() {
    if ((PreferenceUtils.getString('role') == "admin")) {
      //return LeaveRequest_Listview_BUilder_ForMnager();
      //return Admin_Listview_BUilder();
      return Admins_listViewRecruiters();
    }
    /* else if((PreferenceUtils.getString('role') == "employee")){
      return LeaveRequest_Listview_BUilder_ForMnager();
      //return all_EMP_MANG_LeaveRequest_Listview_BUilder_forcompony();
    }*/
    else {
      return Coach_listViewRecruiters();
    }
  }

  Widget totaltx() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 4, bottom: 10),
      child: Container(
        alignment: Alignment.topLeft,
        child: CommonText(
          text: "Total  ${datalist.length.toString()} colleges",
          color: AppColors.grey_text_color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget Coach_listViewRecruiters() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            listModel.isEmpty
                ? Container()
                : Column(
                    children: [
                      // serachbarnew(),
                      // totaltx(),
                    ],
                  ),
            Expanded(
                child: _isFirstLoadRunning
                    ? listModel.isEmpty
                        ? Align(
                            alignment: Alignment.center,
                            child: CustomLoader(),
                          )
                        : const Align(
                            alignment: Alignment.center,
                            child: NoDataFound(),
                          )
                    : searchList.length != 0 || searchcontroller.text.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            // controller: _controller,
                            //itemCount: datalist.length,
                            itemCount: searchList.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                  onTap: () {
                                    // Get.to(const CollegeRecruitersDetailPage());
                                  },
                                  child: coach_search(index));
                            })
                        :  ListView.builder(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            // controller: _controller,
                            //itemCount: datalist.length,
                            itemCount: datalist.length,
                            itemBuilder: (context, index) {
                              // print("plan ====>>>> ${listModel[index].subscription}");
                              return Column(
                                children: [
                                  InkWell(
                                      onTap: () {
                                        // Get.to(const CollegeRecruitersDetailPage());
                                      },
                                      child: Coach_recruiter_raw(index)),
                                ],
                              );
                            })
            ),
            // when the _loadMore function is running
            if (_isLoadMoreRunning == true)
              Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 40),
                  child: Center(
                    child: CustomLoader(),
                  )),

            // When nothing else to load
            if (_hasNextPage == false)
              Container(
                padding: const EdgeInsets.only(top: 30, bottom: 40),
                color: Colors.amber,
                child: const Center(
                  child: Text('You have fetched all of the content'),
                ),
              ),
          ]),
    );
  }

  _buildRow(image, text, color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
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

  Widget coach_search(int index) {
    return Card(
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      shape: RoundedRectangleBorder(
          side: const BorderSide(width: 0.1),
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 40,
              width: 40,
              child: Image.asset("assets/images/recruter.png"),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8, top: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                        text:
                            //datalist[index]["organizationName"]?? "No Name Found",
                            searchList[index].displayName ?? "",
                        fontSize: 16,
                        color: AppColors.black_txcolor,
                        fontWeight: FontWeight.w700),
                    const SizedBox(height: 2),
                    CommonText(
                        text:
                            //"${datalist[index]["bio"] ?? "No Name Found"}",
                            "${searchList[index].bio ?? ""}",
                        fontSize: 10,
                        color: AppColors.grey_hint_color,
                        fontWeight: FontWeight.w400),
                    const SizedBox(height: 9),
                    _buildRow(
                      location_icon,
                      //'${"${datalist[index]["city"] ?? "No Information"}" + ',' + "${datalist[index]["state"] ?? "No Information"}"}',
                      '${"${searchList[index].city ?? ""}" + ',' + "${searchList[index].organizationState.toString() ?? ""}"}',
                      AppColors.black_txcolor,
                    ),
                    const SizedBox(height: 7),
                    _buildRow(
                      call_icon,
                      //"${datalist[index].phoneNumber?? "No Information"}",
                      "${searchList[index].contact ?? ""}",
                      AppColors.black_txcolor,
                    ),
                    const SizedBox(height: 7),
                    _buildRow(
                      world_icon,
                      'www.howard.edu',
                      AppColors.blue_text_Color,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 13,
              width: 11,
              child: searchList[index].isBookMarked == false
                  //child: datalist[index]["isBookMarked"] == false
                  ? Image.asset(collegerecruitersave)
                  : Image.asset(bookmarktrue),
            ),
          ],
        ),
      ),
    );
  }

  Widget Coach_recruiter_raw(int index) {
    return Card(
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      shape: RoundedRectangleBorder(
          side: const BorderSide(width: 0.1),
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(1000.0),
              child: CachedNetworkImage(
                height: 50,
                width: 50,
                fit: BoxFit.cover,
                imageUrl: datalist[index]["image"] ?? "",
                placeholder: (context, url) => CustomLoader(),
                errorWidget: (context, url, error) => SizedBox(
                    height: 40, width: 40, child: Image.asset(avatarImage)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8, top: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    datalist[index]["coachRole"] != null ? CommonText(
                        text: "${datalist[index]["displayName"] ?? " "} - ${datalist[index]["coachRole"] ?? ""} (${datalist[index]["organizationName"] ?? ""})",
                        fontSize: 16,
                        color: AppColors.black_txcolor,
                        fontWeight: FontWeight.w700) : datalist[index]["organizationName"] != null ? CommonText(
                        text: "${datalist[index]["displayName"] ?? " "}  (${datalist[index]["organizationName"] ?? ""})",
                        fontSize: 16,
                        color: AppColors.black_txcolor,
                        fontWeight: FontWeight.w700) : CommonText(
                        text: "${datalist[index]["displayName"] ?? " "}",
                        fontSize: 16,
                        color: AppColors.black_txcolor,
                        fontWeight: FontWeight.w700),
                    const SizedBox(height: 2),
                    CommonText(
                        text: datalist[index]["bio"] ?? "",
                        fontSize: 10,
                        color: AppColors.grey_hint_color,
                        fontWeight: FontWeight.w400),
                    const SizedBox(height: 9),
                    _buildRow(
                      location_icon,
                      '${"${datalist[index]["organizationAddress"] ?? ""}" + ','"${datalist[index]["organizationCity"] ?? ""}" + ',' + "${datalist[index]["organizationState"] ?? ""}"',' + "${datalist[index]["organizationZipcode"] ?? ""}"}',
                      AppColors.black_txcolor,
                    ),
                    const SizedBox(height: 7),
                    _buildRow(
                      call_icon,
                      //"${datalist[index].phoneNumber?? "No Information"}",
                      "${datalist[index]["hidePhone"] == 1 ? datalist[index]["contact"]?.replaceRange(5, 14, "xxxxxxxx") : datalist[index]["contact"]}",
                      AppColors.black_txcolor,
                    ),
                    const SizedBox(height: 7),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                SizedBox(
                  height: 13,
                  width: 11,
                  child: !datalist[index]["isBookMarked"]!
                      ? InkWell(
                          onTap: () {
                            setState(() {
                              datalist[index]["isBookMarked"] =
                                  !datalist[index]["isBookMarked"]!;
                              Unbookmarklisttickapi(
                                  datalist[index]["userID"].toString(), context);
                            });
                          },
                          child: Image.asset(collegerecruitersave))
                      : InkWell(
                          onTap: () {
                            setState(() {
                              datalist[index]["isBookMarked"] =
                                  !datalist[index]["isBookMarked"]!;
                              Unbookmarklisttickapi(
                                  datalist[index]["userID"].toString(), context);
                            });
                          },
                          child: Image.asset(bookmarktrue)),
                ),
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
                              SvgPicture.asset(briefcaseIcon,
                                  color: AppColors.black_txcolor),
                              const SizedBox(width: 10),
                              const CommonText(
                                  text: "Coach/Recruiters Details",
                                  fontSize: 15,
                                  color: AppColors.black_txcolor,
                                  fontWeight: FontWeight.w400),
                            ],
                          ),
                        ),
                      ];
                    },
                    onSelected: (value) async {
                      if (value == 0) {
                        print("Send Message menu is selected.");
                        SendMessageController.clear();
                        SendMessagedialog("${datalist[index]["userID"]}");
                      } else  {
                        print("user ID =====>>> ${datalist[index]["userID"]}");
                        await manageAditionalInformationList("${datalist[index]["userID"]}");
                        _UserDetails("${datalist[index]["userID"]}", "${datalist[index]["sport"]}",datalist[index]["hidePhone"], datalist[index]["hideEmail"]);
                      }
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  onSearchTextChanged(String text) async {
    searchList.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    listModel.forEach((userDetail) {
      if (userDetail.displayName!.toLowerCase().contains(text) ||
          userDetail.organizationCity!.toLowerCase().contains(text))
        searchList.add(userDetail);
    });
    setState(() {});
  }

  Widget Admins_listViewRecruiters() {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
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
                                controller: searchcontroller,
                                decoration:  InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 10, bottom: 5),
                                  border: InputBorder.none,
                                  hintText: "Search",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Row(
                      children: [
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
                                itemPadding:
                                    const EdgeInsets.only(left: 14, right: 14),
                                dropdownMaxHeight: 200,
                                dropdownWidth: 200,
                                dropdownPadding: null,
                                dropdownDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: Colors.white,
                                ),
                                value: search_position_selecte_value,
                                underline: Container(),
                                isExpanded: true,
                                //itemHeight: 50.0,
                                icon: const Icon(Icons.keyboard_arrow_down,
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
                                    text: "All Status",
                                    fontSize: 15,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w500),
                                onChanged: (String? newValue) {
                                  setState(() =>
                                      search_position_selecte_value = newValue);
                                  if (kDebugMode) {
                                    print(
                                        "this is serach postion selected==> $search_position_selecte_value");
                                  }
                                },
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 45,
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
                                onTap: () {
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

                                        // visiblity=true;
                                        // myFuture;
                                      });
                                      setState(() {
                                        dateController.text = '${startDate != null ? DateFormat("yMMMMd").format(startDate!) : '-'} to ${endDate != null ? DateFormat("yMMMMd").format(endDate!) : '-'}';
                                        stDate = startDate != null ? DateFormat("yyyy-MM-dd").format(startDate!) : '-';
                                        edDate = startDate != null ? DateFormat("yyyy-MM-dd").format(endDate!) : '-';
                                        admmingetcollegerecruiters(stDate, edDate);
                                        print(
                                            "controller ==================<><><> ${dateController.text}");
                                        print(
                                            "StartDate ==================<><><> $stDate");
                                        print(
                                            "endDate ==================<><><> $edDate");
                                      });
                                    },
                                    onCancelClick: () {
                                      setState(() {
                                        endDate = null;
                                        startDate = null;
                                      });
                                      setState(() {
                                        dateController.text = "";
                                        print(
                                            "controller ==================<><><> ${dateController.text}");
                                      });
                                    },
                                  );
                                },
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.only(left: 10, bottom: 5),
                                  border: InputBorder.none,
                                  hintText: "Search by date range",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    searchcontroller.text.isEmpty && search_position_selecte_value == "All Status" && dateController.text.isEmpty  ? Container() : SizedBox(width: 15),
                    searchcontroller.text.isEmpty && search_position_selecte_value == "All Status" && dateController.text.isEmpty  ? Container() :  OutlinedButton(
                        child: const CommonText(
                          text: "Clear",
                          fontSize: 14,
                          color: AppColors.dark_red,
                          fontWeight: FontWeight.w400,
                        ),
                        style: OutlinedButton.styleFrom(
                          shape:
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                          side: BorderSide(width: 1.0, color: AppColors.dark_red),
                        ),
                        onPressed: () {
                          setState(() {
                            searchcontroller.clear();
                            search_position_selecte_value = "All Status";
                            selectSportsDropDownValue = "All Sports";
                            dateController.clear();
                          });
                        }

                      /*Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const NewScreen())),*/
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
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
                        dropdownWidth: 180,
                        dropdownPadding: null,
                        dropdownDecoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(14),
                          color: Colors.white,
                        ),
                        value: selectSportsDropDownValue,
                        underline: Container(),
                        isExpanded: true,
                        itemHeight: 35.0,
                        style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.grey[700]),
                        items: allSportsList.map((item) {
                          return DropdownMenuItem(
                            value: item["name"].toString(),
                            child: CommonText(
                                text: item["name"].toString(),
                                fontSize: 14,
                                color: AppColors.black,
                                fontWeight: FontWeight.w500),
                          );
                        }).toList(),
                        hint: const CommonText(
                            text: "All Sports",
                            fontSize: 14,
                            color: AppColors.black,
                            fontWeight: FontWeight.w500),
                        onChanged:
                            (newValue) {
                          setState(() => selectSportsDropDownValue = newValue);
                          if (kDebugMode) {
                            print("option========>>>>>> $selectSportsDropDownValue");
                          }
                          if (kDebugMode) {
                            print("optionList $selectSportsDropDownValue");
                          }
                        },
                      ),
                    )),
              ),
              FutureBuilder(
                future: dateController.text.isEmpty ? getAthleteListApi(accessToken, _page, _limit, "4") : getSearchByDateAthleteListApi(accessToken, _page, _limit, "4", stDate, edDate),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    const Center(
                      child: NoDataFound(),
                    );
                  }
                  if (snapshot.hasData) {
                    List<Records>? records = snapshot.data?.records;
                    if (records != null) {
                      if (search_position_selecte_value == "All Status") {
                        return ListView.builder(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemCount: records.length,
                            itemBuilder: (context, index) {
                              return search_position_selecte_value == "All Status"
                                  ? Column(
                                children: [
                                  if(selectSportsDropDownValue == null)
                                    Admin_Collegerecruiter_Raw(records[index]),
                                  if(selectSportsDropDownValue == "All Sports")
                                    Admin_Collegerecruiter_Raw(records[index]),
                                  if(records[index].sport == selectSportsDropDownValue)
                                    Admin_Collegerecruiter_Raw(records[index]),
                                ],
                              )
                                  : Center(child: Text("No Recored found"));
                            });
                      } else if (search_position_selecte_value == "Approved") {
                        return  ListView.builder(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemCount: records.length,
                            itemBuilder: (context, index) {
                              return records[index].status == "Approved"
                                  ? Column(
                                children: [
                                  if(selectSportsDropDownValue == null)
                                    Admin_Collegerecruiter_Raw(records[index]),
                                  if(selectSportsDropDownValue == "All Sports")
                                    Admin_Collegerecruiter_Raw(records[index]),
                                  if(records[index].sport == selectSportsDropDownValue)
                                    Admin_Collegerecruiter_Raw(records[index]),
                                ],
                              )
                                  : Container();
                            });
                      } else if (search_position_selecte_value == "Rejected") {
                        return  ListView.builder(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemCount: records.length,
                            itemBuilder: (context, index) {
                              if (records[index].status == "Rejected") {
                                return Column(
                                  children: [
                                    if(selectSportsDropDownValue == null)
                                      Admin_Collegerecruiter_Raw(records[index]),
                                    if(selectSportsDropDownValue == "All Sports")
                                      Admin_Collegerecruiter_Raw(records[index]),
                                    if(records[index].sport == selectSportsDropDownValue)
                                      Admin_Collegerecruiter_Raw(records[index]),
                                  ],
                                );
                              } else {
                                return Container();
                              }
                            });
                      } else if (search_position_selecte_value == "Pending") {
                        return  ListView.builder(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemCount: records.length,
                            itemBuilder: (context, index) {
                              if(records[index].status == "Pending") {
                                return  Column(
                                  children: [
                                    if(selectSportsDropDownValue == null)
                                      Admin_Collegerecruiter_Raw(records[index]),
                                    if(selectSportsDropDownValue == "All Sports")
                                      Admin_Collegerecruiter_Raw(records[index]),
                                    if(records[index].sport == selectSportsDropDownValue)
                                      Admin_Collegerecruiter_Raw(records[index]),
                                  ],
                                );
                              } else {
                                return Container();
                              }
                            });
                      } else {
                        Center(
                          child: NoDataFound(),
                        );
                      }
                    }
                  } else {
                    return CustomLoader();
                  }
                  return const Center(
                    child: NoDataFound(),
                  );
                },
              ),
            ]),
      ),
    );
  }

  Widget Admin_Collegerecruiter_Raw(Records record) {
    DateTime joiningDate = DateTime.parse(record.joiningDate.toString());
    String displayname= "${record.displayName.toString()}";
    return searchcontroller.text.isEmpty ?
    Container(
      margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
      child: Card(
        shape: RoundedRectangleBorder(
            side: const BorderSide(width: 0.1),
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CommonText(
                          text: displayname.toTitleCase() ?? "",
                          fontSize: 15,
                          color: AppColors.black_txcolor,
                          fontWeight: FontWeight.bold),
                      const SizedBox(height: 8),
                      _CommonRow("REQUEST DATE : ", DateFormat('yMMMd').format(joiningDate)),
                      const SizedBox(height: 8),
                      record.approvalDate != null ? _CommonRow("APPROVAL DATE : ",  DateFormat('yMMMd').format(DateTime.parse(record.approvalDate.toString())))
                          : _CommonRow("APPROVAL DATE : ", ""),
                      const SizedBox(height: 8),
                      _CommonRow("SUBSCRIPTION : ", record.subscription ?? ""),
                      const SizedBox(height: 8),
                      _CommonRow("PRICE : ", " ${"\$${record.price}" ?? ""}"),
                      const SizedBox(height: 8),
                      _CommonRow("SOLICITED NAME : ", record.solicitedName ?? ""),
                      const SizedBox(height: 8),
                      _CommonRow("SPORT : ", record.sport ?? ""),
                      const SizedBox(height: 8),
                      _CommonRow("TRAINER : ", record.trainerName ?? ""),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                              height: 20,
                              width: 64.52,
                              decoration: BoxDecoration(
                                color: record.status == "Pending"
                                    ? AppColors.onHold
                                    : record.status == "Rejected"
                                    ? AppColors.rejected
                                    : AppColors
                                    .approvedbackground_Color,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child: CommonText(
                                  text: record.status.toString(),
                                  fontSize: 10,
                                  color: record.status == "Pending"
                                      ? AppColors.orange
                                      : record.status == "Rejected"
                                      ? AppColors.onHoldTextColor
                                      : AppColors.approvedtext_Color,
                                  fontWeight: FontWeight.w400,
                                ),
                              )),
                          const SizedBox(width: 15),
                          record.status == "Pending"
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
                                        SvgPicture.asset(
                                            profile_icon,
                                            color: AppColors
                                                .black_txcolor),
                                        const SizedBox(width: 10),
                                        const CommonText(
                                            text: "User Details",
                                            fontSize: 15,
                                            color: AppColors
                                                .black_txcolor,
                                            fontWeight:
                                            FontWeight.w400),
                                      ],
                                    ),
                                  ),
                                  /*PopupMenuItem<int>(
                                                value: 1,
                                                child: Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                        userPlusIcon,
                                                        color: AppColors
                                                            .black_txcolor),
                                                    const SizedBox(width: 10),
                                                    const CommonText(
                                                        text: "Assign Trainer",
                                                        fontSize: 15,
                                                        color: AppColors
                                                            .black_txcolor,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ],
                                                ),
                                              ),*/
                                  PopupMenuItem<int>(
                                    value: 1,
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                            approveIcon,
                                            color: AppColors
                                                .black_txcolor),
                                        const SizedBox(width: 10),
                                        const CommonText(
                                            text: "Approve Request",
                                            fontSize: 15,
                                            color: AppColors
                                                .black_txcolor,
                                            fontWeight:
                                            FontWeight.w400),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem<int>(
                                    value: 2,
                                    child: Container(
                                      height: 40,
                                      width: double.infinity,
                                      color: AppColors.dark_red,
                                      child: const Center(
                                        child: CommonText(
                                            text:
                                            "Cancel Subscription",
                                            fontSize: 15,
                                            color: AppColors.white,
                                            fontWeight:
                                            FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ];
                              },
                              onSelected: (value) {
                                if (value == 0) {
                                  print(
                                      "My account menu is selected.");
                                  manageAditionalInformationList(
                                      "${record.userID}");
                                  _admin_UserDeatil(
                                      "${record.userID}",
                                    "${record.sport}",
                                  );
                                }
                                if (value == 1) {
                                  print(
                                      "My account menu is selected.");
                                  _approveRequest(
                                    "${record.displayName}",
                                    record.userID,
                                    "${record.subscription}",
                                    "${record.status}",
                                  );
                                  approvalCommentController.clear();
                                }
                                if (value == 2) {
                                  print(
                                      "My account menu is selected.");
                                  _cancelSubscriptionRequest(
                                      "${record.displayName}",
                                      record.userID.toString());
                                  approvalCommentController.clear();
                                }
                              },
                            ),
                          )
                              : Container(
                            width: 20,
                            child: record.profileLink != null
                                ? PopupMenuButton(
                                iconSize: 18,
                                itemBuilder: (context) {
                                  return [
                                    PopupMenuItem<int>(
                                      value: 0,
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                              profile_icon,
                                              color: AppColors
                                                  .black_txcolor),
                                          const SizedBox(
                                              width: 10),
                                          const CommonText(
                                              text:
                                              "User Details",
                                              fontSize: 15,
                                              color: AppColors
                                                  .black_txcolor,
                                              fontWeight:
                                              FontWeight
                                                  .w400),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem<int>(
                                      value: 1,
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                              linkIcon,
                                              color: AppColors
                                                  .black_txcolor),
                                          const SizedBox(
                                              width: 10),
                                          const CommonText(
                                              text:
                                              "Profile Link",
                                              fontSize: 15,
                                              color: AppColors
                                                  .black_txcolor,
                                              fontWeight:
                                              FontWeight
                                                  .w400),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem<int>(
                                      value: 2,
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                              addUserIcon,
                                              color: AppColors
                                                  .black_txcolor),
                                          const SizedBox(
                                              width: 10),
                                          const CommonText(
                                              text:
                                              "Change Trainer",
                                              fontSize: 15,
                                              color: AppColors.black_txcolor,
                                              fontWeight: FontWeight.w400),
                                        ],
                                      ),
                                    ),
                                  ];
                                },
                                onSelected: (value) async {

                                  if (value == 0) {
                                    manageAditionalInformationList(
                                        "${record.userID}");
                                    _admin_UserDeatil(
                                        "${record.userID}",
                                      "${record.sport}",
                                    );
                                  } else if (value == 1) {
                                    await profile_lounch(record
                                        .profileLink
                                        .toString());
                                    _launchUrl(record
                                        .profileLink
                                        .toString());
                                  } else if (value == 2) {
                                    if (kDebugMode) {
                                      print("Settings menu is selected.");
                                    }
                                    _changeTrainer(
                                        "${record.displayName}",
                                        "${record.trainerName}",
                                        "${record.status}",
                                        record.userID,
                                        record.trainerID.toString());
                                    PreferenceUtils.remove("coachTrainer");
                                  }
                                })
                                : record.status == "Approved"
                                ? PopupMenuButton(
                                iconSize: 18,
                                itemBuilder: (context) {
                                  return [
                                    PopupMenuItem<int>(
                                      value: 0,
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                              profile_icon,
                                              color: AppColors
                                                  .black_txcolor),
                                          const SizedBox(
                                              width: 10),
                                          const CommonText(
                                              text:
                                              "User Details",
                                              fontSize: 15,
                                              color: AppColors
                                                  .black_txcolor,
                                              fontWeight:
                                              FontWeight
                                                  .w400),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem<int>(
                                      value: 1,
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                              addUserIcon,
                                              color: AppColors
                                                  .black_txcolor),
                                          const SizedBox(
                                              width: 10),
                                          const CommonText(
                                              text:
                                              "Change Trainer",
                                              fontSize: 15,
                                              color: AppColors
                                                  .black_txcolor,
                                              fontWeight:
                                              FontWeight
                                                  .w400),
                                        ],
                                      ),
                                    ),
                                  ];
                                },
                                onSelected: (value) {
                                  if (value == 0) {
                                    if (kDebugMode) {
                                      print(
                                          "My account menu is selected.");
                                    }
                                    manageAditionalInformationList(
                                        "${record.userID}");
                                    _admin_UserDeatil(
                                        "${record.userID}",
                                      "${record.sport}",
                                    );
                                  } else if (value == 1) {
                                    if (kDebugMode) {
                                      print(
                                          "Settings menu is selected.");
                                    }
                                    _changeTrainer(
                                        "${record.displayName}",
                                        "${record.trainerName}",
                                        "${record.status}",
                                        record.userID,
                                        record.trainerID.toString());
                                    PreferenceUtils.remove("coachTrainer");
                                  }
                                })
                                : PopupMenuButton(
                                iconSize: 18,
                                itemBuilder: (context) {
                                  return [
                                    PopupMenuItem<int>(
                                      value: 0,
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                              profile_icon,
                                              color: AppColors
                                                  .black_txcolor),
                                          const SizedBox(
                                              width: 10),
                                          const CommonText(
                                              text:
                                              "Rejected Reason",
                                              fontSize: 15,
                                              color: AppColors
                                                  .black_txcolor,
                                              fontWeight:
                                              FontWeight
                                                  .w400),
                                        ],
                                      ),
                                    ),
                                  ];
                                },
                                onSelected: (value) {
                                  manageAditionalInformationList(
                                      "${record.userID}");
                                  _admin_RejectedReason(
                                    "${record.userID}",
                                    "${record.comment}",
                                  );
                                }),
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
    ) : record.displayName!.toLowerCase().contains(searchString) || record.subscription!.toLowerCase().contains(searchString)
        ? Container(
            margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
            child: Card(
              shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 0.1),
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CommonText(
                                text: displayname.toTitleCase() ?? "",
                                fontSize: 15,
                                color: AppColors.black_txcolor,
                                fontWeight: FontWeight.bold),
                            const SizedBox(height: 8),
                            _CommonRow("REQUEST DATE : ", DateFormat('yMMMd').format(joiningDate)),
                            const SizedBox(height: 8),
                            record.approvalDate != null ? _CommonRow("APPROVAL DATE : ",  DateFormat('yMMMd').format(DateTime.parse(record.approvalDate.toString())))
                                : _CommonRow("APPROVAL DATE : ", ""),
                            const SizedBox(height: 8),
                            _CommonRow("SUBSCRIPTION : ", record.subscription ?? ""),
                            const SizedBox(height: 8),
                            _CommonRow("PRICE : ", " ${"\$${record.price}" ?? ""}"),
                            const SizedBox(height: 8),
                            _CommonRow("SOLICITED NAME : ", record.solicitedName ?? ""),
                            const SizedBox(height: 8),
                            _CommonRow("SPORT : ", record.sport ?? ""),
                            const SizedBox(height: 8),
                            _CommonRow("TRAINER : ", record.trainerName ?? ""),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                    height: 20,
                                    width: 64.52,
                                    decoration: BoxDecoration(
                                      color: record.status == "Pending"
                                          ? AppColors.onHold
                                          : record.status == "Rejected"
                                              ? AppColors.rejected
                                              : AppColors
                                                  .approvedbackground_Color,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Center(
                                      child: CommonText(
                                        text: record.status.toString(),
                                        fontSize: 10,
                                        color: record.status == "Pending"
                                            ? AppColors.orange
                                            : record.status == "Rejected"
                                                ? AppColors.onHoldTextColor
                                                : AppColors.approvedtext_Color,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )),
                                const SizedBox(width: 15),
                                record.status == "Pending"
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
                                                    SvgPicture.asset(
                                                        profile_icon,
                                                        color: AppColors
                                                            .black_txcolor),
                                                    const SizedBox(width: 10),
                                                    const CommonText(
                                                        text: "User Details",
                                                        fontSize: 15,
                                                        color: AppColors
                                                            .black_txcolor,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ],
                                                ),
                                              ),
                                              /*PopupMenuItem<int>(
                                                value: 1,
                                                child: Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                        userPlusIcon,
                                                        color: AppColors
                                                            .black_txcolor),
                                                    const SizedBox(width: 10),
                                                    const CommonText(
                                                        text: "Assign Trainer",
                                                        fontSize: 15,
                                                        color: AppColors
                                                            .black_txcolor,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ],
                                                ),
                                              ),*/
                                              PopupMenuItem<int>(
                                                value: 1,
                                                child: Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                        approveIcon,
                                                        color: AppColors
                                                            .black_txcolor),
                                                    const SizedBox(width: 10),
                                                    const CommonText(
                                                        text: "Approve Request",
                                                        fontSize: 15,
                                                        color: AppColors
                                                            .black_txcolor,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ],
                                                ),
                                              ),
                                              PopupMenuItem<int>(
                                                value: 2,
                                                child: Container(
                                                  height: 40,
                                                  width: double.infinity,
                                                  color: AppColors.dark_red,
                                                  child: const Center(
                                                    child: CommonText(
                                                        text:
                                                            "Cancel Subscription",
                                                        fontSize: 15,
                                                        color: AppColors.white,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                              ),
                                            ];
                                          },
                                          onSelected: (value) {
                                            if (value == 0) {
                                              print(
                                                  "My account menu is selected.");
                                              manageAditionalInformationList(
                                                  "${record.userID}");
                                              _admin_UserDeatil(
                                                  "${record.userID}",
                                                "${record.sport}",
                                              );
                                            }
                                            /*if (value == 1) {
                                              print(
                                                  "My account menu is selected.");
                                              _changeTrainer(
                                                  "${record.displayName}",
                                                  "${record.trainerName}",
                                                  "${record.status}",
                                                  record.userID,
                                                  record.trainerID.toString());
                                            }*/
                                            if (value == 1) {
                                              print(
                                                  "My account menu is selected.");
                                              _approveRequest(
                                                "${record.displayName}",
                                                record.userID,
                                                "${record.subscription}",
                                                "${record.status}",
                                              );
                                              approvalCommentController.clear();
                                            }
                                            if (value == 2) {
                                              print(
                                                  "My account menu is selected.");
                                              _cancelSubscriptionRequest(
                                                  "${record.displayName}",
                                                  record.userID.toString());
                                              approvalCommentController.clear();
                                            }
                                          },
                                        ),
                                      )
                                    : Container(
                                        width: 20,
                                        child: record.profileLink != null
                                            ? PopupMenuButton(
                                                iconSize: 18,
                                                itemBuilder: (context) {
                                                  return [
                                                    PopupMenuItem<int>(
                                                      value: 0,
                                                      child: Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                              profile_icon,
                                                              color: AppColors
                                                                  .black_txcolor),
                                                          const SizedBox(
                                                              width: 10),
                                                          const CommonText(
                                                              text:
                                                                  "User Details",
                                                              fontSize: 15,
                                                              color: AppColors
                                                                  .black_txcolor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        ],
                                                      ),
                                                    ),
                                                    PopupMenuItem<int>(
                                                      value: 1,
                                                      child: Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                              linkIcon,
                                                              color: AppColors
                                                                  .black_txcolor),
                                                          const SizedBox(
                                                              width: 10),
                                                          const CommonText(
                                                              text:
                                                                  "Profile Link",
                                                              fontSize: 15,
                                                              color: AppColors
                                                                  .black_txcolor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        ],
                                                      ),
                                                    ),
                                                    PopupMenuItem<int>(
                                                      value: 2,
                                                      child: Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                              addUserIcon,
                                                              color: AppColors
                                                                  .black_txcolor),
                                                          const SizedBox(
                                                              width: 10),
                                                          const CommonText(
                                                              text:
                                                                  "Change Trainer",
                                                              fontSize: 15,
                                                              color: AppColors
                                                                  .black_txcolor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        ],
                                                      ),
                                                    ),
                                                  ];
                                                },
                                                onSelected: (value) async {
                                                  if (value == 0) {
                                                    manageAditionalInformationList(
                                                        "${record.userID}");
                                                    _admin_UserDeatil(
                                                        "${record.userID}",
                                                      "${record.sport}",
                                                    );
                                                  } else if (value == 1) {
                                                    await profile_lounch(record
                                                        .profileLink
                                                        .toString());
                                                    _launchUrl(record
                                                        .profileLink
                                                        .toString());
                                                  } else if (value == 2) {
                                                    if (kDebugMode) {
                                                      print(
                                                          "Settings menu is selected.");
                                                    }
                                                    _changeTrainer(
                                                        "${record.displayName}",
                                                        "${record.trainerName}",
                                                        "${record.status}",
                                                        record.userID,
                                                        record.trainerID.toString());
                                                    PreferenceUtils.remove("coachTrainer");

                                                  }
                                                })
                                            : record.status == "Approved"
                                                ? PopupMenuButton(
                                                    iconSize: 18,
                                                    itemBuilder: (context) {
                                                      return [
                                                        PopupMenuItem<int>(
                                                          value: 0,
                                                          child: Row(
                                                            children: [
                                                              SvgPicture.asset(
                                                                  profile_icon,
                                                                  color: AppColors
                                                                      .black_txcolor),
                                                              const SizedBox(
                                                                  width: 10),
                                                              const CommonText(
                                                                  text:
                                                                      "User Details",
                                                                  fontSize: 15,
                                                                  color: AppColors
                                                                      .black_txcolor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            ],
                                                          ),
                                                        ),
                                                        PopupMenuItem<int>(
                                                          value: 1,
                                                          child: Row(
                                                            children: [
                                                              SvgPicture.asset(
                                                                  addUserIcon,
                                                                  color: AppColors
                                                                      .black_txcolor),
                                                              const SizedBox(
                                                                  width: 10),
                                                              const CommonText(
                                                                  text:
                                                                      "Change Trainer",
                                                                  fontSize: 15,
                                                                  color: AppColors
                                                                      .black_txcolor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            ],
                                                          ),
                                                        ),
                                                      ];
                                                    },
                                                    onSelected: (value) {
                                                      if (value == 0) {
                                                        if (kDebugMode) {
                                                          print(
                                                              "My account menu is selected.");
                                                        }
                                                        manageAditionalInformationList(
                                                            "${record.userID}");
                                                        _admin_UserDeatil(
                                                            "${record.userID}",
                                                          "${record.sport}",
                                                        );
                                                      } else if (value == 1) {
                                                        if (kDebugMode) {
                                                          print(
                                                              "Settings menu is selected.");
                                                        }
                                                        _changeTrainer(
                                                            "${record.displayName}",
                                                            "${record.trainerName}",
                                                            "${record.status}",
                                                            record.userID,
                                                            record.trainerID.toString());
                                                        PreferenceUtils.remove("coachTrainer");
                                                      }
                                                    })
                                                : PopupMenuButton(
                                                    iconSize: 18,
                                                    itemBuilder: (context) {
                                                      return [
                                                        PopupMenuItem<int>(
                                                          value: 0,
                                                          child: Row(
                                                            children: [
                                                              SvgPicture.asset(
                                                                  profile_icon,
                                                                  color: AppColors
                                                                      .black_txcolor),
                                                              const SizedBox(
                                                                  width: 10),
                                                              const CommonText(
                                                                  text:
                                                                      "Rejected Reason",
                                                                  fontSize: 15,
                                                                  color: AppColors
                                                                      .black_txcolor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            ],
                                                          ),
                                                        ),
                                                      ];
                                                    },
                                                    onSelected: (value) {
                                                      manageAditionalInformationList(
                                                          "${record.userID}");
                                                      _admin_RejectedReason(
                                                        "${record.userID}",
                                                        "${record.comment}",
                                                      );
                                                    }),
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
  }

  Widget AdminSecrch_Collegerecruiter_Raw(int index) {
    DateTime joiningDate = DateTime.parse(adminClgListModel[index].joiningDate.toString());
    String displayname= "${adminClgListModel[index].displayName}";
    return searchcontroller.text.isEmpty ?
    Container(
      margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
      child: Card(
        shape: RoundedRectangleBorder(
            side: const BorderSide(width: 0.1),
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CommonText(
                          text: displayname.toTitleCase() ?? "",
                          fontSize: 15,
                          color: AppColors.black_txcolor,
                          fontWeight: FontWeight.bold),
                      const SizedBox(height: 8),
                      _CommonRow("REQUEST DATE : ", DateFormat('yMMMd').format(joiningDate)),
                      const SizedBox(height: 8),
                      _CommonRow("APPROVAL DATE : ", DateFormat('yMMMd').format(DateTime.parse(adminClgListModel[index].approvalDate.toString() ?? "")) ?? ""),
                      const SizedBox(height: 8),
                      _CommonRow("SUBSCRIPTION : ", adminClgListModel[index].subscription ?? ""),
                      const SizedBox(height: 8),
                      _CommonRow("PRICE : ", " ${"\$${adminClgListModel[index].price}" ?? ""}"),
                      const SizedBox(height: 8),
                      _CommonRow("SOLICITED NAME : ", adminClgListModel[index].solicitedName ?? ""),
                      const SizedBox(height: 8),
                      _CommonRow("SPORT : ", adminClgListModel[index].sport ?? ""),
                      const SizedBox(height: 8),
                      _CommonRow("TRAINER : ", adminClgListModel[index].trainerName ?? ""),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                              height: 20,
                              width: 64.52,
                              decoration: BoxDecoration(
                                color: adminClgListModel[index].status ==
                                    "Pending"
                                    ? AppColors.onHold
                                    : adminClgListModel[index].status ==
                                    "Rejected"
                                    ? AppColors.rejected
                                    : AppColors
                                    .approvedbackground_Color,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child: CommonText(
                                  text: adminClgListModel[index]
                                      .status
                                      .toString(),
                                  fontSize: 10,
                                  color: adminClgListModel[index]
                                      .status ==
                                      "Pending"
                                      ? AppColors.orange
                                      : adminClgListModel[index].status ==
                                      "Rejected"
                                      ? AppColors.onHoldTextColor
                                      : AppColors.approvedtext_Color,
                                  fontWeight: FontWeight.w400,
                                ),
                              )),
                          const SizedBox(width: 15),
                          adminClgListModel[index].status == "Pending"
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
                                        SvgPicture.asset(
                                            profile_icon,
                                            color: AppColors
                                                .black_txcolor),
                                        const SizedBox(width: 10),
                                        const CommonText(
                                            text: "User Details",
                                            fontSize: 15,
                                            color: AppColors
                                                .black_txcolor,
                                            fontWeight:
                                            FontWeight.w400),
                                      ],
                                    ),
                                  ),
                                  /*PopupMenuItem<int>(
                                                value: 1,
                                                child: Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                        userPlusIcon,
                                                        color: AppColors
                                                            .black_txcolor),
                                                    const SizedBox(width: 10),
                                                    const CommonText(
                                                        text: "Assign Trainer",
                                                        fontSize: 15,
                                                        color: AppColors
                                                            .black_txcolor,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ],
                                                ),
                                              ),*/
                                  PopupMenuItem<int>(
                                    value: 1,
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                            approveIcon,
                                            color: AppColors
                                                .black_txcolor),
                                        const SizedBox(width: 10),
                                        const CommonText(
                                            text: "Approve Request",
                                            fontSize: 15,
                                            color: AppColors
                                                .black_txcolor,
                                            fontWeight:
                                            FontWeight.w400),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem<int>(
                                    value: 2,
                                    child: Container(
                                      height: 40,
                                      width: double.infinity,
                                      color: AppColors.dark_red,
                                      child: const Center(
                                        child: CommonText(
                                            text:
                                            "Cancel Subscription",
                                            fontSize: 15,
                                            color: AppColors.white,
                                            fontWeight:
                                            FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ];
                              },
                              onSelected: (value) {
                                if (value == 0) {
                                  print(
                                      "My account menu is selected.");
                                  manageAditionalInformationList(
                                      "${adminClgListModel[index].userId}");
                                  _admin_UserDeatil(
                                      "${adminClgListModel[index].userId}",
                                    "${adminClgListModel[index].sport}",
                                  );
                                }
                                /* if (value == 1) {
                                              print(
                                                  "My account menu is selected.");
                                              _changeTrainer(
                                                  "${adminClgListModel[index].displayName}",
                                                  "${adminClgListModel[index].trainerName}",
                                                  "${adminClgListModel[index].status}",
                                                  adminClgListModel[index]
                                                      .userId,
                                                  adminClgListModel[index]
                                                      .trainerId
                                                      .toString());
                                            }*/
                                if (value == 1) {
                                  print(
                                      "My account menu is selected.");
                                  _approveRequest(
                                    "${adminClgListModel[index].displayName}",
                                    adminClgListModel[index].userId,
                                    "${adminClgListModel[index].subscription}",
                                    "${adminClgListModel[index].status}",
                                  );
                                  approvalCommentController.clear();
                                }
                                if (value == 2) {
                                  print(
                                      "My account menu is selected.");
                                  _cancelSubscriptionRequest(
                                      "${adminClgListModel[index].displayName}",
                                      adminClgListModel[index].userId.toString());
                                  approvalCommentController.clear();
                                }
                              },
                            ),
                          )
                              : Container(
                            width: 20,
                            child: adminClgListModel[index]
                                .profileLink !=
                                null
                                ? PopupMenuButton(
                                iconSize: 18,
                                itemBuilder: (context) {
                                  return [
                                    PopupMenuItem<int>(
                                      value: 0,
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                              profile_icon,
                                              color: AppColors
                                                  .black_txcolor),
                                          const SizedBox(
                                              width: 10),
                                          const CommonText(
                                              text:
                                              "User Details",
                                              fontSize: 15,
                                              color: AppColors
                                                  .black_txcolor,
                                              fontWeight:
                                              FontWeight
                                                  .w400),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem<int>(
                                      value: 1,
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                              linkIcon,
                                              color: AppColors
                                                  .black_txcolor),
                                          const SizedBox(
                                              width: 10),
                                          const CommonText(
                                              text:
                                              "Profile Link",
                                              fontSize: 15,
                                              color: AppColors
                                                  .black_txcolor,
                                              fontWeight:
                                              FontWeight
                                                  .w400),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem<int>(
                                      value: 2,
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                              addUserIcon,
                                              color: AppColors
                                                  .black_txcolor),
                                          const SizedBox(
                                              width: 10),
                                          const CommonText(
                                              text:
                                              "Change Trainer",
                                              fontSize: 15,
                                              color: AppColors
                                                  .black_txcolor,
                                              fontWeight:
                                              FontWeight
                                                  .w400),
                                        ],
                                      ),
                                    ),
                                  ];
                                },
                                onSelected: (value) async {
                                  if (value == 0) {
                                    manageAditionalInformationList(
                                        "${adminClgListModel[index].userId}");
                                    _admin_UserDeatil(
                                        "${adminClgListModel[index].userId}",
                                      "${adminClgListModel[index].sport}",
                                    );
                                  } else if (value == 1) {
                                    var url =
                                        "${adminClgListModel[index].profileLink}";
                                    await launch(url);
                                  } else if (value == 2) {
                                    if (kDebugMode) {
                                      print(
                                          "Settings menu is selected.");
                                    }
                                    _changeTrainer(
                                        "${adminClgListModel[index].displayName}",
                                        "${adminClgListModel[index].trainerName}",
                                        "${adminClgListModel[index].status}",
                                        adminClgListModel[index].userId,
                                        adminClgListModel[index].userId.toString());
                                    PreferenceUtils.remove("coachTrainer");
                                  }
                                })
                                : adminClgListModel[index].status ==
                                "Approved"
                                ? PopupMenuButton(
                                iconSize: 18,
                                itemBuilder: (context) {
                                  return [
                                    PopupMenuItem<int>(
                                      value: 0,
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                              profile_icon,
                                              color: AppColors
                                                  .black_txcolor),
                                          const SizedBox(
                                              width: 10),
                                          const CommonText(
                                              text:
                                              "User Details",
                                              fontSize: 15,
                                              color: AppColors
                                                  .black_txcolor,
                                              fontWeight:
                                              FontWeight
                                                  .w400),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem<int>(
                                      value: 1,
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                              addUserIcon,
                                              color: AppColors
                                                  .black_txcolor),
                                          const SizedBox(
                                              width: 10),
                                          const CommonText(
                                              text:
                                              "Change Trainer",
                                              fontSize: 15,
                                              color: AppColors
                                                  .black_txcolor,
                                              fontWeight:
                                              FontWeight
                                                  .w400),
                                        ],
                                      ),
                                    ),
                                  ];
                                },
                                onSelected: (value) {
                                  if (value == 0) {
                                    if (kDebugMode) {
                                      print(
                                          "My account menu is selected.");
                                    }
                                    manageAditionalInformationList(
                                        "${adminClgListModel[index].userId}");
                                    _admin_UserDeatil(
                                        "${adminClgListModel[index].userId}",
                                      "${adminClgListModel[index].sport}",
                                    );
                                  } else if (value == 1) {
                                    if (kDebugMode) {
                                      print(
                                          "Settings menu is selected.");
                                    }
                                    _changeTrainer(
                                        "${adminClgListModel[index].displayName}",
                                        "${adminClgListModel[index].trainerName}",
                                        "${adminClgListModel[index].status}",
                                        adminClgListModel[index].userId,
                                        adminClgListModel[index].trainerId.toString());
                                    PreferenceUtils.remove("coachTrainer");
                                  }
                                })
                                : PopupMenuButton(
                                iconSize: 18,
                                itemBuilder: (context) {
                                  return [
                                    PopupMenuItem<int>(
                                      value: 0,
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                              profile_icon,
                                              color: AppColors
                                                  .black_txcolor),
                                          const SizedBox(
                                              width: 10),
                                          const CommonText(
                                              text:
                                              "Rejected Reason",
                                              fontSize: 15,
                                              color: AppColors
                                                  .black_txcolor,
                                              fontWeight:
                                              FontWeight
                                                  .w400),
                                        ],
                                      ),
                                    ),
                                  ];
                                },
                                onSelected: (value) {
                                  _admin_RejectedReason(
                                    "${adminClgListModel[index].userId}",
                                    "${adminClgListModel[index].comment}",
                                  );
                                }),
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
        : adminClgListModel[index].displayName!.toLowerCase().contains(searchString) ||
            adminClgListModel[index].subscription!.toLowerCase().contains(searchString)
        ? Container(
            margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
            child: Card(
              shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 0.1),
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CommonText(
                                text: displayname.toTitleCase() ?? "",
                                fontSize: 15,
                                color: AppColors.black_txcolor,
                                fontWeight: FontWeight.bold),
                            const SizedBox(height: 8),
                            _CommonRow("REQUEST DATE : ", DateFormat('yMMMd').format(joiningDate)),
                            const SizedBox(height: 8),
                            _CommonRow("APPROVAL DATE : ", DateFormat('yMMMd').format(DateTime.parse(adminClgListModel[index].approvalDate.toString() ?? "")) ?? ""),
                            const SizedBox(height: 8),
                            _CommonRow("SUBSCRIPTION : ", adminClgListModel[index].subscription ?? ""),
                            const SizedBox(height: 8),
                            _CommonRow("PRICE : ", " ${"\$${adminClgListModel[index].price}" ?? ""}"),
                            const SizedBox(height: 8),
                            _CommonRow("SOLICITED NAME : ", adminClgListModel[index].solicitedName ?? ""),
                            const SizedBox(height: 8),
                            _CommonRow("SPORT : ", adminClgListModel[index].sport ?? ""),
                            const SizedBox(height: 8),
                            _CommonRow("TRAINER : ", adminClgListModel[index].trainerName ?? ""),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                    height: 20,
                                    width: 64.52,
                                    decoration: BoxDecoration(
                                      color: adminClgListModel[index].status ==
                                              "Pending"
                                          ? AppColors.onHold
                                          : adminClgListModel[index].status ==
                                                  "Rejected"
                                              ? AppColors.rejected
                                              : AppColors
                                                  .approvedbackground_Color,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Center(
                                      child: CommonText(
                                        text: adminClgListModel[index]
                                            .status
                                            .toString(),
                                        fontSize: 10,
                                        color: adminClgListModel[index]
                                                    .status ==
                                                "Pending"
                                            ? AppColors.orange
                                            : adminClgListModel[index].status ==
                                                    "Rejected"
                                                ? AppColors.onHoldTextColor
                                                : AppColors.approvedtext_Color,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )),
                                const SizedBox(width: 15),
                                adminClgListModel[index].status == "Pending"
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
                                                    SvgPicture.asset(
                                                        profile_icon,
                                                        color: AppColors
                                                            .black_txcolor),
                                                    const SizedBox(width: 10),
                                                    const CommonText(
                                                        text: "User Details",
                                                        fontSize: 15,
                                                        color: AppColors
                                                            .black_txcolor,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ],
                                                ),
                                              ),
                                              /*PopupMenuItem<int>(
                                                value: 1,
                                                child: Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                        userPlusIcon,
                                                        color: AppColors
                                                            .black_txcolor),
                                                    const SizedBox(width: 10),
                                                    const CommonText(
                                                        text: "Assign Trainer",
                                                        fontSize: 15,
                                                        color: AppColors
                                                            .black_txcolor,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ],
                                                ),
                                              ),*/
                                              PopupMenuItem<int>(
                                                value: 1,
                                                child: Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                        approveIcon,
                                                        color: AppColors
                                                            .black_txcolor),
                                                    const SizedBox(width: 10),
                                                    const CommonText(
                                                        text: "Approve Request",
                                                        fontSize: 15,
                                                        color: AppColors
                                                            .black_txcolor,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ],
                                                ),
                                              ),
                                              PopupMenuItem<int>(
                                                value: 2,
                                                child: Container(
                                                  height: 40,
                                                  width: double.infinity,
                                                  color: AppColors.dark_red,
                                                  child: const Center(
                                                    child: CommonText(
                                                        text:
                                                            "Cancel Subscription",
                                                        fontSize: 15,
                                                        color: AppColors.white,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                              ),
                                            ];
                                          },
                                          onSelected: (value) {
                                            if (value == 0) {
                                              print(
                                                  "My account menu is selected.");
                                              manageAditionalInformationList(
                                                  "${adminClgListModel[index].userId}");
                                              _admin_UserDeatil(
                                                  "${adminClgListModel[index].userId}",
                                                "${adminClgListModel[index].sport}",
                                              );
                                            }
                                            /* if (value == 1) {
                                              print(
                                                  "My account menu is selected.");
                                              _changeTrainer(
                                                  "${adminClgListModel[index].displayName}",
                                                  "${adminClgListModel[index].trainerName}",
                                                  "${adminClgListModel[index].status}",
                                                  adminClgListModel[index]
                                                      .userId,
                                                  adminClgListModel[index]
                                                      .trainerId
                                                      .toString());
                                            }*/
                                            if (value == 1) {
                                              print(
                                                  "My account menu is selected.");
                                              _approveRequest(
                                                "${adminClgListModel[index].displayName}",
                                                adminClgListModel[index].userId,
                                                "${adminClgListModel[index].subscription}",
                                                "${adminClgListModel[index].status}",
                                              );
                                              approvalCommentController.clear();
                                            }
                                            if (value == 2) {
                                              print("My account menu is selected.");
                                              _cancelSubscriptionRequest(
                                                  "${adminClgListModel[index].displayName}",
                                                  adminClgListModel[index].userId.toString());
                                              approvalCommentController.clear();
                                            }
                                          },
                                        ),
                                      )
                                    : Container(
                                        width: 20,
                                        child: adminClgListModel[index]
                                                    .profileLink !=
                                                null
                                            ? PopupMenuButton(
                                                iconSize: 18,
                                                itemBuilder: (context) {
                                                  return [
                                                    PopupMenuItem<int>(
                                                      value: 0,
                                                      child: Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                              profile_icon,
                                                              color: AppColors
                                                                  .black_txcolor),
                                                          const SizedBox(
                                                              width: 10),
                                                          const CommonText(
                                                              text:
                                                                  "User Details",
                                                              fontSize: 15,
                                                              color: AppColors
                                                                  .black_txcolor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        ],
                                                      ),
                                                    ),
                                                    PopupMenuItem<int>(
                                                      value: 1,
                                                      child: Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                              linkIcon,
                                                              color: AppColors
                                                                  .black_txcolor),
                                                          const SizedBox(
                                                              width: 10),
                                                          const CommonText(
                                                              text:
                                                                  "Profile Link",
                                                              fontSize: 15,
                                                              color: AppColors
                                                                  .black_txcolor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        ],
                                                      ),
                                                    ),
                                                    PopupMenuItem<int>(
                                                      value: 2,
                                                      child: Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                              addUserIcon,
                                                              color: AppColors
                                                                  .black_txcolor),
                                                          const SizedBox(
                                                              width: 10),
                                                          const CommonText(
                                                              text:
                                                                  "Change Trainer",
                                                              fontSize: 15,
                                                              color: AppColors
                                                                  .black_txcolor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        ],
                                                      ),
                                                    ),
                                                  ];
                                                },
                                                onSelected: (value) async {
                                                  if (value == 0) {
                                                    manageAditionalInformationList(
                                                        "${adminClgListModel[index].userId}");
                                                    _admin_UserDeatil(
                                                        "${adminClgListModel[index].userId}",
                                                      "${adminClgListModel[index].sport}",
                                                    );
                                                  } else if (value == 1) {
                                                    var url =
                                                        "${adminClgListModel[index].profileLink}";
                                                    await launch(url);
                                                  } else if (value == 2) {
                                                    if (kDebugMode) {
                                                      print(
                                                          "Settings menu is selected.");
                                                    }
                                                    _changeTrainer(
                                                        "${adminClgListModel[index].displayName}",
                                                        "${adminClgListModel[index].trainerName}",
                                                        "${adminClgListModel[index].status}",
                                                        adminClgListModel[index].userId,
                                                        adminClgListModel[index].userId.toString());
                                                    PreferenceUtils.remove("coachTrainer");
                                                  }
                                                })
                                            : adminClgListModel[index].status ==
                                                    "Approved"
                                                ? PopupMenuButton(
                                                    iconSize: 18,
                                                    itemBuilder: (context) {
                                                      return [
                                                        PopupMenuItem<int>(
                                                          value: 0,
                                                          child: Row(
                                                            children: [
                                                              SvgPicture.asset(
                                                                  profile_icon,
                                                                  color: AppColors
                                                                      .black_txcolor),
                                                              const SizedBox(
                                                                  width: 10),
                                                              const CommonText(
                                                                  text:
                                                                      "User Details",
                                                                  fontSize: 15,
                                                                  color: AppColors
                                                                      .black_txcolor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            ],
                                                          ),
                                                        ),
                                                        PopupMenuItem<int>(
                                                          value: 1,
                                                          child: Row(
                                                            children: [
                                                              SvgPicture.asset(
                                                                  addUserIcon,
                                                                  color: AppColors
                                                                      .black_txcolor),
                                                              const SizedBox(
                                                                  width: 10),
                                                              const CommonText(
                                                                  text:
                                                                      "Change Trainer",
                                                                  fontSize: 15,
                                                                  color: AppColors
                                                                      .black_txcolor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            ],
                                                          ),
                                                        ),
                                                      ];
                                                    },
                                                    onSelected: (value) {
                                                      if (value == 0) {
                                                        if (kDebugMode) {
                                                          print(
                                                              "My account menu is selected.");
                                                        }
                                                        manageAditionalInformationList(
                                                            "${adminClgListModel[index].userId}");
                                                        _admin_UserDeatil(
                                                            "${adminClgListModel[index].userId}",
                                                          "${adminClgListModel[index].sport}",
                                                        );
                                                      } else if (value == 1) {
                                                        if (kDebugMode) {
                                                          print(
                                                              "Settings menu is selected.");
                                                        }
                                                        _changeTrainer(
                                                            "${adminClgListModel[index].displayName}",
                                                            "${adminClgListModel[index].trainerName}",
                                                            "${adminClgListModel[index].status}",
                                                            adminClgListModel[index].userId,
                                                            adminClgListModel[index].trainerId.toString());
                                                        PreferenceUtils.remove("coachTrainer");
                                                      }
                                                    })
                                                : PopupMenuButton(
                                                    iconSize: 18,
                                                    itemBuilder: (context) {
                                                      return [
                                                        PopupMenuItem<int>(
                                                          value: 0,
                                                          child: Row(
                                                            children: [
                                                              SvgPicture.asset(
                                                                  profile_icon,
                                                                  color: AppColors
                                                                      .black_txcolor),
                                                              const SizedBox(
                                                                  width: 10),
                                                              const CommonText(
                                                                  text:
                                                                      "Rejected Reason",
                                                                  fontSize: 15,
                                                                  color: AppColors
                                                                      .black_txcolor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            ],
                                                          ),
                                                        ),
                                                      ];
                                                    },
                                                    onSelected: (value) {
                                                      _admin_RejectedReason(
                                                        "${adminClgListModel[index].userId}",
                                                        "${adminClgListModel[index].comment}",
                                                      );
                                                    }),
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
  }

  void getcollegerecruiters() async {
    log('this is call college recruiter api call', name: "college recruiter");
    setState(() {
      _isFirstLoadRunning = true;
    });
    var response;
    MyApplication.getInstance()!
        .checkConnectivity(context)
        .then((internet) async {
      if (internet != null && internet) {
        try {
          Dio dio = Dio();
          response = await dio.post(
              "${AppConstant.MODE_COLLEGE_RECRUITERES}page=$_page&size=$_limit",
              options: Options(followRedirects: false, headers: {
                "Authorization":
                    "Bearer ${PreferenceUtils.getString("accesstoken")}"
              }));
          if (response.statusCode == 200) {
            if (kDebugMode) {
              print(response.data);
            }
            setState(() {
              _isFirstLoadRunning = false;
              datalist = response.data["result"];
              print("=======this is data list${datalist.toString()}");
              // setState(() {
              //   for (Map<String, dynamic> i in datalist) {
              //     listModel.add(Result.fromJson(i));
              //   }
              // });
            });
            if (kDebugMode) {
              print(response.data["result"][0]["userID"].toString());
            }
          } else {
            setState(() => _isFirstLoadRunning = false);
          }
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
          setState(() => _isFirstLoadRunning = false);
        }
      } else {
        MyApplication.getInstance()!
            .showInSnackBar(AppString.no_connection, context);
      }
    });
  }


  admmingetcollegerecruiters(String? stDate, String? edDate) async {
    print("start data =======>>> $stDate");
    print("start data =======>>> $stDate");
    log('this is call admincollege recruiter api call',
        name: "college recruiter");

    MyApplication.getInstance()!
        .checkConnectivity(context)
        .then((internet) async {
      if (internet != null && internet) {
        try {
          Dio dio = Dio();
          var params = {
            "roleID": 4,
            "startDate": stDate.toString(),
            "endDate": edDate.toString(),
          };
          print("$params");
          var response = await dio.post(
              "${AppConstant.ADMIN_USERS}page=$_page&size=$_limit",
              data: params,
              options: Options(followRedirects: false, headers: {
                "Authorization":
                    "Bearer ${PreferenceUtils.getString("accesstoken")}"
              }));
          if (response.statusCode == 200) {
            print("+++++this is admin clg recruiter${response.data}");
            setState(() {
              adminClglist = response.data["Records"];
              print("=======this is data list${adminClglist.toString()}");
              setState(() {
                for (Map<String, dynamic> i in adminClglist) {
                  adminClgListModel.add(Record.fromJson(i));
                }
                print(
                    "=======this is data list of single item${adminClgListModel[0].displayName}");
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

  Future<bool> _admin_UserDeatil(String userId, String sport) async {
    print("sport =======<><><>< $sport");
    final shouldPop = await showDialog(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
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
                                            text:
                                                "${userdetails.displayName}",
                                            fontSize: 16,
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
                                                      "${userdetails.streetAddress ?? ""},${userdetails.landMark ?? ""},${userdetails.city ?? ""},${userdetails.state ?? ""},${userdetails.zipcode ?? ""}",
                                                  fontSize: 13,
                                                  color:
                                                      AppColors.black_txcolor,
                                                  fontWeight: FontWeight.w400),
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
                                          Expanded(
                                            child: CommonText(
                                                text: "${userdetails.userEmail}",
                                                fontSize: 15,
                                                color: AppColors.black_txcolor,
                                                fontWeight: FontWeight.w400),
                                          )
                                        ]),
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
                              const SizedBox(height: 20),
                              _buildColumn("${userdetails.organizationName ?? userdetails.otherOrganizationName}",
                                  "${userdetails.organizationAddress},${userdetails.organizationCity},${userdetails.organizationState},${userdetails.organizationZipcode}"),
                              const SizedBox(height: 10),
                              ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: itemList.length.compareTo(0),
                                  itemBuilder: (context, index) {
                                    print(
                                        "List Of tab length ==-===<><. $sport");
                                    return TabAdminCoachDetailScreen(
                                        userId, itemList, itemList.length, sport);
                                  }),
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
                        return const Center(
                          child: Text("No Data Found"),
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

  Future<void> _launchUrl(String profileLink) async {
    if (!await launchUrl(Uri.parse(
        "http://packhubweb.s3-website-us-west-2.amazonaws.com/profile/$profileLink"))) {
      throw 'Could not launch ${"http://packhubweb.s3-website-us-west-2.amazonaws.com/profile/$profileLink"}';
    }
  }

  Future<bool> _admin_RejectedReason(String userId, String comment) async {
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CommonText(
                      text: "Rejected Reason",
                      fontSize: 18,
                      color: AppColors.black_txcolor,
                      fontWeight: FontWeight.bold),
                  const SizedBox(height: 10),
                  const Divider(color: AppColors.grey_hint_color),
                  const SizedBox(height: 10),
                  comment != null
                      ? CommonText(
                          text: comment,
                          fontSize: 14,
                          color: AppColors.black_txcolor,
                          fontWeight: FontWeight.w400)
                      : const CommonText(
                          text: "not appropriate",
                          fontSize: 14,
                          color: AppColors.black_txcolor,
                          fontWeight: FontWeight.w400),
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
            ),
          ),
        ),
      ),
    );
    return shouldPop ?? false;
  }

  _buildColumn(text, addressText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(
            text: "Organization Details",
            fontSize: 16,
            color: AppColors.black_txcolor,
            fontWeight: FontWeight.w600),
        const SizedBox(height: 8),
        CommonText(
            text: text,
            fontSize: 14,
            color: AppColors.black_txcolor,
            fontWeight: FontWeight.w600),
        const SizedBox(height: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(locationIcon),
            SizedBox(width: 10),
            SizedBox(
              width: Get.width / 2,
              child: Text(
                addressText,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  color: AppColors.black_txcolor,
                ),
                maxLines: 2,
                overflow: TextOverflow.clip,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<bool> _changeTrainer(String displayName, String trainerName, String status, int? userID, String? trainerID) async {
    print("trName2 =========>>>> ${trainerName}");
    trainer = null;
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
                            text: "Change Trainer",
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
                        status == "Pending"
                            ? _buildTrainerDropdown(trainerName)
                            : _buildTrainerDropdown(trainerName),
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
                                /*if (_formKey.currentState!.validate()) {
                                 setState(() {
                                   getAthleteListApi(accessToken, _page, _limit, "4");
                                   getManageSubscription_ALL_LISTING(accessToken);
                                   getcollegerecruiters();
                                   admmingetcollegerecruiters(stDate, edDate);
                                   getTrainerList("1");
                                   SelcteSportsList();
                                   trainer == null ? postAssignTrainer(context, userID, trainerID.toString()) :
                                   postAssignTrainer(context, userID, trainer.toString());
                                 });
                                }*/
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    trainer == null ? postAssignTrainer(context, userID, trainerID.toString())
                                        : postAssignTrainer(context, userID, trainer.toString());
                                    getAthleteListApi(accessToken, _page, _limit, "3");
                                    getManageSubscription_ALL_LISTING(accessToken);
                                    getTrainerList("1");
                                    admmingetcollegerecruiters(stDate, edDate);
                                    getTrainerList("1");
                                    getcollegerecruiters();
                                  });
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
                                type: TextInputType.number,
                                text: "Player ID",
                              )
                            : Container(),
                        const SizedBox(height: 10),
                        subscription == "Free"
                            ? Container()
                            : StatefulBuilder(builder: (context, setState) {
                          return DropdownButtonHideUnderline(
                            child:  DropdownButtonFormField2<String>(
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(left: 0, right: 10, bottom: 15, top: 15),
                                enabledBorder: OutlineInputBorder( //<-- SEE HERE
                                    borderSide: BorderSide(color: AppColors.grey_hint_color, width: 1),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                errorBorder: OutlineInputBorder( //<-- SEE HERE
                                  borderSide: BorderSide(color: AppColors.dark_red, width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                filled: true,
                                fillColor: Colors.white,

                              ),
                              value: trainer,
                              isExpanded: true,
                              validator: (value) => value == null ? ' ' : null,
                              //itemHeight: 50.0,
                              style: TextStyle(fontSize: 15.0, color: Colors.grey[700]),
                              items: trainerList?.map((item) {
                                PreferenceUtils.setString("client_trainerID", item['TrainerID'].toString());
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
                                  print(" approve =======<><><> $clientTrainerID");
                                  print("$status");
                                  print("trainer id ? $trainer");
                                  setState(() {
                                    if (_formKey.currentState!.validate()) {
                                      if (subscription == "Free") {
                                        postApproveRequest(context, userID, status, clientTrainerID.toString());
                                      } else if (subscription == "Gold" || subscription == "Platinum") {
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

                                // if (_formKey.currentState!.validate()) {
                                //   setState(() {
                                //     postApproveRequest(context, userID, status, clientTrainerID.toString());
                                //     getAthleteListApi(accessToken, _page, _limit, "4");
                                //   });
                                // }
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
                                  setState(() {
                                    postAdminReject(context, userID, approvalCommentController.text);
                                  });
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
    print("trName =========>>>> ${trName}");
    print("trainer =========>>>> ${trainer}");
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
                  child:  CommonText(
                      text:  item['TrainerName'] ,
                      fontSize: 13,
                      color: AppColors.black,
                      fontWeight: FontWeight.w500),
                );
              }).toList(),
              hint:  CommonText(
                  text: trName != "null" ? trName : "Select Trainer",
                  fontSize: 15,
                  color: AppColors.black,
                  fontWeight: FontWeight.w500),
              onChanged: (String? newValue) {
                setState(() => trainer = newValue);
                PreferenceUtils.setString("coachTrainer", trainer.toString());
                print(trainer.toString());
              },
            ),
          ));
    });
  }

  Future<bool> College_stats_dialog() async {
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
                                text: AppString.collgestats,
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
                      Column(
                        children: [
                          const CommonText(
                              text: "Baseball",
                              fontSize: 15,
                              color: AppColors.black_txcolor,
                              fontWeight: FontWeight.w600),
                          const SizedBox(
                            height: 10,
                          ),
                          SvgPicture.asset(
                            baseball,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Center(
                        child: ReadMoreText(
                          //item?.bio != null || item?.bio != "" ? "No more details found" : "${item?.bio}",
                          "No Data to display",
                          trimLines: 7,
                          style: TextStyle(color: AppColors.grey_text_color),
                          colorClickableText: AppColors.blue_text_Color,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: '...view more',
                          trimExpandedText: ' view less',
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Divider(color: AppColors.grey_hint_color),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: 100,
                                child: Button(
                                  textColor: AppColors.white,
                                  text: "Cancel",
                                  color: AppColors.dark_blue_button_color,
                                  onClick: () async {
                                    Navigator.pop(context);
                                  },
                                ),
                              )),
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

  Future<bool> _UserDetails(String userId, String sport, int? hidePhone, int? hideEmail) async {
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
                      child: Text("No Data Found"),
                    ),
                  );
                }
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(child: CustomLoader());
                  case ConnectionState.done:
                    if (snapshot.hasData) {
                      var item = snapshot.data?.userdetails;
                      if (item != null) {
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
                                      borderRadius:
                                          BorderRadius.circular(1000.0),
                                      child: CachedNetworkImage(
                                        height: 60,
                                        width: 60,
                                        fit: BoxFit.cover,
                                        imageUrl: "${item.picturePathS3}",
                                        placeholder: (context, url) =>
                                            CustomLoader(),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                          avatarImage,
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
                                              text: "${item.displayName}" ?? "",
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
                                                        "${item.streetAddress}, ${item.city}, ${item.state}, ${item.zipcode}",
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
                                            Expanded(
                                              child: CommonText(
                                                  text:"${hideEmail == 1 ? item.userEmail?.replaceRange(0, item.userEmail?.length, "xxxxxxxxx@xxxx.com") : item.userEmail}",
                                                  fontSize: 15,
                                                  color: AppColors.black_txcolor,
                                                  fontWeight: FontWeight.w400),
                                            )
                                          ]),
                                          const SizedBox(height: 5),
                                          Row(children: [
                                            SvgPicture.asset(
                                              call_icon,
                                              color: AppColors.black,
                                            ),
                                            const SizedBox(width: 3),
                                            CommonText(
                                                text:"${hidePhone == 1 ? item.contact?.replaceRange(5, 14, "xxxxxxxx") : item.contact}",
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
                              const SizedBox(height: 10),
                              const CommonText(
                                  text: AppString.organizationDetails,
                                  fontSize: 15,
                                  color: AppColors.black_txcolor,
                                  fontWeight: FontWeight.w500),
                              const SizedBox(height: 15),
                              CommonText(
                                  text: "${item.organizationName ?? item.otherOrganizationName}",
                                  fontSize: 15,
                                  color: AppColors.black_txcolor,
                                  fontWeight: FontWeight.w500),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.only(left: 0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset(
                                      locationIcon,
                                      color: AppColors.black,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(bottom: 25),
                                        child: CommonText(
                                            text: "${item.organizationAddress}, ${item.organizationCity}, ${item.organizationState}, ${item.organizationZipcode}",
                                            fontSize: 15,
                                            color: AppColors.black_txcolor,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: itemList.length.compareTo(0),
                                  itemBuilder: (context, index) {
                                    print(
                                        "List Of tab length ==-===<><. ${itemList.length}");
                                    return TabAdminCoachDetailScreen(userId, itemList, itemList.length, sport);
                                  }),
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
        setState(() {
          itemList = response.data["attribute"];
          // uniquelist = response.data["attribute"].where((value) => models.add(value["displayGroup"])).toList();
          print("+++++this unique grop List  ${uniquelist}");
          print("+++++this is item ${response.data["attribute"]}");
          print("+++++this uniquelist  ${uniquelist}");
        });
      } else {
        //setState(() => _isFirstLoadRunning = false);
      }
    } catch (e) {
      print(e);
      //setState(() => _isFirstLoadRunning = false);
    }
  }

  /////TODO LoadMore Api /////////

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      _page += 1;
      if (kDebugMode) {
        print("=========thias is total$_page");
      } // Increase _page by 1
      try {
        Dio dio = Dio();
        var response = await dio.post(
            "${AppConstant.MODE_COLLEGE_RECRUITERES}page=$_page&size=$_limit",
            options: Options(followRedirects: false, headers: {
              "Authorization":
                  "Bearer ${PreferenceUtils.getString("accesstoken")}"
            }));
        _isLoadMoreRunning = false;

        final List<Result> fetchedPosts =
            json.decode(response.data["result"].toString());
        if (fetchedPosts.isNotEmpty) {
          setState(() {
            datalist.addAll(fetchedPosts);
            if (kDebugMode) {
              print("=========this is datalist of all data$datalist");
            }
          });
        } else {
          // This means there is no more data
          // and therefore, we will not send another GET request
          setState(() {
            _hasNextPage = false;
          });
        }
      } catch (err) {
        if (kDebugMode) {
          print('Something went wrong!');
        }
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  /////TODO publicprofile Loanch Api /////////
  profile_lounch(String profilelink) async {
    log('this is call profile_lounch api call', name: "Profile Link");
    try {
      Dio dio = Dio();
      var params = {
        "url":
            "http://packhubweb.s3-website-us-west-2.amazonaws.com/$profilelink"
      };
      print("response url  ====> ${params}");
      var response = await dio.post(AppConstant.public_profile,
          data: params,
          options: Options(followRedirects: false, headers: {
            "Authorization":
                "Bearer ${PreferenceUtils.getString("accesstoken")}"
          }));
      if (response.statusCode == 200) {
        print("+++++this is admin clg recruiter${response.data}");
        // if (await canLaunchUrl(Uri.parse())){
        //   await launchUrl(Uri.parse("http://packhubweb.s3-website-us-west-2.amazonaws.com/zelizelensky"));
        // } else {
        //   // can't launch url
        // }
      }
    } catch (e) {
      print(e);
      setState(() => _isFirstLoadRunning = false);
    }
  }

  _CommonRow(text, text2) {
    return Row(
      children: [
        CommonText(
            text: text,
            fontSize: 12,
            color:
            AppColors.black_txcolor,
            fontWeight: FontWeight.bold),
        CommonText(
            text: text2,
            fontSize: 12,
            color:
            AppColors.black_txcolor,
            fontWeight:
            FontWeight.w500),
      ],
    );
  }

  /////TODO  SelcteSportsList Api /////////
  SelcteSportsList() async {
    log('this is SELECT SPORTS  api call', name: "SELECT SPORTS");
    MyApplication.getInstance()!
        .checkConnectivity(context)
        .then((internet) async {
      if (internet != null && internet) {
        try {
          Dio dio = Dio();
          var response = await dio.get(AppConstant.SELECTSPORTS,
              options: Options(followRedirects: false)
          );
          print("-----SELECT SPORTS URL $response");
          if (response.statusCode == 200) {
            print("+++++SELECT SPORTS Response ${response.data}");
            selectSportsResult = response.data["result"];
            allSportsList = allSports + selectSportsResult;
            print("sports DropDown List ========>>>> $allSportsList");
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

}
