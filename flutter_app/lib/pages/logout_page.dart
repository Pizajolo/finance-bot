import 'package:flutter/material.dart';
import 'package:flutter_app/pages/login_page.dart';
import './../utils/session.dart';

class LogoutPage extends StatefulWidget {
  final Session session;
  LogoutPage(this.session);
  @override
  State<StatefulWidget> createState() => _LogoutPageState(session);
}

class _LogoutPageState extends State<LogoutPage> {
  final Session session;
  _LogoutPageState(this.session);
  @override
  Widget build(BuildContext context) {
    return new SizedBox.expand(
        child: new Material(
      color: Colors.blueAccent,
      child: new Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(
            "Do you want",
            style: new TextStyle(
                color: Colors.white,
                fontSize: 40.0,
                fontWeight: FontWeight.bold),
          ),
          new Padding(
            padding: EdgeInsets.only(bottom: 50.0),
            child: new Text("to log out?",
                style: new TextStyle(
                    color: Colors.white,
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold)),
          ),
          new Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: MaterialButton(
              minWidth: 200.0,
              height: 50.0,
              onPressed: _performLogout,
              color: Colors.lightBlue,
              child: Text('Log out',
                  style: new TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    ),
    );
  }
  void _performLogout() async {
    var response = await session.get('http://127.0.0.1:5000/api/logout');
    print(response['status']);
    if(response['code'] == 210){
      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new LoginPage()));
    }
  }
}
