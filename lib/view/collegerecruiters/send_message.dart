import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pachub/Utils/appcolors.dart';
import 'package:pachub/Utils/appstring.dart';
import 'package:pachub/Utils/images.dart';
import 'package:pachub/common_widget/TextField.dart';
import 'package:pachub/common_widget/appbar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pachub/common_widget/textstyle.dart';

class SendMessage extends StatefulWidget {
  const SendMessage({Key? key}) : super(key: key);

  @override
  State<SendMessage> createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  TextEditingController sendMessage = TextEditingController();
  bool checkedValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: DetailAppbar(
        text: AppString.sendMessage,
        onClick: () {
          Get.back();
        },
        onTap: () {
          Get.back();
        },
      ),
      body: _buildColumn(),
      bottomSheet: _buildBottom(),
    );
  }

  _buildContainer() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppColors.ligt_grey_color,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
          child: SvgPicture.asset(
            sendIcon,
            color: AppColors.grey_hint_color,
          ),
        ),
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

  _buildColumn() {
    return SingleChildScrollView(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 19, right: 19, bottom: 150, top: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset(
              userImage,
              height: 100,
              width: 100,
            ),
            const SizedBox(height: 12),
            const CommonText(
                text: AppString.user,
                fontSize: 20,
                color: AppColors.dark_blue_button_color,
                fontWeight: FontWeight.w600),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CommonText(
                    text: AppString.recruiter,
                    fontSize: 16,
                    color: AppColors.black_txcolor,
                    fontWeight: FontWeight.w600),
                CommonText(
                  text: AppString.recruiterText,
                  fontSize: 16,
                  color: AppColors.black_txcolor,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
            const SizedBox(height: 2),
            const CommonText(
                text: AppString.txt,
                fontSize: 15,
                color: AppColors.black_txcolor,
                fontWeight: FontWeight.normal),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 14,
                  width: 14,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Checkbox(
                    activeColor: AppColors.dark_blue_button_color,
                    checkColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    side: const BorderSide(color: AppColors.checkboxColor),
                    value: checkedValue,
                    onChanged: (newValue) {
                      setState(() {
                        checkedValue = newValue!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                const CommonText(
                    text: AppString.markAsApplication,
                    fontSize: 12,
                    color: AppColors.black_txcolor,
                    fontWeight: FontWeight.w400),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
