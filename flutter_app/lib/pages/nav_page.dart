import 'package:flutter/material.dart';
import './../utils/session.dart';
import './search_page.dart';

class NavPage extends StatefulWidget{
  @override
  final Session session;
  NavPage(this.session);
  State<StatefulWidget> createState() => _NavPageState(session);
}

class _NavPageState extends State<NavPage> {
  final Session session;
  _NavPageState(this.session);
  int _currentIndex = 0;
  @override
//  void initState() {
//    //StartFunc();
//    super.initState();
//    _NavPageState(this.session);
//    final List<Widget> _children = [
//      SearchPage(session),
//    ];
//
//  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('financial Advisory Intelligence'),
      ),
      body: getPage(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.search),
            title: new Text('Search'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.person),
            title: new Text('Profile'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.lock),
              title: Text('Logout')
          )
        ],
      ),
    );
  }
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget getPage(int index) {
    if (index == 0) {
      return SearchPage(session);
    }
    return SearchPage(session);
  }

}
