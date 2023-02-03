
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pachub/Utils/constant.dart';
import 'package:pachub/app_function/MyAppFunction.dart';
import 'package:pachub/common_widget/nodatafound_page.dart';
import 'package:pachub/config/preference.dart';
import 'package:pachub/models/Profile_model.dart';
import 'package:pachub/models/bookmark_model.dart';
import 'package:pachub/services/request.dart';
import 'package:pachub/view/dashboard/tab_deatil_screen.dart';
import 'package:pachub/view/login/login_view.dart';
import 'package:readmore/readmore.dart';

import '../../../Utils/appcolors.dart';
import '../../../Utils/appstring.dart';
import '../../../Utils/images.dart';
import '../../../common_widget/button.dart';
import '../../../common_widget/customloader.dart';
import '../../../common_widget/textstyle.dart';

class CoachesTab extends StatefulWidget {
  const CoachesTab({Key? key}) : super(key: key);

  @override
  State<CoachesTab> createState() => _CoachesTabState();
}

class _CoachesTabState extends State<CoachesTab> {
  bool isBookMark = false;
  bool checkedValue = false;
  String? accessToken;
  int _page = 0;
  final int _limit = 50;
  String? roleName;
  List athleteItemList = [];
  var models = <String>{};
  List uniquelist = [];
  var group3;
  List coachList = [];
  bool _isLoadRunning = false;



  @override
  void initState() {
    setState(() {
      accessToken = PreferenceUtils.getString("accesstoken");
      roleName = PreferenceUtils.getString("role");
    });
    super.initState();
    coachBookMarkList(_page, _limit);
  }

