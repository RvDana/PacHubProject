import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pachub/Utils/appcolors.dart';
import 'package:pachub/Utils/images.dart';
import 'package:pachub/common_widget/nodatafound_page.dart';
import 'package:pachub/common_widget/textstyle.dart';
import 'package:pachub/models/AllChatModel/all_chat_list_model.dart';
import 'package:pachub/services/request.dart';
import 'package:pachub/view/chat/Tabs/Inbox/inbox_chat_screen.dart';
import '../../../../common_widget/customloader.dart';
import '../../../../config/preference.dart';
import '../../../../models/new_allchatlist_model.dart';

class Inbox extends StatefulWidget {

  const Inbox({super.key});

  @override
  State<Inbox> createState() => _InboxState();
}

class _InboxState extends State<Inbox> {
  // bool isSelected = false;
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
      body: PreferenceUtils.getString("plan") == "Free"?Center(
        child: NoDataFound(),
      ):
      messagelist_listviewbuilder()

    );
  }
  Widget messagelist_listviewbuilder(){
    return FutureBuilder(
      future: getallChatList(accessToken),
      //future: myFutureList,
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
              List<Chats>? records = snapshot.data?.chats;
              if (records != null) {
                return records.isNotEmpty
                    ? ListView.builder(
                  padding: const EdgeInsets.only(top: 20),
                  shrinkWrap: true,
                  itemCount: records.length,
                  itemBuilder: (context, index) {
                    final item = records[index];
                    /*DateTime joiningDate =
                  DateTime.parse(item.createdDate.toString());*/
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Get.to(InboxChatScreen(
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
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(4),
                                      height: 50,
                                      width: 50,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10000.0),
                                        child: CachedNetworkImage(
                                          height: 40,
                                          width: 40,
                                          fit: BoxFit.cover,
                                          imageUrl: item.picturePathS3??"",
                                          errorWidget: (context, url, error) =>Image.asset(
                                            avatarImage,
                                            height: 40,
                                            width: 40,
                                          ),
                                          placeholder: (context, url) => CustomLoader(),

                                        ),
                                        /*child: Image.network("${item.picturePathS3!=null?item.picturePathS3:""}", fit: BoxFit.cover,
                                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                          print("Exception >> ${exception.toString()}");
                                          return Image.asset(userImage);
                                        },),*/
                                      ),
                                    ),
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
                                      /*CommonText(
                                        text: item.text.toString(),
                                        fontSize: 10,
                                        color: AppColors.blacksubtext_color,
                                        fontWeight: FontWeight.w500),*/
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    /* CommonText(
                                    text: joiningDate==DateTime.now().day-1?
                                    "Yesterday":DateFormat('jm').format(joiningDate),
                                    fontSize: 11,
                                    color: AppColors.green,
                                    *//*color: chat.unread
                                        ? AppColors.green
                                        : AppColors.grey_hint_color,*//*
                                    fontWeight: FontWeight.w500,
                                  ),*/
                                  ],
                                ),
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
                      child: NoDataFound()),
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
      },
    );
  }
}
