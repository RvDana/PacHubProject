import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:pachub/Utils/appstring.dart';
import 'package:pachub/Utils/images.dart';
import 'package:pachub/common_widget/appbar.dart';
import 'package:pachub/common_widget/customloader.dart';
import 'package:pachub/common_widget/nodatafound_page.dart';
import 'package:pachub/config/preference.dart';
import 'package:pachub/models/pending_payment_List_model.dart';
import 'package:pachub/services/request.dart';

import '../../Utils/appcolors.dart';
import '../../common_widget/textstyle.dart';

class PendingPaymentPage extends StatefulWidget {
  const PendingPaymentPage({Key? key}) : super(key: key);

  @override
  State<PendingPaymentPage> createState() => _PendingPaymentPageState();
}

class _PendingPaymentPageState extends State<PendingPaymentPage> {
  String? accessToken;

  @override
  void initState() {
    setState(() {
      accessToken = PreferenceUtils.getString("accesstoken");
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(
        text: AppString.pendingPayments,
        onClick: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildPendingList(),
          ],
        ),
      ),
    );
  }
  _buildPendingList() {
    return FutureBuilder<PendingPaymentListModel?>(
        future: getPendingPayment_ALL_LISTING(accessToken),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            const Center(
              child: NoDataFound(),
            );
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CustomLoader());
            case ConnectionState.done:
              if (snapshot.hasData) {
                List<Result>? recentUsers = snapshot.data?.result;
                if (recentUsers != null) {
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: recentUsers.length,
                    itemBuilder: (context, index) {
                      final item = recentUsers[index];
                      DateTime complainDate = DateTime.parse(item.joiningDate.toString());
                      return Container(
                        margin: const EdgeInsets.only(
                            bottom: 10, left: 5, right: 5),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              side: const BorderSide(width: 0.1),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        CommonText(
                                            text: "${item.displayName}",
                                            fontSize: 15,
                                            color:
                                            AppColors.black_txcolor,
                                            fontWeight: FontWeight.bold),
                                        const SizedBox(height: 8),
                                        _CommonRow("REQUEST DATE : ", DateFormat('yMMMd').format(complainDate)),
                                        const SizedBox(height: 8),
                                        _CommonRow("SUBSCRIPTION : ", item.subscription ?? ""),
                                        const SizedBox(height: 8),
                                        _CommonRow("PRICE : ", " ${"\$${item.price}" ?? ""}"),
                                        const SizedBox(height: 8),
                                        _CommonRow("SOLICITED NAME : ", item.solicitedName ?? ""),
                                        const SizedBox(height: 8),
                                        _CommonRow("SPORT : ", item.sport ?? ""),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                                height: 20,
                                                width: 64.52,
                                                decoration: BoxDecoration(
                                                  color: AppColors.onHold,
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(16),
                                                ),
                                                child: Center(
                                                  child: CommonText(
                                                    text: item.status
                                                        .toString(),
                                                    fontSize: 10,
                                                    color: AppColors
                                                        .onHoldTextColor,
                                                    fontWeight:
                                                    FontWeight.w400,
                                                  ),
                                                )),
                                            PopupMenuButton(
                                              iconSize: 18,
                                              itemBuilder:
                                                  (context) {
                                                return [
                                                  PopupMenuItem<int>(
                                                    value: 0,
                                                    child: Row(
                                                      children: [
                                                        SvgPicture.asset(
                                                            approveIcon,
                                                            color: AppColors.black_txcolor),
                                                        const SizedBox(width: 10),
                                                        CommonText(
                                                            text: AppString.repayment,
                                                            fontSize: 15,
                                                            color: AppColors.black_txcolor,
                                                            fontWeight: FontWeight.w400),
                                                      ],
                                                    ),
                                                  ),
                                                ];
                                              },
                                              onSelected:
                                                  (value) {
                                                if (value == 0) {
                                                  if (kDebugMode) {
                                                    print("My account menu is selected.");}
                                                  sendPaymentLink(item.userID.toString(), context);
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
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
        });
  }
  _CommonRow(text, text2) {
    return Row(
      children: [
        CommonText(
            text: text,
            fontSize: 12,
            color:
            AppColors.black_txcolor,
            fontWeight: FontWeight.bold),
        CommonText(
            text: text2,
            fontSize: 12,
            color:
            AppColors.black_txcolor,
            fontWeight:
            FontWeight.w500),
      ],
    );
  }

}
