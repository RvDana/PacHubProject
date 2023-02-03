import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pachub/Utils/appcolors.dart';
import 'package:pachub/Utils/images.dart';
import 'package:pachub/common_widget/TextField.dart';
import 'package:pachub/common_widget/nodatafound_page.dart';
import 'package:pachub/common_widget/textstyle.dart';
import 'package:pachub/models/ChatModel/chatUsersModel.dart';
import 'package:pachub/models/ChatModel/user.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:pachub/models/mychatlistmodel/mychatlistmodel.dart';

import '../../../../Utils/appstring.dart';
import '../../../../common_widget/customloader.dart';
import '../../../../config/preference.dart';
import '../../../../services/request.dart';

class DeleteChatScreen extends StatefulWidget {
  final String? sender;
  final bool online;
  final String name;
  final bool selected;
  final String recieverid;
  final String senderid;

  const DeleteChatScreen(
      {Key? key,
        this.sender,
        required this.online,
        required this.name,
        required this.selected,
        required this.recieverid,
        required this.senderid})
      : super(key: key);

  @override
  State<DeleteChatScreen> createState() => _DeleteMSgInboxChatScreenState();
}

class _DeleteMSgInboxChatScreenState extends State<DeleteChatScreen> {
  int? prevUserId;
  List<int> selectedItems = [];
  int isSelected = 0;
  final ScrollController _messagegListController = ScrollController();
  int lastMessageId = -1;

  String? accessToken;

  @override
  void initState() {

    setState(() {
      accessToken = PreferenceUtils.getString("accesstoken");
    });
    super.initState();
    scrollDown();
  }

  @override
  void dispose() {
    super.dispose();
  }

  scrollDown() {
    Timer(Duration(milliseconds: 100), () {
      try {
        _messagegListController .jumpTo(_messagegListController.position.maxScrollExtent);
      }
      catch(e) {
        print("########################### FAIL ###########################");
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.drawer_bottom_text_color,
        automaticallyImplyLeading: true,
        leadingWidth: 30,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back,
              color: AppColors.white,
            )
        ),
        title: Row(
          children: [
            Stack(
              children: [
                Container(
                    padding: EdgeInsets.all(4),
                    height: 35,
                    width: 35,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10000.0),
                        child:
                        Image.network(
                          widget.sender.toString(),
                          fit: BoxFit.cover,
                          height: 35,
                          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                            print("Exception >> ${exception.toString()}");
                            return Image.asset(userImage);
                          },
                        ))),
                Positioned(
                  bottom: -1,
                  right: 0,
                  child: widget.online
                      ? const CircleAvatar(
                    backgroundColor: AppColors.drawer_bottom_text_color,
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
                      backgroundColor: AppColors.grey_hint_color,
                      radius: 4,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 15),
            Expanded(
              child: CommonText(
                  text: widget.name,
                  fontSize: 20,
                  color: AppColors.white,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actions: [
          /* Padding(
            padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
            child: GestureDetector(
              onTap: () {},
              child: SvgPicture.asset(deleteIcon),
            ),
          ),*/
        ],
      ),
      body: Column(
        children: [
          Expanded(child: Send_ChatListviewBuilder()),
        ],
      ),
    );
  }


  Widget Send_ChatListviewBuilder(){
    return Padding(
      padding: EdgeInsets.all(1),
      child: FutureBuilder<MYMessagechatlistingModel?>(
        future: ChatMessageApi(accessToken,widget.senderid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            const Center(
              child: NoDataFound(),
            );
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Container();
            case ConnectionState.done:
              if (snapshot.hasData) {
                print("this is msg lengeth ====<> ${snapshot.data?.result?.length}");
                List<MychatResult>? chatresult = snapshot.data?.result;
                if (chatresult != null) {
                  MychatResult lastMessage = chatresult!.last;
                  lastMessageId = chatresult!.lastIndexOf(lastMessage);
                  scrollDown();
                  if (chatresult != null) {
                    return ListView.builder(
                      controller: _messagegListController,
                      padding: const EdgeInsets.only(top: 20),
                      shrinkWrap: true,
                      itemCount: chatresult.length,
                      itemBuilder: (context, index) {
                        final item = chatresult[index];
                        return item.isDeleted==true?
                        ChatBubble(
                          elevation: 0,
                          clipper: ChatBubbleClipper1(type: BubbleType.receiverBubble),
                          backGroundColor: AppColors.ligt_grey_color,
                          margin: EdgeInsets.only(top: 20, right: 100, left: 5),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: CommonText(
                                          text: item.message.toString(),
                                          fontSize: 14,
                                          color: AppColors.black_txcolor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),

                              ],
                            ),
                          ),
                        ):Container();
                      },
                    );
                  }}
              }
              else {
                return const Center(
                  child: NoDataFound(),
                );
              }
          }
          return const Center(
            child: NoDataFound(),
          );
        },
      ),
    );

  }


}
