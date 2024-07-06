// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

class TextTh {
  static final profilestyle = GoogleFonts.dmSans(
    fontSize: 16,
    fontWeight: FontWeight.w300,
    color: const Color(0xffe7e7e7),
  );
  static final chatstyle = GoogleFonts.dmSans(
    fontWeight: FontWeight.w400,
    fontSize: 17,
    color: const Color(0xffe7e7e7),
  );
  static final logstyle = GoogleFonts.dmSans(
    fontSize: 24,
    fontWeight: FontWeight.w300,
    color: const Color(0xffe7e7e7),
  );
  static final logsubstyle = GoogleFonts.dmSans(
    fontSize: 10,
    fontWeight: FontWeight.w200,
    color: Colors.grey[400],
  );
  static final timestyle = GoogleFonts.dmSans(
    fontSize: 10,
    color: const Color(0xffe7e7e7),
  );
  static final hintstyle =
      GoogleFonts.dmSans(color: Colors.white60, fontWeight: FontWeight.w100);
}

void navigateToTop(BuildContext context, Widget destination) {
  Navigator.pushAndRemoveUntil(
      context,
      PageTransition(
        type: PageTransitionType.bottomToTop,
        child: destination,
        curve: Curves.easeIn,
        duration: const Duration(milliseconds: 300),
      ),
      (route) => false);
}
