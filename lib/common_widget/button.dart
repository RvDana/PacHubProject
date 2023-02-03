import 'package:flutter/material.dart';
import 'package:pachub/Utils/appcolors.dart';
class Button extends StatelessWidget {
  final  color;
  final Color  textColor;
  final String text;
  final dynamic onClick;
  const Button({super.key, required this.color, required this.text, this.onClick, required this.textColor});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
            elevation: 0,
          ),
          onPressed: onClick,
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w700,
              fontFamily: 'Montserrat',
            ),
            textAlign: TextAlign.center,
          )),
    );
  }
}




class BorderButton extends StatelessWidget {
  final  color;
  final Color  textColor;
  final String text;
  final dynamic onClick;
  final sideColor;
  final double fontSize;
  const BorderButton({super.key, required this.color, required this.text, this.onClick, required this.textColor, this.sideColor, required this.fontSize});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
              side: BorderSide(
                color: sideColor,
                width: 1,
              ),
            ),
            elevation: 0,
          ),
          onPressed: onClick,
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w700,
              fontFamily: 'Montserrat',
            ),
            textAlign: TextAlign.center,
          )),
    );
  }
}