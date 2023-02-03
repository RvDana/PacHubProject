import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pachub/Utils/appcolors.dart';
import 'package:pachub/Utils/appstring.dart';
import 'package:pachub/Utils/images.dart';
import 'package:pachub/common_widget/appbar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pachub/common_widget/textstyle.dart';
import 'package:pachub/view/collegerecruiters/college%20_sports_list.dart';
import 'package:pachub/view/collegerecruiters/college_stats.dart';
import 'package:pachub/view/collegerecruiters/send_message.dart';
import 'package:pachub/view/collegerecruiters/sports_stats.dart';
import 'package:readmore/readmore.dart';

class CollegeRecruitersDetailPage extends StatefulWidget {
  const CollegeRecruitersDetailPage({Key? key}) : super(key: key);

  @override
  State<CollegeRecruitersDetailPage> createState() =>
      _CollegeRecruitersDetailPageState();
}

class _CollegeRecruitersDetailPageState
    extends State<CollegeRecruitersDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailAppbar(
        text: "Howard University",
        onClick: () {
          Get.back();
        },
        onTap: () {
          Get.back();
        },
      ),
      bottomSheet: _buildBottom(),
      body: SingleChildScrollView(
        child: Container(
          height: Get.height,
          width: Get.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CommonText(
                    text: AppString.about,
                    fontSize: 14,
                    color: AppColors.grey_text_color,
                    fontWeight: FontWeight.w600),
                const SizedBox(height: 8),
                _buildReadMore(),
                const SizedBox(height: 16),
                _buildColumn(),
                const SizedBox(height: 32),
                _builRow(),
                const SizedBox(height: 25),
                _buildSportsRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildContainer(onClick, icon) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppColors.white,
          boxShadow: const [
            BoxShadow(
              color: AppColors.ligt_grey_color,
              blurRadius: 3,
              spreadRadius: 0.5,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
          child: SvgPicture.asset(
            icon,
            color: AppColors.black,
          ),
        ),
      ),
    );
  }

  _buildReadMore() {
    return const ReadMoreText(
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis molestie, dictum est a, mattis tellus. Sed dignissim, metus nec fringilla accumsan.\n \nCurabitur tempor quis eros tempus lacinia. Nam bibendum pellentesque quam a convallis. Sed ut vulputate nisi. Integer in felis sed leo vestibulum venenatis. Suspendisse quis arcu sem. Aenean feugiat ex eu vestibulum vestibulum...view more ',
      trimLines: 7,
      style: TextStyle(color: AppColors.grey_text_color),
      colorClickableText: AppColors.blue_text_Color,
      trimMode: TrimMode.Line,
      trimCollapsedText: '...view more',
      trimExpandedText: ' view less',
    );
  }

  _buildColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          userImage,
          height: 50,
          width: 50,
        ),
        const SizedBox(height: 8),
        const CommonText(
            text: AppString.user,
            fontSize: 14,
            color: AppColors.dark_blue_button_color,
            fontWeight: FontWeight.w600),
        const SizedBox(height: 2),
        Row(
          children: const [
            CommonText(
                text: AppString.recruiter,
                fontSize: 12,
                color: AppColors.black_txcolor,
                fontWeight: FontWeight.w600),
            CommonText(
                text: AppString.recruiterText,
                fontSize: 12,
                color: AppColors.black_txcolor,
                fontWeight: FontWeight.w400),
          ],
        ),
      ],
    );
  }

  _builRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            CommonText(
                text: AppString.collegeSports,
                fontSize: 14,
                color: AppColors.grey_text_color,
                fontWeight: FontWeight.w600),
            CommonText(
                text: AppString.collegeSportsText,
                fontSize: 14,
                color: AppColors.grey_text_color,
                fontWeight: FontWeight.w400),
          ],
        ),
        GestureDetector(
          onTap: () {
            Get.to(CollegeSportsList());
          },
          child: const CommonText(
              text: AppString.viewAll,
              fontSize: 12,
              color: AppColors.blue_text_Color,
              fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  _buildBottom() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildContainer(() {}, emailIcon),
          _buildContainer(() {
            Get.to(CollegeStats());
          }, chartIcon),
          GestureDetector(
            onTap: () {
              Get.to(SendMessage());
            },
            child: Container(
                height: 50,
                width: 190,
                decoration: BoxDecoration(
                    color: AppColors.dark_blue_button_color,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.dark_blue_button_color,
                        blurRadius: 3,
                        spreadRadius: 0.5,
                      ),
                    ]),
                child: const Center(
                  child: CommonText(
                    text: "Send Message",
                    fontSize: 12,
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                  ),
                )),
          ),
        ],
      ),
    );
  }

  _buildSportsRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Get.to(Get.to(SportsStats()));
              },
              child: Column(
                children: [
                  SvgPicture.asset(
                    baseball,
                  ),
                  const SizedBox(height: 5),
                  const CommonText(
                      text: AppString.baseball,
                      fontSize: 12,
                      color: AppColors.ligt_grey_color,
                      fontWeight: FontWeight.w600)
                ],
              ),
            ),
            Column(
              children: [
                SvgPicture.asset(
                  basketball,
                ),
                const SizedBox(height: 5),
                const CommonText(
                    text: AppString.basketball,
                    fontSize: 12,
                    color: AppColors.ligt_grey_color,
                    fontWeight: FontWeight.w600)
              ],
            ),
            Column(
              children: [
                SvgPicture.asset(
                  football,
                ),
                const SizedBox(height: 5),
                const CommonText(
                    text: AppString.football,
                    fontSize: 12,
                    color: AppColors.ligt_grey_color,
                    fontWeight: FontWeight.w600)
              ],
            ),
            Column(
              children: [
                SvgPicture.asset(
                  volleyball,
                ),
                const SizedBox(height: 5),
                const CommonText(
                    text: AppString.volleyball,
                    fontSize: 12,
                    color: AppColors.ligt_grey_color,
                    fontWeight: FontWeight.w600)
              ],
            ),
          ],
        ),
        SizedBox(height: 15),
        Column(
          children: [
            SvgPicture.asset(
              cricket,
            ),
            const SizedBox(height: 5),
            const CommonText(
                text: AppString.cricket,
                fontSize: 12,
                color: AppColors.ligt_grey_color,
                fontWeight: FontWeight.w600)
          ],
        ),
      ],
    );
  }
}
