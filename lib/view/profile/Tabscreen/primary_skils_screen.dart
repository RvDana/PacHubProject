import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pachub/Utils/appcolors.dart';
import 'package:pachub/Utils/appstring.dart';
import 'package:pachub/Utils/constant.dart';
import 'package:pachub/common_widget/textstyle.dart';
import 'package:pachub/config/preference.dart';

import '../../../app_function/MyAppFunction.dart';
import '../../../common_widget/customloader.dart';
import '../../../common_widget/nodatafound_page.dart';


class PrimarySkilsScreen extends StatefulWidget {
  const PrimarySkilsScreen({Key? key}) : super(key: key);

  @override
  State<PrimarySkilsScreen> createState() => _PrimarySkilsScreenState();
}

class _PrimarySkilsScreenState extends State<PrimarySkilsScreen> {
  List athleteItemList = [];
  bool _isFirstLoadRunning = false;
  List possitionPlayedList = [];

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
            possitionPlayedList = athleteItemList[index]['options']:Container();


            if (athleteItemList[index]["displayGroup"] == "Primary Skills") {
              return  Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if(athleteItemList[index]["columnName"] == "positionPlayed")
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
                                itemCount: possitionPlayedList.length,
                                  itemBuilder: (context, i) {
                                  return Container(
                                    child: athleteItemList[index]["value"][0].toString() == possitionPlayedList[i]["id"].toString()?
                                      CommonText(text: "${possitionPlayedList[i]["name"].toString()}", fontSize: 15, color: AppColors.grey_text_color, fontWeight: FontWeight.w400):Container(),
                                    );


                              })

                              /*child:Column(
                            children:
                            List.generate(possitionPlayedList.length, (i) {
                                  print("possitionPlayedId ==-======>>>> ${athleteItemList[index]["value"].toString()}");
                                  if(athleteItemList[index]["value"][0].toString() == possitionPlayedList[i]["id"].toString()) {
                                    print("possitionPlayedId name==-======>>>> ${possitionPlayedList[i]["name"].toString()}");
                                    return  CommonText(text: possitionPlayedList[i]["name"].toString(), fontSize: 15, color: AppColors.black, fontWeight: FontWeight.w400);
                                  } else {
                                    return CommonText(text: "text", fontSize: 15, color: AppColors.grey_text_color, fontWeight: FontWeight.w400);
                                  }
                                }),
                              )*/
                            ),
                          )
                        ],
                      ) :
                      _buildColumn(athleteItemList[index]["displayName"], ""),
                    //_buildColumn(athleteItemList[index]["columnName"], "${athleteItemList[index]["options"][2]["name"] ?? ""}"),
                    if(athleteItemList[index]["columnName"] != "positionPlayed")
                      _buildColumn(athleteItemList[index]["displayName"], athleteItemList[index]["value"] ?? "")
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
