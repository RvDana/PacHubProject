import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:custom_date_range_picker/custom_date_range_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:pachub/Utils/appcolors.dart';
import 'package:pachub/Utils/appstring.dart';
import 'package:pachub/Utils/constant.dart';
import 'package:pachub/Utils/images.dart';
import 'package:pachub/app_function/MyAppFunction.dart';
import 'package:pachub/common_widget/appbar.dart';
import 'package:pachub/common_widget/customloader.dart';
import 'package:pachub/common_widget/nodatafound_page.dart';
import 'package:pachub/common_widget/textstyle.dart';
import 'package:pachub/config/preference.dart';
import 'package:pachub/models/solicited_user_model.dart';
import 'package:pachub/services/request.dart';

class Solicitor extends StatefulWidget {
  const Solicitor({Key? key}) : super(key: key);

  @override
  State<Solicitor> createState() => _SolicitorState();
}

class _SolicitorState extends State<Solicitor> {
  TextEditingController dateController = TextEditingController();
  List solicitedList = [];
  List solicitedUserList = [];
  bool _isFirstLoadRunning = false;
  bool _isLoading = true;
  bool _loading = true;
  List amount = [];
  List amountTotal = [];
  List total = [];
  List resultList = [];
  DateTime? startDate;
  DateTime? endDate;
  String? stDate;
  DateTime dateTimeNow = DateTime.now();
  String firstDate ="";
  String lastDate ="";
  var frstDate;
  var lstDate;
  String firstShowDate ="";
  String lastShowDate ="";
  String? edDate;
  var sum;
  var result;
  var group;
  var seen = <String>{};
  Map<String, dynamic> map = {};



  @override
  void initState() {
    SolicitedApi();
    dateFunction();
    super.initState();
    Future.delayed(Duration(seconds: 8), () {
      setState(() {
        totalamountlist();
        _isLoading = false;
      }) ;
    });
  }


