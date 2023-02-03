import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pachub/Utils/appcolors.dart';
import 'package:pachub/Utils/appstring.dart';
import 'package:pachub/common_widget/appbar.dart';
import 'package:pachub/config/preference.dart';
import 'package:pachub/models/ChatModel/chatUsersModel.dart';
import 'package:pachub/view/Athletes/athletes.dart';
import 'package:pachub/view/chat/Tabs/Delete/delete.dart';
import 'package:pachub/view/chat/Tabs/favourite/favourite.dart';
import 'package:pachub/view/chat/Tabs/Inbox/inbox.dart';
import 'package:get/get.dart';

import '../../Utils/images.dart';
import '../../models/AllChatModel/all_chat_list_model.dart';
import '../../services/request.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  String? accessToken;

  bool selected = false;
  List item = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      tabController = TabController(length: 3, vsync: this);
      accessToken = PreferenceUtils.getString("accesstoken");
    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatAppbar(
          onClick: () {
            Scaffold.of(context).openDrawer();
          },
          serchClick: () {},
          notifictionClick: () {},
          deleteClick: () {},
          widget: item.length < 1
              ? Row(
                  children: [
                    /*SvgPicture.asset(serach_icon,
                        color: Colors.white, height: 22),
                    SizedBox(width: 16),*/
                    SvgPicture.asset(notifiction),
                  ],
                )
              : Icon(
                  Icons.delete,
                  color: Colors.white,
                )),
      drawer: Drawer(),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                Inbox(),
                Favourite(),
                Delete(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildTabBar() {
    return Container(
      color: AppColors.drawer_bottom_text_color,
      height: 45,
      width: Get.width,
      child: TabBar(
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorColor: AppColors.orange,
        indicatorWeight: 4,
        unselectedLabelColor: AppColors.grey_hint_color,
        labelColor: AppColors.white,
        isScrollable: false,
        controller: tabController,
        /*tabs: List.generate(tabName.length, (index) {
          return Tab(
            child: Text(tabName[index]),
          );
        }),*/
        tabs:[
      Tab(
      child: FutureBuilder(
        future: getallChatList(accessToken),
        builder: (context, snapshot){
          if (snapshot.hasError) {
            return Container();
          }
          if(snapshot.data==null){
            return Container(
              child: Text("${AppString.inbox}"),
            );
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
              children:[
                Text("${AppString.inbox}"),
                SizedBox(width: 10),
                snapshot.data!.unReadMessages!.unReadMessages==0?
                    Container():
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                  alignment: Alignment.center,
                  //child: Text("2"),
                  child: Text("${snapshot.data!.unReadMessages!.unReadMessages}"),
                ),
              ] );
        },

      ),
      ),
          Tab(
      child: Text(AppString.favourite),

      ),Tab(
      child: Text(AppString.delete),

      )],
      ),
    );
  }
}
