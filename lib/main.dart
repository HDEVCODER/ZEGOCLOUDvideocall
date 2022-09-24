import 'package:easy_example_flutter/home_page.dart';
import 'package:flutter/material.dart';

import 'package:easy_example_flutter/video_call_page.dart';

void main() {
  runApp(const MyApp());
}

/// MyApp class is use for example only
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
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
