import 'package:flutter/material.dart';
import 'package:firstapp/configs/color_styles.dart';

class Styles {
  static const size18 = TextStyle(fontSize: 18);
  static const size16 = TextStyle(fontSize: 16);
  static const size16c =
      TextStyle(color: ColorStyle.blueGrey_900, fontSize: 16);
  static const bold16 = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: ColorStyle.grey_700,
  );
  static const bold18 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static const bold14 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );

  static const boldwhite = TextStyle(
    fontWeight: FontWeight.bold,
    color: ColorStyle.white,
  );
  static const bold18c = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: ColorStyle.blueGrey_900,
  );
}
