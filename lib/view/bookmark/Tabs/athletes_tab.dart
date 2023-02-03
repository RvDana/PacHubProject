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
import 'package:pachub/common_widget/button.dart';
import 'package:pachub/common_widget/customloader.dart';
import 'package:pachub/common_widget/nodatafound_page.dart';
import 'package:pachub/common_widget/textstyle.dart';
import 'package:pachub/config/preference.dart';
import 'package:pachub/models/stats_model.dart';
import 'package:pachub/services/request.dart';
import 'package:pachub/view/dashboard/tab_deatil_screen.dart';
import 'package:pachub/view/login/login_view.dart';

class AthletesTab extends StatefulWidget {
  const AthletesTab({Key? key}) : super(key: key);

  @override
  State<AthletesTab> createState() => _AthletesTabState();
}

class _AthletesTabState extends State<AthletesTab> {
  bool isBookMark = false;
  bool checkedValue = false;
  String? accessToken;
  int _page = 0;
  final int _limit = 30;
  String? roleName;
  List athleteItemList = [];
  List athleteList = [];
  bool _isLoadRunning = false;


  var models = <String>{};
  List uniquelist = [];
  var group3;


  @override
  void initState() {
    setState(() {
      accessToken = PreferenceUtils.getString("accesstoken");
      roleName = PreferenceUtils.getString("role");
    });
    super.initState();
    athletesBookMarkList(_page, _limit);
  }

