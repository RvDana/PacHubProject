import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pachub/Utils/appcolors.dart';
import 'package:pachub/Utils/appstring.dart';
import 'package:pachub/Utils/constant.dart';
import 'package:pachub/Utils/images.dart';
import 'package:pachub/app_function/MyAppFunction.dart';
import 'package:pachub/common_widget/customloader.dart';
import 'package:pachub/common_widget/textstyle.dart';
import 'package:pachub/config/preference.dart';
import 'package:pachub/models/Profile_model.dart';
import 'package:pachub/models/dashboard_card_count_coach_athelte.dart';
import 'package:pachub/view/dashboard/tab_deatil_screen.dart';
import 'package:pachub/view/login/login_view.dart';

import '../../common_widget/nodatafound_page.dart';
import '../../services/request.dart';


///////////Todo Athlelete DashboardCount view ////////////
class ViewAtheleteCountDetails extends StatefulWidget {
  const ViewAtheleteCountDetails( {Key? key}) : super(key: key);

  @override
  State<ViewAtheleteCountDetails> createState() => _ViewAtheleteCountDetailsState();
}

class _ViewAtheleteCountDetailsState extends State<ViewAtheleteCountDetails> {
  String? accessToken;
  Map item = {};
  List athleteItemList = [];
  List itemData = [];
  bool _isFirstLoadRunning = false;



