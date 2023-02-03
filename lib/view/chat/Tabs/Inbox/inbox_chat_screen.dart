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

class InboxChatScreen extends StatefulWidget {
  final String? sender;
  final bool online;
  final String name;
  final bool selected;
  final String recieverid;
  final String senderid;

  const InboxChatScreen(
      {Key? key,
      this.sender,
      required this.online,
      required this.name,
      required this.selected,
      required this.recieverid,
        required this.senderid})
      : super(key: key);

  @override
  State<InboxChatScreen> createState() => _InboxChatScreenState();
}

class _InboxChatScreenState extends State<InboxChatScreen> {
  TextEditingController sendMessage = TextEditingController();
  int? prevUserId;
  List<int> selectedItems = [];
  int isSelected = 0;
  final ScrollController _messagegListController = ScrollController();
  int lastMessageId = -1;

  String? accessToken;

  @override
  void initState() {
    sendMessage.text = '';
    sendMessage.addListener(() {
      /*setState(() {

      });*/
    });
    setState(() {
      accessToken = PreferenceUtils.getString("accesstoken");
    });
    super.initState();
    scrollDown();
  }

  @override
  void dispose() {
    sendMessage.dispose();
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
          _buildBottom(),
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
                     return item.status=="Send"?
                       ChatBubble(
                        elevation: 0,
                        clipper: ChatBubbleClipper1(type: BubbleType.sendBubble),
                        alignment: Alignment.topRight,
                        backGroundColor: AppColors.drawer_bottom_text_color,
                        margin: EdgeInsets.only(top: 10, right: 10, left: 0),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            //mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Flexible(
                                    child: CommonText(
                                        text: item.message.toString(),
                                        fontSize: 14,
                                        color: AppColors.white,
                                        fontWeight: FontWeight.w500),
                                  ),

                        Container(
                          width: 20,
                          child: PopupMenuButton(
                            iconSize: 20,
                            icon: Icon(Icons.keyboard_arrow_down,color: AppColors.white,),
                            itemBuilder:
                                (context) {
                              return [
                               /* PopupMenuItem<int>(
                                  value: 0,
                                  child: Row(
                                    children: const [
                                      Icon(
                                          Icons.favorite,
                                          color: AppColors
                                              .dark_red),
                                      SizedBox(
                                          width:
                                          10),
                                      CommonText(
                                          text:
                                          "favourite",
                                          fontSize:
                                          15,
                                          color: AppColors
                                              .black_txcolor,
                                          fontWeight:
                                          FontWeight.w400),
                                    ],
                                  ),
                                ),*/
                                PopupMenuItem<int>(
                                  value: 0,
                                  child: Row(
                                    children: const [
                                      Icon(
                                          Icons.delete_outlined,
                                          color: AppColors
                                              .black_txcolor),
                                      SizedBox(
                                          width:
                                          10),
                                      CommonText(
                                          text:
                                          "Delete",
                                          fontSize:
                                          15,
                                          color: AppColors
                                              .black_txcolor,
                                          fontWeight:
                                          FontWeight.w400),
                                    ],
                                  ),
                                ),
                              ];
                            },
                            onSelected: (value) {
                              if (value == 0) {
                                DeleteMessageDialog(item.messageID.toString());
                                print("My account menu is selected.");
                                //FavouriteMessageApi(accessToken,item.messageID.toString(),context);
                                //ReadMessageApi(item.messageID,context);
                              }
                              /*else{
                                DeleteMessageDialog(item.messageID.toString());

                              }*/
                            },
                          ),
                        ),
                                  SizedBox(width: 5,),
                                  /*Icon(
                                    Icons.keyboard_arrow_down,
                                    color: AppColors.white,
                                  ),*/

                                ],
                              ),

                              SizedBox(height: 5),

                            ],
                          ),
                        ),
                      ):item.status=="Receive"&&item.isDeleted==false?
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
                                 Flexible(
                                   child: CommonText(
                                       text: item.message.toString(),
                                       fontSize: 14,
                                       color: AppColors.black_txcolor,
                                       fontWeight: FontWeight.w500),
                                 ),
                                 Container(
                                   width: 20,
                                   child: PopupMenuButton(
                                     iconSize: 20,
                                     icon: Icon(Icons.keyboard_arrow_down,color: AppColors.black,),
                                     itemBuilder:
                                         (context) {
                                       return [
                                          PopupMenuItem<int>(
                                  value: 0,
                                  child: Row(
                                    children: const [
                                      Icon(
                                          Icons.fact_check_outlined,
                                      ),
                                      SizedBox(
                                          width:
                                          10),
                                      CommonText(
                                          text:
                                          "favourite",
                                          fontSize:
                                          15,
                                          color: AppColors
                                              .black_txcolor,
                                          fontWeight:
                                          FontWeight.w400),
                                    ],
                                  ),
                                ),
                                         PopupMenuItem<int>(
                                           value: 1,
                                           child: Row(
                                             children: const [
                                               Icon(
                                                   Icons.delete_outlined,
                                                   color: AppColors
                                                       .black_txcolor),
                                               SizedBox(
                                                   width:
                                                   10),
                                               CommonText(
                                                   text:
                                                   "Delete",
                                                   fontSize:
                                                   15,
                                                   color: AppColors
                                                       .black_txcolor,
                                                   fontWeight:
                                                   FontWeight.w400),
                                             ],
                                           ),
                                         ),
                                       ];
                                     },
                                     onSelected: (value) {
                                       if (value == 0) {
                                         FavouriteMessageApi(accessToken,item.messageID.toString(),context);
                                         //ReadMessageApi(item.messageID,context);
                                       }
                                       else{
                                         SOFT_DeleteMessageDialog(item.messageID.toString());

                              }
                                     },
                                   ),
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


  _buildBottom() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextFieldSendMessage(sendMessage: sendMessage),
            _buildContainer(),
          ],
        ),
      ),
    );
  }

  _buildContainer() {
    return GestureDetector(
      onTap: () {
        setState(() {
          print("this is sender id ${widget.senderid}");
          SendMessageApi(accessToken,widget.senderid,sendMessage.text,context,);
          sendMessage.clear();
         // Send_ChatListviewBuilder();
        });

        /*final message = Message(
          sender: currentUser,
          time: DateFormat.jm().format(DateTime.now()),
          text: sendMessage.text,
          unread: true,
          email: '@jane',
          isSelected: false,
          isSentByMe: true,
        );
        setState(() {
          messages.add(message);
          sendMessage.clear();
        });*/
      },
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color:  AppColors.drawer_bottom_text_color,
         /* color: sendMessage.text.isEmpty
              ? AppColors.ligt_grey_color
              : AppColors.drawer_bottom_text_color,*/
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
          child: SvgPicture.asset(
            sendIcon,
            color:  AppColors.white,
            /*color: sendMessage.text.isEmpty
                ? AppColors.grey_hint_color
                : AppColors.white,*/
          ),
        ),
      ),
    );
  }

  Future<bool> DeleteMessageDialog(String messageid) async {
    final shouldPop = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0)),
            elevation: 0.0,
            backgroundColor: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: AppColors.dark_blue_button_color,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      )),
                  child: Center(
                    child: Text("Confirmation",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            color: AppColors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Center(
                    child: Text(
                      AppString.deletemsgpermisiontx,
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            print("this is message id==>${messageid}");
                            //DeleteMessageApi(accessToken,messageid,context);
                            HARD_DeleteMessageApi(accessToken,messageid,context);
                            Navigator.pop(context, false);

                          });
                        },
                        child: Container(
                            padding: EdgeInsets.all(10),
                            //height: 25,
                            //width: 45.0,
                            decoration: BoxDecoration(
                              color: AppColors.dark_blue_button_color,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                                child: Text(
                                  "Confirm",
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.center,
                                ))),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context, false);
                        },
                        child: Container(
                            padding: EdgeInsets.all(10),
                            //height: 25,
                            //width: 45.0,
                            decoration: BoxDecoration(
                              color: AppColors.dark_blue_button_color,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                                child: Text(
                                  " cancel",
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.center,
                                ))),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });

    return shouldPop ?? false;
  }
  Future<bool> SOFT_DeleteMessageDialog(String messageid) async {
    final shouldPop = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0)),
            elevation: 0.0,
            backgroundColor: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: AppColors.dark_blue_button_color,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      )),
                  child: Center(
                    child: Text("Confirmation",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            color: AppColors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Center(
                    child: Text(
                      AppString.deletemsgpermisiontx,
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            print("this is message id==>${messageid}");
                            DeleteMessageApi(accessToken,messageid,context);
                            Navigator.pop(context, false);

                          });
                        },
                        child: Container(
                            padding: EdgeInsets.all(10),
                            //height: 25,
                            //width: 45.0,
                            decoration: BoxDecoration(
                              color: AppColors.dark_blue_button_color,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                                child: Text(
                                  "Confirm",
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.center,
                                ))),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context, false);
                        },
                        child: Container(
                            padding: EdgeInsets.all(10),
                            //height: 25,
                            //width: 45.0,
                            decoration: BoxDecoration(
                              color: AppColors.dark_blue_button_color,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                                child: Text(
                                  " cancel",
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.center,
                                ))),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });

    return shouldPop ?? false;
  }
}