  @override
  Widget build(BuildContext context) {
    print("list data ===>>> $athleteList");
    return RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      edgeOffset: 20,
      onRefresh: () async{
        await Future.delayed(Duration(milliseconds: 1500));
        setState(() {
          athleteList.clear();
          athletesBookMarkList(_page, _limit);
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: _isLoadRunning ?
        Align(
          alignment: Alignment.center,
          child: CustomLoader(),
        ) :
        athleteList.isNotEmpty ?
        ListView.builder(
          shrinkWrap: true,
          itemCount: athleteList.length,
          itemBuilder: (context, index) {
            var item = athleteList[index];
            return Card(
              margin: EdgeInsets.only(top: 8, bottom: 8),
              shape: RoundedRectangleBorder(
                  side: BorderSide(width: 0.1),
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 17, vertical: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(1000.0),
                      child: item["image"]!=null?SizedBox(
                          height: 40,
                          width: 40,
                          child: Image.asset(avatarImage)):CachedNetworkImage(
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                        imageUrl: "${item["image"]}",
                        placeholder: (context, url) =>
                            CustomLoader(),
                        errorWidget: (context, url, error) =>
                            SizedBox(
                                height: 40,
                                width: 40,
                                child: Image.asset(avatarImage)),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding:
                        const EdgeInsets.only(left: 8, top: 2),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            // item["plan"] == "Free"
                            //     ? CommonText(
                            //     text:
                            //     "${item["firstName"]?.replaceRange(1, item["firstName"]?.length, "xxxxxx")} ${item["lastName"]?.replaceRange(1, item["lastName"]?.length, "xxxxxx")}",
                            //     fontSize: 16,
                            //     color: AppColors.black_txcolor,
                            //     fontWeight: FontWeight.w700)
                            //     : CommonText(
                            //     text: "${item["displayName"]}",
                            //     fontSize: 16,
                            //     color: AppColors.black_txcolor,
                            //     fontWeight: FontWeight.w700),
                            CommonText(
                                text: "${item["displayName"]}",
                                fontSize: 16,
                                color: AppColors.black_txcolor,
                                fontWeight: FontWeight.w700),
                            SizedBox(height: 4),
                            item["bio"] != null
                                ? CommonText(
                                text: "${item["bio"]}",
                                fontSize: 10,
                                color:
                                AppColors.grey_hint_color,
                                fontWeight: FontWeight.w400)
                                : CommonText(
                                text: "",
                                fontSize: 10,
                                color:
                                AppColors.grey_hint_color,
                                fontWeight: FontWeight.w400),
                            SizedBox(height: 9),
                            // item["plan"] == "Free"
                            //     ? _buildRow(
                            //   location_icon,
                            //   "xxxxxxxxxxx,${item["city"]},${item["state"]},xxxxxxxxx",
                            //   AppColors.black_txcolor,
                            // )
                            //     : _buildRow(
                            //   location_icon,
                            //   "${item["address"]},${item["city"]},${item["state"]},${item["zipcode"]}",
                            //   AppColors.black_txcolor,
                            // ),
                            _buildRow(
                              location_icon,
                              "${item["address"]},${item["city"]},${item["state"]},${item["zipcode"]}",
                              AppColors.black_txcolor,
                            ),
                            SizedBox(height: 7),
                            // item["plan"] == "Free" ?_buildRow(
                            //   call_icon,
                            //   "${item["contact"]?.replaceRange(5, 14, "xxxxxxxx")}",
                            //   AppColors.black_txcolor,
                            // ):
                            // _buildRow(
                            //   call_icon,
                            //   "${item["contact"]}",
                            //   AppColors.black_txcolor,
                            // ),
                            _buildRow(
                              call_icon,
                              "${item["contact"]}",
                              AppColors.black_txcolor,
                            ),
                            SizedBox(height: 10),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  item["hittingPosition"] == null ? Container() : _buildRowPositions("Hitting : ", item["hittingPosition"].toString() ?? ""),
                                  const SizedBox(width: 10),
                                  item["throwingPosition"] == null ? Container() : _buildRowPositions("Throwing :", item["throwingPosition"].toString() ?? ""),
                                  const SizedBox(width: 10),
                                  item["graduatingYear"] == null ? Container() : _buildRowPositions("Graduating Year : ", item["graduatingYear"].toString() ?? ""),
                                  const SizedBox(width: 10),
                                  item["educationGpa"] == null ? Container() : _buildRowPositions("GPA :", item["educationGpa"].toString() ?? ""),
                                ],
                              ),
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

                        SizedBox(width: 10),
                        item["plan"] == "Free"
                            ? SizedBox(
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
                                            briefcaseIcon,
                                            color: AppColors
                                                .black_txcolor),
                                        const SizedBox(
                                            width: 10),
                                        const CommonText(
                                            text:
                                            "Athlete Detail",
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
                                  print(
                                      "Settings menu is selected.");
                                  await manageAditionalInformationList(
                                      item["userID"].toString());
                                  _UserDeatil(
                                    item["userID"].toString(),
                                    item["image"].toString(),
                                    item["displayName"].toString(),
                                    item["userEmail"].toString(),
                                    item["contact"].toString(),
                                    item["plan"].toString(),
                                    item["firstName"].toString(),
                                    item["lastName"].toString(),
                                    item["address"].toString(),
                                    item["city"].toString(),
                                    item["state"].toString(),
                                    item["zipcode"].toString(),
                                  );
                                }
                              }),
                        )
                            : SizedBox(
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
                                            color: AppColors
                                                .black_txcolor),
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
                                            barchartIcon,
                                            color: AppColors
                                                .black_txcolor),
                                        const SizedBox(
                                            width: 10),
                                        const CommonText(
                                            text: "Stats",
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
                                            briefcaseIcon,
                                            color: AppColors
                                                .black_txcolor),
                                        const SizedBox(
                                            width: 10),
                                        const CommonText(
                                            text:
                                            "Athlete Detail",
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
                                  Athletes_stats_dialog(item["playerID"].toString());
                                } else if (value == 2) {
                                  print("Settings menu is selected.");
                                  await manageAditionalInformationList(
                                      item["userID"].toString());
                                  _UserDeatil(
                                    item["userID"].toString(),
                                    item["image"].toString(),
                                    item["displayName"].toString(),
                                    item["userEmail"].toString(),
                                    item["contact"].toString(),
                                    item["plan"].toString(),
                                    item["firstName"].toString(),
                                    item["lastName"].toString(),
                                    item["address"].toString(),
                                    item["city"].toString(),
                                    item["state"].toString(),
                                    item["zipcode"].toString(),
                                  );
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
        ) :  Align(
            alignment: Alignment.center,
            child: NoDataFound()
        ),
      ),
    );
  }

