import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pachub/Utils/appcolors.dart';
import 'package:pachub/Utils/appstring.dart';
import 'package:pachub/common_widget/appbar.dart';
import 'package:pachub/common_widget/textstyle.dart';

class SportsStats extends StatefulWidget {
  const SportsStats({Key? key}) : super(key: key);

  @override
  State<SportsStats> createState() => _SportsStatsState();
}

class _SportsStatsState extends State<SportsStats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailAppbar(
        text: AppString.baseballRequirements,
        onClick: () {
          Get.back();
        },
        onTap: () {
          Get.back();
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: Get.height,
              width: Get.width,
              child: DataTable(
                columnSpacing: 15,
                dividerThickness: 0,
                showBottomBorder: true,
                sortAscending: true,
                border: TableBorder(
                    verticalInside:
                        BorderSide(color: AppColors.ligt_grey_color)),
                columns: [
                  DataColumn(
                    label: CommonText(
                        text: AppString.positions,
                        fontSize: 10,
                        color: AppColors.grey_text_color,
                        fontWeight: FontWeight.w600),
                  ),
                  DataColumn(
                    label: CommonText(
                        text: AppString.positionsText,
                        fontSize: 10,
                        color: AppColors.grey_text_color,
                        fontWeight: FontWeight.w600),
                  ),
                ],
                rows: [
                  DataRow(
                    cells: [
                      DataCell(
                        CommonText(
                            text: AppString.velocity,
                            fontSize: 14,
                            color: AppColors.black_txcolor,
                            fontWeight: FontWeight.w500),
                      ),
                      DataCell(
                        CommonText(
                            text: "60",
                            fontSize: 14,
                            color: AppColors.black_txcolor,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(
                        CommonText(
                            text: AppString.fBVelocity,
                            fontSize: 14,
                            color: AppColors.black_txcolor,
                            fontWeight: FontWeight.w500),
                      ),
                      DataCell(
                        CommonText(
                            text: "120",
                            fontSize: 14,
                            color: AppColors.black_txcolor,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(
                        CommonText(
                            text: AppString.yardDash,
                            fontSize: 14,
                            color: AppColors.black_txcolor,
                            fontWeight: FontWeight.w500),
                      ),
                      DataCell(
                        CommonText(
                            text: "4.5",
                            fontSize: 14,
                            color: AppColors.black_txcolor,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(
                        CommonText(
                            text: AppString.specialRequests,
                            fontSize: 14,
                            color: AppColors.black_txcolor,
                            fontWeight: FontWeight.w500),
                      ),
                      DataCell(
                        CommonText(
                            text: "bla,bla,bla",
                            fontSize: 14,
                            color: AppColors.black_txcolor,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(
                        CommonText(
                            text: AppString.battingAverageRange,
                            fontSize: 14,
                            color: AppColors.black_txcolor,
                            fontWeight: FontWeight.w500),
                      ),
                      DataCell(
                        CommonText(
                            text: "0.345",
                            fontSize: 14,
                            color: AppColors.black_txcolor,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(
                        CommonText(
                            text: AppString.strikeoutRatios,
                            fontSize: 14,
                            color: AppColors.black_txcolor,
                            fontWeight: FontWeight.w500),
                      ),
                      DataCell(
                        CommonText(
                            text: "3.01",
                            fontSize: 14,
                            color: AppColors.black_txcolor,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(
                        CommonText(
                            text: AppString.homeRuns,
                            fontSize: 14,
                            color: AppColors.black_txcolor,
                            fontWeight: FontWeight.w500),
                      ),
                      DataCell(
                        CommonText(
                            text: "10",
                            fontSize: 14,
                            color: AppColors.black_txcolor,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(
                        CommonText(
                            text: AppString.rbi,
                            fontSize: 14,
                            color: AppColors.black_txcolor,
                            fontWeight: FontWeight.w500),
                      ),
                      DataCell(
                        CommonText(
                            text: "5",
                            fontSize: 14,
                            color: AppColors.black_txcolor,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(
                        CommonText(
                            text: AppString.stolenBases,
                            fontSize: 14,
                            color: AppColors.black_txcolor,
                            fontWeight: FontWeight.w500),
                      ),
                      DataCell(
                        CommonText(
                            text: "2",
                            fontSize: 14,
                            color: AppColors.black_txcolor,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(
                        CommonText(
                            text: AppString.fieldingPercentage,
                            fontSize: 14,
                            color: AppColors.black_txcolor,
                            fontWeight: FontWeight.w500),
                      ),
                      DataCell(
                        CommonText(
                            text: "10%",
                            fontSize: 14,
                            color: AppColors.black_txcolor,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Container(
            //   height: Get.height,
            //   color: AppColors.white,
            //   child: Column(
            //     children: [
            //       Row(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Expanded(
            //             child: Container(
            //               height: 40,
            //               // width: 200,
            //               color: AppColors.grey_hint_color,
            //               child: Padding(
            //                 padding: const EdgeInsets.symmetric(
            //                     horizontal: 20, vertical: 10),
            //                 child: CommonText(
            //                     text: "Velocity",
            //                     fontSize: 14,
            //                     color: AppColors.black_txcolor,
            //                     fontWeight: FontWeight.w500),
            //               ),
            //             ),
            //           ),
            //           Expanded(
            //             child: Container(
            //               height: 40,
            //               // width: 160,
            //               color: AppColors.white,
            //               child: Padding(
            //                 padding: const EdgeInsets.symmetric(
            //                     horizontal: 9, vertical: 10),
            //                 child: CommonText(
            //                     text: "60",
            //                     fontSize: 14,
            //                     color: AppColors.black_txcolor,
            //                     fontWeight: FontWeight.w500),
            //               ),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  _buildRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: CommonText(
                text: AppString.positions,
                fontSize: 10,
                color: AppColors.grey_text_color,
                fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: CommonText(
                text: AppString.positionsText,
                fontSize: 10,
                color: AppColors.grey_text_color,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