  @override
  void initState() {
    setState(() {
      accessToken = PreferenceUtils.getString("accesstoken");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        elevation: 0.0,
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: SingleChildScrollView(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: FutureBuilder<DashboardAthleteCouchCount?>(
                future: get_Dashboard_Card_count_coach_athelte(accessToken),
                builder: (context, snapshot) {
                  if (snapshot.hasError)
                    const Center(
                      child: NoDataFound(),
                    );
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(child: CustomLoader(),);
                    case ConnectionState.done:
                      if (snapshot.hasData) {
                        List<ViewCountDetails>? viewCountDetails = snapshot.data?.viewCountDetails;
                        if (snapshot.data != null) {
                          return Column(
                            children: [
                              if (viewCountDetails!.isEmpty) Container() else Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
                                    child: CommonText(text: "Profile View by Athlete", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w600),
                                  ),
                                  Container(
                                    height: 45,
                                    width: Get.width,
                                    color: AppColors.grey_hint_color,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      child: Row(
                                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: CommonText(
                                                text: 'NAME',
                                                fontSize: 12,
                                                color: AppColors.black_txcolor,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Expanded(
                                            child: CommonText(
                                                text: 'ROLE',
                                                fontSize: 12,
                                                color: AppColors.black_txcolor,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          CommonText(
                                              text: '',
                                              fontSize: 12,
                                              color: AppColors.black_txcolor,
                                              fontWeight: FontWeight.w600)
                                        ],
                                      ),
                                    ),
                                  ),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: viewCountDetails.length,
                                      itemBuilder: (context, index) {
                                        var countItem = viewCountDetails[index];
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            if(countItem.roleName == "Athlete")
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius: BorderRadius.circular(1000.0),
                                                        child: CachedNetworkImage(
                                                          height: 28,
                                                          width: 28,
                                                          fit: BoxFit.cover,
                                                          imageUrl: "${countItem.picturePathS3}",
                                                          placeholder: (context, url) =>
                                                              CustomLoader(),
                                                          errorWidget: (context, url, error) =>
                                                              SvgPicture.asset(
                                                                userProfile_image,
                                                                height: 28,
                                                                width: 28,
                                                              ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 10),
                                                      CommonText(
                                                          text: "${countItem.userName}",
                                                          fontSize: 12,
                                                          color: AppColors.black_txcolor,
                                                          fontWeight: FontWeight.w500),
                                                    ],
                                                  ),
                                                  Center(
                                                    child: CommonText(
                                                        text: "${countItem.roleName}",
                                                        fontSize: 12,
                                                        color: AppColors.black_txcolor,
                                                        fontWeight: FontWeight.w500),
                                                  ),
                                                  InkWell(
                                                    onTap: () async {
                                                      await manage_profile_userDetail_Api(countItem.userID.toString());
                                                      _admin_UserDeatil(countItem.userID.toString());
                                                    },
                                                    child: Row(
                                                      children: [
                                                        SvgPicture.asset(
                                                            profile_icon,
                                                            color: AppColors.black_txcolor,
                                                            height: 15,
                                                            width: 15,
                                                        ),
                                                        SizedBox(width: 5),
                                                        CommonText(
                                                            text: "User Details",
                                                            fontSize: 12,
                                                            color: AppColors.black_txcolor,
                                                            fontWeight: FontWeight.w500),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            if(countItem.roleName != "Athlete")
                                              Container(),
                                            if(countItem.roleName == "Athlete")
                                            Divider(color: AppColors.grey_hint_color, thickness: 0.3,),
                                            if(countItem.roleName == "Athlete")
                                              Container(),
                                          ],
                                        );
                                      }
                                  ),
                                ],
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
          ),
        ),
      ),
    );
  }


  Future<bool> _admin_UserDeatil(String userId) async {
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
            child:  _isFirstLoadRunning
                ? Align(
              alignment: Alignment.center,
              child: CustomLoader(),
            )
                : item.isEmpty
                ? const Align(
              alignment: Alignment.center,
              child: Center(child: Text("No Data Found"),),
            ): Padding(
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
                          imageUrl: "${item["picturePathS3"]}",
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
                                text: "${item["displayName"]}",
                                fontSize: 18,
                                color: AppColors.black_txcolor,
                                fontWeight: FontWeight.w500),
                            const SizedBox(height: 5),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  locationIcon,
                                  color: AppColors.black,
                                ),
                                const SizedBox(width: 3),
                                Expanded(
                                  child: CommonText(
                                      text:
                                      "${item["streetAddress"]}, ${item["city"]}, ${item["state"]}, ${item["zipcode"]}",
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
                                  emailIcon,
                                  color: AppColors.black,
                                ),
                                const SizedBox(width: 3),
                                CommonText(
                                    text: "${item["userEmail"]}",
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
                                const SizedBox(width: 3),
                                CommonText(
                                    text: "${item["contact"]}",
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
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: athleteItemList.length.compareTo(0),
                      itemBuilder: (context, index) {
                        print("List Of tab length ==-===<><. ${athleteItemList.length}");
                        var group = groupBy(athleteItemList, (e) => e["displayGroup"]).map((key, value) => MapEntry(key,
                            value
                                .map((e) => e["displayGroup"])
                                .whereNotNull()));

                        print(">>>>>>>>>>>>> $group");
                        print(">>>>>>>>>>>>> ${group.length}");
                        return TabAdminHomeDetailScreen(
                            userId, group.length, group);
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
          ),
        ),
      ),
    );

    return shouldPop ?? false;
  }

   manage_profile_userDetail_Api(String? userId) async {
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
        item = response.data["userdetails"];
        athleteItemList = response.data["attribute"];
        itemData.add(item);
        // uniquelist = response.data["attribute"].where((value) => models.add(value["displayGroup"])).toList();
        print("+++++this is item ${response.data["attribute"]}");
        print("+++++ item ${item["picturePathS3"]}");
        print("+++++this is item $athleteItemList");
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


}

///////////Todo Specialist DashboardCount view ////////////

class ViewSpecialistCountDetails extends StatefulWidget {
  const ViewSpecialistCountDetails( {Key? key}) : super(key: key);

  @override
  State<ViewSpecialistCountDetails> createState() => _ViewSpecialistCountDetailsState();
}

class _ViewSpecialistCountDetailsState extends State<ViewSpecialistCountDetails> {
  String? accessToken;
  Map item = {};
  List athleteItemList = [];
  List itemData = [];
  bool _isFirstLoadRunning = false;


  @override
  void initState() {
    setState(() {
      accessToken = PreferenceUtils.getString("accesstoken");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        elevation: 0.0,
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: SingleChildScrollView(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: FutureBuilder<DashboardAthleteCouchCount?>(
                future: get_Dashboard_Card_count_coach_athelte(accessToken),
                builder: (context, snapshot) {
                  if (snapshot.hasError)
                    const Center(
                      child: NoDataFound(),
                    );
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(child: CustomLoader(),);
                    case ConnectionState.done:
                      if (snapshot.hasData) {
                        List<ViewCountDetails>? viewCountDetails = snapshot.data?.viewCountDetails;
                        if (snapshot.data != null) {
                          return Column(
                            children: [
                              viewCountDetails!.isEmpty
                                  ? Container()
                                  : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
                                    child: CommonText(text: "Profile View by Advisor", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w600),
                                  ),
                                  Container(
                                    height: 45,
                                    width: Get.width,
                                    color: AppColors.grey_hint_color,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          CommonText(
                                              text: 'NAME',
                                              fontSize: 12,
                                              color: AppColors.black_txcolor,
                                              fontWeight: FontWeight.w600),
                                          CommonText(
                                              text: 'ROLE',
                                              fontSize: 12,
                                              color: AppColors.black_txcolor,
                                              fontWeight: FontWeight.w600),
                                          CommonText(
                                              text: '',
                                              fontSize: 12,
                                              color: AppColors.dark_blue_button_color,
                                              fontWeight: FontWeight.w600)
                                        ],
                                      ),
                                    ),
                                  ),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: viewCountDetails.length,
                                      itemBuilder: (context, index) {
                                        var countItem = viewCountDetails[index];
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            if(countItem.roleName == "Advisor")
                                              Padding(
                                                padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius: BorderRadius.circular(1000.0),
                                                            child: CachedNetworkImage(
                                                              height: 28,
                                                              width: 28,
                                                              fit: BoxFit.cover,
                                                              imageUrl: "${countItem.picturePathS3}",
                                                              placeholder: (context, url) =>
                                                                  CustomLoader(),
                                                              errorWidget: (context, url, error) =>
                                                                  SvgPicture.asset(
                                                                    userProfile_image,
                                                                    height: 28,
                                                                    width: 28,
                                                                  ),
                                                            ),
                                                          ),
                                                          SizedBox(width: 10),
                                                          Expanded(
                                                            child: CommonText(
                                                                text: "${countItem.userName}",
                                                                fontSize: 12,
                                                                color: AppColors.black_txcolor,
                                                                fontWeight: FontWeight.w500),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Center(
                                                        child: CommonText(
                                                            text: "${countItem.name}",
                                                            fontSize: 12,
                                                            color: AppColors.black_txcolor,
                                                            fontWeight: FontWeight.w500),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () async {
                                                        await manage_profile_userDetail_Api(countItem.userID.toString());
                                                        _admin_UserDeatil(countItem.userID.toString());
                                                      },
                                                      child: Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                            profile_icon,
                                                            color: AppColors.black_txcolor,
                                                            height: 15,
                                                            width: 15,
                                                          ),
                                                          SizedBox(width: 5),
                                                          CommonText(
                                                              text: "User Details",
                                                              fontSize: 12,
                                                              color: AppColors.black_txcolor,
                                                              fontWeight: FontWeight.w500),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            if(countItem.roleName != "Advisor")
                                              Container(),
                                            if(countItem.roleName == "Advisor")
                                              Divider(color: AppColors.grey_hint_color, thickness: 0.3,),
                                            if(countItem.roleName == "Advisor")
                                              Container(),
                                          ],
                                        );
                                      }
                                  ),
                                ],
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
          ),
        ),
      ),
    );
  }
  Future<bool> _admin_UserDeatil(String userId) async {
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
            child:  _isFirstLoadRunning
                ? Align(
              alignment: Alignment.center,
              child: CustomLoader(),
            ) : item.isEmpty
                ? const Align(
              alignment: Alignment.center,
              child: Center(child: Text("No Data Found"),),
            ): Padding(
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
                          imageUrl: "${item["picturePathS3"]}",
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
                                text: "${item["displayName"]}",
                                fontSize: 18,
                                color: AppColors.black_txcolor,
                                fontWeight: FontWeight.w500),
                            const SizedBox(height: 5),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  locationIcon,
                                  color: AppColors.black,
                                ),
                                const SizedBox(width: 3),
                                Expanded(
                                  child: CommonText(
                                      text:
                                      "${item["streetAddress"]}, ${item["city"]}, ${item["state"]}, ${item["zipcode"]}",
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
                                  emailIcon,
                                  color: AppColors.black,
                                ),
                                const SizedBox(width: 3),
                                Expanded(
                                  child: CommonText(
                                      text: "${item["userEmail"]}",
                                      fontSize: 15,
                                      color: AppColors.black_txcolor,
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
                                    text: "${item["contact"]}",
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
                  const SizedBox(height: 10),
                  const CommonText(
                      text: AppString.organizationDetails,
                      fontSize: 15,
                      color: AppColors.black_txcolor,
                      fontWeight: FontWeight.w500),
                  const SizedBox(height: 15),
                  CommonText(
                      text: "${item["otherOrganizationName"] ?? ""}",
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
                                text: "${item["organizationAddress"]}, ${item["organizationCity"]}, ${item["organizationState"]}, ${item["organizationZipcode"]}",
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
                      itemCount: athleteItemList.length.compareTo(0),
                      itemBuilder: (context, index) {
                        print("List Of tab length ==-===<><. ${athleteItemList.length}");
                        var group = groupBy(athleteItemList,
                                (e) => e["displayGroup"])
                            .map((key, value) => MapEntry(
                            key,
                            value
                                .map((e) => e["displayGroup"])
                                .whereNotNull()));

                        print(">>>>>>>>>>>>> $group");
                        print(">>>>>>>>>>>>> ${group.length}");
                        return TabAdminAdvisorDetailScreen(userId, group.length);
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
          ),
        ),
      ),
    );

    return shouldPop ?? false;
  }

  manage_profile_userDetail_Api(String? userId) async {
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
        item = response.data["userdetails"];
        athleteItemList = response.data["attribute"];
        itemData.add(item);
        // uniquelist = response.data["attribute"].where((value) => models.add(value["displayGroup"])).toList();
        print("+++++this is item ${response.data["attribute"]}");
        print("+++++ item ${item["picturePathS3"]}");
        print("+++++this is item $athleteItemList");
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
}

///////////Todo CoachRecruiter DashboardCount view ////////////

class ViewCoachListCountDetails extends StatefulWidget {
  const ViewCoachListCountDetails( {Key? key}) : super(key: key);

  @override
  State<ViewCoachListCountDetails> createState() => _ViewCoachListCountDetailsState();
}

class _ViewCoachListCountDetailsState extends State<ViewCoachListCountDetails> {
  String? accessToken;
  Map item = {};
  List itemList = [];
  List itemData = [];
  bool _isFirstLoadRunning = false;



  @override
  void initState() {
    setState(() {
      accessToken = PreferenceUtils.getString("accesstoken");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        elevation: 0.0,
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: SingleChildScrollView(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: FutureBuilder<DashboardAthleteCouchCount?>(
                future: get_Dashboard_Card_count_coach_athelte(accessToken),
                builder: (context, snapshot) {
                  if (snapshot.hasError)
                    const Center(
                      child: NoDataFound(),
                    );
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(child: CustomLoader(),);
                    case ConnectionState.done:
                      if (snapshot.hasData) {
                        List<ViewCountDetails>? viewCountDetails = snapshot.data?.viewCountDetails;
                        if (snapshot.data != null) {
                          return Column(
                            children: [
                              viewCountDetails!.isEmpty
                                  ? Container()
                                  : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
                                    child: CommonText(text: "Profile View by Coach / Recruiter", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w600),
                                  ),
                                  Container(
                                    height: 45,
                                    width: Get.width,
                                    color: AppColors.grey_hint_color,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          CommonText(
                                              text: 'NAME',
                                              fontSize: 12,
                                              color: AppColors.black_txcolor,
                                              fontWeight: FontWeight.w600),
                                          CommonText(
                                              text: 'ROLE',
                                              fontSize: 12,
                                              color: AppColors.black_txcolor,
                                              fontWeight: FontWeight.w600),
                                          CommonText(
                                              text: '',
                                              fontSize: 12,
                                              color: AppColors.dark_blue_button_color,
                                              fontWeight: FontWeight.w600)
                                        ],
                                      ),
                                    ),
                                  ),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: viewCountDetails.length,
                                      itemBuilder: (context, index) {
                                        var countItem = viewCountDetails[index];
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            if(countItem.roleName == "Coach / Recruiter")
                                              Padding(
                                                padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius: BorderRadius.circular(1000.0),
                                                            child: CachedNetworkImage(
                                                              height: 28,
                                                              width: 28,
                                                              fit: BoxFit.cover,
                                                              imageUrl: "${countItem.picturePathS3}",
                                                              placeholder: (context, url) =>
                                                                  CustomLoader(),
                                                              errorWidget: (context, url, error) =>
                                                                  SvgPicture.asset(
                                                                    userProfile_image,
                                                                    height: 28,
                                                                    width: 28,
                                                                  ),
                                                            ),
                                                          ),
                                                          SizedBox(width: 10),
                                                          Expanded(
                                                            child: CommonText(
                                                                text: "${countItem.userName}",
                                                                fontSize: 12,
                                                                color: AppColors.black_txcolor,
                                                                fontWeight: FontWeight.w500),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Center(
                                                        child: CommonText(
                                                            text: "${countItem.roleName}",
                                                            fontSize: 12,
                                                            color: AppColors.black_txcolor,
                                                            fontWeight: FontWeight.w500),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () async {
                                                        await manage_profile_userDetail_Api(countItem.userID.toString());
                                                        _admin_UserDeatil(countItem.userID.toString());
                                                      },
                                                      child: Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                            profile_icon,
                                                            color: AppColors.black_txcolor,
                                                            height: 15,
                                                            width: 15,
                                                          ),
                                                          SizedBox(width: 5),
                                                          CommonText(
                                                              text: "User Details",
                                                              fontSize: 12,
                                                              color: AppColors.black_txcolor,
                                                              fontWeight: FontWeight.w500),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            if(countItem.roleName != "Coach / Recruiter")
                                              Container(),
                                            if(countItem.roleName == "Coach / Recruiter")
                                              Divider(color: AppColors.grey_hint_color, thickness: 0.3,),
                                            if(countItem.roleName == "Coach / Recruiter")
                                              Container(),
                                          ],
                                        );
                                      }
                                  ),
                                ],
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
          ),
        ),
      ),
    );
  }
  Future<bool> _admin_UserDeatil(String userId) async {
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
            child:  _isFirstLoadRunning
                ? Align(
              alignment: Alignment.center,
              child: CustomLoader(),
            ) : item.isEmpty
                ? const Align(
              alignment: Alignment.center,
              child: Center(child: Text("No Data Found"),),
            ): Padding(
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
                          imageUrl: "${item["picturePathS3"]}",
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
                                text: "${item["displayName"]}",
                                fontSize: 18,
                                color: AppColors.black_txcolor,
                                fontWeight: FontWeight.w500),
                            const SizedBox(height: 5),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  locationIcon,
                                  color: AppColors.black,
                                ),
                                const SizedBox(width: 3),
                                Expanded(
                                  child: CommonText(
                                      text:
                                      "${item["streetAddress"]}, ${item["city"]}, ${item["state"]}, ${item["zipcode"]}",
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
                                  emailIcon,
                                  color: AppColors.black,
                                ),
                                const SizedBox(width: 3),
                                Expanded(
                                  child: CommonText(
                                      text: "${item["userEmail"]}",
                                      fontSize: 15,
                                      color: AppColors.black_txcolor,
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
                                    text: "${item["contact"]}",
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
                  const SizedBox(height: 10),
                  const CommonText(
                      text: AppString.organizationDetails,
                      fontSize: 15,
                      color: AppColors.black_txcolor,
                      fontWeight: FontWeight.w500),
                  const SizedBox(height: 15),
                  CommonText(
                      text: "${item["organizationName"] ?? item["otherOrganizationName"] ?? ""}",
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
                                text: "${item["organizationAddress"]}, ${item["organizationCity"]}, ${item["organizationState"]}, ${item["organizationZipcode"]}",
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
                        print("List Of tab length ==-===<><. ${itemList.length}");
                        return TabAdminCoachDetailScreen(userId, itemList, itemList.length, PreferenceUtils.getString("sport"));
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
          ),
        ),
      ),
    );

