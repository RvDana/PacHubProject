import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:pachub/Utils/appcolors.dart';
import 'package:pachub/Utils/appstring.dart';
import 'package:pachub/app_function/MyAppFunction.dart';
import 'package:pachub/common_widget/appbar.dart';
import 'package:pachub/common_widget/textstyle.dart';
import 'package:pachub/config/preference.dart';
import 'package:pachub/models/Profile_model.dart';
import 'package:pachub/models/coach_athelete_model.dart';
import 'package:pachub/view/profile/Tabscreen/additional_details_screen.dart';
import 'package:pachub/view/profile/Tabscreen/gallery_screen.dart';
import 'package:pachub/view/profile/Tabscreen/personal_details_screen.dart';
import 'package:pachub/view/profile/Tabscreen/primary_skils_screen.dart';
import 'package:get/get.dart';
import 'package:pachub/view/profile/Tabscreen/videos_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../Utils/constant.dart';

class TabAdminHomeDetailScreen extends StatefulWidget {
  final String userId;
  final int length;
  final Map<dynamic, Iterable<Object>> group;

  const TabAdminHomeDetailScreen(this.userId, this.length, this.group,
      {Key? key})
      : super(key: key);

  @override
  State<TabAdminHomeDetailScreen> createState() =>
      _TabAdminHomeDetailScreenState();
}

class _TabAdminHomeDetailScreenState extends State<TabAdminHomeDetailScreen> with SingleTickerProviderStateMixin {
  bool selected = false;
  TabController? tabController;
  var models = <String>{};
  List itemList = [];
  List uniquelist = [];
  int? count;
  int? value;
  bool isLoading = false;
  bool _permissionReady = false;
  TargetPlatform? platform;
  late String _localPath;
  List<CoachAteleteResult> Coach_AthletesModel = [];





  @override
  void initState() {
    if (Platform.isAndroid) {
      platform = TargetPlatform.android;
    } else {
      platform = TargetPlatform.iOS;
    }
    tabController = TabController(length: widget.length, vsync: this);
    setState(() {
      manageAditionalInformationList(widget.userId);
    });
    super.initState();
    print("List Of tab length ==-===<><. ${widget.length}");
    // print("uniqueList $uniquelist");
    // print("Length of List $item");
  }

