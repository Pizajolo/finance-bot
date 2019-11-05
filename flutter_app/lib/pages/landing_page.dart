import 'package:flutter/material.dart';
import './login_page.dart';

class LandingPage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return new Material(
      color: Colors.blueAccent,
      child: new InkWell(
        onTap: () => Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new LoginPage())),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text("financial", style: new TextStyle(color: Colors.white, fontSize: 50.0, fontWeight: FontWeight.bold),),
            new Text("Advisory", style: new TextStyle(color: Colors.white, fontSize: 50.0, fontWeight: FontWeight.bold)),
            new Text("Intelligence", style: new TextStyle(color: Colors.white, fontSize: 50.0, fontWeight: FontWeight.bold)),
            new Padding(
              padding: new EdgeInsets.symmetric(vertical: 50.0),
              child: new Center(
                child: new Text("Tap to login...", style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
