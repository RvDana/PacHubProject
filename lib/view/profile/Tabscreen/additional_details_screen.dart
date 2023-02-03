
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:pachub/Utils/appcolors.dart';
import 'package:pachub/Utils/appstring.dart';
import 'package:pachub/Utils/constant.dart';
import 'package:pachub/app_function/MyAppFunction.dart';
import 'package:pachub/common_widget/customloader.dart';
import 'package:pachub/common_widget/nodatafound_page.dart';
import 'package:pachub/common_widget/textstyle.dart';
import 'package:pachub/config/preference.dart';
import 'package:pachub/view/login/login_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';


///Athlete

class AthleteAdditionalDetailsScreen extends StatefulWidget {
  const AthleteAdditionalDetailsScreen({Key? key}) : super(key: key);

  @override
  State<AthleteAdditionalDetailsScreen> createState() =>
      _AthleteAdditionalDetailsScreenState();
}

class _AthleteAdditionalDetailsScreenState extends State<AthleteAdditionalDetailsScreen> {
  List athleteItemList = [];
  bool _isFirstLoadRunning = false;
  bool status = false;
  late bool _permissionReady;
  late TargetPlatform? platform;
  late String _localPath;
  List pdfList = [];
  List currentschoolyearList = [];






  @override
  void initState() {
    manageAditionalInformationList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      edgeOffset: 20,
      onRefresh: () async{
        await Future.delayed(Duration(milliseconds: 1500));
        setState(() {
          manageAditionalInformationList();
        });
      },
      child: Scaffold(
        body: _isFirstLoadRunning
            ? athleteItemList.isEmpty
            ? Align(
          alignment: Alignment.center,
          child: CustomLoader(),
        ) : const Align(
          alignment: Alignment.center,
          child: NoDataFound(),
        ) :
        ListView.builder(
          padding: const EdgeInsets.only(top: 10),
          shrinkWrap: true,
          itemCount: athleteItemList.length,
          itemBuilder: (context, index) {
            athleteItemList[index]['options']!=null?
            currentschoolyearList = athleteItemList[index]['options']:Container();
            if (athleteItemList[index]["displayGroup"] == "Additional Information") {
              return  Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if(athleteItemList[index]["columnName"] == "AthleteSchoolYear")
                      athleteItemList[index]["value"] != null ?
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonText(text: athleteItemList[index]["displayName"], fontSize: 13, color: AppColors.black_txcolor, fontWeight: FontWeight.w500),
                          SizedBox(height: 5),
                          Container(
                            height: 40,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.contacts_text_color,
                              border: Border.all(
                                  color: AppColors.grey_hint_color, width: 1),
                            ),
                            child:  Padding(
                                padding:  EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                child: ListView.builder(
                                    itemCount: currentschoolyearList.length,
                                    itemBuilder: (context, i) {
                                      return Container(
                                        child: athleteItemList[index]["value"][0].toString() == currentschoolyearList[i]["id"].toString()?
                                        CommonText(text: "${currentschoolyearList[i]["name"] ?? ""}", fontSize: 15, color: AppColors.grey_text_color, fontWeight: FontWeight.w400):Container(),
                                      );
                                    })


                            ),
                          )
                        ],
                      ) :
                      _buildColumn(athleteItemList[index]["displayName"], ""),
                    if(athleteItemList[index]["columnName"] == "NCAAID")
                      _buildColumn(athleteItemList[index]["displayName"], athleteItemList[index]["value"] ?? ""),
                    if(athleteItemList[index]["columnName"] == "socialMediaFB")
                      _buildColumn(athleteItemList[index]["displayName"], athleteItemList[index]["value"] ?? ""),
                    if(athleteItemList[index]["columnName"] == "socialMediaIG")
                      _buildColumn(athleteItemList[index]["displayName"], athleteItemList[index]["value"] ?? ""),
                    if(athleteItemList[index]["columnName"] == "socialMediaTwitter")
                      _buildColumn(athleteItemList[index]["displayName"], athleteItemList[index]["value"] ?? ""),
                    if(athleteItemList[index]["columnName"] == "Commitment")
                      _buildColumn(athleteItemList[index]["displayName"], athleteItemList[index]["value"] ?? ""),
                    if(athleteItemList[index]["columnName"] == "playerInterest")
                      _buildColumn(athleteItemList[index]["displayName"], athleteItemList[index]["value"] ?? ""),
                    if(athleteItemList[index]["columnName"] == "bestSingleGameState")
                      _buildColumn(athleteItemList[index]["displayName"], athleteItemList[index]["value"] ?? ""),
                    if(athleteItemList[index]["columnName"] == "initialMeeting")
                       _buildRow_Switch_Gray(athleteItemList[index]["displayName"],athleteItemList[index]["value"]),
                    if(athleteItemList[index]["columnName"] == "skillEvalutionDirection")
                      _buildRow_Switch_Gray(athleteItemList[index]["displayName"],athleteItemList[index]["value"]),
                    if(athleteItemList[index]["columnName"] == "enhanceAthelete")
                      _buildRow_Switch_Gray(athleteItemList[index]["displayName"],athleteItemList[index]["value"]),
                    if(athleteItemList[index]["columnName"] == "directConnect")
                      _buildRow_Switch_Gray(athleteItemList[index]["displayName"],athleteItemList[index]["value"]),
                    if(athleteItemList[index]["columnName"] == "eligibility")
                      _buildRow_Switch_Gray(athleteItemList[index]["displayName"],athleteItemList[index]["value"]),
                    if(athleteItemList[index]["columnName"] == "weeklyCalls")
                      _buildRow_Switch_Gray(athleteItemList[index]["displayName"],athleteItemList[index]["value"]),
                    if(athleteItemList[index]["columnName"] == "personalListing")
                      _buildRow_Switch_Gray(athleteItemList[index]["displayName"],athleteItemList[index]["value"]),
                    if(athleteItemList[index]["columnName"] == "profileView")
                      _buildRow_Switch_Gray(athleteItemList[index]["displayName"],athleteItemList[index]["value"]),
                    if(athleteItemList[index]["columnName"] == "personalCoach")
                      _buildRow_Switch_Gray(athleteItemList[index]["displayName"],athleteItemList[index]["value"]),
                    if(athleteItemList[index]["columnName"] == "RedShirtEligibility")
                      _buildRow_Switch_Gray(athleteItemList[index]["displayName"],athleteItemList[index]["value"]),
                    if(athleteItemList[index]["columnName"] == "pgResult")
                      _buildColumn(athleteItemList[index]["displayName"], athleteItemList[index]["value"] ?? ""),
                    if(athleteItemList[index]["columnName"] == "awards")
                      _buildColumn(athleteItemList[index]["displayName"], athleteItemList[index]["value"] ?? ""),
                    if(athleteItemList[index]["columnName"] == "educationGpa")
                      _buildColumn(athleteItemList[index]["displayName"], athleteItemList[index]["value"] ?? ""),
                    if(athleteItemList[index]["columnName"] == "uploadTranscript")
                      Container(),
                    if(athleteItemList[index]["columnName"] == "currentSchool")
                      _buildColumn(athleteItemList[index]["displayName"], athleteItemList[index]["value"] ?? ""),
                    if(athleteItemList[index]["columnName"] == "graduatingYear")
                      _buildColumn(athleteItemList[index]["displayName"], athleteItemList[index]["value"] ?? ""),
                    if(athleteItemList[index]["columnName"] == "socialMedia")
                      _buildColumn(athleteItemList[index]["displayName"], athleteItemList[index]["value"] ?? ""),
                    // _buildColumn(itemList[index]["displayName"], itemList[index]["value"] ?? ""),


                    // Row(children: [
                    //   if(itemList[index]["columnName"] == "Commitment")
                    //     _buildColumn(itemList[index]["displayName"], itemList[index]["value"] ?? ""),
                    //   if(itemList[index]["columnName"] == "playerInterest")
                    //     _buildColumn(itemList[index]["displayName"], itemList[index]["value"] ?? ""),
                    // ]),
                  ],
                ),
              );
            }  else {
              return  Container();
            }
          },
        ),
      ),
    );
  }

  manageAditionalInformationList() async {
    log('this is Manage_Profile  api call', name: "Manage_Profile");
    MyApplication.getInstance()!
        .checkConnectivity(context)
        .then((internet) async {
      if (internet != null && internet) {
        try {
          Dio dio = Dio();
          var response = await dio.get(AppConstant.mamage_profile,
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

  _buildColumn(title, subTxt) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(text: title, fontSize: 13, color: AppColors.black_txcolor, fontWeight: FontWeight.w500),
        SizedBox(height: 5),
        Container(
          height: 40,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.contacts_text_color,
            border: Border.all(
                color: AppColors.grey_hint_color, width: 1),
          ),
          child:  Padding(
            padding:  EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            child: CommonText(
                text: subTxt,
                fontSize: 15,
                color: AppColors.blacksubtext_color,
                fontWeight: FontWeight.w400),
          ),
        )
      ],
    );
  }

  _buildRow_Switch_Gray(title, value) {
    print("=========><><<> $value");
    return  Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(value != null)
          value == "0" ?  FlutterSwitch(
            width: 50.0,
            height: 25.0,
            toggleSize: 20.0,
            value: false,
            borderRadius: 30.0,
            onToggle: (val) {
              // setState(() {
              //   status = val;
              // });
            },
          ) : FlutterSwitch(
            width: 50.0,
            height: 25.0,
            toggleSize: 20.0,
            value: true,
            borderRadius: 30.0,
            onToggle: (val) {
              // setState(() {
              //   status = val;
              // });
            },
          ),
        if(value==null)
          FlutterSwitch(
            width: 50.0,
            height: 25.0,
            toggleSize: 20.0,
            value: false,
            borderRadius: 30.0,
            onToggle: (val) {
              // setState(() {
              //   status = val;
              // });
            },
          ),
        SizedBox(width: 15),
        Expanded(
          child: CommonText(
              text: title,
              fontSize: 15,
              color: AppColors.black_txcolor,
              fontWeight: FontWeight.w500),
        ),
      ],
    );
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
      return '${directory.path}${Platform.pathSeparator}Download';
    }
  }
}


