import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pachub/Utils/appcolors.dart';
import 'package:pachub/Utils/appstring.dart';
import 'package:pachub/Utils/images.dart';
import 'package:pachub/common_widget/appbar.dart';
import 'package:pachub/common_widget/button.dart';
import 'package:pachub/common_widget/customloader.dart';
import 'package:pachub/common_widget/nodatafound_page.dart';
import 'package:pachub/common_widget/textstyle.dart';
import 'package:pachub/config/preference.dart';
import 'package:pachub/models/manage_subscription_model.dart';
import 'package:pachub/services/request.dart';
import 'package:pachub/view/login/login_view.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../Utils/constant.dart';
import '../../../../app_function/MyAppFunction.dart';

class ManageSubscription extends StatefulWidget {
  const ManageSubscription({Key? key}) : super(key: key);

  @override
  State<ManageSubscription> createState() => _ManageSubscriptionState();
}

class _ManageSubscriptionState extends State<ManageSubscription> {
  String? accessToken;
  String? stripe_sec_key;
  String? startdate;
  String? expiredate;
  String? enddate;
  int? differenceInDays;
  String? role;



  @override
  void initState() {
    accessToken = PreferenceUtils.getString("accesstoken");
    role = PreferenceUtils.getString("role");
    CLIENT_TRAINER_FOR_STRIPEKEY();
    if(role == "Advisor" || role == "Coach / Recruiter") {
      getMY_PLAN_AND_FEATURES();
    }
    //Plan_expire_days_count();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 19),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              _buildSubscriptionContainer(),
              const SizedBox(height: 15),
              PreferenceUtils.getString("plan_login") == "Free"?
              _buildSubscriptionContainer_gold() : Container(),
              const SizedBox(height: 15),
              PreferenceUtils.getString("plan_login") == "Free"||PreferenceUtils.getString("plan_login") == "Gold"?
              _buildSubscriptionContainer_platinum() : Container(),
              const SizedBox(height: 15),
              const CommonText(
                  text: AppString.billingHistory,
                  fontSize: 16,
                  color: AppColors.black_txcolor,
                  fontWeight: FontWeight.w700),
              const SizedBox(height: 10),
              _buildBillingHistoryContainer(),
            ],
          ),
        ),
      ),
      drawer: const Drawer(),
    );
  }

  _buildRow(txt, subTxt, amount, month,duration) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                      text: txt,
                      fontSize: 18,
                      color: AppColors.white,
                      fontWeight: FontWeight.w500),
                  const SizedBox(height: 0),
                  CommonText(
                      text: subTxt,
                      fontSize: 13,
                      color: AppColors.white,
                      fontWeight: FontWeight.normal),
                ],
              ),
              Row(
                children: [
                  CommonText(
                      text: "$amount",
                      fontSize: 18,
                      color: AppColors.white,
                      fontWeight: FontWeight.w500),
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: CommonText(
                        text: "$month",
                        fontSize: 10,
                        color: AppColors.white,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ],
          ),
          CommonText(
              text: duration,
              fontSize: 12,
              color: AppColors.white,
              fontWeight: FontWeight.w500),

        ],
      ),
    );
  }
  _buildRow_gold_paltinum(txt, subTxt, amount, month,duration) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                      text: txt,
                      fontSize: 18,
                      color: AppColors.white,
                      fontWeight: FontWeight.w500),
                  const SizedBox(height: 0),
                  CommonText(
                      text: subTxt,
                      fontSize: 13,
                      color: AppColors.white,
                      fontWeight: FontWeight.normal),
                ],
              ),
              Row(
                children: [
                  CommonText(
                      text: "$amount",
                      fontSize: 18,
                      color: AppColors.white,
                      fontWeight: FontWeight.w500),
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: CommonText(
                        text: "$month",
                        fontSize: 10,
                        color: AppColors.white,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ],
          ),
          CommonText(
              text: duration,
              fontSize: 12,
              color: AppColors.white,
              fontWeight: FontWeight.w500),

        ],
      ),
    );
  }
  _buildSubscriptionContainer() {
    return FutureBuilder<ManageSubscriptionModel?>(
        future: getManageSubscription_ALL_LISTING(accessToken),
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
                List<BillingHistory>? billingHistory = snapshot.data?.billingHistory;
                if (billingHistory != null) {
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: billingHistory.length.compareTo(0),
                    itemBuilder: (context, index) {
                      final item = billingHistory[index];
                      PreferenceUtils.setString("plan", item.plan.toString());
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 160,
                            width: Get.width,
                            decoration: BoxDecoration(
                              color: AppColors.dark_color,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.ligt_grey_color),
                              image: const DecorationImage(
                                image: AssetImage(platinumbackground),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 14),
                              child: Column(
                                children: [
                                  role == "Advisor" || role == "Coach / Recruiter"? _buildRow(item.displayName, "", "\$${item.amount}/",
                                    item.duration ?? "","Your plan will be Expired at "+"${expiredate??""}",):PreferenceUtils.getString("plan") == "Gold"||PreferenceUtils.getString("plan") == "Platinum"?
                                  _buildRow(item.displayName, "", "\$${item.amount}",
                                      "",item.duration??""):_buildRow(item.displayName, "", "",
                                      "",item.duration??""),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 100, bottom: 10),
                                    child: Button(
                                      color: AppColors.white,
                                      text: AppString.cancelSubscription,
                                      textColor: AppColors.dark_blue_button_color,
                                      onClick: () {
                                        _cancelDialog();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
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
  _buildSubscriptionContainer_gold() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 160,
          width: Get.width,
          decoration: BoxDecoration(
            color: AppColors.matches_card_color_new,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.ligt_grey_color),
            image: const DecorationImage(
              image: AssetImage(platinumbackground),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 25, vertical: 14),
            child: Column(
              children: [
                _buildRow_gold_paltinum("Gold", "", "\$1500",
                    "" "","Once" ""),
                // Padding(
                //   padding: const EdgeInsets.only(
                //       right: 100, bottom: 10),
                //   child: Button(
                //     color: AppColors.white,
                //     text: AppString.upgrade,
                //     textColor: AppColors.dark_blue_button_color,
                //     onClick: () {
                //       /*launchUrl(Uri.parse("https://checkout.stripe.com/c/pay/cs_test_a1Sqij0eKJT80zZO1cs69dyfaxrO2TroNVPG81Kms4KChkLv1Kbqwq"
                //           "7kZv#fidkdWxOYHwnPyd1blpxYHZxWjA0SWRBNXZMdERoT2B8MkZ%2FcENRZDJ3RH9ySkg9aXRUNzNSYTJzYFRHQHI2RzR%2FSFw3YFc2bUEwSnU2cW1XaHRzMGxtMGBNd01jUENvbXc1S2Zrb3xgVVx1NTVWUGh%2FTWh0UycpJ2N3amhWYHdzYHcnP"
                //           "3F3cGApJ2lkfGpwcVF8dWAnPyd2bGtiaWBabHFgaCcpJ2BrZGdpYFVpZGZgbWppYWB3dic%2FcXdwYHgl"));*/
                //       UPGRADE_PLAN_PAYMENT("Gold","1500");
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  _buildSubscriptionContainer_platinum() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 160,
          width: Get.width,
          decoration: BoxDecoration(
            color: AppColors.matches_card_color_new,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.ligt_grey_color),
            image: const DecorationImage(
              image: AssetImage(platinumbackground),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 25, vertical: 14),
            child: Column(
              children: [
                _buildRow_gold_paltinum("Platinum", "", "\$2500", "" "","Once" ""),
               /* Padding(
                  padding: const EdgeInsets.only(
                      right: 100, bottom: 10),
                  child: Button(
                    color: AppColors.white,
                    text: AppString.upgrade,
                    textColor: AppColors.dark_blue_button_color,
                    onClick: () {
                      UPGRADE_PLAN_PAYMENT("Platinum","2500");
                    },
                  ),
                ),*/
              ],
            ),
          ),
        ),
      ],
    );
  }

  _buildBillingHistoryContainer() {
    return FutureBuilder<ManageSubscriptionModel?>(
        future: getManageSubscription_ALL_LISTING(accessToken),
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
                List<BillingHistory>? billingHistory =
                    snapshot.data?.billingHistory;
                if (billingHistory != null) {
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: billingHistory.length,
                    itemBuilder: (context, index) {
                      final item = billingHistory[index];
                      DateTime effectiveAtDate = DateTime.parse(item.effectiveAt.toString());
                      return Column(
                        children: [
                          Container(
                            height: 90,
                            width: Get.width,
                            decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                      color: AppColors.contacts_text_color,
                                      blurRadius: 5,
                                      spreadRadius: 2),
                                ]),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(top: 4),
                                        child: CircleAvatar(
                                          backgroundColor: AppColors.light_blue_color,
                                          radius: 5,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children:  [
                                              CommonText(
                                                  text: "${item.displayName}",
                                                  fontSize: 16,
                                                  color: AppColors.dark_blue_button_color,
                                                  fontWeight: FontWeight.w600),
                                              Padding(
                                                padding: EdgeInsets.only(top: 5, left: 4),
                                                child: CommonText(
                                                    text: item.duration.toString(),
                                                    fontSize: 10,
                                                    color: AppColors.grey_hint_color,
                                                    fontWeight: FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          CommonText(
                                              text: "\$${item.amount}",
                                              fontSize: 14,
                                              color: AppColors.black_txcolor,
                                              fontWeight: FontWeight.w600),
                                          const SizedBox(height: 5),
                                          CommonText(
                                              text: DateFormat('yMMMd').format(effectiveAtDate),
                                              fontSize: 12,
                                              color: AppColors.grey_hint_color,
                                              fontWeight: FontWeight.w400),
                                        ],
                                      ),
                                      // SizedBox(width: 2),
                                    ],
                                  ),
                                ),
                                /*  const Divider(
                                        color: AppColors.contacts_text_color, thickness: 1),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 30, right: 30, top: 5),
                                      child: GestureDetector(
                                          onTap: () {},
                                          child: const CommonText(
                                              text: AppString.downloadInvoice,
                                              fontSize: 12,
                                              color: AppColors.blue_button_Color,
                                              fontWeight: FontWeight.w700)),
                                    )*/
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
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

  Future<bool> _cancelDialog() async {
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
                      text: AppString.subscriptiontxt,
                      fontSize: 18,
                      color: AppColors.black_txcolor,
                      fontWeight: FontWeight.bold),
                  const SizedBox(height: 15),
                  CommonText(
                      text: AppString.subscriptionSubTxt,
                      fontSize: 15,
                      color: AppColors.black_txcolor,
                      fontWeight: FontWeight.normal),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _buildContainer(() {Navigator.pop(context);}, AppColors.dark_red, AppString.cancelTxt),
                      const SizedBox(width: 15),
                      _buildContainer(() {
                        Cancel_Subscription(accessToken);
                      }, AppColors.approvedtext_Color, AppString.confirmText),
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


  CLIENT_TRAINER_FOR_STRIPEKEY() async {
    MyApplication.getInstance()!
        .checkConnectivity(context)
        .then((internet) async {
      if (internet != null && internet) {
        try {
          Dio dio = Dio();
          var params = {
              "clientID" : "1"
          };
          print("$params");
          var response = await dio.post(AppConstant.CLIENTTRAINER,
              data: params,
              options: Options(
                  followRedirects: false,
              ));
          if (response.statusCode == 200) {
            print("response of CLIENT TRAINER API====<> ${response.data}");
            stripe_sec_key=response.data["trainer"][0]["stripeSecretKey"].toString();
            print("this is stripekey ${stripe_sec_key}");
          }

          else {
            Get.back();
          }
        } on DioError catch (e) {
          if (e is DioError) {
            MyApplication.getInstance()?.showInSnackBar(e.response!.data["Message"], context);
          }
          Get.back();
        }
      } else {
        MyApplication.getInstance()
            ?.showInSnackBar(AppString.no_connection, context);
      }
    });
  }
  UPGRADE_PLAN_PAYMENT(String planname,String price) async {
    MyApplication.getInstance()!
        .checkConnectivity(context)
        .then((internet) async {
      if (internet != null && internet) {
        try {
          Dio dio = Dio();
          print("this is passed stripe key $stripe_sec_key");
          var params = {
              "productname" : "$planname",
              "strip_sec" : "{$stripe_sec_key}",
              "description" : "Find the team that's right for you!",
              "currency" : "usd",
              "price" : "$price",
              "success_url":"https://www.google.com",
              "cancel_url":"https://www.google.com",
              "customer_email" : "${PreferenceUtils.getString("loginEmail")}",
              "user_id" : "${PreferenceUtils.getInt("userID").toString()}"
          };
          print("this is payment para***$params");
          var response = await dio.post(AppConstant.STRIPEPAYMENT,
              data: params,
              options: Options(
                  followRedirects: false,
                  /*headers:{
                    "Authorization": "Bearer ${PreferenceUtils.getString("accesstoken")}"
                  }*/
              ));
          if (response.statusCode == 200) {
            launchUrl(Uri.parse("${response.data["data"]["url"].toString()}"));
            print("response of PAYMENT API====<> ${response.data}");
            print("response of PAYMENT API URL====<> ${response.data["data"]["url"].toString()}");
          }
          // else if(response.statusCode == 401) {
          //   return Get.offAll(Loginscreennew());
          // }
          else {
            MyApplication.getInstance()?.showInSnackBar(response.data["Message"], context);
          }
        } on DioError catch (e) {
          if (e is DioError) {
            MyApplication.getInstance()?.showInSnackBar(e.response!.data["Message"], context);
          }
        }
      } else {
        MyApplication.getInstance()
            ?.showInSnackBar(AppString.no_connection, context);
      }
    });
  }
  /////////////////////////////////////TODO UPDATE PLAN AND FEATURES//////////////////////////
  getMY_PLAN_AND_FEATURES() async {
    //DateFormat('yMMMd').format(DateTime.parse(athleteuserdetails["DOB"].toString() ?? ""))
    MyApplication.getInstance()!
        .checkConnectivity(context)
        .then((internet) async {
      if (internet != null && internet) {
        try {
          Dio dio = Dio();
          var response = await dio.get(AppConstant.my_plans_and_features,
              options: Options(
                  followRedirects: false,
                  headers:{
                    "Authorization": "Bearer ${PreferenceUtils.getString("accesstoken")}"
                  }
              ));
          if (response.statusCode == 200) {
            print("getMY_PLAN_AND_FEATURES Response:====<> ${response.data}");
            startdate=DateFormat('yyyy-MM-dd').format(DateTime.parse(response.data["myPlansAndFeatures"]["effectiveDate"].toString() ?? ""));
            expiredate=DateFormat('d MMM y').format(DateTime.parse(response.data["myPlansAndFeatures"]["expireDate"].toString() ?? ""));
            enddate=DateFormat('d MMM y').format(DateTime.parse(response.data["myPlansAndFeatures"]["expireDate"].toString() ?? ""));
            print("this is start date ====<> ${startdate}");
            print("this is end date====<> ${expiredate}");
            DateTime dateTimeCreatedAt = DateTime.parse("${startdate}");
            DateTime dateTimeNow = DateTime.now();
            differenceInDays = dateTimeNow.difference(dateTimeCreatedAt).inDays;
            print('this is the date difference $differenceInDays');
             setState(() {
            });
          }

          // else if(response.statusCode == 401) {
          //   return Get.offAll(Loginscreennew());
          // }
          else {
            // MyApplication.getInstance()?.showInSnackBar(response.data["Message"], context);
            print("this is error of plan and feature ${response.data["Message"]}");

          }
        } on DioError catch (e) {
          if (e is DioError) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => Loginscreennew()));
            // MyApplication.getInstance()?.showInSnackBar(e.response!.data["Message"], context);
            print("this is error of plan and feature ${e.response!.data["Message"]}");
          }
        }
      } else {
        MyApplication.getInstance()
            ?.showInSnackBar(AppString.no_connection, context);
      }
    });
  }

  }





