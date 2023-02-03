import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:pachub/Utils/appcolors.dart';
import 'package:pachub/Utils/appstring.dart';
import 'package:pachub/Utils/constant.dart';
import 'package:pachub/Utils/images.dart';
import 'package:pachub/app_function/MyAppFunction.dart';
import 'package:pachub/common_widget/customloader.dart';
import 'package:pachub/common_widget/textstyle.dart';
import 'package:get/get.dart';
import 'package:pachub/config/preference.dart';
import 'package:pachub/view/login/login_view.dart';
import 'package:pachub/view/profile/viewimage/fullphotoviewpage.dart';
import 'package:url_launcher/url_launcher.dart';

///////Todo PersonalDetails view /////////

class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen({Key? key}) : super(key: key);

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  var athleteuserdetails = {};
  bool _isFirstLoadRunning = false;
  List DivisionList = [];
  bool _isChecked_contact_number = false;
  bool _isChecked_Email_address = false;

  @override
  void initState() {
    setState(() {});
    super.initState();
    GETDIVISION();
    Manage_Profile(); //Manage_Profile(userid);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      edgeOffset: 20,
      onRefresh: () async {
        await Future.delayed(Duration(milliseconds: 1500));
        setState(() {
          Manage_Profile();
        });
      },
      child: Scaffold(
          body: athleteuserdetails.isEmpty
              ? athleteuserdetails.isEmpty
                  ? Center(child: CustomLoader())
                  : Center(
                      child: Text("No Data Found"),
                    )
              : Padding(
                  padding: const EdgeInsets.only(
                      left: 21, right: 21, top: 20, bottom: 0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (athleteuserdetails["picturePathS3"] != null) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FullPhotoViewPage(
                                          photoUrl:
                                              "${athleteuserdetails["picturePathS3"]}")));
                            } else if (athleteuserdetails["picturePathS3"] ==
                                null) {
                              null;
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(4),
                            height: 150,
                            width: 150,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10000.0),
                              child: Image.network(
                                "${athleteuserdetails["picturePathS3"]}",
                                fit: BoxFit.cover,
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                                  print("Exception >> ${exception.toString()}");
                                  return Image.asset(avatarImage);
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        CommonText(
                            text: "${athleteuserdetails["displayName"]}",
                            fontSize: 16,
                            color: AppColors.black,
                            fontWeight: FontWeight.w700),
                        const SizedBox(height: 5),
                        athleteuserdetails["DOB"] != null &&
                                athleteuserdetails["DOB"] != ""
                            ? _builRowView(
                                cakeIcon,
                                DateFormat('MMM d y').format(DateTime.parse(
                                        athleteuserdetails["DOB"].toString() ??
                                            "")) ??
                                    "")
                            : Container(),
                        const SizedBox(height: 8),
                        athleteuserdetails["userEmail"] != null &&
                                athleteuserdetails["userEmail"] != ""
                            ? _builRowView(
                                emailIcon, "${athleteuserdetails["userEmail"]}")
                            : Container(),
                        const SizedBox(height: 8),
                        athleteuserdetails["contact"] != null &&
                                athleteuserdetails["contact"] != ""
                            ? _builRowView(
                                call_icon, "${athleteuserdetails["contact"]}")
                            : Container(),
                        const SizedBox(height: 8),
                        _buildLocationView(),
                        const SizedBox(height: 15),
                        const CommonText(
                            text: "Organization Detail",
                            fontSize: 16,
                            color: AppColors.black,
                            fontWeight: FontWeight.w700),
                        const SizedBox(height: 8),
                        PreferenceUtils.getString("role") == "Advisor"
                            ? athleteuserdetails[
                                            "otherOrganizationName"] !=
                                        null &&
                                    athleteuserdetails[
                                            "otherOrganizationName"] !=
                                        ""
                                ? CommonText(
                                    text: athleteuserdetails[
                                        "otherOrganizationName"],
                                    fontSize: 14,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w500)
                                : Container()
                            : athleteuserdetails["organizationName"] != null &&
                                    athleteuserdetails["organizationName"] != ""
                                ? CommonText(
                                    text:
                                        athleteuserdetails["organizationName"],
                                    fontSize: 14,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w500)
                                : Container(),
                        const SizedBox(height: 10),
                        athleteuserdetails["organizationAddress"] != null &&
                                athleteuserdetails["organizationAddress"] != ""
                            ? CommonText(
                                text:
                                    "${athleteuserdetails["organizationAddress"] ?? ""},${athleteuserdetails["organizationCity"] ?? ""}, ${athleteuserdetails["organizationState"] ?? ""},${athleteuserdetails["organizationZipcode"] ?? ""}",
                                fontSize: 14,
                                color: AppColors.black,
                                fontWeight: FontWeight.w400)
                            : Container(),
                        PreferenceUtils.getString("role") == "Advisor"
                            ? Container()
                            : const SizedBox(height: 10),
                        PreferenceUtils.getString("role") == "Advisor"
                            ? Container()
                            : athleteuserdetails["divID"] != null &&
                                    athleteuserdetails["divID"] != ""
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const CommonText(
                                          text: "My Division",
                                          fontSize: 16,
                                          color: AppColors.black,
                                          fontWeight: FontWeight.w700),
                                      const SizedBox(height: 5),
                                      _buildDIVISIONNAME(),
                                    ],
                                  )
                                : Container(),
                        athleteuserdetails["coachRole"] != null &&
                                athleteuserdetails["coachRole"] != ""
                            ? const SizedBox(height: 10)
                            : Container(),
                        athleteuserdetails["coachRole"] != null &&
                                athleteuserdetails["coachRole"] != ""
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const CommonText(
                                      text: "Coach Role",
                                      fontSize: 16,
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w700),
                                  const SizedBox(height: 5),
                                  CommonText(
                                      text:
                                          "${athleteuserdetails["coachRole"]}",
                                      fontSize: 14,
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w400),
                                ],
                              )
                            : Container(),
                        athleteuserdetails["bio"] != null &&
                                athleteuserdetails["bio"] != ""
                            ? const SizedBox(height: 10)
                            : Container(),
                        athleteuserdetails["bio"] != null &&
                                athleteuserdetails["bio"] != ""
                            ? CommonText(
                                text: "About",
                                fontSize: 16,
                                color: AppColors.black,
                                fontWeight: FontWeight.w700)
                            : CommonText(
                                text: "",
                                fontSize: 16,
                                color: AppColors.black,
                                fontWeight: FontWeight.w700),
                        athleteuserdetails["bio"] != null &&
                                athleteuserdetails["bio"] != ""
                            ? const SizedBox(height: 10)
                            : Container(),
                        athleteuserdetails["bio"] != null &&
                                athleteuserdetails["bio"] != ""
                            ? CommonText(
                                text: "${athleteuserdetails["bio"]}",
                                fontSize: 14,
                                color: AppColors.black,
                                fontWeight: FontWeight.w400)
                            : Container(),
                        PreferenceUtils.getString("role") == "Coach / Recruiter"
                            ? const SizedBox(height: 10)
                            : Container(),
                        PreferenceUtils.getString("role") == "Coach / Recruiter"
                            ? CommonText(
                                text: "Hide From Users",
                                fontSize: 16,
                                color: AppColors.black,
                                fontWeight: FontWeight.w700)
                            : Container(),
                        PreferenceUtils.getString("role") == "Coach / Recruiter"
                            ? const SizedBox(height: 10)
                            : Container(),
                        PreferenceUtils.getString("role") == "Coach / Recruiter"
                            ? Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: AppColors.black_txcolor),
                                      ),
                                      child: Row(
                                        children: [
                                          athleteuserdetails["hidePhone"] == 1
                                              ? Checkbox(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4.0))),
                                                  onChanged: (bool? value) {},
                                                  value: true,
                                                  activeColor:
                                                      Colors.blueAccent,
                                                )
                                              : Checkbox(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4.0))),
                                                  onChanged: (bool? value) {},
                                                  value: false,
                                                  activeColor:
                                                      Colors.blueAccent,
                                                ),
                                          CommonText(
                                              text: "Contact Number",
                                              fontSize: 12,
                                              color: AppColors.stats_title_blue,
                                              fontWeight: FontWeight.w600),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: AppColors.black_txcolor),
                                      ),
                                      child: Row(
                                        children: [
                                          athleteuserdetails["hideEmail"] == 1
                                              ? Checkbox(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4.0))),
                                                  onChanged: (bool? value) {},
                                                  value: true,
                                                  activeColor:
                                                      Colors.blueAccent,
                                                )
                                              : Checkbox(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4.0))),
                                                  onChanged: (bool? value) {},
                                                  value: false,
                                                  activeColor:
                                                      Colors.blueAccent,
                                                ),
                                          CommonText(
                                              text: "Email Address",
                                              fontSize: 12,
                                              color: AppColors.stats_title_blue,
                                              fontWeight: FontWeight.w600),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                        athleteuserdetails["profileName"] != null &&
                                athleteuserdetails["profileName"] != ""
                            ? const SizedBox(height: 16)
                            : Container(),
                        athleteuserdetails["profileName"] != null &&
                                athleteuserdetails["profileName"] != ""
                            ? _buildContainer(
                                "${athleteuserdetails["profileName"]}")
                            : Container(),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                )),
    );
  }

  _builRowView(image, text) {
    return Row(children: [
      SvgPicture.asset(image),
      const SizedBox(width: 5),
      CommonText(
          text: text,
          fontSize: 14,
          color: AppColors.black,
          fontWeight: FontWeight.w400),
    ]);
  }

  _buildLocationView() {
    return Row(children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: SvgPicture.asset(locationIcon),
      ),
      const SizedBox(width: 5),
      Expanded(
        child: CommonText(
            text: "${athleteuserdetails["streetAddress"] ?? ""}" +
                ", " +
                "${athleteuserdetails["landMark"] ?? ""}" +
                ", " +
                "${athleteuserdetails["city"] ?? ""}" +
                ", " +
                "${athleteuserdetails["state"] ?? ""}" +
                " - " +
                "${athleteuserdetails["zipcode"] ?? ""}",
            fontSize: 14,
            color: AppColors.black,
            fontWeight: FontWeight.w400),
      ),
    ]);
  }

  _buildWorldView() {
    return Row(children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: SvgPicture.asset(world_icon),
      ),
      const SizedBox(width: 5),
      const CommonText(
          text: AppString.privateProfileText,
          fontSize: 12,
          color: AppColors.blacksubtext_color,
          fontWeight: FontWeight.w400),
    ]);
  }

  _buildContainer(String profileName) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: AppColors.profileColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildWorldView(),
            const SizedBox(height: 4),
            Padding(
              padding: EdgeInsets.only(left: 23),
              child: InkWell(
                onTap: () async {
                  await profile_lounch(profileName);
                  _launchUrl(profileName);
                  print("profile Name  ======> $profileName");
                },
                child: CommonText(
                    text:
                        "http://packhubweb.s3-website-us-west-2.amazonaws.com/profile/$profileName",
                    fontSize: 16,
                    color: AppColors.blue_button_Color,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildDIVISIONNAME() {
    print("this is divid ${athleteuserdetails["divID"].toString()}");
    print("this is DIVISION IDNAME ${DivisionList[0]["id"].toString()}");
    return Padding(
      padding: EdgeInsets.only(right: 0),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: DivisionList.length,
          itemBuilder: (context, i) {
            return Container(
              child: athleteuserdetails["divID"].toString() ==
                      DivisionList[i]["divisionID"].toString()
                  ? CommonText(
                      text: "${DivisionList[i]["DivisionName"] ?? ""}",
                      fontSize: 14,
                      color: AppColors.black,
                      fontWeight: FontWeight.w400)
                  : Container(),
            );
          }),
    );
  }

  Future<void> _launchUrl(String profileLink) async {
    if (!await launchUrl(Uri.parse(
        "http://packhubweb.s3-website-us-west-2.amazonaws.com/profile/$profileLink"))) {
      throw 'Could not launch ${"http://packhubweb.s3-website-us-west-2.amazonaws.com/profile/$profileLink"}';
    }
  }

  Manage_Profile() async {
    log('this is Manage_Profile  api call', name: "Manage_Profile");
    MyApplication.getInstance()!
        .checkConnectivity(context)
        .then((internet) async {
      if (internet != null && internet) {
        try {
          Dio dio = Dio();
          var response = await dio.get("${AppConstant.mamage_profile}",
              options: Options(followRedirects: false, headers: {
                "Authorization":
                    "Bearer ${PreferenceUtils.getString("accesstoken")}"
              }));
          print("-----this is url $response");
          if (response.statusCode == 200) {
            print("+++++this is manageprofile ${response.data}");
            setState(() {
              athleteuserdetails = response.data["userdetails"];
              print("---this is profile data== $athleteuserdetails");
              print(
                  "profile picture path--- ${athleteuserdetails["picturePathS3"]}");
            });
          } else if (response.statusCode == 401) {
            return Get.offAll(Loginscreennew());
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

  GETDIVISION() async {
    log('this is DIVISION name  api call', name: "DIVISION NAME");
    MyApplication.getInstance()!
        .checkConnectivity(context)
        .then((internet) async {
      if (internet != null && internet) {
        try {
          Dio dio = Dio();
          var response = await dio.get("${AppConstant.DIVISIONLISTING}",
              options: Options(followRedirects: false, headers: {
                "Authorization":
                    "Bearer ${PreferenceUtils.getString("accesstoken")}"
              }));
          print("-----this is DIVISIONurl $response");
          if (response.statusCode == 200) {
            print("+++++this is DIVISION Response ${response.data}");
            setState(() {
              DivisionList = response.data["division"];
              print("---this is DIVISION data== ${DivisionList.length}");
              print(
                  "profile DivisionName--- ${DivisionList[0]["DivisionName"]}");
            });
          } else if (response.statusCode == 401) {
            return Get.offAll(Loginscreennew());
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
}

///////Todo AthletePersonalDetails view /////////

class AthletePersonalDetailsScreen extends StatefulWidget {
  const AthletePersonalDetailsScreen({Key? key}) : super(key: key);

  @override
  State<AthletePersonalDetailsScreen> createState() =>
      _AthletePersonalDetailsScreenState();
}

class _AthletePersonalDetailsScreenState
    extends State<AthletePersonalDetailsScreen> {
  var athleteuserdetails = {};
  var persnoledetails = {};
  List collageName = [];
  bool _isFirstLoadRunning = false;
  List DivisionList = [];

  @override
  void initState() {
    setState(() {});
    super.initState();
    GETDIVISION();
    Manage_Profile(); //Manage_Profile(userid);
  }

  @override
  Widget build(BuildContext context) {
    athleteuserdetails['collegeName'] != null
        ? collageName = athleteuserdetails["collegeName"]
        : Container();
    print("=======> collagename ${collageName.toString()}");
    return RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      edgeOffset: 20,
      onRefresh: () async {
        await Future.delayed(Duration(milliseconds: 1500));
        setState(() {
          Manage_Profile();
        });
      },
      child: Scaffold(
          body: athleteuserdetails.isEmpty
              ? athleteuserdetails.isEmpty
                  ? Center(child: CustomLoader())
                  : Center(
                      child: Text("No Data Found"),
                    )
              : Padding(
                  padding: const EdgeInsets.only(
                      left: 21, right: 21, top: 20, bottom: 0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            print(
                                "this is click ${athleteuserdetails["picturePathS3"]}");
                            if (athleteuserdetails["picturePathS3"] != null) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FullPhotoViewPage(
                                          photoUrl:
                                              "${athleteuserdetails["picturePathS3"]}")));
                            } else if (athleteuserdetails["picturePathS3"] ==
                                null) {
                              null;
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(4),
                            height: 150,
                            width: 150,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10000.0),
                              child: Image.network(
                                "${athleteuserdetails["picturePathS3"]}",
                                fit: BoxFit.cover,
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                                  print("Exception >> ${exception.toString()}");
                                  return Image.asset(avatarImage);
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        CommonText(
                            text: "${athleteuserdetails["displayName"]}",
                            fontSize: 16,
                            color: AppColors.black,
                            fontWeight: FontWeight.w700),
                        const SizedBox(height: 5),
                        athleteuserdetails["DOB"] != null
                            ? _builRowView(
                                cakeIcon,
                                DateFormat('MMM d y').format(DateTime.parse(
                                        athleteuserdetails["DOB"].toString() ??
                                            "")) ??
                                    "")
                            : Container(),
                        const SizedBox(height: 8),
                        athleteuserdetails["userEmail"] != null
                            ? _builRowView(
                                emailIcon, "${athleteuserdetails["userEmail"]}")
                            : Container(),
                        const SizedBox(height: 8),
                        athleteuserdetails["contact"] != null
                            ? _builRowView(
                                call_icon, "${athleteuserdetails["contact"]}")
                            : Container(),
                        const SizedBox(height: 8),
                        _buildLocationView(),
                        const SizedBox(height: 15),
                        athleteuserdetails['collegeName'] != null
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 15),
                                  CommonText(
                                      text: "Colleges I Am Interested In",
                                      fontSize: 16,
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w700),
                                  Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 0, vertical: 0),
                                      child: ListView.builder(
                                          itemCount: collageName.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, i) {
                                            return Container(
                                                child: Row(children: [
                                              Container(
                                                  height: 20,
                                                  width: 20,
                                                  child: Image.asset(
                                                      pointerdot_icon)),
                                              Expanded(
                                                child: CommonText(
                                                    text: collageName[i]
                                                        .toString(),
                                                    fontSize: 15,
                                                    color: AppColors
                                                        .grey_text_color,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              )
                                            ]));
                                          })),
                                ],
                              )
                            : Container(),
                        athleteuserdetails["currentSchool"] == "" ||
                                athleteuserdetails["currentSchool"] == null
                            ? Container()
                            : const SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                                mainAxisAlignment: athleteuserdetails[
                                                "currentSchool"] ==
                                            "" ||
                                        athleteuserdetails["currentSchool"] ==
                                            null ||
                                        athleteuserdetails["currentSchool"] ==
                                            "null"
                                    ? MainAxisAlignment.start
                                    : MainAxisAlignment.spaceBetween,
                                children: [
                                  athleteuserdetails["currentSchool"] == "" ||
                                          athleteuserdetails["currentSchool"] ==
                                              null ||
                                          athleteuserdetails["currentSchool"] ==
                                              "null"
                                      ? Container()
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const CommonText(
                                                text: "Current School",
                                                fontSize: 16,
                                                color: AppColors.black,
                                                fontWeight: FontWeight.w700),
                                            const SizedBox(height: 5),
                                            CommonText(
                                                text:
                                                    "${athleteuserdetails["currentSchool"] ?? ""}",
                                                fontSize: 14,
                                                color: AppColors.black,
                                                fontWeight: FontWeight.w400),
                                          ],
                                        ),
                                  athleteuserdetails["ageAtDraft"] == "" ||
                                          athleteuserdetails["ageAtDraft"] ==
                                              null ||
                                          athleteuserdetails["ageAtDraft"] ==
                                              "null"
                                      ? Container()
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const CommonText(
                                                text: "Graduating Senior Age",
                                                fontSize: 16,
                                                color: AppColors.black,
                                                fontWeight: FontWeight.w700),
                                            const SizedBox(height: 5),
                                            CommonText(
                                                text:
                                                    "${athleteuserdetails["ageAtDraft"] ?? ""}",
                                                fontSize: 14,
                                                color: AppColors.black,
                                                fontWeight: FontWeight.w400),
                                          ],
                                        ),
                                ]),
                            athleteuserdetails["height"] == "" ||
                                    athleteuserdetails["height"] == null
                                ? Container()
                                : const SizedBox(height: 15),
                            Row(
                                mainAxisAlignment:
                                    athleteuserdetails["height"] == "" ||
                                            athleteuserdetails["height"] == null
                                        ? MainAxisAlignment.start
                                        : MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: athleteuserdetails["height"] == "" ||
                                            athleteuserdetails["height"] == null
                                        ? Container()
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const CommonText(
                                                  text: "Height",
                                                  fontSize: 16,
                                                  color: AppColors.black,
                                                  fontWeight: FontWeight.w700),
                                              const SizedBox(height: 5),
                                              CommonText(
                                                  text:
                                                      "${athleteuserdetails["height"] ?? ""}(Feet-Inches)",
                                                  fontSize: 14,
                                                  color: AppColors.black,
                                                  fontWeight: FontWeight.w400),
                                            ],
                                          ),
                                  ),
                                  athleteuserdetails["weight"] == "" ||
                                          athleteuserdetails["weight"] == null
                                      ? Container()
                                      : const SizedBox(width: 45),
                                  athleteuserdetails["weight"] == "" ||
                                          athleteuserdetails["weight"] == null
                                      ? Container()
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const CommonText(
                                                text: "Weight",
                                                fontSize: 16,
                                                color: AppColors.black,
                                                fontWeight: FontWeight.w700),
                                            const SizedBox(height: 5),
                                            CommonText(
                                                text:
                                                    "${athleteuserdetails["weight"] ?? ""}(Lbs.)",
                                                fontSize: 14,
                                                color: AppColors.black,
                                                fontWeight: FontWeight.w400),
                                          ],
                                        ),
                                ]),
                            athleteuserdetails["committedTo"] == " " ||
                                    athleteuserdetails["committedTo"] == null ||
                                    athleteuserdetails["committedTo"] == "." ||
                                    athleteuserdetails["committedTo"] == ""
                                ? Container()
                                : const SizedBox(height: 15),
                            athleteuserdetails["committedTo"] == " " ||
                                    athleteuserdetails["committedTo"] == null ||
                                    athleteuserdetails["committedTo"] == "." ||
                                    athleteuserdetails["committedTo"] == "" ||
                                    athleteuserdetails["committedTo"] == "null"
                                ? Container()
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CommonText(
                                          text: "Committed To",
                                          fontSize: 16,
                                          color: AppColors.black,
                                          fontWeight: FontWeight.w700),
                                      SizedBox(height: 5),
                                      CommonText(
                                          text:
                                              "${athleteuserdetails["committedTo"]}",
                                          fontSize: 14,
                                          color: AppColors.black,
                                          fontWeight: FontWeight.w400),
                                    ],
                                  ),
                            athleteuserdetails["divID"] != null &&
                                    athleteuserdetails["divID"] != ""
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 15),
                                      const CommonText(
                                          text: "My Division",
                                          fontSize: 16,
                                          color: AppColors.black,
                                          fontWeight: FontWeight.w700),
                                      const SizedBox(height: 5),
                                      _buildDIVISIONNAME(),
                                    ],
                                  )
                                : Container(),
                            athleteuserdetails["bio"] == "" ||
                                    athleteuserdetails["bio"] == null
                                ? Container()
                                : const SizedBox(height: 15),
                            athleteuserdetails["bio"] == "" ||
                                    athleteuserdetails["bio"] == null
                                ? Container()
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                        CommonText(
                                            text: "About",
                                            fontSize: 16,
                                            color: AppColors.black,
                                            fontWeight: FontWeight.w700),
                                        const SizedBox(height: 5),
                                        CommonText(
                                            text:
                                                "${athleteuserdetails["bio"]}",
                                            fontSize: 14,
                                            color: AppColors.black,
                                            fontWeight: FontWeight.w400)
                                      ]),
                            athleteuserdetails["profileName"] != null &&
                                    athleteuserdetails["profileName"] != ""
                                ? const SizedBox(height: 15)
                                : Container(),
                            athleteuserdetails["profileName"] != null &&
                                    athleteuserdetails["profileName"] != ""
                                ? const SizedBox(height: 16)
                                : Container(),
                          ],
                        ),
                        athleteuserdetails["profileName"] != null &&
                                athleteuserdetails["profileName"] != ""
                            ? _buildContainer(
                                "${athleteuserdetails["profileName"]}")
                            : Container(),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                )),
    );
  }

  _buildDIVISIONNAME() {
    print("this is divid ${athleteuserdetails["divID"].toString()}");
    print("this is DIVISION IDNAME ${DivisionList[0]["id"].toString()}");
    return Padding(
      padding: EdgeInsets.only(right: 0),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: DivisionList.length,
          itemBuilder: (context, i) {
            return Container(
              child: athleteuserdetails["divID"].toString() ==
                      DivisionList[i]["divisionID"].toString()
                  ? CommonText(
                      text: "${DivisionList[i]["DivisionName"] ?? ""}",
                      fontSize: 14,
                      color: AppColors.black,
                      fontWeight: FontWeight.w400)
                  : Container(),
            );
          }),
    );
  }

  _builRowView(image, text) {
    return Row(children: [
      SvgPicture.asset(image),
      const SizedBox(width: 5),
      CommonText(
          text: text,
          fontSize: 14,
          color: AppColors.black,
          fontWeight: FontWeight.w400),
    ]);
  }

  _buildLocationView() {
    return Row(children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: SvgPicture.asset(locationIcon),
      ),
      const SizedBox(width: 5),
      Expanded(
        child: CommonText(
            text: "${athleteuserdetails["streetAddress"] ?? ""}" +
                ", " +
                "${athleteuserdetails["landMark"] ?? ""}" +
                ", " +
                "${athleteuserdetails["city"] ?? ""}" +
                ", " +
                "${athleteuserdetails["state"] ?? ""}" +
                " - " +
                "${athleteuserdetails["zipcode"] ?? ""}",
            fontSize: 14,
            color: AppColors.black,
            fontWeight: FontWeight.w400),
      ),
    ]);
  }

  _buildWorldView() {
    return Row(children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: SvgPicture.asset(world_icon),
      ),
      const SizedBox(width: 5),
      const CommonText(
          text: AppString.privateProfileText,
          fontSize: 12,
          color: AppColors.blacksubtext_color,
          fontWeight: FontWeight.w400),
    ]);
  }

  _buildContainer(String profileName) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: AppColors.profileColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildWorldView(),
            const SizedBox(height: 4),
            Padding(
              padding: EdgeInsets.only(left: 23),
              child: InkWell(
                onTap: () async {
                  await profile_lounch(profileName);
                  _launchUrl(profileName);
                  print("profile Name  ======> $profileName");
                },
                child: CommonText(
                    text:
                        "http://packhubweb.s3-website-us-west-2.amazonaws.com/profile/$profileName",
                    fontSize: 16,
                    color: AppColors.blue_button_Color,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String profileLink) async {
    if (!await launchUrl(Uri.parse(
        "http://packhubweb.s3-website-us-west-2.amazonaws.com/profile/$profileLink"))) {
      throw 'Could not launch ${"http://packhubweb.s3-website-us-west-2.amazonaws.com/profile/$profileLink"}';
    }
  }

  CollageNameListview(collegename) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: ListView.builder(
            itemCount: collageName.length,
            itemBuilder: (context, i) {
              return Container(
                child: CommonText(
                    text: collegename,
                    fontSize: 15,
                    color: AppColors.grey_text_color,
                    fontWeight: FontWeight.w400),
              );
            }));
  }

  Manage_Profile() async {
    log('this is Manage_Profile  api call', name: "Manage_Profile");
    MyApplication.getInstance()!
        .checkConnectivity(context)
        .then((internet) async {
      if (internet != null && internet) {
        try {
          Dio dio = Dio();
          var response = await dio.get("${AppConstant.mamage_profile}",
              options: Options(followRedirects: false, headers: {
                "Authorization":
                    "Bearer ${PreferenceUtils.getString("accesstoken")}"
              }));
          print("-----this is url $response");
          if (response.statusCode == 200) {
            print("+++++this is manageprofile ${response.data}");
            setState(() {
              athleteuserdetails = response.data["userdetails"];
              print("---this is profile data== $athleteuserdetails");
              print(
                  "profile picture path--- ${athleteuserdetails["picturePathS3"]}");
            });
          } else if (response.statusCode == 401) {
            return Get.offAll(Loginscreennew());
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
      print("response url  ====> ${PreferenceUtils.getString("accesstoken")}");

      var response = await dio.post(AppConstant.public_profile,
          data: params,
          options: Options(followRedirects: false, headers: {
            "Authorization":
                "Bearer ${PreferenceUtils.getString("accesstoken")}"
          }));
      if (response.statusCode == 200) {
        print("+++++this is admin clg recruiter${response.data}");
        persnoledetails = response.data["userDetails"];
        print("+++++this is admin${persnoledetails["profileName"]}");
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

  GETDIVISION() async {
    log('this is DIVISION name  api call', name: "DIVISION NAME");
    MyApplication.getInstance()!
        .checkConnectivity(context)
        .then((internet) async {
      if (internet != null && internet) {
        try {
          Dio dio = Dio();
          var response = await dio.get("${AppConstant.DIVISIONLISTING}",
              options: Options(followRedirects: false, headers: {
                "Authorization":
                    "Bearer ${PreferenceUtils.getString("accesstoken")}"
              }));
          print("-----this is DIVISIONurl $response");
          if (response.statusCode == 200) {
            print("+++++this is DIVISION Response ${response.data}");
            setState(() {
              DivisionList = response.data["division"];
              print("---this is DIVISION data== ${DivisionList.length}");
              print(
                  "profile DivisionName--- ${DivisionList[0]["DivisionName"]}");
            });
          } else if (response.statusCode == 401) {
            return Get.offAll(Loginscreennew());
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
