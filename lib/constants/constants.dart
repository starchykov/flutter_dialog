import 'package:flutter/cupertino.dart';

enum MenuActions {
  resent,
  cancelSending,
  copy,
  delete,
}

enum PendingStatus {
  notSent,
  sending,
  sent,
}

const kBackgroundBlue = Color(0xFF2C87F6);
const kBackgroundGray = Color(0x28787880);
const kPrimaryColor = Color(0xFF366CF6);
const kSecondaryColor = Color(0xFFF5F6FC);
const kBgLightColor = Color(0xFFF2F4FC);
const kBgDarkColor = Color(0xFFEBEDFA);
const kErrorColor = Color(0xffff4d4f);
const kSuccessColor = Color.fromRGBO(115, 209, 61, 1);
const kGrayColor = CupertinoColors.inactiveGray;
const kDarkGrayColor = CupertinoColors.separator;
const kTransparencyGrayColor = CupertinoColors.systemFill;
const kTitleTextColor = Color(0xFF30384D);
const kTextColor = Color(0xFF4D5875);

const kTextSpaceDefault = 4.0;

const kHeadFontSize = 14.0;
const kDefaultFontSize = 16.0;
const kSmallFontSize = 14.0;

const kOffsetDefault = 4.0;
const kOffsetDouble = 8.0;
const kBoxMarginDefault = 12.0;


const kBorderRadiusDefault = 16.0;
const kBorderRadiusOval = 20.0;
