import 'dart:ui';

import '../config/preference.dart';

Color hexToColor(String code) {
  print("${code} Text Color");
  try {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  } catch (e) {
    print(e);
  }
  throw {};
}

class AppColors {
  Color text_color = hexToColor(PreferenceUtils.getString("primary"));
  static const Color white = Color(0xffffffff);
  static const Color ligt_white_color = Color(0xFFFAFAFA);
  static const Color ligt_grey_color = Color(0xFFE7E8E9);
  static const Color onHold = Color(0xFFfff6e7);
  static const Color contacts_text_color = Color(0xFFF3F3F4);
  static const Color checkboxColor = Color(0xFFCFD1D4);
  static const Color rejected = Color(0xFFf0d4d2);
  static const Color light_blue_color = Color(0xFFF6F7FE);
  static const Color profileColor = Color(0xFF16191E08);
  static const Color black = Color(0xff000000);
  static const Color black_txcolor = Color(0xFF343639);
  static const Color grey_hint_color = Color(0xFF9FA3A9);
  static const Color grey_text_color = Color(0xFF5B5E62);
  static const Color blacksubtext_color = Color(0xFF5B5E62);
  static const Color bacgroundcolor =Color(0x00f5f5f5);





  static const Color orange = Color(0xFFFD9900);
  static const Color onHoldTextColor = Color(0xFFCE7D00);

  static const Color dark_red = Color(0xffFF443D);
  static const Color rejectedTextColor = Color(0xFFC83C34);
  static const Color contacts_card_color = Color(0xFFDA554E);


  static const Color blue_text_Color = Color(0xFF0067FF);
  static const Color dark_blue_button_color = Color(0xFF4558C6);
  static const Color drawer_bottom_text_color = Color(0xFF3243A7);
  static const Color matches_card_color = Color(0xFF7182E2);
  static const Color matches_card_color_new = Color(0xFFc0d7fc);
  static const Color blue_button_Color = Color(0xFF0067FF);
  static const Color dark_color = Color(0xFF263277);
  static const Color stats_title_blue =Color(0xFF5E5873);




  static const Color approvedbackground_Color = Color(0xFFcfeac8);
  static const Color approvedtext_Color = Color(0xFF187201);
  static const Color green = Color(0xff23AC00);
}
