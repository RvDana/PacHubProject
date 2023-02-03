// import 'dart:convert';
// import 'dart:developer';
//
// import 'package:dio/dio.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:pachub/Utils/images.dart';
// import 'package:pachub/common_widget/customloader.dart';
// import 'package:pachub/common_widget/textstyle.dart';
// import 'package:pachub/config/preference.dart';
// import 'package:pachub/models/recruiter_model_response.dart';
// import 'package:pachub/view/collegerecruiters/college_recruiters_detail_page.dart';
//
// import '../../Utils/appcolors.dart';
// import '../../Utils/appstring.dart';
// import '../../Utils/constant.dart';
// import '../../app_function/MyAppFunction.dart';
// import '../../common_widget/appbar.dart';
// import '../../common_widget/drawer.dart';
// import 'package:http/http.dart' as http;
//
// class Recruiters extends StatefulWidget {
//   const Recruiters({Key? key}) : super(key: key);
//
//   @override
//   State<Recruiters> createState() => _RecruitersState();
// }
//
// class _RecruitersState extends State<Recruiters> {
//   List datalist = [];
//   int _page = 0;
//   final int _limit = 30;
//   bool _hasNextPage = true;
//   bool _isFirstLoadRunning = false;
//   bool _isLoadMoreRunning = false;
//   late ScrollController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//     getcollegerecruiters();
//     _controller = ScrollController()..addListener(_loadMore);
//   }
//
//   @override
//   void dispose() {
//     _controller.removeListener(_loadMore);
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: Appbar(
//         text: AppString.choachrecuiters,
//         onClick: () {
//           Scaffold.of(context).openDrawer();
//         },
//       ),
//       body: _isFirstLoadRunning
//           ? Center(
//               child: CustomLoader(),
//             )
//           : ListViewRecruiters(),
//
//       /* SingleChildScrollView(
//            child: Padding(
//              padding: EdgeInsets.only(right: 10, left: 10, top: 10),
//              child: Column(
//                crossAxisAlignment: CrossAxisAlignment.center,
//                children: [
//                  serachbarnew(),
//                  totaltx(),
//                  // dataItem()
//                  ListViewRecruiters(),
//                  */ /*ListView.builder(
//                    shrinkWrap: true,
//                    itemCount: datalist.length,
//                    itemBuilder: (context, index) {
//                      return ActivtiyTILE_Employee(index);})*/ /*
//                ],
//              ),
//            )),*/
//       drawer: const Drawer(
//         child: AppDrawer(),
//       ),
//     );
//   }
//
//   Widget serachbarnew() {
//     return Container(
//       height: 50,
//       width: MediaQuery.of(context).size.width,
//       padding: EdgeInsets.only(top: 0),
//       decoration: BoxDecoration(
//         color: Color(0xffF0F0F0),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextFormField(
//               // controller: search,
//               onChanged: (v) {
//                 //searchData = v;
//               },
//               onEditingComplete: () {},
//               decoration: InputDecoration(
//                 border: InputBorder.none,
//                 hintText: "Search",
//                 suffixIcon: GestureDetector(
//                   onTap: () {},
//                   child: Padding(
//                       padding: EdgeInsets.all(15),
//                       child: SvgPicture.asset(serach_suffix_icon)),
//                 ),
//                 prefixIcon: GestureDetector(
//                   onTap: () {},
//                   child: Padding(
//                       padding: EdgeInsets.all(15),
//                       child: SvgPicture.asset(serach_icon)),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget totaltx() {
//     return Padding(
//       padding: const EdgeInsets.only(top: 10, left: 4, bottom: 10),
//       child: Container(
//         alignment: Alignment.topLeft,
//         child: CommonText(
//           text: "Total  ${datalist.length.toString()} colleges",
//           color: AppColors.grey_text_color,
//           fontSize: 12,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     );
//   }
//
//   Widget ListViewRecruiters() {
//     return Container(
//         padding:
//             const EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 10),
//         child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             mainAxisSize: MainAxisSize.max,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               serachbarnew(),
//               totaltx(),
//               Expanded(
//                   child: _isFirstLoadRunning
//                       ? Align(
//                           alignment: Alignment.center,
//                           child: CustomLoader(),
//                         )
//                       : datalist.isEmpty
//                           ? const Align(
//                               alignment: Alignment.center,
//                               child: Text("No Data Found"),
//                             )
//                           : ListView.builder(
//                               shrinkWrap: true,
//                               physics: ClampingScrollPhysics(),
//                               controller: _controller,
//                               itemCount: datalist.length,
//                               itemBuilder: (context, index) {
//                                 return InkWell(
//                                     onTap: () {
//                                       Get.to(CollegeRecruitersDetailPage());
//                                     },
//                                     child: ActivtiyTILE_Employee(index));
//                               })),
//               // when the _loadMore function is running
//               if (_isLoadMoreRunning == true)
//                 Padding(
//                     padding: EdgeInsets.only(top: 10, bottom: 40),
//                     child: Center(
//                       child: CustomLoader(),
//                     )),
//
//               // When nothing else to load
//               if (_hasNextPage == false)
//                 Container(
//                   padding: const EdgeInsets.only(top: 30, bottom: 40),
//                   color: Colors.amber,
//                   child: const Center(
//                     child: Text('You have fetched all of the content'),
//                   ),
//                 ),
//             ]));
//   }
//
//   Widget ActivtiyTILE_Employee(int index) {
//     return Card(
//       margin: EdgeInsets.only(top: 8, bottom: 8),
//       shape: RoundedRectangleBorder(
//           side: BorderSide(width: 0.1),
//           borderRadius: BorderRadius.circular(10)),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             SizedBox(
//               height: 40,
//               width: 40,
//               child: Image.asset("assets/images/recruter.png"),
//             ),
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 8, top: 2),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     CommonText(
//                         text:
//                             "${datalist[index]["organizationName"] ?? "No Name Found"}",
//                         fontSize: 16,
//                         color: AppColors.black_txcolor,
//                         fontWeight: FontWeight.w700),
//                     SizedBox(height: 2),
//                     CommonText(
//                         text: datalist[index]["bio"] ?? "No Any Information",
//                         fontSize: 10,
//                         color: AppColors.grey_hint_color,
//                         fontWeight: FontWeight.w400),
//                     SizedBox(height: 9),
//                     _buildRow(
//                       location_icon,
//                       '${"${datalist[index]["city"] ?? "No Information"}" + ',' + "${datalist[index]["state"] ?? "No Information"}"}',
//                       AppColors.black_txcolor,
//                     ),
//                     SizedBox(height: 7),
//                     _buildRow(
//                       call_icon,
//                       "${datalist[index]["phoneNumber"] ?? "No Information"}",
//                       AppColors.black_txcolor,
//                     ),
//                     SizedBox(height: 7),
//                     _buildRow(
//                       world_icon,
//                       'www.howard.edu',
//                       AppColors.blue_text_Color,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 13,
//               width: 11,
//               child: datalist[index]["isBookMarked"] == false
//                   ? Image.asset(collegerecruitersave)
//                   : Image.asset(bookmarktrue),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void getcollegerecruiters() async {
//     log('this is call college recruiter api call', name: "college recruiter");
//     setState(() {
//       _isFirstLoadRunning = true;
//     });
//     MyApplication.getInstance()!
//         .checkConnectivity(context)
//         .then((internet) async {
//       if (internet != null && internet) {
//         try {
//           Dio dio = Dio();
//           var response = await dio.post(
//               "${AppConstant.MODE_COLLEGE_RECRUITERES}page=$_page&size=$_limit",
//               options: Options(followRedirects: false, headers: {
//                 "Authorization":
//                     "Bearer ${PreferenceUtils.getString("accesstoken")}"
//               }));
//           if (response.statusCode == 200) {
//             print(response.data);
//             print("========response============${response.data["result"]}");
//             setState(() {
//               datalist = response.data["result"];
//               _isFirstLoadRunning = false;
//             });
//             print("++++$datalist");
//             print(response.data["result"][0]["userID"].toString());
//             //loading = false;
//           } else {
//             setState(() => _isFirstLoadRunning = false);
//           }
//         } catch (e) {
//           print(e);
//           setState(() => _isFirstLoadRunning = false);
//         }
//       } else {
//         MyApplication.getInstance()!
//             .showInSnackBar(AppString.no_connection, context);
//       }
//     });
//   }
//
//   void _loadMore() async {
//     if (_hasNextPage == true &&
//         _isFirstLoadRunning == false &&
//         _isLoadMoreRunning == false &&
//         _controller.position.extentAfter < 300) {
//       setState(() {
//         _isLoadMoreRunning = true; // Display a progress indicator at the bottom
//       });
//       _page += 1;
//       print("=========thias is total$_page"); // Increase _page by 1
//       try {
//         Dio dio = Dio();
//         var response = await dio.post(
//             "${AppConstant.MODE_COLLEGE_RECRUITERES}page=$_page&size=$_limit",
//             options: Options(followRedirects: false, headers: {
//               "Authorization":
//                   "Bearer ${PreferenceUtils.getString("accesstoken")}"
//             }));
//         final List fetchedPosts =
//             json.decode(response.data["result"].toString());
//         if (fetchedPosts.isNotEmpty) {
//           setState(() {
//             datalist.addAll(fetchedPosts);
//           });
//         } else {
//           // This means there is no more data
//           // and therefore, we will not send another GET request
//           setState(() {
//             _hasNextPage = false;
//           });
//         }
//       } catch (err) {
//         if (kDebugMode) {
//           print('Something went wrong!');
//         }
//       }
//
//       setState(() {
//         _isLoadMoreRunning = false;
//       });
//     }
//   }
//
//   _buildRow(image, text, color) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         SvgPicture.asset(image),
//         SizedBox(width: 10),
//         SizedBox(
//           width: Get.width/2,
//           child: Text(
//             text,
//             style: TextStyle(
//               fontFamily: 'Montserrat',
//               fontSize: 12,
//               fontWeight: FontWeight.w400,
//               fontStyle: FontStyle.normal,
//               color: color,
//             ),
//             maxLines: 2,
//             overflow: TextOverflow.clip,
//           ),
//         ),
//       ],
//     );
//   }
// }