  /////////////////TODO CHECK permission for downaload transcript///////////////////////////////
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


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Column(
        children: [
          const SizedBox(height: 11),
          _buildTabBar(),
          const SizedBox(height: 10),
          Expanded(
            child: widget.length == 1
                ? TabBarView(controller: tabController, children: [
              widget.group.keys == "Additional Information"
                  ?  Column(
                  children: [
                  Container(
                  height: 40,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              color: AppColors.drawer_bottom_text_color,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15),
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: const [
                    CommonText(
                        text: "ATTRIBUTE NAME",
                        fontSize: 14,
                        color: AppColors.white,
                        fontWeight: FontWeight.w600),
                    CommonText(
                        text: "DESCRIPTION",
                        fontSize: 14,
                        color: AppColors.white,
                        fontWeight: FontWeight.w600),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 5),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: itemList.length,
                  itemBuilder: (context, index) {
                    var totalPendingItem = itemList[index];
                    if (totalPendingItem["displayGroup"] == "Additional Information") {
                      if (totalPendingItem["columnName"] == "AthleteSchoolYear")
                        print("optionsList =====>  ${totalPendingItem["value"][0]}");
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (totalPendingItem["columnName"] == "uploadTranscript")
                            Container(),
                          if (totalPendingItem["columnName"] != "uploadTranscript")
                            const SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15),
                            child: Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CommonText(
                                            text: totalPendingItem["displayName"] == "Upload Transcript" ? "Download Transcript" : totalPendingItem["displayName"],
                                            fontSize: 13,
                                            color: AppColors
                                                .black_txcolor,
                                            fontWeight: FontWeight.w500),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: SizedBox(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .end,
                                      children: [
                                        if (totalPendingItem["columnName"] == "AthleteSchoolYear")
                                          totalPendingItem["value"][0] == totalPendingItem["options"][0]["id"] ?
                                          CommonText(
                                              text: "${totalPendingItem["options"][0]["name"]}",
                                              fontSize: 13,
                                              color: AppColors.black_txcolor,
                                              fontWeight: FontWeight.w500) :
                                          totalPendingItem["value"][0] == totalPendingItem["options"][1]["id"] ?
                                          CommonText(
                                              text: "${totalPendingItem["options"][1]["name"]}",
                                              fontSize: 13,
                                              color: AppColors.black_txcolor,
                                              fontWeight: FontWeight.w500) :
                                          totalPendingItem["value"][0] == totalPendingItem["options"][2]["id"] ?
                                          CommonText(
                                              text: "${totalPendingItem["options"][2]["name"]}",
                                              fontSize: 13,
                                              color: AppColors
                                                  .black_txcolor,
                                              fontWeight: FontWeight.w500) :
                                          totalPendingItem["value"][0] == totalPendingItem["options"][3]["id"] ?
                                          CommonText(
                                              text: "${totalPendingItem["options"][3]["name"]}",
                                              fontSize: 13,
                                              color: AppColors.black_txcolor,
                                              fontWeight: FontWeight.w500) :
                                          totalPendingItem["value"][0] == totalPendingItem["options"][4]["id"] ?
                                          CommonText(
                                              text: "${totalPendingItem["options"][4]["name"]}",
                                              fontSize: 13,
                                              color: AppColors.black_txcolor,
                                              fontWeight: FontWeight.w500) : Container(),
                                        if (totalPendingItem["columnName"] == "uploadTranscript")
                                          Row(
                                            mainAxisAlignment : MainAxisAlignment.end,
                                            children: [
                                              Flexible(
                                                child:  Text(
                                                  totalPendingItem["value"]['DisplayName'],
                                                  overflow: TextOverflow.ellipsis,
                                                  style:  TextStyle(
                                                    fontSize: 13.0,
                                                    fontFamily: 'Roboto',
                                                    color:  Color(0xFF212121),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              GestureDetector(
                                                  onTap : () async {
                                                    _permissionReady = await _checkPermission();
                                                    if (_permissionReady) {
                                                      await _prepareSaveDir();
                                                      print("Downloading");
                                                      try {
                                                        File file =  File("${totalPendingItem["value"]['FilePath']}");
                                                        var path = file.path;
                                                        var filename = path.split("/").last;
                                                        print("@@@@@ ${filename}");
                                                        await Dio().download(
                                                            "${totalPendingItem["value"]['FilePath']}", _localPath! + "/" + "$filename");
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
                                                  child: Icon(Icons.download, color: Colors.black)
                                              ),
                                            ],
                                          ),
                                        if (totalPendingItem["columnName"] != "uploadTranscript" && totalPendingItem["columnName"] != "AthleteSchoolYear")
                                          CommonText(
                                              text: totalPendingItem["value"],
                                              fontSize: 13,
                                              color: AppColors.black_txcolor,
                                              fontWeight: FontWeight.w500),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // ListView.builder(
                          //   shrinkWrap: true,
                          //     itemCount : totalPendingItem["options"],
                          //     itemBuilder: (context, index) {
                          //   return  totalPendingItem["value"][0] == totalPendingItem["options"][index]["id"] ?  CommonText(
                          //         text: "${totalPendingItem["options"][index]["name"]}",
                          //         fontSize: 13,
                          //         color: AppColors.black_txcolor,
                          //         fontWeight: FontWeight.w500) : Container();
                          // }
                          // ),
                          const Divider(),
                        ],
                      );
                    } else {
                      return Container();
                    }
                  }),
            ),
            ],
          )
                  : Column(
                children: [
                  Container(
                    height: 40,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    color: AppColors.drawer_bottom_text_color,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: const [
                          CommonText(
                              text: "ATTRIBUTE NAME",
                              fontSize: 14,
                              color: AppColors.white,
                              fontWeight: FontWeight.w600),
                          CommonText(
                              text: "DESCRIPTION",
                              fontSize: 14,
                              color: AppColors.white,
                              fontWeight: FontWeight.w600),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: itemList.length,
                        itemBuilder: (context, index) {
                          var totalPendingItem = itemList[index];
                          if (totalPendingItem["displayGroup"] == "Primary Skills") {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (totalPendingItem["columnName"] ==
                                    "uploadTranscript")
                                  Container(),
                                if (totalPendingItem["columnName"] !=
                                    "uploadTranscript")
                                  const SizedBox(height: 5),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              CommonText(
                                                  text: totalPendingItem["displayName"],
                                                  fontSize: 13,
                                                  color: AppColors
                                                      .black_txcolor,
                                                  fontWeight: FontWeight.w500),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .end,
                                            children: [
                                              if (totalPendingItem["columnName"] ==
                                                  "positionPlayed")
                                                totalPendingItem["value"][0] == totalPendingItem["options"][0]["id"] ?
                                                CommonText(
                                                    text: "${totalPendingItem["options"][0]["name"]}",
                                                    fontSize: 13,
                                                    color: AppColors.black_txcolor,
                                                    fontWeight: FontWeight.w500) :
                                                totalPendingItem["value"][0] == totalPendingItem["options"][1]["id"] ?
                                                CommonText(
                                                    text: "${totalPendingItem["options"][1]["name"]}",
                                                    fontSize: 13,
                                                    color: AppColors.black_txcolor,
                                                    fontWeight: FontWeight.w500) :
                                                totalPendingItem["value"][0] == totalPendingItem["options"][2]["id"] ?
                                                CommonText(
                                                    text: "${totalPendingItem["options"][2]["name"]}",
                                                    fontSize: 13,
                                                    color: AppColors.black_txcolor,
                                                    fontWeight: FontWeight.w500) :
                                                totalPendingItem["value"][0] == totalPendingItem["options"][3]["id"] ?
                                                CommonText(
                                                    text: "${totalPendingItem["options"][3]["name"]}",
                                                    fontSize: 13,
                                                    color: AppColors.black_txcolor,
                                                    fontWeight: FontWeight.w500) :
                                                totalPendingItem["value"][0] == totalPendingItem["options"][4]["id"] ?
                                                CommonText(
                                                    text: "${totalPendingItem["options"][4]["name"]}",
                                                    fontSize: 13,
                                                    color: AppColors.black_txcolor,
                                                    fontWeight: FontWeight.w500) : Container(),
                                              if (totalPendingItem["columnName"] !=
                                                  "positionPlayed")
                                                CommonText(
                                                    text: totalPendingItem["value"],
                                                    fontSize: 13,
                                                    color: AppColors
                                                        .black_txcolor,
                                                    fontWeight: FontWeight
                                                        .w500),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(),
                              ],
                            );
                          } else {
                            return Container();
                          }
                        }),
                  ),
                ],
              )
            ])
                : widget.length == 2
                ? TabBarView(controller: tabController, children: [
              Column(
                children: [
                  Container(
                    height: 40,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    color: AppColors.drawer_bottom_text_color,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: const [
                          CommonText(
                              text: "ATTRIBUTE NAME",
                              fontSize: 14,
                              color: AppColors.white,
                              fontWeight: FontWeight.w600),
                          CommonText(
                              text: "DESCRIPTION",
                              fontSize: 14,
                              color: AppColors.white,
                              fontWeight: FontWeight.w600),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: itemList.length,
                        itemBuilder: (context, index) {
                          var totalPendingItem = itemList[index];
                          if (totalPendingItem["displayGroup"] == "Primary Skills") {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (totalPendingItem["columnName"] == "uploadTranscript")
                                  Container(),
                                if (totalPendingItem["columnName"] != "uploadTranscript")
                                  const SizedBox(height: 5),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          width: MediaQuery.of(context).size.width,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              CommonText(
                                                  text: totalPendingItem["displayName"],
                                                  fontSize: 13,
                                                  color: AppColors
                                                      .black_txcolor,
                                                  fontWeight: FontWeight.w500),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .end,
                                            children: [
                                              if (totalPendingItem["columnName"] ==
                                                  "positionPlayed")
                                                totalPendingItem["value"][0] == totalPendingItem["options"][0]["id"] ?
                                                CommonText(
                                                    text: "${totalPendingItem["options"][0]["name"]}",
                                                    fontSize: 13,
                                                    color: AppColors.black_txcolor,
                                                    fontWeight: FontWeight.w500) :
                                                totalPendingItem["value"][0] == totalPendingItem["options"][1]["id"] ?
                                                CommonText(
                                                    text: "${totalPendingItem["options"][1]["name"]}",
                                                    fontSize: 13,
                                                    color: AppColors.black_txcolor,
                                                    fontWeight: FontWeight.w500) :
                                                totalPendingItem["value"][0] == totalPendingItem["options"][2]["id"] ?
                                                CommonText(
                                                    text: "${totalPendingItem["options"][2]["name"]}",
                                                    fontSize: 13,
                                                    color: AppColors.black_txcolor,
                                                    fontWeight: FontWeight.w500) :
                                                totalPendingItem["value"][0] == totalPendingItem["options"][3]["id"] ?
                                                CommonText(
                                                    text: "${totalPendingItem["options"][3]["name"]}",
                                                    fontSize: 13,
                                                    color: AppColors.black_txcolor,
                                                    fontWeight: FontWeight.w500) :
                                                totalPendingItem["value"][0] == totalPendingItem["options"][4]["id"] ?
                                                CommonText(
                                                    text: "${totalPendingItem["options"][4]["name"]}",
                                                    fontSize: 13,
                                                    color: AppColors.black_txcolor,
                                                    fontWeight: FontWeight.w500) : Container(),
                                              if (totalPendingItem["columnName"] != "positionPlayed")
                                                CommonText(
                                                    text: totalPendingItem["value"],
                                                    fontSize: 13,
                                                    color: AppColors
                                                        .black_txcolor,
                                                    fontWeight: FontWeight
                                                        .w500),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(),
                              ],
                            );
                          } else {
                            return Container();
                          }
                        }),
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    height: 40,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    color: AppColors.drawer_bottom_text_color,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: const [
                          CommonText(
                              text: "ATTRIBUTE NAME",
                              fontSize: 14,
                              color: AppColors.white,
                              fontWeight: FontWeight.w600),
                          CommonText(
                              text: "DESCRIPTION",
                              fontSize: 14,
                              color: AppColors.white,
                              fontWeight: FontWeight.w600),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: itemList.length,
                        itemBuilder: (context, index) {
                          var totalPendingItem = itemList[index];
                          if (totalPendingItem["displayGroup"] ==
                              "Additional Information") {
                            if (totalPendingItem["columnName"] ==
                                "AthleteSchoolYear")
                              print(
                                  "optionsList =====>  ${totalPendingItem["value"][0]}");
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (totalPendingItem["columnName"] ==
                                    "uploadTranscript")
                                  Container(),
                                if (totalPendingItem["columnName"] !=
                                    "uploadTranscript")
                                  const SizedBox(height: 5),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              CommonText(
                                                  text: totalPendingItem["displayName"] == "Upload Transcript" ? "Download Transcript" : totalPendingItem["displayName"],
                                                  fontSize: 13,
                                                  color: AppColors
                                                      .black_txcolor,
                                                  fontWeight: FontWeight.w500),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .end,
                                            children: [
                                              if (totalPendingItem["columnName"] == "AthleteSchoolYear")
                                                totalPendingItem["value"][0] == totalPendingItem["options"][0]["id"] ?
                                                CommonText(
                                                    text: "${totalPendingItem["options"][0]["name"]}",
                                                    fontSize: 13,
                                                    color: AppColors.black_txcolor,
                                                    fontWeight: FontWeight.w500) :
                                                totalPendingItem["value"][0] == totalPendingItem["options"][1]["id"] ?
                                                CommonText(
                                                    text: "${totalPendingItem["options"][1]["name"]}",
                                                    fontSize: 13,
                                                    color: AppColors.black_txcolor,
                                                    fontWeight: FontWeight.w500) :
                                                totalPendingItem["value"][0] == totalPendingItem["options"][2]["id"] ?
                                                CommonText(
                                                    text: "${totalPendingItem["options"][2]["name"]}",
                                                    fontSize: 13,
                                                    color: AppColors.black_txcolor,
                                                    fontWeight: FontWeight.w500) :
                                                totalPendingItem["value"][0] == totalPendingItem["options"][3]["id"] ?
                                                CommonText(
                                                    text: "${totalPendingItem["options"][3]["name"]}",
                                                    fontSize: 13,
                                                    color: AppColors.black_txcolor,
                                                    fontWeight: FontWeight.w500) :
                                                totalPendingItem["value"][0] == totalPendingItem["options"][4]["id"] ?
                                                CommonText(
                                                    text: "${totalPendingItem["options"][4]["name"]}",
                                                    fontSize: 13,
                                                    color: AppColors.black_txcolor,
                                                    fontWeight: FontWeight.w500) : Container(),
                                              if (totalPendingItem["columnName"] == "uploadTranscript")
                                                Row(
                                                  mainAxisAlignment : MainAxisAlignment.end,
                                                  children: [
                                                    Flexible(
                                                      child:  Text(
                                                        totalPendingItem["value"]['DisplayName'],
                                                        overflow: TextOverflow.ellipsis,
                                                        style:  TextStyle(
                                                          fontSize: 13.0,
                                                          fontFamily: 'Roboto',
                                                          color:  Color(0xFF212121),
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    // CommonText(
                                                    //     text: totalPendingItem["value"]['DisplayName'],
                                                    //     fontSize: 13,
                                                    //     color: AppColors.black_txcolor,
                                                    //     fontWeight: FontWeight.w500),
                                                    SizedBox(width: 5),
                                                    GestureDetector(
                                                        onTap : () async {
                                                          _permissionReady = await _checkPermission();
                                                          if (_permissionReady) {
                                                            await _prepareSaveDir();
                                                            print("Downloading");
                                                            try {
                                                              File file =  File("${totalPendingItem["value"]['FilePath']}");
                                                              var path = file.path;
                                                              var filename = path.split("/").last;
                                                              print("@@@@@ ${filename}");
                                                              await Dio().download(
                                                                  "${totalPendingItem["value"]['FilePath']}", _localPath! + "/" + "$filename");
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
                                                        child: Icon(Icons.download, color: Colors.black)
                                                    ),
                                                  ],
                                                ),
                                              if (totalPendingItem["columnName"] != "uploadTranscript" && totalPendingItem["columnName"] != "AthleteSchoolYear")
                                                CommonText(
                                                    text: totalPendingItem["value"],
                                                    fontSize: 13,
                                                    color: AppColors.black_txcolor,
                                                    fontWeight: FontWeight.w500),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // ListView.builder(
                                //   shrinkWrap: true,
                                //     itemCount : totalPendingItem["options"],
                                //     itemBuilder: (context, index) {
                                //   return  totalPendingItem["value"][0] == totalPendingItem["options"][index]["id"] ?  CommonText(
                                //         text: "${totalPendingItem["options"][index]["name"]}",
                                //         fontSize: 13,
                                //         color: AppColors.black_txcolor,
                                //         fontWeight: FontWeight.w500) : Container();
                                // }
                                // ),
                                const Divider(),
                              ],
                            );
                          } else {
                            return Container();
                          }
                        }),
                  ),
                ],
              ),
            ])
                : widget.length == 3
                ? TabBarView(controller: tabController, children: [
              Column(
                children: [
                  Container(
                    height: 40,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    color: AppColors.drawer_bottom_text_color,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: const [
                          CommonText(
                              text: "ATTRIBUTE NAME",
                              fontSize: 14,
                              color: AppColors.white,
                              fontWeight: FontWeight.w600),
                          CommonText(
                              text: "DESCRIPTION",
                              fontSize: 14,
                              color: AppColors.white,
                              fontWeight: FontWeight.w600),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: itemList.length,
                        itemBuilder: (context, index) {
                          var totalPendingItem = itemList[index];
                          if (totalPendingItem["displayGroup"] == "Primary Skills") {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (totalPendingItem["columnName"] == "uploadTranscript")
                                  Container(),
                                if (totalPendingItem["columnName"] != "uploadTranscript")
                                  const SizedBox(height: 5),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          width: MediaQuery.of(context).size.width,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              CommonText(
                                                  text: totalPendingItem["displayName"],
                                                  fontSize: 13,
                                                  color: AppColors.black_txcolor,
                                                  fontWeight: FontWeight.w500),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          width: MediaQuery.of(context).size.width,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              if (totalPendingItem["columnName"] == "positionPlayed")
                                                totalPendingItem["value"][0] == totalPendingItem["options"][0]["id"] ?
                                                CommonText(
                                                    text: "${totalPendingItem["options"][0]["name"]}",
                                                    fontSize: 13,
                                                    color: AppColors
                                                        .black_txcolor,
                                                    fontWeight: FontWeight.w500) :
                                                totalPendingItem["value"][0] == totalPendingItem["options"][1]["id"] ?
                                                CommonText(
                                                    text: "${totalPendingItem["options"][1]["name"]}",
                                                    fontSize: 13,
                                                    color: AppColors
                                                        .black_txcolor,
                                                    fontWeight: FontWeight.w500) :
                                                totalPendingItem["value"][0] == totalPendingItem["options"][2]["id"] ?
                                                CommonText(
                                                    text: "${totalPendingItem["options"][2]["name"]}",
                                                    fontSize: 13,
                                                    color: AppColors
                                                        .black_txcolor,
                                                    fontWeight: FontWeight.w500) :
                                                totalPendingItem["value"][0] == totalPendingItem["options"][3]["id"] ?
                                                CommonText(
                                                    text: "${totalPendingItem["options"][3]["name"]}",
                                                    fontSize: 13,
                                                    color: AppColors.black_txcolor,
                                                    fontWeight: FontWeight.w500) :
                                                totalPendingItem["value"][0] == totalPendingItem["options"][4]["id"] ?
                                                CommonText(
                                                    text: "${totalPendingItem["options"][4]["name"]}",
                                                    fontSize: 13,
                                                    color: AppColors.black_txcolor,
                                                    fontWeight: FontWeight.w500) : Container(),
                                              if (totalPendingItem["columnName"] != "positionPlayed")
                                                CommonText(
                                                    text: totalPendingItem["value"],
                                                    fontSize: 13,
                                                    color: AppColors
                                                        .black_txcolor,
                                                    fontWeight: FontWeight
                                                        .w500),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(),
                              ],
                            );
                          } else {
                            return Container();
                          }
                        }),
                  ),
                ],
              ),
              GalleryByIdScreen(widget.userId),
              Column(
                children: [
                  Container(
                    height: 40,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    color: AppColors.drawer_bottom_text_color,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: const [
                          CommonText(
                              text: "ATTRIBUTE NAME",
                              fontSize: 14,
                              color: AppColors.white,
                              fontWeight: FontWeight.w600),
                          CommonText(
                              text: "DESCRIPTION",
                              fontSize: 14,
                              color: AppColors.white,
                              fontWeight: FontWeight.w600),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: itemList.length,
                        itemBuilder: (context, index) {
                          var totalPendingItem = itemList[index];
                          if (totalPendingItem["displayGroup"] == "Additional Information") {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (totalPendingItem["columnName"] ==
                                    "uploadTranscript")
                                  Container(),
                                if (totalPendingItem["columnName"] !=
                                    "uploadTranscript")
                                  const SizedBox(height: 5),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              CommonText(
                                                  text: totalPendingItem["displayName"] == "Upload Transcript" ? "Download Transcript" : totalPendingItem["displayName"],
                                                  fontSize: 13,
                                                  color: AppColors
                                                      .black_txcolor,
                                                  fontWeight: FontWeight.w500),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .end,
                                            children: [
                                              if (totalPendingItem["columnName"] == "AthleteSchoolYear")
                                                totalPendingItem["value"][0] == totalPendingItem["options"][0]["id"] ?
                                                CommonText(
                                                    text: "${totalPendingItem["options"][0]["name"]}",
                                                    fontSize: 13,
                                                    color: AppColors
                                                        .black_txcolor,
                                                    fontWeight: FontWeight.w500) :
                                                totalPendingItem["value"][0] == totalPendingItem["options"][1]["id"] ?
                                                CommonText(
                                                    text: "${totalPendingItem["options"][1]["name"]}",
                                                    fontSize: 13,
                                                    color: AppColors.black_txcolor,
                                                    fontWeight: FontWeight.w500) :
                                                totalPendingItem["value"][0] == totalPendingItem["options"][2]["id"] ?
                                                CommonText(
                                                    text: "${totalPendingItem["options"][2]["name"]}",
                                                    fontSize: 13,
                                                    color: AppColors
                                                        .black_txcolor,
                                                    fontWeight: FontWeight.w500) :
                                                totalPendingItem["value"][0] == totalPendingItem["options"][3]["id"] ?
                                                CommonText(
                                                    text: "${totalPendingItem["options"][3]["name"]}",
                                                    fontSize: 13,
                                                    color: AppColors
                                                        .black_txcolor,
                                                    fontWeight: FontWeight.w500) :
                                                totalPendingItem["value"][0] == totalPendingItem["options"][4]["id"] ?
                                                CommonText(
                                                    text: "${totalPendingItem["options"][4]["name"]}",
                                                    fontSize: 13,
                                                    color: AppColors
                                                        .black_txcolor,
                                                    fontWeight: FontWeight.w500) : Container(),
                                              if (totalPendingItem["columnName"] == "uploadTranscript")
                                                Row(
                                                  mainAxisAlignment : MainAxisAlignment.end,
                                                  children: [
                                                    Flexible(
                                                      child:  Text(
                                                        totalPendingItem["value"]['DisplayName'],
                                                        overflow: TextOverflow.ellipsis,
                                                        style:  TextStyle(
                                                          fontSize: 13.0,
                                                          fontFamily: 'Roboto',
                                                          color:  Color(0xFF212121),
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    GestureDetector(
                                                        onTap : () async {
                                                          _permissionReady = await _checkPermission();
                                                          if (_permissionReady) {
                                                            await _prepareSaveDir();
                                                            print("Downloading");
                                                            try {
                                                              File file =  File("${totalPendingItem["value"]['FilePath']}");
                                                              var path = file.path;
                                                              var filename = path.split("/").last;
                                                              print("@@@@@ ${filename}");
                                                              await Dio().download(
                                                                  "${totalPendingItem["value"]['FilePath']}", _localPath! + "/" + "$filename");
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
                                                        child: Icon(Icons.download, color: Colors.black)
                                                    ),
                                                  ],
                                                ),
                                              if (totalPendingItem["columnName"] != "uploadTranscript" && totalPendingItem["columnName"] != "AthleteSchoolYear")
                                                CommonText(
                                                    text: totalPendingItem["value"],
                                                    fontSize: 13,
                                                    color: AppColors.black_txcolor,
                                                    fontWeight: FontWeight.w500),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // ListView.builder(
                                //   shrinkWrap: true,
                                //     itemCount : totalPendingItem["options"],
                                //     itemBuilder: (context, index) {
                                //   return  totalPendingItem["value"][0] == totalPendingItem["options"][index]["id"] ?  CommonText(
                                //         text: "${totalPendingItem["options"][index]["name"]}",
                                //         fontSize: 13,
                                //         color: AppColors.black_txcolor,
                                //         fontWeight: FontWeight.w500) : Container();
                                // }
                                // ),
                                const Divider(),
                              ],
                            );
                          } else {
                            return Container();
                          }
                        }),
                  ),
                ],
              ),
            ])
                : TabBarView(controller: tabController, children: [
              Column(
                children: [
                  Container(
                    height: 40,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    color: AppColors.drawer_bottom_text_color,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: const [
                          CommonText(
                              text: "ATTRIBUTE NAME",
                              fontSize: 14,
                              color: AppColors.white,
                              fontWeight: FontWeight.w600),
                          CommonText(
                              text: "DESCRIPTION",
                              fontSize: 14,
                              color: AppColors.white,
                              fontWeight: FontWeight.w600),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: itemList.length,
                        itemBuilder: (context, index) {
                          var totalPendingItem = itemList[index];
                          if (totalPendingItem["displayGroup"] ==
                              "Primary Skills") {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (totalPendingItem["columnName"] == "uploadTranscript")
                                  Container(),
                                if (totalPendingItem["columnName"] != "uploadTranscript")
                                  const SizedBox(height: 5),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              CommonText(
                                                  text: totalPendingItem["displayName"],
                                                  fontSize: 13,
                                                  color: AppColors
                                                      .black_txcolor,
                                                  fontWeight: FontWeight.w500),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .end,
                                            children: [
                                              if (totalPendingItem["columnName"] == "positionPlayed")
                                                totalPendingItem["value"][0] == totalPendingItem["options"][0]["id"] ?
                                                CommonText(
                                                    text: "${totalPendingItem["options"][0]["name"]}",
                                                    fontSize: 13,
                                                    color: AppColors.black_txcolor,
                                                    fontWeight: FontWeight.w500) :
                                                totalPendingItem["value"][0] == totalPendingItem["options"][1]["id"] ?
                                                CommonText(
                                                    text: "${totalPendingItem["options"][1]["name"]}",
                                                    fontSize: 13,
                                                    color: AppColors.black_txcolor,
                                                    fontWeight: FontWeight.w500) :
                                                totalPendingItem["value"][0] == totalPendingItem["options"][2]["id"] ?
                                                CommonText(
                                                    text: "${totalPendingItem["options"][2]["name"]}",
                                                    fontSize: 13,
                                                    color: AppColors.black_txcolor,
                                                    fontWeight: FontWeight.w500) :
                                                totalPendingItem["value"][0] == totalPendingItem["options"][3]["id"] ?
                                                CommonText(
                                                    text: "${totalPendingItem["options"][3]["name"]}",
                                                    fontSize: 13,
                                                    color: AppColors.black_txcolor,
                                                    fontWeight: FontWeight.w500) :
                                                totalPendingItem["value"][0] == totalPendingItem["options"][4]["id"] ?
                                                CommonText(
                                                    text: "${totalPendingItem["options"][4]["name"]}",
                                                    fontSize: 13,
                                                    color: AppColors.black_txcolor,
                                                    fontWeight: FontWeight.w500) : Container(),
                                              if (totalPendingItem["columnName"] !=
                                                  "positionPlayed")
                                                CommonText(
                                                    text: totalPendingItem["value"],
                                                    fontSize: 13,
                                                    color: AppColors
                                                        .black_txcolor,
                                                    fontWeight: FontWeight
                                                        .w500),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(),
                              ],
                            );
                          } else {
                            return Container();
                          }
                        }),
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    height: 40,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    color: AppColors.drawer_bottom_text_color,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: const [
                          CommonText(
                              text: "ATTRIBUTE NAME",
                              fontSize: 14,
                              color: AppColors.white,
                              fontWeight: FontWeight.w600),
                          CommonText(
                              text: "DESCRIPTION",
                              fontSize: 14,
                              color: AppColors.white,
                              fontWeight: FontWeight.w600),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: itemList.length,
                        itemBuilder: (context, index) {
                          var totalPendingItem = itemList[index];
                          if (totalPendingItem["displayGroup"] == "Additional Information") {
                            if (totalPendingItem["columnName"] == "AthleteSchoolYear")
                              print("optionsList =====>  ${totalPendingItem["value"][0]}");
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (totalPendingItem["columnName"] == "uploadTranscript")
                                  Container(),
                                if (totalPendingItem["columnName"] != "uploadTranscript")
                                  const SizedBox(height: 5),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          width: MediaQuery.of(context).size.width,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              CommonText(
                                                  text: totalPendingItem["displayName"] == "Upload Transcript" ? "Download Transcript" : totalPendingItem["displayName"],
                                                  fontSize: 13,
                                                  color: AppColors
                                                      .black_txcolor,
                                                  fontWeight: FontWeight.w500),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .end,
                                            children: [
                                              if (totalPendingItem["columnName"] == "AthleteSchoolYear")
                                                totalPendingItem["value"][0] == totalPendingItem["options"][0]["id"] ?
                                                CommonText(
                                                    text: "${totalPendingItem["options"][0]["name"]}",
                                                    fontSize: 13,
                                                    color: AppColors.black_txcolor,
                                                    fontWeight: FontWeight.w500) :
                                                totalPendingItem["value"][0] == totalPendingItem["options"][1]["id"] ?
                                                CommonText(
                                                    text: "${totalPendingItem["options"][1]["name"]}",
                                                    fontSize: 13,
                                                    color: AppColors.black_txcolor,
                                                    fontWeight: FontWeight.w500) :
                                                totalPendingItem["value"][0] == totalPendingItem["options"][2]["id"] ?
                                                CommonText(
                                                    text: "${totalPendingItem["options"][2]["name"]}",
                                                    fontSize: 13,
                                                    color: AppColors
                                                        .black_txcolor,
                                                    fontWeight: FontWeight.w500) :
                                                totalPendingItem["value"][0] == totalPendingItem["options"][3]["id"] ?
                                                CommonText(
                                                    text: "${totalPendingItem["options"][3]["name"]}",
                                                    fontSize: 13,
                                                    color: AppColors.black_txcolor,
                                                    fontWeight: FontWeight.w500) :
                                                totalPendingItem["value"][0] == totalPendingItem["options"][4]["id"] ?
                                                CommonText(
                                                    text: "${totalPendingItem["options"][4]["name"]}",
                                                    fontSize: 13,
                                                    color: AppColors.black_txcolor,
                                                    fontWeight: FontWeight.w500) : Container(),
                                              if (totalPendingItem["columnName"] == "uploadTranscript")
                                                Row(
                                                   mainAxisAlignment : MainAxisAlignment.end,
                                                  children: [
                                                    Flexible(
                                                      child:  Text(
                                                        totalPendingItem["value"]['DisplayName'],
                                                        overflow: TextOverflow.ellipsis,
                                                        style:  TextStyle(
                                                          fontSize: 13.0,
                                                          fontFamily: 'Roboto',
                                                          color:  Color(0xFF212121),
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    InkWell(
                                                        onTap : () async {
                                                          _permissionReady = await _checkPermission();
                                                          if (_permissionReady) {
                                                            await _prepareSaveDir();
                                                            print("Downloading");
                                                            print("Downloading ${totalPendingItem["value"]['FilePath']}");
                                                            try {
                                                              File file =  File("${totalPendingItem["value"]['FilePath']}");
                                                              var path = file.path;
                                                              var filename = path.split("/").last;
                                                              print("@@@@@ ${filename}");
                                                              await Dio().download(
                                                                  "${totalPendingItem["value"]['FilePath']}", _localPath! + "/" + "$filename");
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
                                                        child: Icon(Icons.download, color: Colors.black)
                                                    ),
                                                  ],
                                                ),
                                              if (totalPendingItem["columnName"] != "uploadTranscript" && totalPendingItem["columnName"] != "AthleteSchoolYear")
                                                CommonText(
                                                    text: totalPendingItem["value"],
                                                    fontSize: 13,
                                                    color: AppColors.black_txcolor,
                                                    fontWeight: FontWeight.w500),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // ListView.builder(
                                //   shrinkWrap: true,
                                //     itemCount : totalPendingItem["options"],
                                //     itemBuilder: (context, index) {
                                //   return  totalPendingItem["value"][0] == totalPendingItem["options"][index]["id"] ?  CommonText(
                                //         text: "${totalPendingItem["options"][index]["name"]}",
                                //         fontSize: 13,
                                //         color: AppColors.black_txcolor,
                                //         fontWeight: FontWeight.w500) : Container();
                                // }
                                // ),
                                const Divider(),
                              ],
                            );
                          } else {
                            return Container();
                          }
                        }),
                  ),
                ],
              ),
              VideosByIdScreen(widget.userId),
              GalleryByIdScreen(widget.userId),
            ]),
          ),
        ],
      ),
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
          labelColor: AppColors.blue_text_Color,
          // padding: const EdgeInsets.symmetric(horizontal: 11),
          splashBorderRadius: BorderRadius.circular(15),
          isScrollable: true,
          controller: tabController,
          tabs: widget.length == 1
              ? [widget.group.keys == "Additional Information" ? Tab(text: "Additional Information") : Tab(text: "Primary Skills")]
              : widget.length == 2
              ? [
            Tab(text: "Primary Skills"),
            Tab(text: "Additional Information")
          ]
              : widget.length == 3
              ? [
            Tab(text: "Primary Skills"),
            Tab(text: "Images"),
            Tab(text: "Additional Information")
          ]
              : [
            Tab(text: "Primary Skills"),
            Tab(text: "Additional Information"),
            Tab(text: "Videos"),
            Tab(text: "Images"),
          ]

        // List.generate(widget.length , (index) {
        //   print("length ====>/. ${uniquelist[index]}");
        //
        //   return Text(uniquelist[index]["displayGroup"]);
        // }),
      ),
    );
  }

  manageAditionalInformationList(String userId) async {
    log('this is Manage_Profile  api call', name: "Manage_Profile");
    setState(() {
      isLoading == true;
    });
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
              itemList = response.data["attribute"];
              uniquelist = response.data["attribute"].where((value) => models.add(value["displayGroup"])).toList();
              print("+++++this is item ${response.data["attribute"]}");
              print("+++++ ${uniquelist}");
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
}




class TabAdminCoachDetailScreen extends StatefulWidget {
  final String userId;
  final List itemList;
  final int length;
  final String sport;

  const TabAdminCoachDetailScreen(this.userId, this.itemList, this.length, this.sport,
      {Key? key})
      : super(key: key);

  @override
  State<TabAdminCoachDetailScreen> createState() =>
      _TabAdminCoachDetailScreenState();
}

class _TabAdminCoachDetailScreenState extends State<TabAdminCoachDetailScreen> with SingleTickerProviderStateMixin {
  bool selected = false;
  TabController? tabController;
  var models = <String>{};
  List itemList = [];
  List uniquelist = [];
  int? count;
  int? value;
  String? optionBaseball = "1";
  String? optionFootball = "All Positions";

  List optionList = [];
  List pitcherList = [];
  List catcherList = [];
  List outfieldList = [];
  List infieldList = [];
  List universalList = [];
  List qbList = [];
  List rbList = [];
  List hbList = [];
  List fbList = [];
  List wrList = [];
  List teList = [];
  List dList = [];
  List dlList = [];
  List lbList = [];
  List mlbList = [];
  List olbList = [];
  List dbList = [];
  List cbList = [];
  List sList = [];
  List nbList = [];
  List kList = [];
  List pList = [];


  @override
  void initState() {
    tabController = TabController(length: widget.length, vsync: this);
    manageAditionalInformationList(widget.userId);
    super.initState();
    print("List Of tab length ==-===<><. ${widget.length}");
    print("spots Print ======<><> ${widget.sport}");
    // print("uniqueList $uniquelist");
    // print("Length of List $item");
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Column(
        children: [
          const SizedBox(height: 11),
          _buildTabBar(),
          const SizedBox(height: 10),
          Expanded(
            child: widget.length > 1
                ? TabBarView(controller: tabController, children: [
              VideosByIdScreen(widget.userId),
              if(widget.sport == "FOOTBALL")
                StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: itemList.length,
                                itemBuilder: (context, index) {
                                  var item = itemList[index];
                                  if (item["displayGroup"] == "Desired Positions") {
                                    optionList = item["options"];
                                    print("list ======<><> $optionList");
                                    var all = item["child_fields"];
                                    print("Data View  =========<> $all");
                                    var data = json.decode(all);
                                    log('Keys: $data');
                                    qbList = data["QB"] ?? [];
                                    rbList = data["RB"] ?? [];
                                    hbList = data["HB"] ?? [];
                                    fbList = data["FB"] ?? [];
                                    wrList = data["WR"] ?? [];
                                    teList = data["TE"] ?? [];
                                    dList = data["D"] ?? [];
                                    dlList = data["DL"] ?? [];
                                    lbList = data["LB"] ?? [];
                                    mlbList = data["MLB"] ?? [];
                                    olbList = data["OLB"] ?? [];
                                    dbList = data["DB"] ?? [];
                                    cbList = data["CB"] ?? [];
                                    sList = data["S"] ?? [];
                                    nbList = data["NB"] ?? [];
                                    kList = data["K"] ?? [];
                                    pList = data["P"] ?? [];
                                    var newList = qbList + rbList + hbList + fbList + wrList + teList + dList + dlList + lbList + mlbList + olbList + dbList + cbList + sList + nbList + kList + pList;
                                    print("Data  :  $newList");
                                    return Column(
                                      children: [
                                        Container(
                                          height: 55,
                                          width: MediaQuery.of(context).size.width,
                                          color: AppColors.checkboxColor,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 15),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Expanded(
                                                  child: CommonText(
                                                      text: 'POSITION',
                                                      fontSize: 14,
                                                      color: AppColors.black_txcolor,
                                                      fontWeight: FontWeight.w500),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                      height: 40,
                                                      width: MediaQuery.of(context).size.width,
                                                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                                      decoration: BoxDecoration(
                                                        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                                        color: AppColors.white,
                                                        border: Border.all(
                                                          color: AppColors.dark_blue_button_color,
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
                                                          value: optionFootball,
                                                          underline: Container(),
                                                          isExpanded: true,
                                                          itemHeight: 35.0,
                                                          style: TextStyle(
                                                              fontSize: 15.0,
                                                              color: Colors.grey[700]),
                                                          items: optionList.map((item) {
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
                                                              text: "All Positions",
                                                              fontSize: 14,
                                                              color: AppColors.black,
                                                              fontWeight: FontWeight.w500),
                                                          onChanged:
                                                              (newValue) {
                                                            setState(() => optionFootball = newValue);
                                                            if (kDebugMode) {
                                                              print("option========>>>>>> $optionFootball");
                                                            }
                                                            if (kDebugMode) {
                                                              print("optionList $optionFootball");
                                                            }
                                                          },
                                                        ),
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        if (optionFootball == "All Positions")
                                          ListView.builder(
                                              physics: const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: newList.length,
                                              itemBuilder: (context, index) {
                                                var keysData = newList[index];
                                                return Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 15),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: SizedBox(
                                                              width:
                                                              MediaQuery
                                                                  .of(
                                                                  context)
                                                                  .size
                                                                  .width,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                                children: [
                                                                  CommonText(
                                                                      text: keysData[
                                                                      "displayName"],
                                                                      fontSize:
                                                                      13,
                                                                      color: AppColors
                                                                          .black_txcolor,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: SizedBox(
                                                              width:
                                                              MediaQuery
                                                                  .of(
                                                                  context)
                                                                  .size
                                                                  .width,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                                children: [
                                                                  CommonText(
                                                                      text: keysData[
                                                                      "value"],
                                                                      fontSize:
                                                                      13,
                                                                      color: AppColors
                                                                          .black_txcolor,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const Divider(),
                                                  ],
                                                );
                                              }),
                                        if (optionFootball == "QB")
                                          ListView.builder(
                                              physics: const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: qbList.length,
                                              itemBuilder: (context, index) {
                                                var keysData = qbList[index];
                                                return Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 15),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: SizedBox(
                                                              width:
                                                              MediaQuery
                                                                  .of(
                                                                  context)
                                                                  .size
                                                                  .width,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                                children: [
                                                                  CommonText(
                                                                      text: keysData[
                                                                      "displayName"],
                                                                      fontSize:
                                                                      13,
                                                                      color: AppColors
                                                                          .black_txcolor,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: SizedBox(
                                                              width:
                                                              MediaQuery
                                                                  .of(
                                                                  context)
                                                                  .size
                                                                  .width,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                                children: [
                                                                  CommonText(
                                                                      text: keysData[
                                                                      "value"],
                                                                      fontSize:
                                                                      13,
                                                                      color: AppColors
                                                                          .black_txcolor,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const Divider(),
                                                  ],
                                                );
                                              }),
                                        if (optionFootball == "RB")
                                          ListView.builder(
                                              physics: const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: rbList.length,
                                              itemBuilder: (context, index) {
                                                var keysData = rbList[index];
                                                return Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 15),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: SizedBox(
                                                              width:
                                                              MediaQuery
                                                                  .of(
                                                                  context)
                                                                  .size
                                                                  .width,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                                children: [
                                                                  CommonText(
                                                                      text: keysData[
                                                                      "displayName"],
                                                                      fontSize:
                                                                      13,
                                                                      color: AppColors
                                                                          .black_txcolor,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: SizedBox(
                                                              width:
                                                              MediaQuery
                                                                  .of(
                                                                  context)
                                                                  .size
                                                                  .width,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                                children: [
                                                                  CommonText(
                                                                      text: keysData[
                                                                      "value"],
                                                                      fontSize:
                                                                      13,
                                                                      color: AppColors
                                                                          .black_txcolor,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const Divider(),
                                                  ],
                                                );
                                              }),
                                        if (optionFootball == "HB")
                                          ListView.builder(
                                              physics: const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: hbList.length,
                                              itemBuilder: (context, index) {
                                                var keysData = hbList[index];
                                                return Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 15),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: SizedBox(
                                                              width:
                                                              MediaQuery
                                                                  .of(
                                                                  context)
                                                                  .size
                                                                  .width,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                                children: [
                                                                  CommonText(
                                                                      text: keysData[
                                                                      "displayName"],
                                                                      fontSize:
                                                                      13,
                                                                      color: AppColors
                                                                          .black_txcolor,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: SizedBox(
                                                              width:
                                                              MediaQuery
                                                                  .of(
                                                                  context)
                                                                  .size
                                                                  .width,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                                children: [
                                                                  CommonText(
                                                                      text: keysData[
                                                                      "value"],
                                                                      fontSize:
                                                                      13,
                                                                      color: AppColors
                                                                          .black_txcolor,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const Divider(),
                                                  ],
                                                );
                                              }),
                                        if (optionFootball == "FB")
                                          ListView.builder(
                                              physics: const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: fbList.length,
                                              itemBuilder: (context, index) {
                                                var keysData = fbList[index];
                                                return Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 15),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: SizedBox(
                                                              width:
                                                              MediaQuery
                                                                  .of(
                                                                  context)
                                                                  .size
                                                                  .width,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                                children: [
                                                                  CommonText(
                                                                      text: keysData[
                                                                      "displayName"],
                                                                      fontSize:
                                                                      13,
                                                                      color: AppColors
                                                                          .black_txcolor,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: SizedBox(
                                                              width:
                                                              MediaQuery
                                                                  .of(
                                                                  context)
                                                                  .size
                                                                  .width,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                                children: [
                                                                  CommonText(
                                                                      text: keysData[
                                                                      "value"],
                                                                      fontSize:
                                                                      13,
                                                                      color: AppColors
                                                                          .black_txcolor,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const Divider(),
                                                  ],
                                                );
                                              }),
                                        if (optionFootball == "WR")
                                          ListView.builder(
                                              physics: const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: wrList.length,
                                              itemBuilder: (context, index) {
                                                var keysData = wrList[index];
                                                return Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 15),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: SizedBox(
                                                              width:
                                                              MediaQuery
                                                                  .of(
                                                                  context)
                                                                  .size
                                                                  .width,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                                children: [
                                                                  CommonText(
                                                                      text: keysData[
                                                                      "displayName"],
                                                                      fontSize:
                                                                      13,
                                                                      color: AppColors
                                                                          .black_txcolor,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: SizedBox(
                                                              width:
                                                              MediaQuery
                                                                  .of(
                                                                  context)
                                                                  .size
                                                                  .width,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                                children: [
                                                                  CommonText(
                                                                      text: keysData[
                                                                      "value"],
                                                                      fontSize:
                                                                      13,
                                                                      color: AppColors
                                                                          .black_txcolor,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const Divider(),
                                                  ],
                                                );
                                              }),
                                        if (optionFootball == "TE")
                                          ListView.builder(
                                              physics: const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: teList.length,
                                              itemBuilder: (context, index) {
                                                var keysData = teList[index];
                                                return Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 15),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: SizedBox(
                                                              width:
                                                              MediaQuery
                                                                  .of(
                                                                  context)
                                                                  .size
                                                                  .width,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                                children: [
                                                                  CommonText(
                                                                      text: keysData[
                                                                      "displayName"],
                                                                      fontSize:
                                                                      13,
                                                                      color: AppColors
                                                                          .black_txcolor,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: SizedBox(
                                                              width:
                                                              MediaQuery
                                                                  .of(
                                                                  context)
                                                                  .size
                                                                  .width,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                                children: [
                                                                  CommonText(
                                                                      text: keysData[
                                                                      "value"],
                                                                      fontSize:
                                                                      13,
                                                                      color: AppColors
                                                                          .black_txcolor,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const Divider(),
                                                  ],
                                                );
                                              }),
                                        if (optionFootball == "D")
                                          ListView.builder(
                                              physics: const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: dList.length,
                                              itemBuilder: (context, index) {
                                                var keysData = dList[index];
                                                return Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 15),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: SizedBox(
                                                              width:
                                                              MediaQuery
                                                                  .of(
                                                                  context)
                                                                  .size
                                                                  .width,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                                children: [
                                                                  CommonText(
                                                                      text: keysData[
                                                                      "displayName"],
                                                                      fontSize:
                                                                      13,
                                                                      color: AppColors
                                                                          .black_txcolor,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: SizedBox(
                                                              width:
                                                              MediaQuery
                                                                  .of(
                                                                  context)
                                                                  .size
                                                                  .width,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                                children: [
                                                                  CommonText(
                                                                      text: keysData[
                                                                      "value"],
                                                                      fontSize:
                                                                      13,
                                                                      color: AppColors
                                                                          .black_txcolor,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const Divider(),
                                                  ],
                                                );
                                              }),
                                        if (optionFootball == "DL")
                                          ListView.builder(
                                              physics: const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: dlList.length,
                                              itemBuilder: (context, index) {
                                                var keysData = dlList[index];
                                                return Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 15),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: SizedBox(
                                                              width:
                                                              MediaQuery
                                                                  .of(
                                                                  context)
                                                                  .size
                                                                  .width,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                                children: [
                                                                  CommonText(
                                                                      text: keysData[
                                                                      "displayName"],
                                                                      fontSize:
                                                                      13,
                                                                      color: AppColors
                                                                          .black_txcolor,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: SizedBox(
                                                              width:
                                                              MediaQuery
                                                                  .of(
                                                                  context)
                                                                  .size
                                                                  .width,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                                children: [
                                                                  CommonText(
                                                                      text: keysData[
                                                                      "value"],
                                                                      fontSize:
                                                                      13,
                                                                      color: AppColors
                                                                          .black_txcolor,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const Divider(),
                                                  ],
                                                );
                                              }),
                                        if (optionFootball == "LB")
                                          ListView.builder(
                                              physics: const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: lbList.length,
                                              itemBuilder: (context, index) {
                                                var keysData = lbList[index];
                                                return Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 15),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: SizedBox(
                                                              width:
                                                              MediaQuery
                                                                  .of(
                                                                  context)
                                                                  .size
                                                                  .width,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                                children: [
                                                                  CommonText(
                                                                      text: keysData[
                                                                      "displayName"],
                                                                      fontSize:
                                                                      13,
                                                                      color: AppColors
                                                                          .black_txcolor,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: SizedBox(
                                                              width:
                                                              MediaQuery
                                                                  .of(
                                                                  context)
                                                                  .size
                                                                  .width,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                                children: [
                                                                  CommonText(
                                                                      text: keysData[
                                                                      "value"],
                                                                      fontSize:
                                                                      13,
                                                                      color: AppColors
                                                                          .black_txcolor,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const Divider(),
                                                  ],
                                                );
                                              }),
                                        if (optionFootball == "MLB")
                                          ListView.builder(
                                              physics: const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: mlbList.length,
                                              itemBuilder: (context, index) {
                                                var keysData = mlbList[index];
                                                return Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 15),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: SizedBox(
                                                              width:
                                                              MediaQuery
                                                                  .of(
                                                                  context)
                                                                  .size
                                                                  .width,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                                children: [
                                                                  CommonText(
                                                                      text: keysData[
                                                                      "displayName"],
                                                                      fontSize:
                                                                      13,
                                                                      color: AppColors
                                                                          .black_txcolor,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: SizedBox(
                                                              width:
                                                              MediaQuery
                                                                  .of(
                                                                  context)
                                                                  .size
                                                                  .width,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                                children: [
                                                                  CommonText(
                                                                      text: keysData[
                                                                      "value"],
                                                                      fontSize:
                                                                      13,
                                                                      color: AppColors
                                                                          .black_txcolor,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const Divider(),
                                                  ],
                                                );
                                              }),
                                        if (optionFootball == "OLB")
                                          ListView.builder(
                                              physics: const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: olbList.length,
                                              itemBuilder: (context, index) {
                                                var keysData = olbList[index];
                                                return Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 15),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: SizedBox(
                                                              width:
                                                              MediaQuery
                                                                  .of(
                                                                  context)
                                                                  .size
                                                                  .width,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                                children: [
                                                                  CommonText(
                                                                      text: keysData[
                                                                      "displayName"],
                                                                      fontSize:
                                                                      13,
                                                                      color: AppColors
                                                                          .black_txcolor,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: SizedBox(
                                                              width:
                                                              MediaQuery
                                                                  .of(
                                                                  context)
                                                                  .size
                                                                  .width,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                                children: [
                                                                  CommonText(
                                                                      text: keysData[
                                                                      "value"],
                                                                      fontSize:
                                                                      13,
                                                                      color: AppColors
                                                                          .black_txcolor,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const Divider(),
                                                  ],
                                                );
                                              }),
                                        if (optionFootball == "DB")
                                          ListView.builder(
                                              physics: const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: dbList.length,
                                              itemBuilder: (context, index) {
                                                var keysData = dbList[index];
                                                return Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 15),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: SizedBox(
                                                              width:
                                                              MediaQuery
                                                                  .of(
                                                                  context)
                                                                  .size
                                                                  .width,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                                children: [
                                                                  CommonText(
                                                                      text: keysData[
                                                                      "displayName"],
                                                                      fontSize:
                                                                      13,
                                                                      color: AppColors
                                                                          .black_txcolor,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: SizedBox(
                                                              width:
                                                              MediaQuery
                                                                  .of(
                                                                  context)
                                                                  .size
                                                                  .width,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                                children: [
                                                                  CommonText(
                                                                      text: keysData[
                                                                      "value"],
                                                                      fontSize:
                                                                      13,
                                                                      color: AppColors
                                                                          .black_txcolor,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const Divider(),
                                                  ],
                                                );
                                              }),
                                        if (optionFootball == "CB")
                                          ListView.builder(
                                              physics: const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: cbList.length,
                                              itemBuilder: (context, index) {
                                                var keysData = cbList[index];
                                                return Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 15),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: SizedBox(
                                                              width:
                                                              MediaQuery
                                                                  .of(
                                                                  context)
                                                                  .size
                                                                  .width,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                                children: [
                                                                  CommonText(
                                                                      text: keysData[
                                                                      "displayName"],
                                                                      fontSize:
                                                                      13,
                                                                      color: AppColors
                                                                          .black_txcolor,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: SizedBox(
                                                              width:
                                                              MediaQuery
                                                                  .of(
                                                                  context)
                                                                  .size
                                                                  .width,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                                children: [
                                                                  CommonText(
                                                                      text: keysData[
                                                                      "value"],
                                                                      fontSize:
                                                                      13,
                                                                      color: AppColors
                                                                          .black_txcolor,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const Divider(),
                                                  ],
                                                );
                                              }),
                                        if (optionFootball == "S")
                                          ListView.builder(
                                              physics: const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: sList.length,
                                              itemBuilder: (context, index) {
                                                var keysData = sList[index];
                                                return Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 15),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: SizedBox(
                                                              width:
                                                              MediaQuery
                                                                  .of(
                                                                  context)
                                                                  .size
                                                                  .width,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                                children: [
                                                                  CommonText(
                                                                      text: keysData[
                                                                      "displayName"],
                                                                      fontSize:
                                                                      13,
                                                                      color: AppColors
                                                                          .black_txcolor,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: SizedBox(
                                                              width:
                                                              MediaQuery
                                                                  .of(
                                                                  context)
                                                                  .size
                                                                  .width,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                                children: [
                                                                  CommonText(
                                                                      text: keysData[
                                                                      "value"],
                                                                      fontSize:
                                                                      13,
                                                                      color: AppColors
                                                                          .black_txcolor,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const Divider(),
                                                  ],
                                                );
                                              }),
                                        if (optionFootball == "NB")
                                          ListView.builder(
                                              physics: const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: nbList.length,
                                              itemBuilder: (context, index) {
                                                var keysData = nbList[index];
                                                return Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 15),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: SizedBox(
                                                              width:
                                                              MediaQuery
                                                                  .of(
                                                                  context)
                                                                  .size
                                                                  .width,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                                children: [
                                                                  CommonText(
                                                                      text: keysData[
                                                                      "displayName"],
                                                                      fontSize:
                                                                      13,
                                                                      color: AppColors
                                                                          .black_txcolor,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: SizedBox(
                                                              width:
                                                              MediaQuery
                                                                  .of(
                                                                  context)
                                                                  .size
                                                                  .width,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                                children: [
                                                                  CommonText(
                                                                      text: keysData[
                                                                      "value"],
                                                                      fontSize:
                                                                      13,
                                                                      color: AppColors
                                                                          .black_txcolor,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const Divider(),
                                                  ],
                                                );
                                              }),
                                        if (optionFootball == "K")
                                          ListView.builder(
                                              physics: const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: kList.length,
                                              itemBuilder: (context, index) {
                                                var keysData = kList[index];
                                                return Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 15),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: SizedBox(
                                                              width:
                                                              MediaQuery
                                                                  .of(
                                                                  context)
                                                                  .size
                                                                  .width,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                                children: [
                                                                  CommonText(
                                                                      text: keysData[
                                                                      "displayName"],
                                                                      fontSize:
                                                                      13,
                                                                      color: AppColors
                                                                          .black_txcolor,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: SizedBox(
                                                              width:
                                                              MediaQuery
                                                                  .of(
                                                                  context)
                                                                  .size
                                                                  .width,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                                children: [
                                                                  CommonText(
                                                                      text: keysData[
                                                                      "value"],
                                                                      fontSize:
                                                                      13,
                                                                      color: AppColors
                                                                          .black_txcolor,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const Divider(),
                                                  ],
                                                );
                                              }),
                                        if (optionFootball == "P")
                                          ListView.builder(
                                              physics: const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: pList.length,
                                              itemBuilder: (context, index) {
                                                var keysData = pList[index];
                                                return Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 15),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: SizedBox(
                                                              width:
                                                              MediaQuery
                                                                  .of(
                                                                  context)
                                                                  .size
                                                                  .width,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                                children: [
                                                                  CommonText(
                                                                      text: keysData[
                                                                      "displayName"],
                                                                      fontSize:
                                                                      13,
                                                                      color: AppColors
                                                                          .black_txcolor,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: SizedBox(
                                                              width:
                                                              MediaQuery
                                                                  .of(
                                                                  context)
                                                                  .size
                                                                  .width,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                                children: [
                                                                  CommonText(
                                                                      text: keysData[
                                                                      "value"],
                                                                      fontSize:
                                                                      13,
                                                                      color: AppColors
                                                                          .black_txcolor,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const Divider(),
                                                  ],
                                                );
                                              }),

                                      ],
                                    );
                                  } else {
                                    return Container();
                                  }
                                }),
                          ],
                        ),
                      );
                    }),
              if(widget.sport == "BASEBALL")
                StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: itemList.length,
                                itemBuilder: (context, index) {
                                  var item = itemList[index];
                                  if (item["displayGroup"] == "Desired Positions") {
                                    optionList = item["options"];
                                    print("list ======<><> $optionList");
                                    var all = item["child_fields"];
                                    print("Data View  =========<> $all");
                                    var data = json.decode(all);
                                    log('Keys: $data');
                                    pitcherList = data["P"] ?? [];
                                    catcherList = data["C"] ?? [];
                                    outfieldList = data["OF"] ?? [];
                                    infieldList = data["IF"] ?? [];
                                    universalList = data["U"] ?? [];
                                    var newList = pitcherList + catcherList + outfieldList + infieldList + universalList;
                                    print("Data  :  $newList");
                                    return Column(
                                      children: [
                                        Container(
                                          height: 55,
                                          width: MediaQuery.of(context).size.width,
                                          color: AppColors.checkboxColor,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 15),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Expanded(
                                                  child: CommonText(
                                                      text: 'POSITION',
                                                      fontSize: 14,
                                                      color: AppColors.black_txcolor,
                                                      fontWeight: FontWeight.w500),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                      height: 40,
                                                      width: MediaQuery.of(context).size.width,
                                                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                                      decoration: BoxDecoration(
                                                        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                                        color: AppColors.white,
                                                        border: Border.all(
                                                          color: AppColors.dark_blue_button_color,
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
                                                          value: optionBaseball,
                                                          underline: Container(),
                                                          isExpanded: true,
                                                          itemHeight: 35.0,
                                                          style: TextStyle(
                                                              fontSize: 15.0,
                                                              color: Colors.grey[700]),
                                                          items: optionList.map((item) {
                                                            return DropdownMenuItem(
                                                              value: item["id"].toString(),
                                                              child: CommonText(
                                                                  text: item["name"].toString(),
                                                                  fontSize: 14,
                                                                  color: AppColors.black,
                                                                  fontWeight: FontWeight.w500),
                                                            );
                                                          }).toList(),
                                                          hint: const CommonText(
                                                              text: "All Positions",
                                                              fontSize: 14,
                                                              color: AppColors.black,
                                                              fontWeight: FontWeight.w500),
                                                          onChanged:
                                                              (newValue) {
                                                            setState(() => optionBaseball = newValue);
                                                            if (kDebugMode) {
                                                              print("option========>>>>>> $optionBaseball");                                                            }
                                                            if (kDebugMode) {
                                                              print("optionList $optionBaseball");
                                                            }
                                                          },
                                                        ),
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        if (optionBaseball == "1")
                                          ListView.builder(
                                              physics:
                                              const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: newList.length,
                                              itemBuilder: (context, index) {
                                                var keysData = newList[index];
                                                return Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 15),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: SizedBox(
                                                              width:
                                                              MediaQuery
                                                                  .of(
                                                                  context)
                                                                  .size
                                                                  .width,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                                children: [
                                                                  CommonText(
                                                                      text: keysData[
                                                                      "displayName"],
                                                                      fontSize:
                                                                      13,
                                                                      color: AppColors
                                                                          .black_txcolor,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: SizedBox(
                                                              width:
                                                              MediaQuery
                                                                  .of(
                                                                  context)
                                                                  .size
                                                                  .width,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                                children: [
                                                                  CommonText(
                                                                      text: keysData[
                                                                      "value"],
                                                                      fontSize:
                                                                      13,
                                                                      color: AppColors
                                                                          .black_txcolor,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const Divider(),
                                                  ],
                                                );
                                              }),
                                        if (optionBaseball == "2")
                                          ListView.builder(
                                              physics:
                                              const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: pitcherList.length,
                                              itemBuilder: (context, index) {
                                                var keysData =
                                                pitcherList[index];
                                                if (keysData != null) {
                                                  return Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 15),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: SizedBox(
                                                                width: MediaQuery
                                                                    .of(
                                                                    context)
                                                                    .size
                                                                    .width,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                                  children: [
                                                                    CommonText(
                                                                        text: keysData[
                                                                        "displayName"],
                                                                        fontSize:
                                                                        13,
                                                                        color: AppColors
                                                                            .black_txcolor,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: SizedBox(
                                                                width: MediaQuery
                                                                    .of(
                                                                    context)
                                                                    .size
                                                                    .width,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                                  children: [
                                                                    CommonText(
                                                                        text: keysData[
                                                                        "value"],
                                                                        fontSize:
                                                                        13,
                                                                        color: AppColors
                                                                            .black_txcolor,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const Divider(),
                                                    ],
                                                  );
                                                } else {
                                                  return const Center(
                                                      child: Text(
                                                          "No Data Found"));
                                                }
                                              }),
                                        if (optionBaseball == "3")
                                          ListView.builder(
                                              physics:
                                              const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: catcherList.length,
                                              itemBuilder: (context, index) {
                                                var keysData =
                                                catcherList[index];
                                                if (keysData != null) {
                                                  return Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 15),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: SizedBox(
                                                                width: MediaQuery
                                                                    .of(
                                                                    context)
                                                                    .size
                                                                    .width,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                                  children: [
                                                                    CommonText(
                                                                        text: keysData[
                                                                        "displayName"],
                                                                        fontSize:
                                                                        13,
                                                                        color: AppColors
                                                                            .black_txcolor,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: SizedBox(
                                                                width: MediaQuery
                                                                    .of(
                                                                    context)
                                                                    .size
                                                                    .width,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                                  children: [
                                                                    CommonText(
                                                                        text: keysData[
                                                                        "value"],
                                                                        fontSize:
                                                                        13,
                                                                        color: AppColors
                                                                            .black_txcolor,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const Divider(),
                                                    ],
                                                  );
                                                } else {
                                                  return const Center(
                                                      child: Text(
                                                          "No Data Found"));
                                                }
                                              }),
                                        if (optionBaseball == "4")
                                          ListView.builder(
                                              physics:
                                              const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: outfieldList.length,
                                              itemBuilder: (context, index) {
                                                var keysData =
                                                outfieldList[index];
                                                if (keysData != null) {
                                                  return Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 15),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: SizedBox(
                                                                width: MediaQuery
                                                                    .of(
                                                                    context)
                                                                    .size
                                                                    .width,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                                  children: [
                                                                    CommonText(
                                                                        text: keysData[
                                                                        "displayName"],
                                                                        fontSize:
                                                                        13,
                                                                        color: AppColors
                                                                            .black_txcolor,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: SizedBox(
                                                                width: MediaQuery
                                                                    .of(
                                                                    context)
                                                                    .size
                                                                    .width,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                                  children: [
                                                                    CommonText(
                                                                        text: keysData[
                                                                        "value"],
                                                                        fontSize:
                                                                        13,
                                                                        color: AppColors
                                                                            .black_txcolor,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const Divider(),
                                                    ],
                                                  );
                                                } else {
                                                  return const Center(
                                                      child: Text(
                                                          "No Data Found"));
                                                }
                                              }),
                                        if (optionBaseball == "5")
                                          ListView.builder(
                                              physics:
                                              const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: infieldList.length,
                                              itemBuilder: (context, index) {
                                                var keysData =
                                                infieldList[index];
                                                if (keysData != null) {
                                                  return Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 15),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: SizedBox(
                                                                width: MediaQuery
                                                                    .of(
                                                                    context)
                                                                    .size
                                                                    .width,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                                  children: [
                                                                    CommonText(
                                                                        text: keysData[
                                                                        "displayName"],
                                                                        fontSize:
                                                                        13,
                                                                        color: AppColors
                                                                            .black_txcolor,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: SizedBox(
                                                                width: MediaQuery
                                                                    .of(
                                                                    context)
                                                                    .size
                                                                    .width,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                                  children: [
                                                                    CommonText(
                                                                        text: keysData[
                                                                        "value"],
                                                                        fontSize:
                                                                        13,
                                                                        color: AppColors
                                                                            .black_txcolor,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const Divider(),
                                                    ],
                                                  );
                                                } else {
                                                  return const Center(
                                                      child: Text(
                                                          "No Data Found"));
                                                }
                                              }),
                                        if (optionBaseball == "6")
                                          ListView.builder(
                                              physics:
                                              const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: universalList.length,
                                              itemBuilder: (context, index) {
                                                var keysData =
                                                universalList[index];
                                                if (keysData != null) {
                                                  return Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 15),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: SizedBox(
                                                                width: MediaQuery
                                                                    .of(
                                                                    context)
                                                                    .size
                                                                    .width,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                                  children: [
                                                                    CommonText(
                                                                        text: keysData[
                                                                        "displayName"],
                                                                        fontSize:
                                                                        13,
                                                                        color: AppColors
                                                                            .black_txcolor,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: SizedBox(
                                                                width: MediaQuery
                                                                    .of(
                                                                    context)
                                                                    .size
                                                                    .width,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                                  children: [
                                                                    CommonText(
                                                                        text: keysData[
                                                                        "value"],
                                                                        fontSize:
                                                                        13,
                                                                        color: AppColors
                                                                            .black_txcolor,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const Divider(),
                                                    ],
                                                  );
                                                } else {
                                                  return const Center(
                                                      child: Text(
                                                          "No Data Found"));
                                                }
                                              }),
                                      ],
                                    );
                                  } else {
                                    return Container();
                                  }
                                }),
                          ],
                        ),
                      );
                    }),
            ])
                : TabBarView(controller: tabController, children: [
                  if(widget.sport == "FOOTBALL")
              StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: itemList.length,
                              itemBuilder: (context, index) {
                                var item = itemList[index];
                                if (item["displayGroup"] == "Desired Positions") {
                                  optionList = item["options"];
                                  print("list ======<><> $optionList");
                                  var all = item["child_fields"];
                                  print("Data View  =========<> $all");
                                  var data = json.decode(all);
                                  log('Keys: $data');
                                  qbList = data["QB"] ?? [];
                                  rbList = data["RB"] ?? [];
                                  hbList = data["HB"] ?? [];
                                  fbList = data["FB"] ?? [];
                                  wrList = data["WR"] ?? [];
                                  teList = data["TE"] ?? [];
                                  dList = data["D"] ?? [];
                                  dlList = data["DL"] ?? [];
                                  lbList = data["LB"] ?? [];
                                  mlbList = data["MLB"] ?? [];
                                  olbList = data["OLB"] ?? [];
                                  dbList = data["DB"] ?? [];
                                  cbList = data["CB"] ?? [];
                                  sList = data["S"] ?? [];
                                  nbList = data["NB"] ?? [];
                                  kList = data["K"] ?? [];
                                  pList = data["P"] ?? [];
                                  var newList = qbList + rbList + hbList + fbList + wrList + teList + dList + dlList + lbList + mlbList + olbList + dbList + cbList + sList + nbList + kList + pList;
                                  print("Data  :  $newList");
                                  return Column(
                                    children: [
                                      Container(
                                        height: 55,
                                        width: MediaQuery.of(context).size.width,
                                        color: AppColors.checkboxColor,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 15),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Expanded(
                                                child: CommonText(
                                                    text: 'POSITION',
                                                    fontSize: 14,
                                                    color: AppColors.black_txcolor,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                              Expanded(
                                                child: Container(
                                                    height: 40,
                                                    width: MediaQuery.of(context).size.width,
                                                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                                    decoration: BoxDecoration(
                                                      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                                      color: AppColors.white,
                                                      border: Border.all(
                                                        color: AppColors.dark_blue_button_color,
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
                                                        value: optionFootball,
                                                        underline: Container(),
                                                        isExpanded: true,
                                                        itemHeight: 35.0,
                                                        style: TextStyle(
                                                            fontSize: 15.0,
                                                            color: Colors.grey[700]),
                                                        items: optionList.map((item) {
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
                                                            text: "All Positions",
                                                            fontSize: 14,
                                                            color: AppColors.black,
                                                            fontWeight: FontWeight.w500),
                                                        onChanged:
                                                            (newValue) {
                                                          setState(() => optionFootball = newValue);
                                                          if (kDebugMode) {
                                                            print("option========>>>>>> $optionFootball");
                                                          }
                                                          if (kDebugMode) {
                                                            print("optionList $optionFootball");
                                                          }
                                                        },
                                                      ),
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      if (optionFootball == "All Positions")
                                      ListView.builder(
                                          physics: const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: newList.length,
                                          itemBuilder: (context, index) {
                                            var keysData = newList[index];
                                            return Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 15),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: SizedBox(
                                                          width:
                                                          MediaQuery
                                                              .of(
                                                              context)
                                                              .size
                                                              .width,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              CommonText(
                                                                  text: keysData[
                                                                  "displayName"],
                                                                  fontSize:
                                                                  13,
                                                                  color: AppColors
                                                                      .black_txcolor,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: SizedBox(
                                                          width:
                                                          MediaQuery
                                                              .of(
                                                              context)
                                                              .size
                                                              .width,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                            children: [
                                                              CommonText(
                                                                  text: keysData[
                                                                  "value"],
                                                                  fontSize:
                                                                  13,
                                                                  color: AppColors
                                                                      .black_txcolor,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const Divider(),
                                              ],
                                            );
                                          }),
                                      if (optionFootball == "QB")
                                        ListView.builder(
                                            physics: const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: qbList.length,
                                            itemBuilder: (context, index) {
                                              var keysData = qbList[index];
                                              return Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 15),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: SizedBox(
                                                            width:
                                                            MediaQuery
                                                                .of(
                                                                context)
                                                                .size
                                                                .width,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                              children: [
                                                                CommonText(
                                                                    text: keysData[
                                                                    "displayName"],
                                                                    fontSize:
                                                                    13,
                                                                    color: AppColors
                                                                        .black_txcolor,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: SizedBox(
                                                            width:
                                                            MediaQuery
                                                                .of(
                                                                context)
                                                                .size
                                                                .width,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                              children: [
                                                                CommonText(
                                                                    text: keysData[
                                                                    "value"],
                                                                    fontSize:
                                                                    13,
                                                                    color: AppColors
                                                                        .black_txcolor,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const Divider(),
                                                ],
                                              );
                                            }),
                                      if (optionFootball == "RB")
                                        ListView.builder(
                                            physics: const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: rbList.length,
                                            itemBuilder: (context, index) {
                                              var keysData = rbList[index];
                                              return Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 15),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: SizedBox(
                                                            width:
                                                            MediaQuery
                                                                .of(
                                                                context)
                                                                .size
                                                                .width,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                              children: [
                                                                CommonText(
                                                                    text: keysData[
                                                                    "displayName"],
                                                                    fontSize:
                                                                    13,
                                                                    color: AppColors
                                                                        .black_txcolor,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: SizedBox(
                                                            width:
                                                            MediaQuery
                                                                .of(
                                                                context)
                                                                .size
                                                                .width,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                              children: [
                                                                CommonText(
                                                                    text: keysData[
                                                                    "value"],
                                                                    fontSize:
                                                                    13,
                                                                    color: AppColors
                                                                        .black_txcolor,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const Divider(),
                                                ],
                                              );
                                            }),
                                      if (optionFootball == "HB")
                                        ListView.builder(
                                            physics: const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: hbList.length,
                                            itemBuilder: (context, index) {
                                              var keysData = hbList[index];
                                              return Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 15),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: SizedBox(
                                                            width:
                                                            MediaQuery
                                                                .of(
                                                                context)
                                                                .size
                                                                .width,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                              children: [
                                                                CommonText(
                                                                    text: keysData[
                                                                    "displayName"],
                                                                    fontSize:
                                                                    13,
                                                                    color: AppColors
                                                                        .black_txcolor,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: SizedBox(
                                                            width:
                                                            MediaQuery
                                                                .of(
                                                                context)
                                                                .size
                                                                .width,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                              children: [
                                                                CommonText(
                                                                    text: keysData[
                                                                    "value"],
                                                                    fontSize:
                                                                    13,
                                                                    color: AppColors
                                                                        .black_txcolor,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const Divider(),
                                                ],
                                              );
                                            }),
                                      if (optionFootball == "FB")
                                        ListView.builder(
                                            physics: const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: fbList.length,
                                            itemBuilder: (context, index) {
                                              var keysData = fbList[index];
                                              return Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 15),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: SizedBox(
                                                            width:
                                                            MediaQuery
                                                                .of(
                                                                context)
                                                                .size
                                                                .width,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                              children: [
                                                                CommonText(
                                                                    text: keysData[
                                                                    "displayName"],
                                                                    fontSize:
                                                                    13,
                                                                    color: AppColors
                                                                        .black_txcolor,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: SizedBox(
                                                            width:
                                                            MediaQuery
                                                                .of(
                                                                context)
                                                                .size
                                                                .width,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                              children: [
                                                                CommonText(
                                                                    text: keysData[
                                                                    "value"],
                                                                    fontSize:
                                                                    13,
                                                                    color: AppColors
                                                                        .black_txcolor,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const Divider(),
                                                ],
                                              );
                                            }),
                                      if (optionFootball == "WR")
                                        ListView.builder(
                                            physics: const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: wrList.length,
                                            itemBuilder: (context, index) {
                                              var keysData = wrList[index];
                                              return Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 15),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: SizedBox(
                                                            width:
                                                            MediaQuery
                                                                .of(
                                                                context)
                                                                .size
                                                                .width,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                              children: [
                                                                CommonText(
                                                                    text: keysData[
                                                                    "displayName"],
                                                                    fontSize:
                                                                    13,
                                                                    color: AppColors
                                                                        .black_txcolor,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: SizedBox(
                                                            width:
                                                            MediaQuery
                                                                .of(
                                                                context)
                                                                .size
                                                                .width,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                              children: [
                                                                CommonText(
                                                                    text: keysData[
                                                                    "value"],
                                                                    fontSize:
                                                                    13,
                                                                    color: AppColors
                                                                        .black_txcolor,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const Divider(),
                                                ],
                                              );
                                            }),
                                      if (optionFootball == "TE")
                                        ListView.builder(
                                            physics: const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: teList.length,
                                            itemBuilder: (context, index) {
                                              var keysData = teList[index];
                                              return Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 15),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: SizedBox(
                                                            width:
                                                            MediaQuery
                                                                .of(
                                                                context)
                                                                .size
                                                                .width,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                              children: [
                                                                CommonText(
                                                                    text: keysData[
                                                                    "displayName"],
                                                                    fontSize:
                                                                    13,
                                                                    color: AppColors
                                                                        .black_txcolor,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: SizedBox(
                                                            width:
                                                            MediaQuery
                                                                .of(
                                                                context)
                                                                .size
                                                                .width,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                              children: [
                                                                CommonText(
                                                                    text: keysData[
                                                                    "value"],
                                                                    fontSize:
                                                                    13,
                                                                    color: AppColors
                                                                        .black_txcolor,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const Divider(),
                                                ],
                                              );
                                            }),
                                      if (optionFootball == "D")
                                        ListView.builder(
                                            physics: const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: dList.length,
                                            itemBuilder: (context, index) {
                                              var keysData = dList[index];
                                              return Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 15),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: SizedBox(
                                                            width:
                                                            MediaQuery
                                                                .of(
                                                                context)
                                                                .size
                                                                .width,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                              children: [
                                                                CommonText(
                                                                    text: keysData[
                                                                    "displayName"],
                                                                    fontSize:
                                                                    13,
                                                                    color: AppColors
                                                                        .black_txcolor,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: SizedBox(
                                                            width:
                                                            MediaQuery
                                                                .of(
                                                                context)
                                                                .size
                                                                .width,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                              children: [
                                                                CommonText(
                                                                    text: keysData[
                                                                    "value"],
                                                                    fontSize:
                                                                    13,
                                                                    color: AppColors
                                                                        .black_txcolor,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const Divider(),
                                                ],
                                              );
                                            }),
                                      if (optionFootball == "DL")
                                        ListView.builder(
                                            physics: const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: dlList.length,
                                            itemBuilder: (context, index) {
                                              var keysData = dlList[index];
                                              return Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 15),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: SizedBox(
                                                            width:
                                                            MediaQuery
                                                                .of(
                                                                context)
                                                                .size
                                                                .width,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                              children: [
                                                                CommonText(
                                                                    text: keysData[
                                                                    "displayName"],
                                                                    fontSize:
                                                                    13,
                                                                    color: AppColors
                                                                        .black_txcolor,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: SizedBox(
                                                            width:
                                                            MediaQuery
                                                                .of(
                                                                context)
                                                                .size
                                                                .width,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                              children: [
                                                                CommonText(
                                                                    text: keysData[
                                                                    "value"],
                                                                    fontSize:
                                                                    13,
                                                                    color: AppColors
                                                                        .black_txcolor,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const Divider(),
                                                ],
                                              );
                                            }),
                                      if (optionFootball == "LB")
                                        ListView.builder(
                                            physics: const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: lbList.length,
                                            itemBuilder: (context, index) {
                                              var keysData = lbList[index];
                                              return Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 15),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: SizedBox(
                                                            width:
                                                            MediaQuery
                                                                .of(
                                                                context)
                                                                .size
                                                                .width,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                              children: [
                                                                CommonText(
                                                                    text: keysData[
                                                                    "displayName"],
                                                                    fontSize:
                                                                    13,
                                                                    color: AppColors
                                                                        .black_txcolor,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: SizedBox(
                                                            width:
                                                            MediaQuery
                                                                .of(
                                                                context)
                                                                .size
                                                                .width,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                              children: [
                                                                CommonText(
                                                                    text: keysData[
                                                                    "value"],
                                                                    fontSize:
                                                                    13,
                                                                    color: AppColors
                                                                        .black_txcolor,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const Divider(),
                                                ],
                                              );
                                            }),
                                      if (optionFootball == "MLB")
                                        ListView.builder(
                                            physics: const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: mlbList.length,
                                            itemBuilder: (context, index) {
                                              var keysData = mlbList[index];
                                              return Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 15),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: SizedBox(
                                                            width:
                                                            MediaQuery
                                                                .of(
                                                                context)
                                                                .size
                                                                .width,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                              children: [
                                                                CommonText(
                                                                    text: keysData[
                                                                    "displayName"],
                                                                    fontSize:
                                                                    13,
                                                                    color: AppColors
                                                                        .black_txcolor,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: SizedBox(
                                                            width:
                                                            MediaQuery
                                                                .of(
                                                                context)
                                                                .size
                                                                .width,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                              children: [
                                                                CommonText(
                                                                    text: keysData[
                                                                    "value"],
                                                                    fontSize:
                                                                    13,
                                                                    color: AppColors
                                                                        .black_txcolor,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const Divider(),
                                                ],
                                              );
                                            }),
                                      if (optionFootball == "OLB")
                                        ListView.builder(
                                            physics: const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: olbList.length,
                                            itemBuilder: (context, index) {
                                              var keysData = olbList[index];
                                              return Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 15),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: SizedBox(
                                                            width:
                                                            MediaQuery
                                                                .of(
                                                                context)
                                                                .size
                                                                .width,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                              children: [
                                                                CommonText(
                                                                    text: keysData[
                                                                    "displayName"],
                                                                    fontSize:
                                                                    13,
                                                                    color: AppColors
                                                                        .black_txcolor,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: SizedBox(
                                                            width:
                                                            MediaQuery
                                                                .of(
                                                                context)
                                                                .size
                                                                .width,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                              children: [
                                                                CommonText(
                                                                    text: keysData[
                                                                    "value"],
                                                                    fontSize:
                                                                    13,
                                                                    color: AppColors
                                                                        .black_txcolor,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const Divider(),
                                                ],
                                              );
                                            }),
                                      if (optionFootball == "DB")
                                        ListView.builder(
                                            physics: const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: dbList.length,
                                            itemBuilder: (context, index) {
                                              var keysData = dbList[index];
                                              return Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 15),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: SizedBox(
                                                            width:
                                                            MediaQuery
                                                                .of(
                                                                context)
                                                                .size
                                                                .width,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                              children: [
                                                                CommonText(
                                                                    text: keysData[
                                                                    "displayName"],
                                                                    fontSize:
                                                                    13,
                                                                    color: AppColors
                                                                        .black_txcolor,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: SizedBox(
                                                            width:
                                                            MediaQuery
                                                                .of(
                                                                context)
                                                                .size
                                                                .width,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                              children: [
                                                                CommonText(
                                                                    text: keysData[
                                                                    "value"],
                                                                    fontSize:
                                                                    13,
                                                                    color: AppColors
                                                                        .black_txcolor,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const Divider(),
                                                ],
                                              );
                                            }),
                                      if (optionFootball == "CB")
                                        ListView.builder(
                                            physics: const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: cbList.length,
                                            itemBuilder: (context, index) {
                                              var keysData = cbList[index];
                                              return Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 15),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: SizedBox(
                                                            width:
                                                            MediaQuery
                                                                .of(
                                                                context)
                                                                .size
                                                                .width,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                              children: [
                                                                CommonText(
                                                                    text: keysData[
                                                                    "displayName"],
                                                                    fontSize:
                                                                    13,
                                                                    color: AppColors
                                                                        .black_txcolor,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: SizedBox(
                                                            width:
                                                            MediaQuery
                                                                .of(
                                                                context)
                                                                .size
                                                                .width,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                              children: [
                                                                CommonText(
                                                                    text: keysData[
                                                                    "value"],
                                                                    fontSize:
                                                                    13,
                                                                    color: AppColors
                                                                        .black_txcolor,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const Divider(),
                                                ],
                                              );
                                            }),
                                      if (optionFootball == "S")
                                        ListView.builder(
                                            physics: const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: sList.length,
                                            itemBuilder: (context, index) {
                                              var keysData = sList[index];
                                              return Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 15),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: SizedBox(
                                                            width:
                                                            MediaQuery
                                                                .of(
                                                                context)
                                                                .size
                                                                .width,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                              children: [
                                                                CommonText(
                                                                    text: keysData[
                                                                    "displayName"],
                                                                    fontSize:
                                                                    13,
                                                                    color: AppColors
                                                                        .black_txcolor,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: SizedBox(
                                                            width:
                                                            MediaQuery
                                                                .of(
                                                                context)
                                                                .size
                                                                .width,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                              children: [
                                                                CommonText(
                                                                    text: keysData[
                                                                    "value"],
                                                                    fontSize:
                                                                    13,
                                                                    color: AppColors
                                                                        .black_txcolor,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const Divider(),
                                                ],
                                              );
                                            }),
                                      if (optionFootball == "NB")
                                        ListView.builder(
                                            physics: const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: nbList.length,
                                            itemBuilder: (context, index) {
                                              var keysData = nbList[index];
                                              return Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 15),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: SizedBox(
                                                            width:
                                                            MediaQuery
                                                                .of(
                                                                context)
                                                                .size
                                                                .width,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                              children: [
                                                                CommonText(
                                                                    text: keysData[
                                                                    "displayName"],
                                                                    fontSize:
                                                                    13,
                                                                    color: AppColors
                                                                        .black_txcolor,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: SizedBox(
                                                            width:
                                                            MediaQuery
                                                                .of(
                                                                context)
                                                                .size
                                                                .width,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                              children: [
                                                                CommonText(
                                                                    text: keysData[
                                                                    "value"],
                                                                    fontSize:
                                                                    13,
                                                                    color: AppColors
                                                                        .black_txcolor,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const Divider(),
                                                ],
                                              );
                                            }),
                                      if (optionFootball == "K")
                                        ListView.builder(
                                            physics: const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: kList.length,
                                            itemBuilder: (context, index) {
                                              var keysData = kList[index];
                                              return Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 15),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: SizedBox(
                                                            width:
                                                            MediaQuery
                                                                .of(
                                                                context)
                                                                .size
                                                                .width,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                              children: [
                                                                CommonText(
                                                                    text: keysData[
                                                                    "displayName"],
                                                                    fontSize:
                                                                    13,
                                                                    color: AppColors
                                                                        .black_txcolor,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: SizedBox(
                                                            width:
                                                            MediaQuery
                                                                .of(
                                                                context)
                                                                .size
                                                                .width,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                              children: [
                                                                CommonText(
                                                                    text: keysData[
                                                                    "value"],
                                                                    fontSize:
                                                                    13,
                                                                    color: AppColors
                                                                        .black_txcolor,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const Divider(),
                                                ],
                                              );
                                            }),
                                      if (optionFootball == "P")
                                        ListView.builder(
                                            physics: const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: pList.length,
                                            itemBuilder: (context, index) {
                                              var keysData = pList[index];
                                              return Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 15),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: SizedBox(
                                                            width:
                                                            MediaQuery
                                                                .of(
                                                                context)
                                                                .size
                                                                .width,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                              children: [
                                                                CommonText(
                                                                    text: keysData[
                                                                    "displayName"],
                                                                    fontSize:
                                                                    13,
                                                                    color: AppColors
                                                                        .black_txcolor,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: SizedBox(
                                                            width:
                                                            MediaQuery
                                                                .of(
                                                                context)
                                                                .size
                                                                .width,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                              children: [
                                                                CommonText(
                                                                    text: keysData[
                                                                    "value"],
                                                                    fontSize:
                                                                    13,
                                                                    color: AppColors
                                                                        .black_txcolor,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const Divider(),
                                                ],
                                              );
                                            }),

                                    ],
                                  );
                                } else {
                                  return Container();
                                }
                              }),
                        ],
                      ),
                    );
                  }),
              if(widget.sport == "BASEBALL")
                StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: itemList.length,
                                itemBuilder: (context, index) {
                                  var item = itemList[index];
                                  if (item["displayGroup"] == "Desired Positions") {
                                    optionList = item["options"];
                                    print("list ======<><> $optionList");
                                    var all = item["child_fields"];
                                    print("Data View  =========<> $all");
                                    var data = json.decode(all);
                                    log('Keys: $data');
                                    pitcherList = data["P"] ?? [];
                                    catcherList = data["C"] ?? [];
                                    outfieldList = data["OF"] ?? [];
                                    infieldList = data["IF"] ?? [];
                                    universalList = data["U"] ?? [];
                                    var newList = pitcherList + catcherList + outfieldList + infieldList + universalList;
                                    print("Data  :  $newList");
                                    return Column(
                                      children: [
                                        Container(
                                          height: 55,
                                          width: MediaQuery.of(context).size.width,
                                          color: AppColors.checkboxColor,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 15),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Expanded(
                                                  child: CommonText(
                                                      text: 'POSITION',
                                                      fontSize: 14,
                                                      color: AppColors.black_txcolor,
                                                      fontWeight: FontWeight.w500),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                      height: 40,
                                                      width: MediaQuery.of(context).size.width,
                                                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                                      decoration: BoxDecoration(
                                                        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                                        color: AppColors.white,
                                                        border: Border.all(
                                                          color: AppColors.dark_blue_button_color,
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
                                                          value: optionBaseball,
                                                          underline: Container(),
                                                          isExpanded: true,
                                                          itemHeight: 35.0,
                                                          style: TextStyle(
                                                              fontSize: 15.0,
                                                              color: Colors.grey[700]),
                                                          items: optionList.map((item) {
                                                            return DropdownMenuItem(
                                                              value: item["id"].toString(),
                                                              child: CommonText(
                                                                  text: item["name"].toString(),
                                                                  fontSize: 14,
                                                                  color: AppColors.black,
                                                                  fontWeight: FontWeight.w500),
                                                            );
                                                          }).toList(),
                                                          hint: const CommonText(
                                                              text: "All Positions",
                                                              fontSize: 14,
                                                              color: AppColors.black,
                                                              fontWeight: FontWeight.w500),
                                                          onChanged:
                                                              (newValue) {
                                                            setState(() => optionBaseball = newValue);
                                                            if (kDebugMode) {
                                                              print("option========>>>>>> $optionBaseball");                                                            }
                                                            if (kDebugMode) {
                                                              print("optionList $optionBaseball");
                                                            }
                                                          },
                                                        ),
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        if (optionBaseball == "1")
                                          ListView.builder(
                                              physics:
                                              const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: newList.length,
                                              itemBuilder: (context, index) {
                                                var keysData = newList[index];
                                                return Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 15),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: SizedBox(
                                                              width:
                                                              MediaQuery
                                                                  .of(
                                                                  context)
                                                                  .size
                                                                  .width,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                                children: [
                                                                  CommonText(
                                                                      text: keysData[
                                                                      "displayName"],
                                                                      fontSize:
                                                                      13,
                                                                      color: AppColors
                                                                          .black_txcolor,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: SizedBox(
                                                              width:
                                                              MediaQuery
                                                                  .of(
                                                                  context)
                                                                  .size
                                                                  .width,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                                children: [
                                                                  CommonText(
                                                                      text: keysData[
                                                                      "value"],
                                                                      fontSize:
                                                                      13,
                                                                      color: AppColors
                                                                          .black_txcolor,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const Divider(),
                                                  ],
                                                );
                                              }),
                                        if (optionBaseball == "2")
                                          ListView.builder(
                                              physics:
                                              const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: pitcherList.length,
                                              itemBuilder: (context, index) {
                                                var keysData =
                                                pitcherList[index];
                                                if (keysData != null) {
                                                  return Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 15),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: SizedBox(
                                                                width: MediaQuery
                                                                    .of(
                                                                    context)
                                                                    .size
                                                                    .width,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                                  children: [
                                                                    CommonText(
                                                                        text: keysData[
                                                                        "displayName"],
                                                                        fontSize:
                                                                        13,
                                                                        color: AppColors
                                                                            .black_txcolor,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: SizedBox(
                                                                width: MediaQuery
                                                                    .of(
                                                                    context)
                                                                    .size
                                                                    .width,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                                  children: [
                                                                    CommonText(
                                                                        text: keysData[
                                                                        "value"],
                                                                        fontSize:
                                                                        13,
                                                                        color: AppColors
                                                                            .black_txcolor,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const Divider(),
                                                    ],
                                                  );
                                                } else {
                                                  return const Center(
                                                      child: Text(
                                                          "No Data Found"));
                                                }
                                              }),
                                        if (optionBaseball == "3")
                                          ListView.builder(
                                              physics:
                                              const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: catcherList.length,
                                              itemBuilder: (context, index) {
                                                var keysData =
                                                catcherList[index];
                                                if (keysData != null) {
                                                  return Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 15),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: SizedBox(
                                                                width: MediaQuery
                                                                    .of(
                                                                    context)
                                                                    .size
                                                                    .width,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                                  children: [
                                                                    CommonText(
                                                                        text: keysData[
                                                                        "displayName"],
                                                                        fontSize:
                                                                        13,
                                                                        color: AppColors
                                                                            .black_txcolor,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: SizedBox(
                                                                width: MediaQuery
                                                                    .of(
                                                                    context)
                                                                    .size
                                                                    .width,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                                  children: [
                                                                    CommonText(
                                                                        text: keysData[
                                                                        "value"],
                                                                        fontSize:
                                                                        13,
                                                                        color: AppColors
                                                                            .black_txcolor,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const Divider(),
                                                    ],
                                                  );
                                                } else {
                                                  return const Center(
                                                      child: Text(
                                                          "No Data Found"));
                                                }
                                              }),
                                        if (optionBaseball == "4")
                                          ListView.builder(
                                              physics:
                                              const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: outfieldList.length,
                                              itemBuilder: (context, index) {
                                                var keysData =
                                                outfieldList[index];
                                                if (keysData != null) {
                                                  return Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 15),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: SizedBox(
                                                                width: MediaQuery
                                                                    .of(
                                                                    context)
                                                                    .size
                                                                    .width,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                                  children: [
                                                                    CommonText(
                                                                        text: keysData[
                                                                        "displayName"],
                                                                        fontSize:
                                                                        13,
                                                                        color: AppColors
                                                                            .black_txcolor,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: SizedBox(
                                                                width: MediaQuery
                                                                    .of(
                                                                    context)
                                                                    .size
                                                                    .width,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                                  children: [
                                                                    CommonText(
                                                                        text: keysData[
                                                                        "value"],
                                                                        fontSize:
                                                                        13,
                                                                        color: AppColors
                                                                            .black_txcolor,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const Divider(),
                                                    ],
                                                  );
                                                } else {
                                                  return const Center(
                                                      child: Text(
                                                          "No Data Found"));
                                                }
                                              }),
                                        if (optionBaseball == "5")
                                          ListView.builder(
                                              physics:
                                              const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: infieldList.length,
                                              itemBuilder: (context, index) {
                                                var keysData =
                                                infieldList[index];
                                                if (keysData != null) {
                                                  return Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 15),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: SizedBox(
                                                                width: MediaQuery
                                                                    .of(
                                                                    context)
                                                                    .size
                                                                    .width,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                                  children: [
                                                                    CommonText(
                                                                        text: keysData[
                                                                        "displayName"],
                                                                        fontSize:
                                                                        13,
                                                                        color: AppColors
                                                                            .black_txcolor,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: SizedBox(
                                                                width: MediaQuery
                                                                    .of(
                                                                    context)
                                                                    .size
                                                                    .width,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                                  children: [
                                                                    CommonText(
                                                                        text: keysData[
                                                                        "value"],
                                                                        fontSize:
                                                                        13,
                                                                        color: AppColors
                                                                            .black_txcolor,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const Divider(),
                                                    ],
                                                  );
                                                } else {
                                                  return const Center(
                                                      child: Text(
                                                          "No Data Found"));
                                                }
                                              }),
                                        if (optionBaseball == "6")
                                          ListView.builder(
                                              physics:
                                              const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: universalList.length,
                                              itemBuilder: (context, index) {
                                                var keysData =
                                                universalList[index];
                                                if (keysData != null) {
                                                  return Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 15),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: SizedBox(
                                                                width: MediaQuery
                                                                    .of(
                                                                    context)
                                                                    .size
                                                                    .width,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                                  children: [
                                                                    CommonText(
                                                                        text: keysData[
                                                                        "displayName"],
                                                                        fontSize:
                                                                        13,
                                                                        color: AppColors
                                                                            .black_txcolor,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: SizedBox(
                                                                width: MediaQuery
                                                                    .of(
                                                                    context)
                                                                    .size
                                                                    .width,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                                  children: [
                                                                    CommonText(
                                                                        text: keysData[
                                                                        "value"],
                                                                        fontSize:
                                                                        13,
                                                                        color: AppColors
                                                                            .black_txcolor,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const Divider(),
                                                    ],
                                                  );
                                                } else {
                                                  return const Center(
                                                      child: Text(
                                                          "No Data Found"));
                                                }
                                              }),
                                      ],
                                    );
                                  } else {
                                    return Container();
                                  }
                                }),
                          ],
                        ),
                      );
                    }),
            ]),
          )
        ],
      ),
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
        labelColor: AppColors.blue_text_Color,
        // padding: const EdgeInsets.symmetric(horizontal: 11),
        splashBorderRadius: BorderRadius.circular(15),
        isScrollable: true,
        controller: tabController,
        tabs: List.generate(widget.itemList.length, (index) {
          print("length ====>/. ${widget.itemList[index]}");
          return Text(widget.itemList[index]["displayGroup"]);
        }),
      ),
    );
  }

  manageAditionalInformationList(String userId) async {
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
              itemList = response.data["attribute"];
              uniquelist = response.data["attribute"]
                  .where((value) => models.add(value["displayGroup"]))
                  .toList();
              // uniquelist = response.data["attribute"].where((value) => models.add(value.toString())).toList();
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
}



class TabAdminAdvisorDetailScreen extends StatefulWidget {
  final String userId;
  final int length;

  const TabAdminAdvisorDetailScreen(this.userId, this.length, {Key? key})
      : super(key: key);

  @override
  State<TabAdminAdvisorDetailScreen> createState() =>
      _TabAdminAdvisorDetailScreenState();
}

class _TabAdminAdvisorDetailScreenState extends State<TabAdminAdvisorDetailScreen> with SingleTickerProviderStateMixin {
  bool selected = false;
  TabController? tabController;
  var models = <String>{};
  List itemList = [];
  List uniquelist = [];
  int? count;
  int? value;
  bool isLoading = false;

  @override
  void initState() {
    tabController = TabController(length: widget.length, vsync: this);
    setState(() {
      manageAditionalInformationList(widget.userId);
    });
    super.initState();
    print("List Of tab length ==-===<><. ${widget.length}");
    // print("uniqueList $uniquelist");
    // print("Length of List $item");
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Column(
        children: [
          const SizedBox(height: 11),
          _buildTabBar(),
          const SizedBox(height: 10),
          Expanded(
              child: TabBarView(controller: tabController, children: [
                VideosByIdScreen(widget.userId),
              ])),
        ],
      ),
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
          labelColor: AppColors.blue_text_Color,
          // padding: const EdgeInsets.symmetric(horizontal: 11),
          splashBorderRadius: BorderRadius.circular(15),
          isScrollable: true,
          controller: tabController,
          tabs: [Tab(text: "Videos")]

        // List.generate(widget.length , (index) {
        //   print("length ====>/. ${uniquelist[index]}");
        //
        //   return Text(uniquelist[index]["displayGroup"]);
        // }),
      ),
    );
  }

  manageAditionalInformationList(String userId) async {
    log('this is Manage_Profile  api call', name: "Manage_Profile");
    setState(() {
      isLoading == true;
    });
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
              itemList = response.data["attribute"];
              uniquelist = response.data["attribute"]
                  .where((value) => models.add(value["displayGroup"]))
                  .toList();
              // uniquelist = response.data["attribute"].where((value) => models.add(value.toString())).toList();
              print("+++++this is item ${response.data["attribute"]}");
              print("+++++ ${itemList.toString()}");
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
}

/*class TabTestingAdminHomeDetailScreen extends StatefulWidget {
  final String userId;
  final int length;
  final Map<dynamic, Iterable<Object>> group;
  final List uniquelist;
  const TabTestingAdminHomeDetailScreen(this.userId, this.length,this.group, this.uniquelist, {Key? key}) : super(key: key);

  @override
  State<TabTestingAdminHomeDetailScreen> createState() =>
      _TabTestingAdminHomeDetailScreenState();
}

class _TabTestingAdminHomeDetailScreenState extends State<TabTestingAdminHomeDetailScreen>
    with SingleTickerProviderStateMixin {
  bool selected = false;
  TabController? tabController;
  var models = <String>{};
  List itemList = [];
  List uniquelist = [];
  int? count;
  int? value;
  bool isLoading = false;

  @override
  void initState() {
    tabController = TabController(length: widget.length, vsync: this);
    setState(() {
      manageAditionalInformationList(widget.userId);
    });
    super.initState();
    print("List Of tab length ==-===<><. ${widget.length}");
    // print("uniqueList $uniquelist");
    // print("Length of List $item");
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Column(
        children: [
          const SizedBox(height: 11),
          _buildTabBar(),
          const SizedBox(height: 10),
          Expanded(
            child: widget.length == 1
                ? TabBarView(controller: tabController, children: [
              Column(
                children: [
                  Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    color: AppColors.drawer_bottom_text_color,
                    child: Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: const [
                          CommonText(
                              text: "ATTRIBUTE NAME",
                              fontSize: 14,
                              color: AppColors.white,
                              fontWeight: FontWeight.w600),
                          CommonText(
                              text: "DESCRIPTION",
                              fontSize: 14,
                              color: AppColors.white,
                              fontWeight: FontWeight.w600),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: itemList.length,
                        itemBuilder: (context, index) {
                          var totalPendingItem = itemList[index];
                          if (totalPendingItem["displayGroup"] == "Additional Information") {
                            if (totalPendingItem["columnName"] ==
                                "AthleteSchoolYear")
                              print(
                                  "optionsList =====>  ${totalPendingItem["options"]}");
                            return Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                if (totalPendingItem["columnName"] ==
                                    "uploadTranscript")
                                  Container(),
                                if (totalPendingItem["columnName"] !=
                                    "uploadTranscript")
                                  const SizedBox(height: 5),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          width:
                                          MediaQuery.of(context)
                                              .size
                                              .width,
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: [
                                              CommonText(
                                                  text: totalPendingItem[
                                                  "displayName"],
                                                  fontSize: 13,
                                                  color: AppColors
                                                      .black_txcolor,
                                                  fontWeight:
                                                  FontWeight
                                                      .w500),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          width:
                                          MediaQuery.of(context)
                                              .size
                                              .width,
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .end,
                                            children: [
                                              if (totalPendingItem[
                                              "columnName"] ==
                                                  "AthleteSchoolYear")
                                                if (totalPendingItem[
                                                "value"][0] ==
                                                    totalPendingItem[
                                                    "options"]
                                                    [3]["id"])
                                                  CommonText(
                                                      text:
                                                      "${totalPendingItem["options"][3]["name"]}",
                                                      fontSize: 13,
                                                      color: AppColors
                                                          .black_txcolor,
                                                      fontWeight:
                                                      FontWeight
                                                          .w500),
                                              if (totalPendingItem[
                                              "columnName"] ==
                                                  "uploadTranscript")
                                                CommonText(
                                                    text: totalPendingItem[
                                                    "value"]
                                                    [
                                                    'DisplayName'],
                                                    fontSize: 13,
                                                    color: AppColors
                                                        .black_txcolor,
                                                    fontWeight:
                                                    FontWeight
                                                        .w500),
                                              if (totalPendingItem[
                                              "columnName"] !=
                                                  "uploadTranscript" &&
                                                  totalPendingItem[
                                                  "columnName"] !=
                                                      "AthleteSchoolYear")
                                                CommonText(
                                                    text:
                                                    totalPendingItem[
                                                    "value"],
                                                    fontSize: 13,
                                                    color: AppColors
                                                        .black_txcolor,
                                                    fontWeight:
                                                    FontWeight
                                                        .w500),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // ListView.builder(
                                //   shrinkWrap: true,
                                //     itemCount : totalPendingItem["options"],
                                //     itemBuilder: (context, index) {
                                //   return  totalPendingItem["value"][0] == totalPendingItem["options"][index]["id"] ?  CommonText(
                                //         text: "${totalPendingItem["options"][index]["name"]}",
                                //         fontSize: 13,
                                //         color: AppColors.black_txcolor,
                                //         fontWeight: FontWeight.w500) : Container();
                                // }
                                // ),
                                const Divider(),
                              ],
                            );
                          } else {
                            return Container();
                          }
                        }),
                  ),
                ],
              ),
            ])
                : widget.length == 2
                ? TabBarView(controller: tabController, children: [
              Column(
                children: [
                  Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    color: AppColors.drawer_bottom_text_color,
                    child: Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: const [
                          CommonText(
                              text: "ATTRIBUTE NAME",
                              fontSize: 14,
                              color: AppColors.white,
                              fontWeight: FontWeight.w600),
                          CommonText(
                              text: "DESCRIPTION",
                              fontSize: 14,
                              color: AppColors.white,
                              fontWeight: FontWeight.w600),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: itemList.length,
                        itemBuilder: (context, index) {
                          var totalPendingItem = itemList[index];
                          if (totalPendingItem["displayGroup"] == "Primary Skills") {
                            return Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 5),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          width:
                                          MediaQuery.of(context)
                                              .size
                                              .width,
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: [
                                              CommonText(
                                                  text: totalPendingItem[
                                                  "displayName"],
                                                  fontSize: 13,
                                                  color: AppColors
                                                      .black_txcolor,
                                                  fontWeight:
                                                  FontWeight
                                                      .w500),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          width:
                                          MediaQuery.of(context)
                                              .size
                                              .width,
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .end,
                                            children: [
                                              if (totalPendingItem[
                                              "columnName"] ==
                                                  "positionPlayed")
                                                CommonText(
                                                    text: totalPendingItem[
                                                    "value"]
                                                    [0]
                                                        .toString(),
                                                    fontSize: 13,
                                                    color: AppColors
                                                        .black_txcolor,
                                                    fontWeight:
                                                    FontWeight
                                                        .w500),
                                              if (totalPendingItem[
                                              "columnName"] !=
                                                  "positionPlayed")
                                                CommonText(
                                                    text:
                                                    totalPendingItem[
                                                    "value"],
                                                    fontSize: 13,
                                                    color: AppColors
                                                        .black_txcolor,
                                                    fontWeight:
                                                    FontWeight
                                                        .w500),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(),
                              ],
                            );
                          } else {
                            return Container();
                          }
                        }),
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    color: AppColors.drawer_bottom_text_color,
                    child: Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: const [
                          CommonText(
                              text: "ATTRIBUTE NAME",
                              fontSize: 14,
                              color: AppColors.white,
                              fontWeight: FontWeight.w600),
                          CommonText(
                              text: "DESCRIPTION",
                              fontSize: 14,
                              color: AppColors.white,
                              fontWeight: FontWeight.w600),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: itemList.length,
                        itemBuilder: (context, index) {
                          var totalPendingItem = itemList[index];
                          if (totalPendingItem["displayGroup"] == "Additional Information") {
                            if (totalPendingItem["columnName"] ==
                                "AthleteSchoolYear")
                              print(
                                  "optionsList =====>  ${totalPendingItem["options"]}");
                            return Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                if (totalPendingItem["columnName"] ==
                                    "uploadTranscript")
                                  Container(),
                                if (totalPendingItem["columnName"] !=
                                    "uploadTranscript")
                                  const SizedBox(height: 5),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          width:
                                          MediaQuery.of(context)
                                              .size
                                              .width,
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: [
                                              CommonText(
                                                  text: totalPendingItem[
                                                  "displayName"],
                                                  fontSize: 13,
                                                  color: AppColors
                                                      .black_txcolor,
                                                  fontWeight:
                                                  FontWeight
                                                      .w500),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          width:
                                          MediaQuery.of(context)
                                              .size
                                              .width,
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .end,
                                            children: [
                                              if (totalPendingItem[
                                              "columnName"] ==
                                                  "AthleteSchoolYear")
                                                if (totalPendingItem[
                                                "value"][0] ==
                                                    totalPendingItem[
                                                    "options"]
                                                    [3]["id"])
                                                  CommonText(
                                                      text:
                                                      "${totalPendingItem["options"][3]["name"]}",
                                                      fontSize: 13,
                                                      color: AppColors
                                                          .black_txcolor,
                                                      fontWeight:
                                                      FontWeight
                                                          .w500),
                                              if (totalPendingItem[
                                              "columnName"] ==
                                                  "uploadTranscript")
                                                CommonText(
                                                    text: totalPendingItem[
                                                    "value"]
                                                    [
                                                    'DisplayName'],
                                                    fontSize: 13,
                                                    color: AppColors
                                                        .black_txcolor,
                                                    fontWeight:
                                                    FontWeight
                                                        .w500),
                                              if (totalPendingItem[
                                              "columnName"] !=
                                                  "uploadTranscript" &&
                                                  totalPendingItem[
                                                  "columnName"] !=
                                                      "AthleteSchoolYear")
                                                CommonText(
                                                    text:
                                                    totalPendingItem[
                                                    "value"],
                                                    fontSize: 13,
                                                    color: AppColors
                                                        .black_txcolor,
                                                    fontWeight:
                                                    FontWeight
                                                        .w500),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // ListView.builder(
                                //   shrinkWrap: true,
                                //     itemCount : totalPendingItem["options"],
                                //     itemBuilder: (context, index) {
                                //   return  totalPendingItem["value"][0] == totalPendingItem["options"][index]["id"] ?  CommonText(
                                //         text: "${totalPendingItem["options"][index]["name"]}",
                                //         fontSize: 13,
                                //         color: AppColors.black_txcolor,
                                //         fontWeight: FontWeight.w500) : Container();
                                // }
                                // ),
                                const Divider(),
                              ],
                            );
                          } else {
                            return Container();
                          }
                        }),
                  ),
                ],
              ),
            ])
                : widget.length == 3
                ? TabBarView(controller: tabController, children: [
              Column(
                children: [
                  Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    color: AppColors.drawer_bottom_text_color,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: const [
                          CommonText(
                              text: "ATTRIBUTE NAME",
                              fontSize: 14,
                              color: AppColors.white,
                              fontWeight: FontWeight.w600),
                          CommonText(
                              text: "DESCRIPTION",
                              fontSize: 14,
                              color: AppColors.white,
                              fontWeight: FontWeight.w600),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: itemList.length,
                        itemBuilder: (context, index) {
                          var totalPendingItem = itemList[index];
                          if (totalPendingItem["displayGroup"] ==
                              "Primary Skills") {
                            return Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                if (totalPendingItem[
                                "columnName"] ==
                                    "uploadTranscript")
                                  Container(),
                                if (totalPendingItem[
                                "columnName"] !=
                                    "uploadTranscript")
                                  const SizedBox(height: 5),
                                Padding(
                                  padding:
                                  const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          width: MediaQuery.of(
                                              context)
                                              .size
                                              .width,
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: [
                                              CommonText(
                                                  text: totalPendingItem[
                                                  "displayName"],
                                                  fontSize: 13,
                                                  color: AppColors
                                                      .black_txcolor,
                                                  fontWeight:
                                                  FontWeight
                                                      .w500),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          width: MediaQuery.of(
                                              context)
                                              .size
                                              .width,
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .end,
                                            children: [
                                              if (totalPendingItem[
                                              "columnName"] ==
                                                  "positionPlayed")
                                                CommonText(
                                                    text: totalPendingItem[
                                                    "value"]
                                                    [0]
                                                        .toString(),
                                                    fontSize: 13,
                                                    color: AppColors
                                                        .black_txcolor,
                                                    fontWeight:
                                                    FontWeight
                                                        .w500),
                                              if (totalPendingItem[
                                              "columnName"] !=
                                                  "positionPlayed")
                                                CommonText(
                                                    text: totalPendingItem[
                                                    "value"],
                                                    fontSize: 13,
                                                    color: AppColors
                                                        .black_txcolor,
                                                    fontWeight:
                                                    FontWeight
                                                        .w500),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(),
                              ],
                            );
                          } else {
                            return Container();
                          }
                        }),
                  ),
                ],
              ),
              GalleryByIdScreen(widget.userId),
              Column(
                children: [
                  Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    color: AppColors.drawer_bottom_text_color,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: const [
                          CommonText(
                              text: "ATTRIBUTE NAME",
                              fontSize: 14,
                              color: AppColors.white,
                              fontWeight: FontWeight.w600),
                          CommonText(
                              text: "DESCRIPTION",
                              fontSize: 14,
                              color: AppColors.white,
                              fontWeight: FontWeight.w600),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: itemList.length,
                        itemBuilder: (context, index) {
                          var totalPendingItem = itemList[index];
                          if (totalPendingItem["displayGroup"] == "Additional Information") {
                            if (totalPendingItem["columnName"] ==
                                "AthleteSchoolYear")
                              print(
                                  "optionsList =====>  ${totalPendingItem["options"]}");
                            return Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                if (totalPendingItem[
                                "columnName"] ==
                                    "uploadTranscript")
                                  Container(),
                                if (totalPendingItem[
                                "columnName"] !=
                                    "uploadTranscript")
                                  const SizedBox(height: 5),
                                Padding(
                                  padding:
                                  const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          width: MediaQuery.of(
                                              context)
                                              .size
                                              .width,
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: [
                                              CommonText(
                                                  text: totalPendingItem[
                                                  "displayName"],
                                                  fontSize: 13,
                                                  color: AppColors
                                                      .black_txcolor,
                                                  fontWeight:
                                                  FontWeight
                                                      .w500),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          width: MediaQuery.of(
                                              context)
                                              .size
                                              .width,
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .end,
                                            children: [
                                              if (totalPendingItem[
                                              "columnName"] ==
                                                  "AthleteSchoolYear")
                                                if (totalPendingItem[
                                                "value"]
                                                [0] ==
                                                    totalPendingItem[
                                                    "options"]
                                                    [3]["id"])
                                                  CommonText(
                                                      text:
                                                      "${totalPendingItem["options"][3]["name"]}",
                                                      fontSize:
                                                      13,
                                                      color: AppColors
                                                          .black_txcolor,
                                                      fontWeight:
                                                      FontWeight
                                                          .w500),
                                              if (totalPendingItem[
                                              "columnName"] ==
                                                  "uploadTranscript")
                                                CommonText(
                                                    text: totalPendingItem[
                                                    "value"]
                                                    [
                                                    'DisplayName'],
                                                    fontSize: 13,
                                                    color: AppColors
                                                        .black_txcolor,
                                                    fontWeight:
                                                    FontWeight
                                                        .w500),
                                              if (totalPendingItem[
                                              "columnName"] !=
                                                  "uploadTranscript" &&
                                                  totalPendingItem[
                                                  "columnName"] !=
                                                      "AthleteSchoolYear")
                                                CommonText(
                                                    text: totalPendingItem[
                                                    "value"],
                                                    fontSize: 13,
                                                    color: AppColors
                                                        .black_txcolor,
                                                    fontWeight:
                                                    FontWeight
                                                        .w500),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // ListView.builder(
                                //   shrinkWrap: true,
                                //     itemCount : totalPendingItem["options"],
                                //     itemBuilder: (context, index) {
                                //   return  totalPendingItem["value"][0] == totalPendingItem["options"][index]["id"] ?  CommonText(
                                //         text: "${totalPendingItem["options"][index]["name"]}",
                                //         fontSize: 13,
                                //         color: AppColors.black_txcolor,
                                //         fontWeight: FontWeight.w500) : Container();
                                // }
                                // ),
                                const Divider(),
                              ],
                            );
                          } else {
                            return Container();
                          }
                        }),
                  ),
                ],
              ),
            ])
                : TabBarView(controller: tabController, children: [
              Column(
                children: [
                  Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    color: AppColors.drawer_bottom_text_color,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: const [
                          CommonText(
                              text: "ATTRIBUTE NAME",
                              fontSize: 14,
                              color: AppColors.white,
                              fontWeight: FontWeight.w600),
                          CommonText(
                              text: "DESCRIPTION",
                              fontSize: 14,
                              color: AppColors.white,
                              fontWeight: FontWeight.w600),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: itemList.length,
                        itemBuilder: (context, index) {
                          var totalPendingItem = itemList[index];
                          if (totalPendingItem["displayGroup"] ==
                              "Primary Skills") {
                            return Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                if (totalPendingItem[
                                "columnName"] ==
                                    "uploadTranscript")
                                  Container(),
                                if (totalPendingItem[
                                "columnName"] !=
                                    "uploadTranscript")
                                  const SizedBox(height: 5),
                                Padding(
                                  padding:
                                  const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          width: MediaQuery.of(
                                              context)
                                              .size
                                              .width,
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: [
                                              CommonText(
                                                  text: totalPendingItem[
                                                  "displayName"],
                                                  fontSize: 13,
                                                  color: AppColors
                                                      .black_txcolor,
                                                  fontWeight:
                                                  FontWeight
                                                      .w500),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          width: MediaQuery.of(
                                              context)
                                              .size
                                              .width,
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .end,
                                            children: [
                                              if (totalPendingItem[
                                              "columnName"] ==
                                                  "positionPlayed")
                                                CommonText(
                                                    text: totalPendingItem[
                                                    "value"]
                                                    [0]
                                                        .toString(),
                                                    fontSize: 13,
                                                    color: AppColors
                                                        .black_txcolor,
                                                    fontWeight:
                                                    FontWeight
                                                        .w500),
                                              if (totalPendingItem[
                                              "columnName"] !=
                                                  "positionPlayed")
                                                CommonText(
                                                    text: totalPendingItem[
                                                    "value"],
                                                    fontSize: 13,
                                                    color: AppColors
                                                        .black_txcolor,
                                                    fontWeight:
                                                    FontWeight
                                                        .w500),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(),
                              ],
                            );
                          } else {
                            return Container();
                          }
                        }),
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    color: AppColors.drawer_bottom_text_color,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: const [
                          CommonText(
                              text: "ATTRIBUTE NAME",
                              fontSize: 14,
                              color: AppColors.white,
                              fontWeight: FontWeight.w600),
                          CommonText(
                              text: "DESCRIPTION",
                              fontSize: 14,
                              color: AppColors.white,
                              fontWeight: FontWeight.w600),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: itemList.length,
                        itemBuilder: (context, index) {
                          var totalPendingItem = itemList[index];
                          if (totalPendingItem["displayGroup"] ==
                              "Additional Information") {
                            if (totalPendingItem["columnName"] ==
                                "AthleteSchoolYear")
                              print(
                                  "optionsList =====>  ${totalPendingItem["options"]}");
                            return Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                if (totalPendingItem[
                                "columnName"] ==
                                    "uploadTranscript")
                                  Container(),
                                if (totalPendingItem[
                                "columnName"] !=
                                    "uploadTranscript")
                                  const SizedBox(height: 5),
                                Padding(
                                  padding:
                                  const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          width: MediaQuery.of(
                                              context)
                                              .size
                                              .width,
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: [
                                              CommonText(
                                                  text: totalPendingItem[
                                                  "displayName"],
                                                  fontSize: 13,
                                                  color: AppColors
                                                      .black_txcolor,
                                                  fontWeight:
                                                  FontWeight
                                                      .w500),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          width: MediaQuery.of(
                                              context)
                                              .size
                                              .width,
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .end,
                                            children: [
                                              if (totalPendingItem[
                                              "columnName"] ==
                                                  "AthleteSchoolYear")
                                                if (totalPendingItem[
                                                "value"]
                                                [0] ==
                                                    totalPendingItem[
                                                    "options"]
                                                    [3]["id"])
                                                  CommonText(
                                                      text:
                                                      "${totalPendingItem["options"][3]["name"]}",
                                                      fontSize:
                                                      13,
                                                      color: AppColors
                                                          .black_txcolor,
                                                      fontWeight:
                                                      FontWeight
                                                          .w500),
                                              if (totalPendingItem[
                                              "columnName"] ==
                                                  "uploadTranscript")
                                                CommonText(
                                                    text: totalPendingItem[
                                                    "value"]
                                                    [
                                                    'DisplayName'],
                                                    fontSize: 13,
                                                    color: AppColors
                                                        .black_txcolor,
                                                    fontWeight:
                                                    FontWeight
                                                        .w500),
                                              if (totalPendingItem[
                                              "columnName"] !=
                                                  "uploadTranscript" &&
                                                  totalPendingItem[
                                                  "columnName"] !=
                                                      "AthleteSchoolYear")
                                                CommonText(
                                                    text: totalPendingItem[
                                                    "value"],
                                                    fontSize: 13,
                                                    color: AppColors
                                                        .black_txcolor,
                                                    fontWeight:
                                                    FontWeight
                                                        .w500),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // ListView.builder(
                                //   shrinkWrap: true,
                                //     itemCount : totalPendingItem["options"],
                                //     itemBuilder: (context, index) {
                                //   return  totalPendingItem["value"][0] == totalPendingItem["options"][index]["id"] ?  CommonText(
                                //         text: "${totalPendingItem["options"][index]["name"]}",
                                //         fontSize: 13,
                                //         color: AppColors.black_txcolor,
                                //         fontWeight: FontWeight.w500) : Container();
                                // }
                                // ),
                                const Divider(),
                              ],
                            );
                          } else {
                            return Container();
                          }
                        }),
                  ),
                ],
              ),
              VideosByIdScreen(widget.userId),
              GalleryByIdScreen(widget.userId),
            ]),
          ),
        ],
      ),
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
          labelColor: AppColors.blue_text_Color,
          // padding: const EdgeInsets.symmetric(horizontal: 11),
          splashBorderRadius: BorderRadius.circular(15),
          isScrollable: true,
          controller: tabController,
          tabs: List.generate(widget.uniquelist.length, (index) {
            return Text(widget.uniquelist[index]);
          }),
          // widget.length == 1
          //     ?  [Tab(text: "Primary Skills")]
          //     : widget.length == 2
          //     ? [
          //   Tab(text: "Primary Skills"),
          //   Tab(text: "Additional Information")
          // ]
          //     : widget.length == 3
          //     ? [
          //   Tab(text: "Primary Skills"),
          //   Tab(text: "Images"),
          //   Tab(text: "Additional Information")
          // ]
          //     : [
          //   Tab(text: "Primary Skills"),
          //   Tab(text: "Additional Information"),
          //   Tab(text: "Videos"),
          //   Tab(text: "Images"),
          // ]

        // List.generate(widget.length , (index) {
        //   print("length ====>/. ${uniquelist[index]}");
        //
        //   return Text(uniquelist[index]["displayGroup"]);
        // }),
      ),
    );
  }

  manageAditionalInformationList(String userId) async {
    log('this is Manage_Profile  api call', name: "Manage_Profile");
    setState(() {
      isLoading == true;
    });
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
              itemList = response.data["attribute"];
              uniquelist = response.data["attribute"]
                  .where((value) => models.add(value["displayGroup"]))
                  .toList();
              // uniquelist = response.data["attribute"].where((value) => models.add(value.toString())).toList();
              print("+++++this is item ${response.data["attribute"]}");
              print("+++++ ${uniquelist}");
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
}*/
