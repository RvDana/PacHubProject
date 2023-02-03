import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pachub/Utils/appcolors.dart';
import 'package:pachub/Utils/appstring.dart';
import 'package:pachub/Utils/constant.dart';
import 'package:pachub/app_function/MyAppFunction.dart';
import 'package:pachub/common_widget/textstyle.dart';
import 'package:pachub/config/preference.dart';
import 'package:pachub/services/request.dart';
import 'package:photo_view/photo_view.dart';

import '../../../common_widget/customloader.dart';
import '../../../common_widget/nodatafound_page.dart';
import '../viewimage/fullphotoviewpage.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List itemList = [];
  List image = [];
  bool _isFirstLoadRunning = false;

  @override
  void initState() {
    super.initState();
    manageImageList();
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery
        .of(context)
        .orientation;
    return RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      edgeOffset: 20,
      onRefresh: () async{
        await Future.delayed(Duration(milliseconds: 1500));
        setState(() {
          manageImageList();
        });
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
          child: _isFirstLoadRunning
              ? itemList.isEmpty
              ? Align(
            alignment: Alignment.center,
            child: CustomLoader(),
          ) :
           Align(
            alignment: Alignment.center,
            child: NoDataFound(),
          ) : ListView.builder(
              shrinkWrap: false,
              itemCount: itemList.length,
              itemBuilder: (context, index) {
                var item = itemList[index];
                print("video ${item["displayGroup"]}");
                if (item["displayGroup"] == "Images") {
                  image = item["value"] ?? [];
                  print("Videos data ====<> $image");
                  if(image.isNotEmpty) {
                    return  GridView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: BouncingScrollPhysics(),
                      itemCount: image.length,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 250,
                        childAspectRatio: 1,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                 child: GestureDetector(
                                   child: CachedNetworkImage(
                                   imageUrl: "${image[index]["FilePath"]}",
                        placeholder:  (context, url) =>
                        CustomLoader(),
                        /*progressIndicatorBuilder:(context, url, downloadProgress)=> Container(
                        margin: EdgeInsets.only(
                        top: 100,
                        bottom: 100,),
                        child: CustomLoader()),*/
                        errorWidget: (context, url, error) =>
                        Icon(Icons.error,),
                        fit:BoxFit.cover),
                                   onTap: (){
                                     Navigator.push(context,
                                         MaterialPageRoute(builder: (context) => FullPhotoViewPage(photoUrl: "${image[index]["FilePath"]}")));
                                   },

                                 ),
                             ),
                              ),
                              Divider(),
                              Padding(
                                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 100.0,
                                      child: Text(
                                        "${image[index]["File"]}",
                                        style: const TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          fontStyle: FontStyle.normal,
                                          color: AppColors.black,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                   return  Align(
                      alignment: Alignment.center,
                      child: NoDataFound(),
                    );
                  }

                } else {
                  return Container();
                }
              }),
        ),
      ),
    );
  }

  manageImageList() async {
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
              itemList = response.data["attribute"];
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


//////TODO Image By User Id/////


class GalleryByIdScreen extends StatefulWidget {
  final String userId;
  const GalleryByIdScreen(this.userId, {Key? key}) : super(key: key);

  @override
  State<GalleryByIdScreen> createState() => _GalleryByIdScreenState();
}

class _GalleryByIdScreenState extends State<GalleryByIdScreen> {
  List itemList = [];
  List image = [];
  bool _isFirstLoadRunning = false;

  @override
  void initState() {
    super.initState();
    manageImageList(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      edgeOffset: 20,
      onRefresh: () async{
        await Future.delayed(Duration(milliseconds: 1500));
        setState(() {
          manageImageList(widget.userId);
        });
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
          child: _isFirstLoadRunning
              ? itemList.isEmpty
              ? Align(
            alignment: Alignment.center,
            child: CustomLoader(),
          ) :
          Align(
            alignment: Alignment.center,
            child: NoDataFound(),
          ) : ListView.builder(
              shrinkWrap: false,
              itemCount: itemList.length,
              itemBuilder: (context, index) {
                var item = itemList[index];
                print("video ${item["displayGroup"]}");
                if (item["displayGroup"] == "Images") {
                  image = item["value"];
                  print("Videos data ====<> $image");
                  return GridView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    itemCount: image.length,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 250,
                      childAspectRatio: 1,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                       color: Colors.white,
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(15),
                       ),
                       child: Column(
                         children: [
                       ClipRRect(
                         borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                         child: GestureDetector(
                           child: CachedNetworkImage(
                               imageUrl: "${image[index]["FilePath"]}",
                               placeholder:  (context, url) => CustomLoader(),
                               errorWidget: (context, url, error) => Icon(Icons.error,),
                               fit:BoxFit.cover),
                           onTap: (){
                             Navigator.push(context,
                                 MaterialPageRoute(builder: (context) => FullPhotoViewPage(photoUrl: "${image[index]["FilePath"]}")));
                           },
                         ),
                       ),
                         ],
                       ),
                      );
                    },
                  );
                } else {
                  return Container();
                }
              }),
        ),
      ),
    );
  }

  manageImageList(String userId) async {
    log('this is Manage_Profile  api call', name: "Manage_Profile");
    MyApplication.getInstance()!
        .checkConnectivity(context)
        .then((internet) async {
      if (internet != null && internet) {
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
              itemList = response.data["attribute"];
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