class FreeAthleteAdditionalDetailsScreen extends StatefulWidget {
  const FreeAthleteAdditionalDetailsScreen({Key? key}) : super(key: key);

  @override
  State<FreeAthleteAdditionalDetailsScreen> createState() => _FreeAthleteAdditionalDetailsScreenState();
}

class _FreeAthleteAdditionalDetailsScreenState extends State<FreeAthleteAdditionalDetailsScreen> {
  List athleteItemList = [];
  bool _isFirstLoadRunning = false;
  bool status = false;
  late bool _permissionReady;
  late TargetPlatform? platform;
  late String _localPath;
  List pdfList = [];
  int? index;




  @override
  void initState() {
    manageAditionalInformationList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      edgeOffset: 20,
      onRefresh: () async{
        await Future.delayed(Duration(milliseconds: 1500));
        setState(() {
          manageAditionalInformationList();
        });
      },
      child: Scaffold(
        body: _isFirstLoadRunning
            ? athleteItemList.isEmpty
            ? Align(
          alignment: Alignment.center,
          child: CustomLoader(),
        ) : const Align(
          alignment: Alignment.center,
          child: NoDataFound(),
        ) :
        ListView.builder(
          padding: const EdgeInsets.only(top: 10),
          shrinkWrap: true,
          itemCount: athleteItemList.length,
          itemBuilder: (context, index) {
            if (athleteItemList[index]["displayGroup"] == "Additional Information") {
              return  Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if(athleteItemList[index]["columnName"] == "eligibility")
                      _buildRow_Switch_Gray(athleteItemList[index]["displayName"],athleteItemList[index]["value"]),
                    if(athleteItemList[index]["columnName"] == "RedShirtEligibility")
                      _buildRow_Switch_Gray(athleteItemList[index]["displayName"],athleteItemList[index]["value"]),
                    if(athleteItemList[index]["columnName"] == "NCAAID")
                      _buildColumn(athleteItemList[index]["displayName"], athleteItemList[index]["value"] ?? ""),
                    if(athleteItemList[index]["columnName"] == "playerInterest")
                    _buildColumn(athleteItemList[index]["displayName"], athleteItemList[index]["value"] ?? ""),
                    if(athleteItemList[index]["columnName"] == "bestSingleGameState")
                    _buildColumn(athleteItemList[index]["displayName"], athleteItemList[index]["value"] ?? ""),
                    if(athleteItemList[index]["columnName"] == "educationGpa")
                    _buildColumn(athleteItemList[index]["displayName"], athleteItemList[index]["value"] ?? ""),
                    if(athleteItemList[index]["columnName"] == "graduatingYear")
                    _buildColumn(athleteItemList[index]["displayName"], athleteItemList[index]["value"] ?? ""),

                    // Row(children: [
                    //   if(itemList[index]["columnName"] == "Commitment")
                    //     _buildColumn(itemList[index]["displayName"], itemList[index]["value"] ?? ""),
                    //   if(itemList[index]["columnName"] == "playerInterest")
                    //     _buildColumn(itemList[index]["displayName"], itemList[index]["value"] ?? ""),
                    // ]),
                  ],
                ),
              );
            }  else {
              return  Container();
            }
          },
        ),
      ),
    );
  }
   switchrow(index){
    return Container(
      child: Column(
        children: [
          if(athleteItemList[index]["columnName"] == "eligibility"&& athleteItemList[index]["fieldType"] == "CheckBox"&& athleteItemList[index]["dataType"] == "boolean")
            _buildRow_Switch_Gray(athleteItemList[index]["displayName"],AppColors.dark_blue_button_color)
          else
            _buildRow_Switch_Gray(athleteItemList[index]["displayName"],AppColors.grey_text_color),
          if(athleteItemList[index]["columnName"] == "RedShirtEligibility")
            _buildRow_Switch_Gray(athleteItemList[index]["displayName"],AppColors.dark_blue_button_color),
        ],

      ),
    );
   }
  manageAditionalInformationList() async {
    log('this is Manage_Profile  api call', name: "Manage_Profile");
    MyApplication.getInstance()!
        .checkConnectivity(context)
        .then((internet) async {
      if (internet != null && internet) {
        try {
          Dio dio = Dio();
          var response = await dio.get(AppConstant.mamage_profile,
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

  _buildColumn(title, subTxt) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(text: title, fontSize: 13, color: AppColors.black_txcolor, fontWeight: FontWeight.w500),
        SizedBox(height: 5),
        Container(
          height: 40,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.contacts_text_color,
            border: Border.all(
                color: AppColors.grey_hint_color, width: 1),
          ),
          child:  Padding(
            padding:  EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            child: CommonText(
                text: subTxt,
                fontSize: 15,
                color: AppColors.blacksubtext_color,
                fontWeight: FontWeight.w400),
          ),
        )
      ],
    );
  }

  _buildRow_Switch_Gray(title, value) {
    print("=========><><<> $value");
    return  Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(value != null)
          value == "0" ?  FlutterSwitch(
            width: 50.0,
            height: 25.0,
            toggleSize: 20.0,
            value: false,
            borderRadius: 30.0,
            onToggle: (val) {
              // setState(() {
              //   status = val;
              // });
            },
          ) : FlutterSwitch(
            width: 50.0,
            height: 25.0,
            toggleSize: 20.0,
            value: true,
            borderRadius: 30.0,
            onToggle: (val) {
              // setState(() {
              //   status = val;
              // });
            },
          ),
        if(value==null)
          FlutterSwitch(
            width: 50.0,
            height: 25.0,
            toggleSize: 20.0,
            value: false,
            borderRadius: 30.0,
            onToggle: (val) {
              // setState(() {
              //   status = val;
              // });
            },
          ),
        SizedBox(width: 15),
        Expanded(
          child: CommonText(
              text: title,
              fontSize: 15,
              color: AppColors.black_txcolor,
              fontWeight: FontWeight.w500),
        ),
      ],
    );
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
      return '${directory.path}${Platform.pathSeparator}Download';
    }
  }
}

