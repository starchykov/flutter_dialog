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
const kPrimaryColor = Color(0xFF366CF6);
const kSecondaryColor = Color(0xFFF5F6FC);
const kBgLightColor = Color(0xFFF2F4FC);
const kBgDarkColor = Color(0xFFEBEDFA);
const kErrorColor = Color(0xffff4d4f);
const kSuccessColor = Color.fromRGBO(115, 209, 61, 1);
const kGrayColor = CupertinoColors.systemFill;
const kDarkGrayColor = CupertinoColors.systemGrey;
const kTitleTextColor = Color(0xFF30384D);
const kTextColor = Color(0xFF4D5875);

const kDefaultFontSize = 14.0;

const kDefaultBoxPadding = 16.0;
const kDefaultDoubleBoxPadding = 8.0;
const kDefaultBoxMargin = 10.0;
const kDefaultTextSpace = 4.0;
const kDefaultBorderRadius = 20.0;
