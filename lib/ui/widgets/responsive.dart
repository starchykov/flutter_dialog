import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Responsive extends StatefulWidget {
  final Widget mobile;
  final Widget tablet;

  const Responsive({Key? key, required this.mobile, required this.tablet}) : super(key: key);

  static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 650;

  static bool isTablet(BuildContext context) => MediaQuery.of(context).size.width >= 650;

  @override
  State<Responsive> createState() => _ResponsiveState();
}

class _ResponsiveState extends State<Responsive> {
  static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 650;

  static bool isTablet(BuildContext context) => MediaQuery.of(context).size.width > 1000;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          if (isTablet(context)) {
            log(isTablet(context).toString(), name: 'Tablet');
            log(MediaQuery.of(context).size.width.toString(), name: 'Device width');
            SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
            return widget.tablet;
          } else if (isMobile(context)) {
            log(isMobile(context).toString(), name: 'Mobile');
            log(MediaQuery.of(context).size.width.toString(), name: 'Device width');
            SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
            return widget.mobile;
          } else {
            log(isTablet(context).toString(), name: 'Mobile');
            log(MediaQuery.of(context).size.width.toString(), name: 'Device width');
            SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
            return widget.mobile;
          }
        },
      );
}
