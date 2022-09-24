import 'package:easy_example_flutter/home_page.dart';
import 'package:flutter/material.dart';

import 'package:easy_example_flutter/video_call_page.dart';

void main() {
  runApp(const MyApp());
}
 
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      initialRoute: '/home_page',
      routes: {
        '/home_page': (context) => const HomePage(),
        '/video_call_page': (context) => const VideoCallPage(),
      },
    );
  }
}
