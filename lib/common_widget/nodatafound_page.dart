import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:pachub/common_widget/textstyle.dart';

import '../Utils/appcolors.dart';
import '../Utils/appstring.dart';

class NoDataFound extends StatefulWidget {
  const NoDataFound({Key? key}) : super(key: key);

  @override
  State<NoDataFound> createState() => _NoDataFoundState();
}

class _NoDataFoundState extends State<NoDataFound> with SingleTickerProviderStateMixin{
  late AnimationController lottieController;
  @override
  void initState() {
    super.initState();
    lottieController = AnimationController(
      vsync: this,
    );

    lottieController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        //Navigator.pop(context);
        lottieController.reset();
      }
    });
  }

  @override
  void dispose() {
    lottieController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: AppColors.bacgroundcolor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset("assets/notfound.json",repeat: true,
                height: 200,
                width: 200,
                controller: lottieController,
                onLoaded: (composition) {
                  lottieController.duration = composition.duration;
                  lottieController.forward();
                }),
            /*Image.asset(
              nodatafound
            ),*/
            SizedBox(height: 5,),
            const CommonText(
              text: AppString.noresultfound,
              fontSize: 16,
              color: AppColors.black_txcolor,
              fontWeight: FontWeight.w600,
            ),
            const CommonText(
              text: AppString.wenotfindtx,
              fontSize: 14,
              color: AppColors.grey_text_color,
              fontWeight: FontWeight.w400,
            ),
          ],

        ),
      ),
    );
  }
}
