import 'package:flutter/material.dart';

enum DsCalendarColorOption {
  standard(false),
  grey(false),
  greenTea(true),
  mistyRose(true),
  azul(true),
  green(true),
  volcano(true),
  pastel(true),
  bluePint(true),
  apricotSunset(true),
  ;

  final bool premium;

  const DsCalendarColorOption(this.premium);

  List<Color> get calendarColors {
    return switch (this) {
      DsCalendarColorOption.standard => [
          Colors.blue.shade300,
          Colors.blue.shade100,
          Colors.teal.shade500,
          Colors.teal.shade300,
          Colors.green.shade400,
          Colors.green.shade200,
          Colors.yellow.shade300,
          Colors.orange.shade200,
          Colors.orange.shade500,
          Colors.red.shade200,
          Colors.red.shade400,
          Colors.purple.shade300,
          Colors.blue.shade300
        ],
      DsCalendarColorOption.grey => List.generate(12, (index) => Colors.grey.shade200),
      DsCalendarColorOption.greenTea => [
          const Color(0xffccd5ae),
          const Color(0xffd4dbb5),
          const Color(0xffdbe1bc),
          const Color(0xffe9edc9),
          const Color(0xffeff1cf),
          const Color(0xfff4f4d5),
          const Color(0xffF7F6D8),
          const Color(0xfffefae0),
          const Color(0xfffcf4d7),
          const Color(0xfffbf1d2),
          const Color(0xfffaedcd),
          const Color(0xfff9eac8),
        ],
      DsCalendarColorOption.mistyRose => // return
        [
          const Color(0xffFFE5EC),
          const Color(0xffFFD4DF),
          const Color(0xffFFCBD8),
          const Color(0xffFFC2D1),
          const Color(0xffFFBBCC),
          const Color(0xffFFB3C6),
          const Color(0xffFFAAC0),
          const Color(0xffFFA6BD),
          const Color(0xffFFA1B9),
          const Color(0xffFF9DB6),
          const Color(0xffFF98B2),
          const Color(0xffFF8FAB),
        ],
      DsCalendarColorOption.azul => [
          const Color(0xffade8f4),
          const Color(0xff9fe4f2),
          const Color(0xff90e0ef),
          const Color(0xff7EDBED),
          const Color(0xff6CD5EA),
          const Color(0xff48cae4),
          const Color(0xff24bfde),
          const Color(0xff12BADB),
          const Color(0xff00b4d8),
          const Color(0xff00ADD4),
          const Color(0xff00a5d0),
          const Color(0xff0096c7),
        ],
      DsCalendarColorOption.green => [
          const Color(0xff9ef01a),
          const Color(0xff87e80d),
          const Color(0xff70e000),
          const Color(0xff54c800),
          const Color(0xff38b000),
          const Color(0xff1c9800),
          const Color(0xff008000),
          const Color(0xff007900),
          const Color(0xff007200),
          const Color(0xff006b00),
          const Color(0xff006400),
          const Color(0xff004b23),
        ],
      DsCalendarColorOption.volcano => [
          const Color(0xff0a9396),
          const Color(0xff2da3a0),
          const Color(0xff4fb3aa),
          const Color(0xff94d2bd),
          const Color(0xffbfd5b2),
          const Color(0xffd5cf98),
          const Color(0xffe9d8a6),
          const Color(0xffebc97d),
          const Color(0xffecba53),
          const Color(0xffee9b00),
          const Color(0xffdc8101),
          const Color(0xffca6702),
        ],
      DsCalendarColorOption
            .pastel => // list of https://coolors.co/ff99c8-fec8c3-fcf6bd-e6f5ce-d0f4de-c7efe5-bde9ec-a9def9-c7d0f9-e4c1f9
        [
          const Color(0xffFF99C8),
          const Color(0xffFEC8C3),
          const Color(0xffFCF6BD),
          const Color(0xffE6F5CE),
          const Color(0xffD0F4DE),
          const Color(0xffC7EFE5),
          const Color(0xffBDE9EC),
          const Color(0xffA9DEF9),
          const Color(0xffC7D0F9),
          const Color(0xffE4C1F9),
          const Color(0xffFF99C8),
          const Color(0xffFEC8C3),
        ],
      DsCalendarColorOption
            .bluePint => // use colors /7bdff2-b2f7ef-eff7f6-f7d6e0-f2b5d4-f0a6ca-f0a6ca-f9c0c4-f9c0c4-f9c0c4-f9c0c4-f9c0c4
        [
          const Color(0xff7BDFF2),
          const Color(0xff7BDFF2),
          const Color(0xff97ebf1),
          const Color(0xff97ebf1),
          const Color(0xffB2F7EF),
          const Color(0xffB2F7EF),
          const Color(0xffF7D6E0),
          const Color(0xffF7D6E0),
          const Color(0xfff5c6da),
          const Color(0xfff5c6da),
          const Color(0xffF2B5D4),
          const Color(0xffF2B5D4),
        ],
      DsCalendarColorOption.apricotSunset => [
          const Color(0xffF4F1DE),
          const Color(0xffF4F1DE),
          const Color(0xffEAB69F),
          const Color(0xffEAB69F),
          const Color(0xffE07A5F),
          const Color(0xffE07A5F),
          const Color(0xff81B29A),
          const Color(0xff81B29A),
          const Color(0xffBABF95),
          const Color(0xffBABF95),
          const Color(0xffF2CC8F),
          const Color(0xffF2CC8F),
        ],
    };
  }

  List<Color> get calendarColorsForButton {
    return switch (this) {
      DsCalendarColorOption.grey => [Colors.grey, Colors.white],
      _ => calendarColors,
    };
  }
}
