import 'package:flutter/material.dart';
import './../utils/session.dart';
import './nav_page.dart';


class LoginPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      color: Colors.blueAccent,
      child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Padding(
                padding: new EdgeInsets.symmetric(vertical: 50.0),
                child: new Text(
                  "Login",
                  style: new TextStyle(
                      color: Colors.white,
                      fontSize: 50.0,
                      fontWeight: FontWeight.bold),
                )),
            new Padding(
                padding: new EdgeInsets.all(15.0),
                child: new TextFormField(
                  controller: _usernameController,
                  keyboardType: TextInputType.text,
                  autofocus: false,
                  decoration: InputDecoration(
                    hintText: 'Username',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0)),
                  ),
                )),
            new Padding(
              padding: new EdgeInsets.all(15.0),
              child: new TextFormField(
                controller: _passwordController,
                autofocus: false,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Password',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                ),
              ),
            ),
            new Padding(
              padding: EdgeInsets.symmetric(vertical: 30.0),
              child: MaterialButton(
                minWidth: 200.0,
                height: 50.0,
                onPressed: _performLogin,
                color: Colors.lightBlue,
                child: Text('Log In',
                    style: new TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
    );
  }

  void _performLogin() async {
    final session = new Session();
    String username = _usernameController.text;
    String password = _passwordController.text;
    var response = await session.post('http://127.0.0.1:5000/api/login', {
        "username": username,
        "password": password
      });
    print(response['status']);
    if(response['code'] == 201 || response['code'] == 202){
      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new NavPage(session)));
    }
  }
}


