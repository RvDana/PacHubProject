import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pachub/Utils/appstring.dart';
import 'package:pachub/common_widget/textstyle.dart';
import '../Utils/appcolors.dart';
import '../Utils/images.dart';

class Appbar extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  final onClick;

  const Appbar({super.key, required this.text, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.drawer_bottom_text_color,
      elevation: 0,
      leading: Builder(
        builder: (BuildContext context) {
          return InkWell(
            onTap: onClick,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17),
              child: SvgPicture.asset(
                hamburger,
              ),
            ),
          );
        },
      ),
      title: CommonText(
          text: text,
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.w500),
      // actions: [
      //   Padding(
      //     padding: const EdgeInsets.only(
      //         left: 8.33, right: 7.23, top: 8.33, bottom: 5.33),
      //     child: SvgPicture.asset(notifiction),
      //   ),
      // ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class DetailAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  final onClick;
  final onTap;

  const DetailAppbar({super.key, required this.text, required this.onClick, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.ligt_white_color,
      elevation: 0.5,
      leading: IconButton(
          onPressed: onClick,
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.black_txcolor,
          )),
      title: CommonText(
          text: text,
          fontSize: 20,
          color: AppColors.black_txcolor,
          fontWeight: FontWeight.w500),
      // actions: [
      //   Padding(
      //     padding: const EdgeInsets.only(right: 18),
      //     child: GestureDetector(
      //       onTap: onTap,
      //       child: SvgPicture.asset(close),
      //     ),
      //   ),
      // ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}



class ChatAppbar extends StatelessWidget implements PreferredSizeWidget {
  final onClick;
  final serchClick;
  final notifictionClick;
  final deleteClick;
  final dynamic widget;

  const ChatAppbar({super.key, required this.onClick, required this.serchClick, required this.notifictionClick, required this.deleteClick, required this.widget});



  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.drawer_bottom_text_color,
      elevation: 0,
      leading: Builder(
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: onClick,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17),
              child: SvgPicture.asset(
                hamburger,
              ),
            ),
          );
        },
      ),
      title: CommonText(
          text: AppString.messages,
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.w500),
      // actions: [
      //   Padding(
      //     padding: const EdgeInsets.only(
      //         left: 8.33, right: 7.23, top: 8.33, bottom: 5.33),
      //     child: widget,
      //   ),
      // ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

