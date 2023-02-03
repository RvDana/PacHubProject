import 'package:flutter/material.dart';
import 'package:pachub/Utils/appcolors.dart';
import 'package:pachub/Utils/appstring.dart';
import 'package:pachub/Utils/images.dart';
import 'package:pachub/common_widget/appbar.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pachub/common_widget/textstyle.dart';
import 'package:pachub/view/collegerecruiters/sports_stats.dart';

class CollegeSportsList extends StatefulWidget {
  const CollegeSportsList({Key? key}) : super(key: key);

  @override
  State<CollegeSportsList> createState() => _CollegeSportsListState();
}

class _CollegeSportsListState extends State<CollegeSportsList> {
  List item = [
    {
      "title": AppString.baseball,
      "image": baseball,
    },
    {
      "title": AppString.basketball,
      "image": basketball,
    },
    {
      "title": AppString.football,
      "image": football,
    },
    {
      "title": AppString.volleyball,
      "image": volleyball,
    },
    {
      "title": AppString.cricket,
      "image": cricket,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailAppbar(
        text: AppString.collegeSports,
        onClick: () {
          Get.back();
        },
        onTap: () {
          Get.back();
        },
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: ListView.builder(
          itemCount: item.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              child: GestureDetector(
                onTap: () {
                  Get.to(SportsStats());
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          item[index]["image"],
                          height: 32,
                          width: 32,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonText(
                                text: item[index]["title"],
                                fontSize: 14,
                                color: AppColors.black_txcolor,
                                fontWeight: FontWeight.w700,
                              ),
                              SizedBox(height: 3),
                              const CommonText(
                                text: AppString.privateProfileText,
                                fontSize: 12,
                                color: AppColors.grey_hint_color,
                                fontWeight: FontWeight.w400,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 17),
                          child: SvgPicture.asset(forewordIcon),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
