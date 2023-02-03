import 'package:flutter/material.dart';

class CommonText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final fontWeight;

  const CommonText({
    super.key,
    required this.text,
    required this.fontSize,
    required this.color,
    required this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: FontStyle.normal,
        color: color,
      ),
    );
  }
}

class CommonTextSecond extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final  fontWeight;

  const CommonTextSecond({
    super.key,
    required this.text,
    required this.fontSize,
    required this.color,
    required this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: FontStyle.normal,
        color: color,
      ),
      textAlign: TextAlign.center,
    );
  }
}


class CommonTextspace extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final  fontWeight;

  const CommonTextspace({
    super.key,
    required this.text,
    required this.fontSize,
    required this.color,
    required this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: fontSize,
          fontWeight: fontWeight,
          fontStyle: FontStyle.normal,
          color: color,
        ),
        overflow: TextOverflow.fade,
      ),
    );
  }
}