  Future<bool> Athletes_stats_dialog(String playerId) async {
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
            child: FutureBuilder(
              future: StatsApi(playerId),
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
                      PlayerStats? playerStats = snapshot.data?.playerStats;
                      List<Pitchingstats>? pitchingstatslist =
                          snapshot.data?.playerStats?.pitchingstatslist;
                      List<Battingstats>? battingstatslist =
                          snapshot.data?.playerStats?.battingstatslist;
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
                            battingstatslist != null
                                ? const SizedBox(height: 15)
                                : Container(),
                            battingstatslist != null
                                ? const CommonText(
                                    text: "Batting Stats",
                                    fontSize: 16,
                                    color: AppColors.stats_title_blue,
                                    fontWeight: FontWeight.w800)
                                : Container(),
                            battingstatslist != null
                                ? const SizedBox(height: 5)
                                : Container(),
                            battingstatslist != null
                                ? SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                        showBottomBorder: true,
                                        headingRowColor:
                                            MaterialStateProperty.resolveWith(
                                                (states) =>
                                                    AppColors.grey_hint_color),
                                        columns: _createBattingStatsColumns(),
                                        rows: List.generate(
                                            battingstatslist.length, (index) {
                                          var battingstatsItem =
                                              battingstatslist[index];
                                          if (battingstatsItem != null) {
                                            return DataRow(
                                              cells: [
                                                DataCell(
                                                  CommonText(
                                                      text:
                                                          "${battingstatsItem.name}",
                                                      fontSize: 11,
                                                      color: AppColors
                                                          .black_txcolor,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                DataCell(
                                                  CommonText(
                                                      text:
                                                          "${battingstatsItem.ab}",
                                                      fontSize: 11,
                                                      color: AppColors
                                                          .black_txcolor,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                DataCell(
                                                  CommonText(
                                                      text:
                                                          "${battingstatsItem.avg}",
                                                      fontSize: 11,
                                                      color: AppColors
                                                          .black_txcolor,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                DataCell(
                                                  CommonText(
                                                      text:
                                                          "${battingstatsItem.bb}",
                                                      fontSize: 11,
                                                      color: AppColors
                                                          .black_txcolor,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                DataCell(
                                                  CommonText(
                                                      text:
                                                          "${battingstatsItem.bib}",
                                                      fontSize: 11,
                                                      color: AppColors
                                                          .black_txcolor,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                DataCell(
                                                  CommonText(
                                                      text:
                                                          "${battingstatsItem.gp}",
                                                      fontSize: 11,
                                                      color: AppColors
                                                          .black_txcolor,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                DataCell(
                                                  CommonText(
                                                      text:
                                                          "${battingstatsItem.h}",
                                                      fontSize: 11,
                                                      color: AppColors
                                                          .black_txcolor,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                DataCell(
                                                  CommonText(
                                                      text:
                                                          "${battingstatsItem.hr}",
                                                      fontSize: 11,
                                                      color: AppColors
                                                          .black_txcolor,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                DataCell(
                                                  CommonText(
                                                      text:
                                                          "${battingstatsItem.r}",
                                                      fontSize: 11,
                                                      color: AppColors
                                                          .black_txcolor,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                DataCell(
                                                  CommonText(
                                                      text:
                                                          "${battingstatsItem.rbi}",
                                                      fontSize: 11,
                                                      color: AppColors
                                                          .black_txcolor,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                DataCell(
                                                  CommonText(
                                                      text:
                                                          "${battingstatsItem.sb}",
                                                      fontSize: 11,
                                                      color: AppColors
                                                          .black_txcolor,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                DataCell(
                                                  CommonText(
                                                      text:
                                                          "${battingstatsItem.so}",
                                                      fontSize: 11,
                                                      color: AppColors
                                                          .black_txcolor,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                DataCell(
                                                  CommonText(
                                                      text:
                                                          "${battingstatsItem.trib}",
                                                      fontSize: 11,
                                                      color: AppColors
                                                          .black_txcolor,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                DataCell(
                                                  CommonText(
                                                      text:
                                                          "${battingstatsItem.x2b}",
                                                      fontSize: 11,
                                                      color: AppColors
                                                          .black_txcolor,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                DataCell(
                                                  CommonText(
                                                      text:
                                                          "${battingstatsItem.x3b}",
                                                      fontSize: 11,
                                                      color: AppColors
                                                          .black_txcolor,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            );
                                          } else {
                                            return const DataRow(
                                              cells: [],
                                            );
                                          }
                                        })),
                                  )
                                : Container(),
                            pitchingstatslist != null
                                ? const SizedBox(height: 15)
                                : Container(),
                            pitchingstatslist != null
                                ? const CommonText(
                                    text: "Pitching Stats",
                                    fontSize: 16,
                                    color: AppColors.stats_title_blue,
                                    fontWeight: FontWeight.w800)
                                : Container(),
                            pitchingstatslist != null
                                ? const SizedBox(height: 5)
                                : Container(),
                            pitchingstatslist != null
                                ? SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                      showBottomBorder: true,
                                      headingRowColor:
                                          MaterialStateProperty.resolveWith(
                                              (states) =>
                                                  AppColors.grey_hint_color),
                                      columns: _createPitchingStatsColumns(),
                                      rows: List.generate(
                                          pitchingstatslist.length, (index) {
                                        var pitchingstatsItem =
                                            pitchingstatslist[index];
                                        if (pitchingstatsItem != null) {
                                          return DataRow(
                                            cells: [
                                              DataCell(
                                                CommonText(
                                                    text:
                                                        "${pitchingstatsItem.name}",
                                                    fontSize: 11,
                                                    color:
                                                        AppColors.black_txcolor,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              DataCell(
                                                CommonText(
                                                    text:
                                                        "${pitchingstatsItem.bb}",
                                                    fontSize: 11,
                                                    color:
                                                        AppColors.black_txcolor,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              DataCell(
                                                CommonText(
                                                    text:
                                                        "${pitchingstatsItem.er}",
                                                    fontSize: 11,
                                                    color:
                                                        AppColors.black_txcolor,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              DataCell(
                                                CommonText(
                                                    text:
                                                        "${pitchingstatsItem.era}",
                                                    fontSize: 11,
                                                    color:
                                                        AppColors.black_txcolor,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              DataCell(
                                                CommonText(
                                                    text:
                                                        "${pitchingstatsItem.gp}",
                                                    fontSize: 11,
                                                    color:
                                                        AppColors.black_txcolor,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              DataCell(
                                                CommonText(
                                                    text:
                                                        "${pitchingstatsItem.gs}",
                                                    fontSize: 11,
                                                    color:
                                                        AppColors.black_txcolor,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              DataCell(
                                                CommonText(
                                                    text:
                                                        "${pitchingstatsItem.h}",
                                                    fontSize: 11,
                                                    color:
                                                        AppColors.black_txcolor,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              DataCell(
                                                CommonText(
                                                    text:
                                                        "${pitchingstatsItem.ip}",
                                                    fontSize: 11,
                                                    color:
                                                        AppColors.black_txcolor,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              DataCell(
                                                CommonText(
                                                    text:
                                                        "${pitchingstatsItem.l}",
                                                    fontSize: 11,
                                                    color:
                                                        AppColors.black_txcolor,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              DataCell(
                                                CommonText(
                                                    text:
                                                        "${pitchingstatsItem.sho}",
                                                    fontSize: 11,
                                                    color:
                                                        AppColors.black_txcolor,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              DataCell(
                                                CommonText(
                                                    text:
                                                        "${pitchingstatsItem.so}",
                                                    fontSize: 11,
                                                    color:
                                                        AppColors.black_txcolor,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              DataCell(
                                                CommonText(
                                                    text:
                                                        "${pitchingstatsItem.sv}",
                                                    fontSize: 11,
                                                    color:
                                                        AppColors.black_txcolor,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              DataCell(
                                                CommonText(
                                                    text:
                                                        "${pitchingstatsItem.w}",
                                                    fontSize: 11,
                                                    color:
                                                        AppColors.black_txcolor,
                                                    fontWeight:
                                                        FontWeight.w500),
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

  _buildRow(image, text, color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SvgPicture.asset(image),
        SizedBox(width: 10),
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
          insetPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
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
                      SizedBox(height: 20),
                      Row(
                        children: const [
                          Expanded(
                            child: TextField(
                              keyboardType: TextInputType.multiline,
                              maxLength: null,
                              maxLines: 4,
                              decoration: InputDecoration(
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
                      SizedBox(height: 20),
                      Divider(color: AppColors.grey_hint_color),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: CommonText(
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
                              onClick: () async {},
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

  Future<bool> _UserDeatil(
      String userId,
      String image,
      String displayName,
      String userEmail,
      String contact,
      String plan,
      String firstName,
      String lastName,
      String address,
      String city,
      String state,
      String zipcode) async {
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
                            imageUrl: "$image",
                            placeholder: (context, url) => CustomLoader(),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // plan == "Free"
                              //     ? CommonText(
                              //         text:
                              //             "${firstName.replaceRange(1, firstName.length, "xxxxxx")} ${lastName.replaceRange(1, lastName.length, "xxxxxx")}",
                              //         fontSize: 16,
                              //         color: AppColors.black_txcolor,
                              //         fontWeight: FontWeight.w700)
                              //     : CommonText(
                              //         text: displayName,
                              //         fontSize: 16,
                              //         color: AppColors.black_txcolor,
                              //         fontWeight: FontWeight.w700),
                              CommonText(
                                  text: displayName,
                                  fontSize: 16,
                                  color: AppColors.black_txcolor,
                                  fontWeight: FontWeight.w700),
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
                                        "${address ?? ""},${city ?? ""},${state ?? ""},${zipcode ?? ""}",
                                        fontSize: 15,
                                        color: AppColors.black_txcolor,
                                        fontWeight: FontWeight.w400),
                                    // plan == "Free"
                                    //     ? CommonText(
                                    //         text:
                                    //             "xxxxxxxxxxxxxx,${city ?? ""},${state ?? ""},xxxxxxx",
                                    //         fontSize: 15,
                                    //         color: AppColors.black_txcolor,
                                    //         fontWeight: FontWeight.w400)
                                    //     : CommonText(
                                    //         text:
                                    //             "${address ?? ""},${city ?? ""},${state ?? ""},${zipcode ?? ""}",
                                    //         fontSize: 15,
                                    //         color: AppColors.black_txcolor,
                                    //         fontWeight: FontWeight.w400),
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
                                // plan == "Free"
                                //     ? CommonText(
                                //         text: userEmail.replaceRange(
                                //             0,
                                //             userEmail.length,
                                //             "xxxxxxxxx@xxxx.com"),
                                //         fontSize: 15,
                                //         color: AppColors.black_txcolor,
                                //         fontWeight: FontWeight.w400)
                                //     : CommonText(
                                //         text: "$userEmail",
                                //         fontSize: 15,
                                //         color: AppColors.black_txcolor,
                                //         fontWeight: FontWeight.w400),
                                CommonText(
                                    text: "$userEmail",
                                    fontSize: 15,
                                    color: AppColors.black_txcolor,
                                    fontWeight: FontWeight.w400),
                              ]),
                              const SizedBox(height: 5),
                              Row(children: [
                                SvgPicture.asset(
                                  call_icon,
                                  color: AppColors.black,
                                ),
                                const SizedBox(width: 3),
                                // plan == "Free"
                                //     ? CommonText(
                                //         text: contact.replaceRange(
                                //             5, 14, "xxxxxxxx"),
                                //         fontSize: 15,
                                //         color: AppColors.black_txcolor,
                                //         fontWeight: FontWeight.w400)
                                //     : CommonText(
                                //         text: "$contact",
                                //         fontSize: 15,
                                //         color: AppColors.black_txcolor,
                                //         fontWeight: FontWeight.w400)
                                CommonText(
                                    text: "$contact",
                                    fontSize: 15,
                                    color: AppColors.black_txcolor,
                                    fontWeight: FontWeight.w400),
                              ])
                            ],
                          ),
                        )
                      ]),
                  const SizedBox(height: 10),
                  const Divider(color: AppColors.grey_hint_color),
                  const SizedBox(height: 5),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: athleteItemList.length.compareTo(0),
                      itemBuilder: (context, index) {
                        print(
                            "List Of tab length ==-===<><. ${athleteItemList.length}");
                        uniquelist.add(athleteItemList[index]["displayGroup"]);
                        print("tab length ==-===<><. ${uniquelist}");
                        var group =
                            groupBy(athleteItemList, (e) => e["displayGroup"])
                                .map((key, value) => MapEntry(key,
                                value.map((e) => e["displayGroup"])
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

  Future<bool> _BoookmarkDialog(String userID) async {
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
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _buildContainer(() {Navigator.pop(context);}, AppColors.dark_red, AppString.cancelTxt),
                      const SizedBox(width: 15),
                      GestureDetector(
                        onTap: ()  {
                          setState(() {
                            Unbookmarklistapi(userID);
                          });
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 40,
                          width: 80,
                          decoration: BoxDecoration(
                            color: AppColors.approvedtext_Color,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Center(child: CommonText(text: AppString.confirmText, fontSize: 14, color: AppColors.white, fontWeight: FontWeight.w500)),
                        ),
                      )
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
        setState(() {
          athleteItemList = response.data["attribute"];
          // uniquelist = response.data["attribute"].where((value) => models.add(value["displayGroup"])).toList();
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
  }

  athletesBookMarkList(int page, int limit) async {
    log('this is Manage_Profile  api call', name: "Manage_Profile");
    setState(() {
      _isLoadRunning = true;
    });
    try {
      Dio dio = Dio();
      var response = await dio.get("${AppConstant.BOOK_MARK}page=$page&size=$limit",
          options: Options(followRedirects: false, headers: {
            "Authorization": "Bearer $accessToken"
          }));
      print("-----this is url $response");
      if (response.statusCode == 200) {
        print("+++++this is manageprofile ${response.data}");
        setState(() {
          uniquelist = response.data["bookMarkList"];
          group3 = groupBy(uniquelist, (e) => e["role"]).map((key, value) => MapEntry(key, value.map((e) => e).whereNotNull().toList()));
          athleteList = group3["Athlete"];
          _isLoadRunning = false;
          print("+++++Item ${athleteList}");
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
        athleteList.clear();
        athletesBookMarkList(_page, _limit);
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