  @override
  Widget build(BuildContext context) {
    print("list data ===>>> $coachList");
    return RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      edgeOffset: 20,
      onRefresh: () async{
        await Future.delayed(Duration(milliseconds: 1500));
        setState(() {
          coachList.clear();
          coachBookMarkList(_page, _limit);
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: _isLoadRunning ?
        Align(
          alignment: Alignment.center,
          child: CustomLoader(),
        )
            : coachList.isEmpty ?
        const Align(
            alignment: Alignment.center,
            child: NoDataFound()
        )
            : ListView.builder(
          shrinkWrap: true,
          itemCount: coachList.length,
          itemBuilder: (context, index) {
            var item = coachList[index];
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
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                        imageUrl: avatarImage,
                        placeholder: (context, url) => CustomLoader(),
                        errorWidget: (context, url, error) =>
                            SizedBox(
                                height: 40,
                                width: 40,
                                child: Image.asset(avatarImage)
                            ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 8, top: 2),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            CommonText(
                                text: item["displayName"] ?? "",
                                fontSize: 16,
                                color: AppColors.black_txcolor,
                                fontWeight: FontWeight.w700),
                            item["organizationName"] == null ? Container() :  CommonText(
                                text: "(${item["organizationName"].toString()})",
                                fontSize: 14,
                                color: AppColors.black_txcolor,
                                fontWeight: FontWeight.w700),
                            const SizedBox(height: 4),
                            item["bio"] != null ? CommonText(
                                text: "${item["bio"]}",
                                fontSize: 10,
                                color:
                                AppColors.grey_hint_color,
                                fontWeight: FontWeight.w400) : const Text(""),
                            const SizedBox(height: 9),
                            _buildRow(
                              location_icon,
                              "${item["city"]},${item["state"]},${item["zipcode"]}",
                              AppColors.black_txcolor,
                            ),
                            const SizedBox(height: 7),
                            _buildRow(
                              call_icon,
                              "${item["contact"]}",
                              AppColors.black_txcolor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _BoookmarkDialog(item["userID"].toString());
                          },
                          child: SizedBox(
                            height: 13,
                            width: 11,
                            child: Image.asset(bookmarktrue),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
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
                                            messageCircleIcon,
                                            color: AppColors.black_txcolor),
                                        const SizedBox(
                                            width: 10),
                                        const CommonText(
                                            text:
                                            "Send Message",
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
                                            briefcaseIcon,
                                            color: AppColors
                                                .black_txcolor),
                                        const SizedBox(
                                            width: 10),
                                        const CommonText(
                                            text:
                                            "Coach / Recruiters Detail",
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
                                  print("My account menu is selected.");
                                  SendMessagedialog();
                                } else if (value == 1) {
                                  print("Settings menu is selected.");
                                  await manageAditionalInformationList(item["userID"].toString());
                                  _UserDeatil(item["userID"].toString());
                                }
                              }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _buildRow(image, text, color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SvgPicture.asset(image),
        const SizedBox(width: 10),
        SizedBox(
          width: Get.width / 2,
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              color: color,
            ),
            maxLines: 2,
            overflow: TextOverflow.clip,
          ),
        ),
      ],
    );
  }

  Future<bool> SendMessagedialog() async {
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
                          children:  [
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
                        children: const [
                          Expanded(
                            child: TextField(
                              keyboardType: TextInputType.multiline,
                              maxLength: null,
                              maxLines: 4,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(8)),
                                      borderSide: BorderSide(width: 1, color: AppColors.grey_hint_color)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(8)),
                                      borderSide: BorderSide(width: 1, color: AppColors.grey_hint_color)
                                  )
                              ),
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
                            onTap:(){
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
                              },
                            ),
                          )                        ],
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

  Future<bool> _UserDeatil(String userId) async {
    final shouldPop = await showDialog(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Dialog(shape:
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
                    child: Center(
                      child: NoDataFound(),
                    ),
                  );
                }
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(child: CustomLoader());
                  case ConnectionState.done:
                    if (snapshot.hasData) {
                      var item = snapshot.data?.userdetails;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start, children: [Row(
                              children: [
                                item?.picturePathS3 != null || item?.picturePathS3 != "" ?SvgPicture.asset(
                                  userProfile_image,
                                  height: 60,
                                  width: 60,
                                ): Image.asset(
                                  "${item?.picturePathS3}",
                                  height: 60,
                                  width: 60,
                                ),
                                const SizedBox(width: 15),
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CommonText(
                                        text: "${item?.displayName}",
                                        fontSize: 18,
                                        color: AppColors.black_txcolor,
                                        fontWeight: FontWeight.w500),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          locationIcon,
                                          color: AppColors.black,
                                        ),
                                        const SizedBox(width: 7),
                                        CommonText(
                                            text: "${item?.streetAddress}",
                                            fontSize: 15,
                                            color: AppColors.black_txcolor,
                                            fontWeight: FontWeight.w400),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          emailIcon,
                                          color: AppColors.black,
                                        ),
                                        const SizedBox(width: 5),
                                        CommonText(
                                            text: "${item?.userEmail}",
                                            fontSize: 15,
                                            color: AppColors.black_txcolor,
                                            fontWeight: FontWeight.w400),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          call_icon,
                                          color: AppColors.black,
                                        ),
                                        const SizedBox(width: 7),
                                        CommonText(
                                            text: "${item?.contact}",
                                            fontSize: 15,
                                            color: AppColors.black_txcolor,
                                            fontWeight: FontWeight.w400),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                              const SizedBox(height: 10),
                              const Divider(color: AppColors.grey_hint_color),
                              SizedBox(height: 5),
                              const CommonText(
                                  text: AppString.organizationDetails,
                                  fontSize: 15,
                                  color: AppColors.black_txcolor,
                                  fontWeight: FontWeight.w500),
                              SizedBox(height: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CommonText(
                                      text: item?.displayName ?? "",
                                      fontSize: 15,
                                      color: AppColors.black_txcolor,
                                      fontWeight: FontWeight.w600),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        locationIcon,
                                        color: AppColors.black,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: CommonText(
                                            text: "${item?.organizationAddress}, ${item?.organizationCity}, ${item?.organizationState}, ${item?.organizationZipcode??""}" ?? "",
                                            fontSize: 15,
                                            color: AppColors.black_txcolor,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: athleteItemList.length.compareTo(0),
                                  itemBuilder: (context, index) {
                                    print("List Of tab length ==-===<><. ${athleteItemList.length}");
                                    return TabAdminCoachDetailScreen(userId, athleteItemList, athleteItemList.length, "");
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
                          ),
                        ],
                      );
                    } else {return Container(
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
  Future<bool> _BoookmarkDialog(String userId) async {
    final shouldPop = await showDialog(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0)),
            elevation: 0.0,
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CommonText(
                      text: AppString.confirmationText,
                      fontSize: 18,
                      color: AppColors.black_txcolor,
                      fontWeight: FontWeight.bold),
                  const SizedBox(height: 15),
                  CommonText(
                      text: AppString.subscriptiontxt,
                      fontSize: 15,
                      color: AppColors.black_txcolor,
                      fontWeight: FontWeight.normal),
                  SizedBox(
                    height: 20
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _buildContainer(() {Navigator.pop(context);}, AppColors.dark_red, AppString.cancelTxt),
                      const SizedBox(width: 15),
                      _buildContainer(() {
                        setState(() {
                          Unbookmarklistapi(userId);
                        });
                        Navigator.pop(context);
                      }, AppColors.approvedtext_Color, AppString.confirmText),
                    ],
                  ),
                ],
              ),
            )),
      ),
    );

    return shouldPop ?? false;
  }
  _buildContainer(onClick, backgroundColor, txt) {
    return  GestureDetector(
      onTap: onClick,
      child: Container(
        height: 40,
        width: 80,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(child: CommonText(text: txt, fontSize: 14, color: AppColors.white, fontWeight: FontWeight.w500)),
      ),
    );
  }

  manageAditionalInformationList(String? userId) async {
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
        athleteItemList = response.data["attribute"];
        // uniquelist = response.data["attribute"].where((value) => models.add(value["displayGroup"])).toList();
        print("+++++this is item ${response.data["attribute"]}");
      } else if (response.statusCode == 401) {
        return Get.offAll(Loginscreennew());
      } else {
        //setState(() => _isFirstLoadRunning = false);
      }
    } catch (e) {
      print(e);
      //setState(() => _isFirstLoadRunning = false);
    }
  }

  coachBookMarkList(int page, int limit) async {
    log('this is Manage_Profile  api call', name: "Manage_Profile");
    setState(() {
      _isLoadRunning = true;
    });
    try {
      Dio dio = Dio();
      var response = await dio.get("${AppConstant.BOOK_MARK}page=$page&size=$limit",
          options: Options(followRedirects: false, headers: {
            "Authorization":
            "Bearer $accessToken"
          }));
      print("-----this is url $response");
      if (response.statusCode == 200) {
        print("+++++this is manageprofile ${response.data}");
        setState(() {
          uniquelist = response.data["bookMarkList"];
          group3 = groupBy(uniquelist, (e) => e["role"]).map((key, value) => MapEntry(key, value.map((e) => e).whereNotNull().toList()));
          coachList = group3["Coach / Recruiter"];
          _isLoadRunning = false;
          print("+++++Item ${coachList}");
        });
      } else {
        setState(() => _isLoadRunning = false);
      }
    } catch (e) {
      print(e);
      setState(() => _isLoadRunning = false);
    }
  }

  Unbookmarklistapi(String userId) async {
    setState(() {
      _isLoadRunning = true;
    });
    try {
      Dio dio = Dio();
      var params = {
        "bookMarkedID": userId,
      };
      print("$params");
      var response = await dio.post(AppConstant.BookMarkListTICK,
          data: params,
          options: Options(
              followRedirects: false,
              headers:{
                "Authorization": "Bearer ${PreferenceUtils.getString("accesstoken")}"
              }
          ));
      if (response.statusCode == 200) {
        setState(() {
          print("response ====<> ${response.data}");
          print("bookmarklist click Response:" + response.data["Message"]);
          MyApplication.getInstance()?.showInGreenSnackBar("${response.data["Message"]}", context);
          _isLoadRunning = false;
        });
        coachList.clear();
        coachBookMarkList(_page, _limit);
      }
      // else if(response.statusCode == 401) {
      //   return Get.offAll(Loginscreennew());
      // }
      else {
        MyApplication.getInstance()?.showInSnackBar(response.data["Message"], context);
        setState(() => _isLoadRunning = false);
      }
    } on DioError catch (e) {
      if (e is DioError) {
        MyApplication.getInstance()?.showInSnackBar(e.response!.data["Message"], context);
        setState(() => _isLoadRunning = false);
      }
    }
  }

}
