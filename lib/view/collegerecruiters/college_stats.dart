import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pachub/Utils/appcolors.dart';
import 'package:pachub/Utils/appstring.dart';
import 'package:pachub/common_widget/textstyle.dart';

import '../../common_widget/appbar.dart';

class CollegeStats extends StatefulWidget {
  const CollegeStats({Key? key}) : super(key: key);

  @override
  State<CollegeStats> createState() => _CollegeStatsState();
}

class _CollegeStatsState extends State<CollegeStats> {
  List itme = [
    {"txt": "*W-L", "txt2": "9-0", "txt3": "6-3"},
    {"txt": "*Pct.", "txt2": "1.0000", "txt3": "0.667"},
    {"txt": "*RF", "txt2": "90", "txt3": "51"},
    {"txt": "*RA", "txt2": "16", "txt3": "42"},
    {"txt": "W-L", "txt2": "34-3", "txt3": "20-12"},
    {"txt": "Pct", "txt2": "0.919", "txt3": "0.625"},
    {"txt": "RF", "txt2": "285", "txt3": "201"},
    {"txt": "RA", "txt2": "91", "txt3": "150"},
    {"txt": "RA", "txt2": "91", "txt3": "150"},
    {"txt": "Strk", "txt2": "Strk", "txt3": "2 L"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailAppbar(
        text: AppString.collegeStats,
        onClick: () {
          Get.back();
        },
        onTap: () {
          Get.back();
        },
      ),
      body: ListView.builder(
        itemCount: itme.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              Expanded(
                child: Container(
                  height: 60,
                  color: AppColors.contacts_text_color,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, top: 20, bottom: 20),
                    child: CommonText(
                        text: itme[index]["txt"],
                        fontSize: 10,
                        color: AppColors.blacksubtext_color,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 60,
                  color: AppColors.ligt_white_color,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 14, top: 20, bottom: 20),
                    child: CommonText(
                        text: itme[index]["txt2"],
                        fontSize: 14,
                        color: AppColors.black_txcolor,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 60,
                  color: AppColors.white,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 14, top: 20, bottom: 20),
                    child: CommonText(
                        text: itme[index]["txt3"],
                        fontSize: 14,
                        color: AppColors.black_txcolor,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