///Coach

class CoachAdditionalDetailsScreen extends StatefulWidget {
  const CoachAdditionalDetailsScreen({Key? key}) : super(key: key);

  @override
  State<CoachAdditionalDetailsScreen> createState() =>
      _CoachAdditionalDetailsScreenState();
}

class _CoachAdditionalDetailsScreenState extends State<CoachAdditionalDetailsScreen> {
  List coachItemList = [];
  bool _isFirstLoadRunning = false;
  List option = [];
  List optionList = [];
  List pitcherList = [];
  List catcherList = [];
  List outfieldList = [];
  List infieldList = [];
  List universalList = [];
  ////TODO Football List////
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
    super.initState();
    ManageAditionalInformationList();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      edgeOffset: 20,
      onRefresh: () async{
        await Future.delayed(Duration(milliseconds: 1500));
        setState(() {
          ManageAditionalInformationList();
        });
      },
      child: Scaffold(
        body: _isFirstLoadRunning
            ? coachItemList.isEmpty
            ? Align(
          alignment: Alignment.center,
          child: CustomLoader(),
        ): const Align(
          alignment: Alignment.center,
          child: NoDataFound(),
        ) :
        ListView.builder(
          padding: const EdgeInsets.only(top: 20),
          shrinkWrap: true,
          itemCount: coachItemList.length,
          itemBuilder: (context, index) {
            var item = coachItemList[index] ?? [];
            if (item["displayGroup"] == "Desired Positions") {
              option = item["options"];
              print("list ======<><> $option");
              var all = item["child_fields"];
              print("Data View  =========<> $all");
              var data = json.decode(all);
              log('Keys: $data');
              pitcherList = data["P"] ?? [];
              catcherList = data["C"] ?? [];
              outfieldList = data["OF"] ?? [];
              infieldList = data["IF"] ?? [];
              universalList = data["U"] ?? [];
              ////TODO Football DataList////
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
              var newBASEBALLList =  catcherList +infieldList+outfieldList+pitcherList + universalList;
              var newFOOTBALLList = qbList + rbList + hbList + fbList + wrList + teList + dList + dlList + lbList + mlbList + olbList + dbList + cbList + sList + nbList + kList + pList;
              print("Data  :  $newBASEBALLList");
              return  Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                        text: item["displayName"],
                        fontSize: 13,
                        color: AppColors.black_txcolor,
                        fontWeight: FontWeight.w500),
                    SizedBox(height: 5),
                    Container(
                      height: 40,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.contacts_text_color,
                        border: Border.all(
                            color: AppColors.grey_hint_color, width: 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CommonText(
                                text: option[0]["name"],
                                fontSize: 15,
                                color: AppColors.blacksubtext_color,
                                fontWeight: FontWeight.w400),
                            const Icon(
                              Icons.keyboard_arrow_down,
                              color: AppColors.blacksubtext_color,
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    if(PreferenceUtils.getString("sport")  == "BASEBALL")
                    GridView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: BouncingScrollPhysics(),
                        itemCount: newBASEBALLList.length,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: 2.2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 1,
                        ),
                        itemBuilder: (context, index) {
                      return  _buildRow(newBASEBALLList[index]["displayName"], newBASEBALLList[index]["value"] ?? "");
                    }),
                    if(PreferenceUtils.getString("sport")  == "FOOTBALL")
                      GridView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          physics: BouncingScrollPhysics(),
                          itemCount: newFOOTBALLList.length,
                          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 2.2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 1,
                          ),
                          itemBuilder: (context, index) {
                            return  _buildRow(newFOOTBALLList[index]["displayName"], newFOOTBALLList[index]["value"] ?? "");
                          }),
                  ],
                ),
              );
            } else {
              return  Container();
            }
          },
        ),
      ),
    );
  }
  _buildRow(title, subTxt) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(text: title, fontSize: 13, color: AppColors.black_txcolor, fontWeight: FontWeight.w500),
        SizedBox(height: 5),
        Container(
          height: 40,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.contacts_text_color,
            border: Border.all(
                color: AppColors.grey_hint_color, width: 1),
          ),
          child:  Padding(
            padding:  EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            child: CommonText(
                text: subTxt,
                fontSize: 15,
                color: AppColors.blacksubtext_color,
                fontWeight: FontWeight.w400),
          ),
        )
      ],
    );
  }

  ManageAditionalInformationList() async {
    log('this is Manage_Profile  api call', name: "Manage_Profile");
    MyApplication.getInstance()!
        .checkConnectivity(context)
        .then((internet) async {
      if (internet != null && internet) {
        try {
          Dio dio = Dio();
          var response = await dio.get(AppConstant.mamage_profile,
              options: Options(followRedirects: false, headers: {
                "Authorization":
                "Bearer ${PreferenceUtils.getString("accesstoken")}"
              }));
          print("-----this is url $response");
          if (response.statusCode == 200) {
            print("+++++this is manageprofile ${response.data}");
            setState(() {
              coachItemList = response.data["attribute"];
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
        MyApplication.getInstance()!.showInSnackBar(AppString.no_connection, context);
      }
    });
  }

}

/// Advisor

class AdvisorAdditionalDetailsScreen extends StatefulWidget {
  const AdvisorAdditionalDetailsScreen({Key? key}) : super(key: key);

  @override
  State<AdvisorAdditionalDetailsScreen> createState() =>
      _AdvisorAdditionalDetailsScreenState();
}

class _AdvisorAdditionalDetailsScreenState extends State<AdvisorAdditionalDetailsScreen> {
  List advisorItemList = [];
  bool _isFirstLoadRunning = false;
  bool status = false;

  @override
  void initState() {
    manageAditionalInformationList();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      edgeOffset: 20,
      onRefresh: () async{
        await Future.delayed(Duration(milliseconds: 1500));
        setState(() {
          manageAditionalInformationList();
        });
      },
      child: Scaffold(
        body: _isFirstLoadRunning
            ? advisorItemList.isEmpty
            ? Align(
          alignment: Alignment.center,
          child: CustomLoader(),
        ) : const Align(
          alignment: Alignment.center,
          child: NoDataFound(),
        ) : ListView.builder(
          padding: const EdgeInsets.only(top: 20),
          shrinkWrap: true,
          itemCount: advisorItemList.length,
          itemBuilder: (context, index) {
            var item = advisorItemList[index];
            print ("response ==== <> $item");
            if (item["displayGroup"] == "Milestones") {
              print ("response ==== <> ${advisorItemList[index]["displayGroup"]}");
              return  Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildRow_Switch_Gray_milestone(advisorItemList[index]["displayName"],advisorItemList[index]["value"]),
                    SizedBox(height: 20),
                  ],
                ),
              );
            } else {
              return  Container();
            }
          },
        ),
      ),
    );
  }

  manageAditionalInformationList() async {
    log('this is Manage_Profile  api call', name: "Manage_Profile");
    MyApplication.getInstance()!
        .checkConnectivity(context)
        .then((internet) async {
      if (internet != null && internet) {
        try {
          Dio dio = Dio();
          var response = await dio.get(AppConstant.mamage_profile,
              options: Options(followRedirects: false, headers: {
                "Authorization":
                "Bearer ${PreferenceUtils.getString("accesstoken")}"
              }));
          print("-----this is url $response");
          if (response.statusCode == 200) {
            print("+++++this is manageprofile ${response.data}");
            setState(() {
              advisorItemList = response.data["attribute"];
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
        MyApplication.getInstance()!.showInSnackBar(AppString.no_connection, context);
      }
    });
  }

  _buildRow_Switch_Gray_milestone(title, value) {
    print("mile stone=========><><<> $value");
    return  Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(value != null)
        value == "0" ?  FlutterSwitch(
          width: 50.0,
          height: 25.0,
          toggleSize: 20.0,
          value: false,
          borderRadius: 30.0,
          onToggle: (val) {
            // setState(() {
            //   status = val;
            // });
          },
        ) : FlutterSwitch(
          width: 50.0,
          height: 25.0,
          toggleSize: 20.0,
          value: true,
          borderRadius: 30.0,
          onToggle: (val) {
            // setState(() {
            //   status = val;
            // });
          },
        ),
        if(value==null)
          FlutterSwitch(
            width: 50.0,
            height: 25.0,
            toggleSize: 20.0,
            value: false,
            borderRadius: 30.0,
            onToggle: (val) {
              // setState(() {
              //   status = val;
              // });
            },
          ),
        SizedBox(width: 15),
        Expanded(
          child: CommonText(
              text: title,
              fontSize: 15,
              color: AppColors.black_txcolor,
              fontWeight: FontWeight.w500),
        ),
      ],
    );
  }


}