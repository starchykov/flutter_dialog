import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog/dialog/messages_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => const CupertinoApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: CupertinoThemeData(primaryColor: Colors.blue),
        home: MyHomePage(title: 'Flutter Demo Home Page'),
      );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) => const CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(middle: Text('Messages')),
        child: SafeArea(child: CommentPage()),
      );
}