    return shouldPop ?? false;
  }

  manage_profile_userDetail_Api(String? userId) async {
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
        item = response.data["userdetails"];
        itemList = response.data["attribute"];
        itemData.add(item);
        // uniquelist = response.data["attribute"].where((value) => models.add(value["displayGroup"])).toList();
        print("+++++this is item ${response.data["attribute"]}");
        print("+++++ item ${item["picturePathS3"]}");
        print("+++++this is item $itemList");
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
}


///////////Todo BookMarked DashboardCount view ////////////

class ViewBookMarkedCountDetails extends StatefulWidget {
  const ViewBookMarkedCountDetails({Key? key}) : super(key: key);

  @override
  State<ViewBookMarkedCountDetails> createState() => _ViewBookMarkedCountDetailsState();
}

class _ViewBookMarkedCountDetailsState extends State<ViewBookMarkedCountDetails> {
  String? accessToken;
  Map item = {};
  List athleteItemList = [];
  List itemData = [];
  bool _isFirstLoadRunning = false;
  List itemList = [];


  @override
  void initState() {
    setState(() {
      accessToken = PreferenceUtils.getString("accesstoken");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        elevation: 0.0,
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: SingleChildScrollView(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: FutureBuilder<DashboardAthleteCouchCount?>(
                future: get_Dashboard_Card_count_coach_athelte(accessToken),
                builder: (context, snapshot) {
                  if (snapshot.hasError)
                    const Center(
                      child: NoDataFound(),
                    );
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(child: CustomLoader(),);
                    case ConnectionState.done:
                      if (snapshot.hasData) {
                        List<BookMarkCountDetails>? bookMarkCountDetails = snapshot.data?.bookMarkCountDetails;
                        if (snapshot.data != null) {
                          return Column(
                            children: [
                              bookMarkCountDetails!.isEmpty
                                  ? Container()
                                  : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
                                    child: CommonText(text: "Profile Bookmark", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w600),
                                  ),
                                  Container(
                                    height: 45,
                                    width: Get.width,
                                    color: AppColors.grey_hint_color,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          CommonText(
                                              text: 'NAME',
                                              fontSize: 12,
                                              color: AppColors.black_txcolor,
                                              fontWeight: FontWeight.w600),
                                          CommonText(
                                              text: 'ROLE',
                                              fontSize: 12,
                                              color: AppColors.black_txcolor,
                                              fontWeight: FontWeight.w600),
                                          CommonText(
                                              text: '',
                                              fontSize: 12,
                                              color: AppColors.dark_blue_button_color,
                                              fontWeight: FontWeight.w600)
                                        ],
                                      ),
                                    ),
                                  ),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: bookMarkCountDetails.length,
                                      itemBuilder: (context, index) {
                                        var countItem = bookMarkCountDetails[index];
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius: BorderRadius.circular(1000.0),
                                                          child: CachedNetworkImage(
                                                            height: 28,
                                                            width: 28,
                                                            fit: BoxFit.cover,
                                                            imageUrl: "${countItem.picturePathS3}",
                                                            placeholder: (context, url) =>
                                                                CustomLoader(),
                                                            errorWidget: (context, url, error) =>
                                                                SvgPicture.asset(
                                                                  userProfile_image,
                                                                  height: 28,
                                                                  width: 28,
                                                                ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 10),
                                                        Expanded(
                                                          child: CommonText(
                                                              text: "${countItem.userName}",
                                                              fontSize: 12,
                                                              color: AppColors.black_txcolor,
                                                              fontWeight: FontWeight.w500),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Center(
                                                      child: CommonText(
                                                          text: "${countItem.name}",
                                                          fontSize: 12,
                                                          color: AppColors.black_txcolor,
                                                          fontWeight: FontWeight.w500),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () async {
                                                      await manage_profile_userDetail_Api(countItem.userID.toString());
                                                      _admin_UserDeatil(countItem.userID.toString(),countItem.roleName.toString(),);
                                                    },
                                                    child: Row(
                                                      children: [
                                                        SvgPicture.asset(
                                                          profile_icon,
                                                          color: AppColors.black_txcolor,
                                                          height: 15,
                                                          width: 15,
                                                        ),
                                                        SizedBox(width: 5),
                                                        CommonText(
                                                            text: "User Details",
                                                            fontSize: 12,
                                                            color: AppColors.black_txcolor,
                                                            fontWeight: FontWeight.w500),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Divider(color: AppColors.grey_hint_color, thickness: 0.3,),
                                          ],
                                        );
                                      }
                                  ),
                                ],
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
          ),
        ),
      ),
    );
  }
  Future<bool> _admin_UserDeatil(String userId, String roleName) async {
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
            child:  _isFirstLoadRunning
                ? Align(
              alignment: Alignment.center,
              child: CustomLoader(),
            )
                : item.isEmpty
                ? const Align(
              alignment: Alignment.center,
              child: Center(child: Text("No Data Found"),),
            ): Padding(
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
                          imageUrl: "${item["picturePathS3"]}",
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
                                text: "${item["displayName"]}",
                                fontSize: 18,
                                color: AppColors.black_txcolor,
                                fontWeight: FontWeight.w500),
                            const SizedBox(height: 5),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  locationIcon,
                                  color: AppColors.black,
                                ),
                                const SizedBox(width: 3),
                                Expanded(
                                  child: CommonText(
                                      text:
                                      "${item["streetAddress"]}, ${item["city"]}, ${item["state"]}, ${item["zipcode"]}",
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
                                  emailIcon,
                                  color: AppColors.black,
                                ),
                                const SizedBox(width: 3),
                                CommonText(
                                    text: "${item["userEmail"]}",
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
                                const SizedBox(width: 3),
                                CommonText(
                                    text: "${item["contact"]}",
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
                  roleName == "Athlete" ? Container() : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      const CommonText(
                          text: AppString.organizationDetails,
                          fontSize: 15,
                          color: AppColors.black_txcolor,
                          fontWeight: FontWeight.w500),
                      const SizedBox(height: 15),
                      CommonText(
                          text: "${item["organizationName"] ?? item["otherOrganizationName"]}",
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
                                    text: "${item["organizationAddress"]}, ${item["organizationCity"]}, ${item["organizationState"]}, ${item["organizationZipcode"]}",
                                    fontSize: 15,
                                    color: AppColors.black_txcolor,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                  if(roleName == "Athlete")
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: athleteItemList.length.compareTo(0),
                      itemBuilder: (context, index) {
                        print("List Of tab length ==-===<><. ${athleteItemList.length}");
                        var group = groupBy(athleteItemList,
                                (e) => e["displayGroup"])
                            .map((key, value) => MapEntry(
                            key,
                            value
                                .map((e) => e["displayGroup"])
                                .whereNotNull()));

                        print(">>>>>>>>>>>>> $group");
                        print(">>>>>>>>>>>>> ${group.length}");
                        return TabAdminHomeDetailScreen(userId, group.length, group);
                      }),
                  if(roleName == "Advisor")
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: itemList.length.compareTo(0),
                      itemBuilder: (context, index) {
                        print("List Of tab length ==-===<><. ${itemList.length}");
                        var group = groupBy(itemList, (e) => e["displayGroup"]).map((key, value) =>  MapEntry(key, value.map((e) => e["displayGroup"]).whereNotNull()));

                        print(">>>>>>>>>>>>> $group");
                        print(">>>>>>>>>>>>> ${group.length}");
                        if(itemList[index]["displayGroup"] == "Milestones") {
                          return Container();
                        } else {
                          return  TabAdminAdvisorDetailScreen(userId,group.length);
                        }
                      }),
                  if(roleName == "Coach / Recruiter")
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: itemList.length.compareTo(0),
                      itemBuilder: (context, index) {
                        print("List Of tab length ==-===<><. ${itemList.length}");
                        return TabAdminCoachDetailScreen(userId, itemList, itemList.length , PreferenceUtils.getString("sport"));
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
          ),
        ),
      ),
    );

    return shouldPop ?? false;
  }

  manage_profile_userDetail_Api(String? userId) async {
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
        item = response.data["userdetails"];
        athleteItemList = response.data["attribute"];
        itemList = response.data["attribute"];
        itemData.add(item);
        // uniquelist = response.data["attribute"].where((value) => models.add(value["displayGroup"])).toList();
        print("+++++this is item ${response.data["attribute"]}");
        print("+++++ item ${item["picturePathS3"]}");
        print("+++++this is item $athleteItemList");
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
}
