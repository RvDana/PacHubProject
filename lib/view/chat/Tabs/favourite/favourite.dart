import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:pachub/Utils/appcolors.dart';
import 'package:pachub/Utils/images.dart';
import 'package:pachub/common_widget/nodatafound_page.dart';
import 'package:pachub/common_widget/textstyle.dart';
import 'package:pachub/models/ChatModel/chatUsersModel.dart';

import '../../../../common_widget/customloader.dart';
import '../../../../config/preference.dart';
import '../../../../models/AllChatModel/all_chat_list_model.dart';
import '../../../../models/new_allchatlist_model.dart';
import '../../../../services/request.dart';
import '../Inbox/inbox_chat_screen.dart';
import 'favourite_msg_screen.dart';

class Favourite extends StatefulWidget {

  const Favourite({super.key,});


  @override
  State<Favourite> createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  String? accessToken;
  @override
  void initState() {
    setState(() {
      accessToken = PreferenceUtils.getString("accesstoken");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      messagelist_listviewbuilder(),
    );
  }
  Widget messagelist_listviewbuilder(){
    return FutureBuilder(
      future: getallChatList(accessToken),
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
              List<FavoriteMessage_new>? records = snapshot.data?.favoriteMessage;
              if (records != null) {
                return records.isNotEmpty
                    ? ListView.builder(
                  padding: const EdgeInsets.only(top: 20),
                  shrinkWrap: true,
                  itemCount: records.length,
                  itemBuilder: (context, index) {
                    final item = records[index];
                    // DateTime joiningDate =
                    // DateTime.parse(item.createdDate.toString());
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Get.to(FavoritemsgChatScreen(
                              sender : item.picturePathS3.toString(),
                              online : true,
                              name : item.displayName.toString(),
                              selected : true,
                              recieverid: item.receiverID.toString(),
                              senderid: item.senderID.toString(),
                            ));
                          },
                          onLongPress: () {
                            setState(() {
                              /*chat.isSelected = !chat.isSelected;
                              widget.isSelected(!chat.isSelected);*/
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10, top: 0),
                            child: Row(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(4),
                                      height: 50,
                                      width: 50,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10000.0),
                                        child: Image.network("${item.picturePathS3}", fit: BoxFit.cover,
                                          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                            print("Exception >> ${exception.toString()}");
                                            return Image.asset(userImage);
                                          },),
                                      ),
                                    ),
                                    /*chat.isSelected
                                        ? Positioned(
                                      bottom: -1,
                                      right: -1,
                                      child: SvgPicture.asset(
                                        checkCircle,
                                        height: 16,
                                        width: 16,
                                      ),
                                    )
                                        : Positioned(
                                      bottom: -1,
                                      right: 0,
                                      child: chat.sender!.isOnline
                                          ? const CircleAvatar(
                                        backgroundColor: AppColors.white,
                                        radius: 6,
                                        child: CircleAvatar(
                                          backgroundColor: AppColors.green,
                                          radius: 4,
                                        ),
                                      )
                                          : const CircleAvatar(
                                        backgroundColor: AppColors.white,
                                        radius: 6,
                                        child: CircleAvatar(
                                          backgroundColor:
                                          AppColors.grey_hint_color,
                                          radius: 4,
                                        ),
                                      ),
                                    ),*/
                                  ],
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CommonText(
                                          text: item.displayName.toString(),
                                          fontSize: 12,
                                          color: AppColors.black_txcolor,
                                          fontWeight: FontWeight.w600),
                                      // CommonText(
                                      //     text: item.text.toString(),
                                      //     fontSize: 10,
                                      //     color: AppColors.blacksubtext_color,
                                      //     fontWeight: FontWeight.w500),
                                      // const SizedBox(height: 16),
                                      // CommonText(
                                      //     text: item.text.toString(),
                                      //     fontSize: 12,
                                      //     color: AppColors.blacksubtext_color,
                                      //     fontWeight: FontWeight.w500),
                                    ],
                                  ),
                                ),
                                // Column(
                                //   crossAxisAlignment: CrossAxisAlignment.end,
                                //   children: [
                                //     CommonText(
                                //       text: "${DateFormat('jm').format(joiningDate)}",
                                //       fontSize: 11,
                                //       color: AppColors.green,
                                //       /*color: chat.unread
                                //           ? AppColors.green
                                //           : AppColors.grey_hint_color,*/
                                //       fontWeight: FontWeight.w500,
                                //     ),
                                //     /*const SizedBox(height: 7),
                                //     chat.unread
                                //         ? const CircleAvatar(
                                //       backgroundColor: AppColors.green,
                                //       radius: 8,
                                //       child: CommonText(
                                //           text: "0",
                                //           fontSize: 8,
                                //           color: AppColors.white,
                                //           fontWeight: FontWeight.w600),
                                //     )
                                //         : Container(),*/
                                //   ],
                                // ),
                              ],
                            ),
                          ),
                        ),
                        const Divider(color: Color(0xffCBCBCB), thickness: 1),
                      ],
                    );
                  },
                )
                    : const Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Center(
                      child: NoDataFound(),
                  ),
                );
              }
            } else {
              return const Center(
                  child:Center(
                      child: NoDataFound(),
                  ),);
            }
        }
        return const Center(
            child: Center(
                child: NoDataFound(),
            ),);
      },
    );
  }

}
