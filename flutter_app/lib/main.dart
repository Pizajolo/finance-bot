import 'package:flutter/material.dart';
import './pages/landing_page.dart';
import './pages/graph_page.dart';

void main(){
  runApp(new MaterialApp(
    home: new LandingPage(),
  ));
}
//void main() => runApp(MyApp());
//
//class MyApp extends StatelessWidget {
//  // This widget is the root of your application.
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      debugShowCheckedModeBanner: false,
//      title: 'Flutter Animated Charts App',
//      theme: ThemeData(
//        primaryColor: Color(0xffff6101),
//      ),
//      home: HomePage(),
//    );
//  }
//}