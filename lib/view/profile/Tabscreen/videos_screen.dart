import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pachub/Utils/appcolors.dart';
import 'package:pachub/Utils/appstring.dart';
import 'package:pachub/Utils/images.dart';
import 'package:pachub/common_widget/textstyle.dart';
import 'package:pachub/config/preference.dart';
import 'package:pachub/services/request.dart';
import 'package:pachub/view/login/login_view.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flick_video_player/flick_video_player.dart';
import '../../../Utils/constant.dart';
import '../../../app_function/MyAppFunction.dart';
import '../../../common_widget/customloader.dart';
import '../../../common_widget/nodatafound_page.dart';

class VideosScreen extends StatefulWidget {
  const VideosScreen({Key? key}) : super(key: key);

  @override
  State<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  String? accessToken;
  String? roleName;
  List itemList = [];
  List videos = [];
  bool _isFirstLoadRunning = false;

  late VideoPlayerController _videoPlayerController;
  late Future<void> _initializeVideoPlayerFuture;
  FlickManager? flickManager;



  @override
  void initState() {
    _videoPlayerController = VideoPlayerController.network
      (PreferenceUtils.getString("FilePath").toString());
    _initializeVideoPlayerFuture = _videoPlayerController.initialize();
    _videoPlayerController.setLooping(true);
    setState(() {
      accessToken = PreferenceUtils.getString("accesstoken");
      roleName = PreferenceUtils.getString("role");
    });
    super.initState();
    ManageVedioList();
    /*_chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio:5/8,
      autoInitialize: true,
      autoPlay: widget.autoplay,
      looping: widget.looping,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );*/


  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    flickManager?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      edgeOffset: 20,
      onRefresh: () async{
        await Future.delayed(Duration(milliseconds: 1500));
        setState(() {
          ManageVedioList();
        });
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 0),
          child: _isFirstLoadRunning
              ? itemList.isEmpty
                  ? Align(
                      alignment: Alignment.center,
                      child: CustomLoader(),
                    )
                  : const Align(
            alignment: Alignment.center,
            child: NoDataFound(),
          ): ListView.builder(
                      shrinkWrap: false,
                      itemCount: itemList.length,
                      //list<string> lstDisplayGroups = itemList.select(i => i.displaygroup).orderby(i =>i.displaylevel)
                      itemBuilder: (context, index) {
                        var item = itemList[index];
                        print("video ${item["displayGroup"]}");
                        if (item["displayGroup"] == "Videos") {
                          videos = item["value"] ?? [];
                          print("Videos data ====<> $videos");
                          // String videolink= videos[index]["FilePath"];
                          // final String _encoded = Uri.encodeFull(videolink);
                          // print("this is video link $videolink");
                          if(videos.isNotEmpty) {
                            return ListView.builder(
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: videos.length,
                              itemBuilder: (context, index) {
                                PreferenceUtils.setString("FilePath", videos[index]["FilePath"]);
                                String videolink= videos[index]["FilePath"];
                                final String _encoded = Uri.encodeFull(videolink);
                                return Card(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(15),
                                          topLeft: Radius.circular(15),
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.black,
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          height: 320,
                                          child: FlickVideoPlayer(
                                            flickManager: FlickManager(
                                              autoPlay: false,
                                              videoPlayerController:
                                              VideoPlayerController.network(
                                                  "$_encoded"),
                                            ),
                                            flickVideoWithControls: FlickVideoWithControls(
                                              videoFit: BoxFit.fill,
                                              backgroundColor: Colors.black,
                                              controls: FlickPortraitControls(
                                                progressBarSettings:
                                                FlickProgressBarSettings(playedColor: Colors.green),
                                              ),
                                            ),
                                          ),


                                )),
                                      SizedBox(height: 10),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: 200.0,
                                              child: Text(
                                                "${videos[index]["File"]}",
                                                style: TextStyle(
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
                            return Align(
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

  ManageVedioList() async {
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
          } else if (response.statusCode == 401) {
            return Get.offAll(Loginscreennew());
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
//////TODO Video By User Id/////
class VideosByIdScreen extends StatefulWidget {
  final String userId;
  const VideosByIdScreen(this.userId, {Key? key}) : super(key: key);

  @override
  State<VideosByIdScreen> createState() => _VideosByIdScreenState();
}

class _VideosByIdScreenState extends State<VideosByIdScreen> {
  String? accessToken;
  String? roleName;
  List itemList = [];
  List videos = [];
  bool _isFirstLoadRunning = false;

  late VideoPlayerController _videoPlayerController;
  late Future<void> _initializeVideoPlayerFuture;
  FlickManager? flickManager;

  @override
  void initState() {
    _videoPlayerController = VideoPlayerController.network
      (PreferenceUtils.getString("FilePath").toString());
    _initializeVideoPlayerFuture = _videoPlayerController.initialize();
    _videoPlayerController.setLooping(true);
    setState(() {
      accessToken = PreferenceUtils.getString("accesstoken");
      roleName = PreferenceUtils.getString("role");
    });
    super.initState();
    ManageVedioList(widget.userId); //Manage_Profile(userid);
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    flickManager?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("----++++======<>< ${widget.userId}");
    return RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      edgeOffset: 20,
      onRefresh: () async{
        await Future.delayed(Duration(milliseconds: 1500));
        setState(() {
          ManageVedioList(widget.userId);
        });
      },
      child: Scaffold(
        body: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: itemList.length,
            itemBuilder: (context, index) {
              var item = itemList[index];
              print("video ${item["displayGroup"]}");
              if (item["displayGroup"] == "Videos") {
                videos = item["value"] ?? [];
                print("Videos data ====<> $videos");
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: videos.length,
                  itemBuilder: (context, index) {
                    PreferenceUtils.setString("FilePath", videos[index]["FilePath"]);
                    String videolink= videos[index]["FilePath"];
                    final String _encoded = Uri.encodeFull(videolink);
                    if(videos.isNotEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15)
                            ),
                            width: 200,
                            child: FlickVideoPlayer(
                              flickManager: FlickManager(
                                autoPlay: false,
                                videoPlayerController:
                                VideoPlayerController.network(
                                    "$_encoded"),
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Text("No Data Found");
                    }

                  },
                );
              } else {
                return Container();
              }
            }),
      ),
    );
  }

  ManageVedioList(String userId) async {
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
          } else if (response.statusCode == 401) {
            return Get.offAll(Loginscreennew());
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
