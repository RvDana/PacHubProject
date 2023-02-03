import 'package:dynamic_fa_icons/dynamic_fa_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pachub/common_widget/textstyle.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DrawerRowWidgets extends StatelessWidget {
  final String image;
  final String text;
  final dynamic textColor;
  final dynamic color;

  const DrawerRowWidgets(
      {super.key,
      required this.image,
      required this.text,
      this.textColor,
      this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FaIcon(DynamicFaIcons.getIconFromName(image),color: color, size: 15,),
        // SvgPicture.asset(image, color: color),
        SizedBox(width: 12),
        CommonText(
          text: text,
          fontSize: 16,
          color: textColor,
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }
}
