import 'package:flutter/cupertino.dart';
import 'package:flutter_dialog/ui/views/home_screen/home_screen.dart';

class DialogApp extends StatelessWidget {
  const DialogApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: CupertinoThemeData(primaryColor: CupertinoColors.systemBlue),
      home: HomeScreen(),
    );
  }
}