  dateFunction() {
    frstDate = DateTime(dateTimeNow.year, dateTimeNow.month, 1).toString();
    lstDate = DateTime(dateTimeNow.year, dateTimeNow.month + 1, 0).toString();
    var firstdateParse = DateTime.parse(frstDate);
    var lastdateParse = DateTime.parse(lstDate.toString());
    stDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(firstdateParse.toString()));
    edDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(lastdateParse.toString()));
    // firstShowDate = DateFormat('yMMMMd').format(DateTime.parse(firstdateParse.toString()));
    // lastShowDate = DateFormat('yMMMMd').format(DateTime.parse(lastdateParse.toString()));
    print("this is first date $stDate");
    print("this is last date $edDate");
    // print("this is first date $firstShowDate");
    // print("this is last date $lastShowDate");
  }



  totalamountlist()  {
    print("first date $stDate");
    print("last date $edDate");
    setState(() {
      for (var e in solicitedList)  {
        solicitedUserTest(e["id"], "$stDate", "$edDate").then((value)  {
          total.clear();
          var list = value?.resultSolicitedUserList;
          list?.forEach((element) {
            element.amount.toString();
            print("******-=---=-=-=-=-=->> ${element.amount.toString()}");
            total.add(element.amount ?? 0);
            result = total.reduce((value, element) => value + element);
            e["totalAmount"] = result;
            resultList.add(e);
            print("<<<<<<-=---=-=-=-=-=->> $resultList");
          });
        });
      }
    });
  }

  // Future totalmain()  {
  //   return Future.delayed(Duration(seconds: 8), () {
  //     setState(() {
  //       totalamountlist();
  //       _isLoading = false;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    totalamountlist();
    print("++++++======>>>> $resultList");
    return Scaffold(
      appBar: Appbar(
        text: AppString.solicitor,
        onClick: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      body: Column(
        children: [
          _isLoading  ? Align(
            alignment: Alignment.center,
            child: CustomLoader(),
          ) :  _isFirstLoadRunning
              ?  Align(
                  alignment: Alignment.center,
                  child: CustomLoader(),
                )
              : solicitedList.isEmpty
                  ? const Align(
                      alignment: Alignment.center,
                      child: NoDataFound(),
                    )
                  : Column(
                    children: [
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.only(right: 10,left: 10),

                        child: Container(
                          height: 45,
                          padding: const EdgeInsets.only(top: 0),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.grey_hint_color),
                          ),
                          child: Row(
                            children: [

                              Expanded(
                                child: TextFormField(
                                  controller: dateController,
                                  readOnly: true,
                                  onTap: () {
                                    _isLoading = true;
                                    showCustomDateRangePicker(
                                      context,
                                      dismissible: true,
                                      minimumDate: DateTime.now().subtract(const Duration(days: 365)),
                                      maximumDate: DateTime.now().add(const Duration(days: 365)),
                                      endDate: DateTime.tryParse(edDate.toString()),
                                      startDate: DateTime.tryParse(stDate.toString()),
                                      onApplyClick: (start, end) {
                                        setState(() {
                                          endDate = end;
                                          startDate = start;
                                          solicitedList.clear();
                                          total.clear();
                                          resultList.clear();
                                          result == null;
                                          SolicitedApi();
                                          dateFunction();
                                          Future.delayed(Duration(seconds: 8), () {
                                            setState(() {
                                              totalamountlist();
                                              _isLoading = false;
                                            });
                                          });
                                          // visiblity=true;
                                          // myFuture;
                                        });
                                        setState(() {
                                          dateController.text =
                                          '${startDate != null ? DateFormat("yMMMMd").format(startDate!) : '-'} to ${endDate != null ? DateFormat("yMMMMd").format(endDate!) : '-'}';
                                          stDate = startDate != null ? DateFormat("yyyy-MM-dd").format(startDate!) : '-';
                                          edDate = startDate != null ? DateFormat("yyyy-MM-dd").format(endDate!) : '-';
                                          print("controller ==================<><><> ${dateController.text}");
                                          print("StartDate ==================<><><> $stDate");
                                          print("endDate ==================<><><> $edDate");
                                        });
                                      },
                                      onCancelClick: () {
                                        setState(() {
                                          endDate = null;
                                          startDate = null;
                                        });
                                        setState(() {
                                          dateController.text = "";
                                          print("controller ==================<><><> ${dateController.text}");
                                          _isLoading = false;
                                        });
                                      },
                                    );
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(left: 10, bottom: 5, top: 10),
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(color: AppColors.black_txcolor),
                                    hintText: '${stDate != null ? DateFormat('yMMMMd').format(DateTime.parse(stDate.toString())) : '-'} to ${edDate != null ? DateFormat('yMMMMd').format(DateTime.parse(edDate.toString())) : '-'}',
                                    suffixIcon: dateController.text.isEmpty ? Container(width: 1)
                                        : IconButton(onPressed: () {
                                    setState(() {
                                      _isLoading = true;
                                      dateController.clear();
                                      SolicitedApi();
                                      dateFunction();
                                      Future.delayed(Duration(seconds: 8), () {
                                        setState(() {
                                          totalamountlist();
                                          _isLoading = false;
                                        });
                                      });
                                    });
                                    }, icon: Icon(Icons.close, color: AppColors.black_txcolor,)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowColor: MaterialStateProperty.resolveWith((states) => AppColors.grey_hint_color),
                            columns: const [
                              DataColumn(
                                label: CommonText(
                                    text: "NAME",
                                    fontSize: 14,
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                              DataColumn(
                                label: CommonText(
                                    text: "TOTAL AMOUNT",
                                    fontSize: 14,
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                              DataColumn(
                                label: CommonText(
                                    text: "ACTION",
                                    fontSize: 14,
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                            rows: List.generate(solicitedList.length, (index) {
                              var solicited = solicitedList[index];
                              print("list Data OF Total Amount======>>>>> ${solicited["totalAmount"]}");
                              return DataRow(
                                cells: [
                                  DataCell(
                                    CommonText(
                                        text: solicited["solicitedName"],
                                        fontSize: 14,
                                        color: AppColors.black_txcolor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  DataCell(
                                      CommonText(
                                          text: "\$${ solicited["totalAmount"] ?? " 0.00"}",
                                          fontSize: 14,
                                          color: AppColors.black_txcolor,
                                          fontWeight: FontWeight.w500)
                                  ),
                                  DataCell(
                                    InkWell(
                                      onTap: ()  {
                                        _solicitedDetails(solicited["id"],stDate.toString(), edDate.toString());
                                      },
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            profile_icon,
                                            color: AppColors.black_txcolor,
                                            height: 15,
                                            width: 15,
                                          ),
                                          SizedBox(width: 5),
                                          CommonText(
                                              text: "Details",
                                              fontSize: 12,
                                              color: AppColors.black_txcolor,
                                              fontWeight: FontWeight.w500),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ),
                    ],
                  ),
        ],
      ),
    );
  }

  Future<bool> _solicitedDetails(solicited, String stDate, String edDate) async {
    print("solicitedUserList ====>>>>>  $solicitedUserList");
    print('start Date   : $stDate');
    print('first Date   : $edDate');
    final shouldPop = await showDialog(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0)),
            elevation: 0.0,
            backgroundColor: Colors.white,
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: SingleChildScrollView(
              child: FutureBuilder<SolicitedUserModel?>(
                future: solicitedUserTest(solicited, stDate, edDate),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                     const SizedBox(
                      height: 100,
                      child:  Center(
                        child: Text("Details not found"),
                      ),
                    );
                  }
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(child: CustomLoader());
                    case ConnectionState.done:
                      if (snapshot.hasData) {
                        List<Result>? resultSolicitedUserList = snapshot.data?.resultSolicitedUserList;
                        if (resultSolicitedUserList != null) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    CommonText(
                                        text: "Active Users",
                                        fontSize: 18,
                                        color: AppColors.black,
                                        fontWeight: FontWeight.bold),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Divider(thickness: 1),
                                SizedBox(height: 10),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    headingRowColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) => AppColors
                                                .drawer_bottom_text_color),
                                    columns: const [
                                      DataColumn(
                                        numeric: false,
                                        label: CommonText(
                                            text: "NAME",
                                            fontSize: 14,
                                            color: AppColors.white,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      DataColumn(
                                        numeric: false,
                                        label: CommonText(
                                            text: "SPORTS",
                                            fontSize: 14,
                                            color: AppColors.white,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      DataColumn(
                                        numeric: false,
                                        label: CommonText(
                                            text: "PLAN",
                                            fontSize: 14,
                                            color: AppColors.white,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      DataColumn(
                                        numeric: false,
                                        label: CommonText(
                                            text: "USERS",
                                            fontSize: 14,
                                            color: AppColors.white,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      DataColumn(
                                        numeric: false,
                                        label: CommonText(
                                            text: "AMOUNT",
                                            fontSize: 14,
                                            color: AppColors.white,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                    rows: List.generate(resultSolicitedUserList.length, (index) {
                                      var solicitedUser = resultSolicitedUserList[index];
                                      return DataRow(
                                        cells: [
                                          DataCell(
                                            CommonText(
                                                text: "${solicitedUser.roleName ?? ""}",
                                                fontSize: 14,
                                                color: AppColors.black_txcolor,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          DataCell(
                                            CommonText(
                                                text: "${solicitedUser.sport ?? ""}",
                                                fontSize: 14,
                                                color: AppColors.black_txcolor,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          DataCell(
                                            CommonText(
                                                text: "${solicitedUser.plan ?? ""}",
                                                fontSize: 14,
                                                color: AppColors.black_txcolor,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          DataCell(
                                            Center(
                                              child: CommonText(
                                                  text: "${solicitedUser.users ?? ""}",
                                                  fontSize: 14,
                                                  color: AppColors.black_txcolor,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          DataCell(
                                            Center(
                                              child: CommonText(
                                                  text: "${solicitedUser.amount ?? ""}",
                                                  fontSize: 14,
                                                  color: AppColors.black_txcolor,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Divider(thickness: 1),
                                SizedBox(height: 10),
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
                                          color: AppColors
                                              .drawer_bottom_text_color,
                                          borderRadius:
                                              BorderRadius.circular(20),
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
                          );
                        } else {
                          return  const SizedBox(
                            height: 100,
                            child:   Center(
                              child: Text("Details not found"),
                            ),
                          );
                        }
                      } else {
                        return const SizedBox(
                          height: 100,
                          child:  Center(
                            child: Text("Details not found"),
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
            )),
      ),
    );

    return shouldPop ?? false;
  }

////TODO Solicited List Api ////////
  SolicitedApi() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    MyApplication.getInstance()!
        .checkConnectivity(context)
        .then((internet) async {
      if (internet != null && internet) {
        try {
          Dio dio = Dio();
          var response = await dio.get(AppConstant.Solicited,
              options: Options(followRedirects: false, headers: {
                "Authorization":
                    "Bearer ${PreferenceUtils.getString("accesstoken")}"
              }));
          if (response.statusCode == 200) {
            print("this is solicited response${response.data["result"]}");
            setState(() {
              solicitedList = response.data["result"];
              _isFirstLoadRunning = false;
            });
          } else {
           /* MyApplication.getInstance()
                ?.showInSnackBar(response.data["Message"], context);
            _isFirstLoadRunning = false;
            print("errror message home ======>>> ${response.data["Message"]}");*/
          }
        } on DioError catch (e) {
          /*if (e is DioError) {
            MyApplication.getInstance()
                ?.showInSnackBar(e.response!.data["Message"], context);
            print(
                "errror message home ======>>> ${e.response!.data["Message"]}");
            _isFirstLoadRunning = false;
          }*/
        }
      } else {
        MyApplication.getInstance()
            ?.showInSnackBar(AppString.no_connection, context);
      }
    });
  }
}
