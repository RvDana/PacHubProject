import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pachub/Utils/appcolors.dart';
import 'package:pachub/Utils/appstring.dart';
import 'package:pachub/Utils/images.dart';

class TextFieldView extends StatelessWidget {
  final dynamic controller;
  final dynamic type;
  final String? text;
  final dynamic validator;
  final dynamic textInputAction;
  final onChanged;

  const TextFieldView({
    super.key,
    this.controller,
    this.type,
    this.text,
    this.validator,
    this.textInputAction,
    this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'\s')),
      ],
      autocorrect: true,
      onChanged: onChanged,
      textInputAction: TextInputAction.next,
      validator: validator,
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        hintText: text,
        hintStyle: const TextStyle(
          fontStyle: FontStyle.normal,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: Color(0xFF9FA3A9),
        ),
        fillColor: Colors.white,
        filled: false,
        enabled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFE7E8E9), width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 10),
      ),
    );
  }
}

class TextFieldView2 extends StatelessWidget {
  final dynamic controller;
  final dynamic type;
  final String? text;
  final dynamic validator;
  final dynamic textInputAction;
  final onChanged;

  const TextFieldView2({
    super.key,
    this.controller,
    this.type,
    this.text,
    this.validator,
    this.textInputAction,
    this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'\s')),
      ],
      autocorrect: true,
      onChanged: onChanged,
      textInputAction: TextInputAction.next,
      validator: validator,
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        hintText: text,
        hintStyle: const TextStyle(
          fontStyle: FontStyle.normal,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: Color(0xFF9FA3A9),
        ),
        fillColor: Colors.white,
        filled: false,
        enabled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFE7E8E9), width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 10),
      ),
    );
  }
}


class TextFieldPasswordView extends StatelessWidget {
  final dynamic controller;
  final dynamic type;
  final String? text;
  final dynamic validator;
  final dynamic textInputAction;
  final String image;
  final dynamic obscureText;
  final Onclick;
  final onChanged;
  final height;
  final width;

  const TextFieldPasswordView({
    super.key,
    this.controller,
    this.type,
    this.text,
    this.validator,
    this.textInputAction,
    required this.image,
    this.obscureText,
    this.Onclick,
    this.onChanged,
    this.height,
    this.width
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: onChanged,
      obscureText: obscureText,
      textInputAction: TextInputAction.next,
      validator: validator,
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        suffixIcon: GestureDetector(
          onTap: Onclick,
            child: Image.asset(image),
        ),
        hintText: text,
        hintStyle: TextStyle(
          fontStyle: FontStyle.normal,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: Color(0xFF9FA3A9),
        ),
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFCFD1D4), width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 10),
      ),
    );
  }
}


class TextFieldSearchView extends StatelessWidget {
  final search;
  TextFieldSearchView({super.key, this.search});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 16),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: TextField(
          // autovalidateMode: AutovalidateMode.onUserInteraction,
          textInputAction: TextInputAction.done,
          controller: search,
          decoration: InputDecoration(
            suffixIcon: Padding(
              padding: const EdgeInsets.only(left: 5, top: 14, bottom: 15),
              child: SvgPicture.asset(
                serach_suffix_icon,
              ),
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 5, top: 14, bottom: 15),
              child: SvgPicture.asset(
                serach_icon,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.white),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.white),
              borderRadius: BorderRadius.circular(10),
            ),
            hintText: AppString.search,
            hintStyle: const TextStyle(
              fontStyle: FontStyle.normal,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: AppColors.grey_hint_color,
            ),
            fillColor: AppColors.white,
            filled: true,
            contentPadding:
            const EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 10),
          ),
        ),
      ),
    );
  }
}


class TextFieldSendMessage extends StatelessWidget {
  final sendMessage;
  TextFieldSendMessage({super.key, this.sendMessage});

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: 260,
      child: TextFormField(
        // autovalidateMode: AutovalidateMode.onUserInteraction,
        // onChanged: onChanged,
        // obscureText: obscureText,
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        // validator: validator,
        controller: sendMessage,
        decoration: InputDecoration(
          suffixIcon: Padding(
            padding: const EdgeInsets.only(top: 13, bottom: 17, right: 16),
            child: GestureDetector(
              onTap: () {},
              child: SvgPicture.asset(smileIcon),
            ),
          ),
          fillColor: AppColors.white,
          filled: true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.checkboxColor),
          borderRadius: BorderRadius.circular(25),
        ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: AppColors.dark_red),
          ),
          // contentPadding:
          //     EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 10),
        ),
      ),
    );
  }
}

class TextFieldDetailView extends StatelessWidget {
  final dynamic controller;
  final dynamic type;
  final String? text;
  final dynamic validator;
  final dynamic textInputAction;
  final onChanged;

  const TextFieldDetailView({
    super.key,
    this.controller,
    this.type,
    this.text,
    this.validator,
    this.textInputAction,
    this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      autocorrect: true,
      onChanged: onChanged,
      textInputAction: TextInputAction.next,
      validator: validator,
      controller: controller,
      keyboardType: type,
      maxLength: 1000,
      maxLines: 10,
      decoration: InputDecoration(
        hintText: text,
        hintStyle: const TextStyle(
          fontStyle: FontStyle.normal,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: Color(0xFF9FA3A9),
        ),
        fillColor: Colors.white,
        filled: false,
        enabled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFE7E8E9), width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 10),
      ),
    );
  }
}






