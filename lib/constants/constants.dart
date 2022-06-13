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

const kBackgroundGray = Color(0xFF366CF6);
const kPrimaryColor = Color(0xFF366CF6);
const kSecondaryColor = Color(0xFFF5F6FC);
const kBgLightColor = Color(0xFFF2F4FC);
const kBgDarkColor = Color(0xFFEBEDFA);
const kBadgeColor = Color(0xFFEE376E);
const kGrayColor = CupertinoColors.lightBackgroundGray;
const kDarkGrayColor = CupertinoColors.systemGrey;
const kTitleTextColor = Color(0xFF30384D);
const kTextColor = Color(0xFF4D5875);

const kDefaultFontSize = 14.0;

const kDefaultBoxPadding = 15.0;
const kDefaultBoxMargin = 10.0;
const kDefaultTextSpace = 5.0;
const kDefaultBorderRadius = 20.0;
