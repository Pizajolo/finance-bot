import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';


class LoginPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {

  final session = new Session();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

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
                  keyboardType: TextInputType.emailAddress,
                  autofocus: false,
                  decoration: InputDecoration(
                    hintText: 'Email',
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
            Padding(
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
//  void _performLogin() async {
//    String username = _usernameController.text;
//    String password = _passwordController.text;
    // set up POST request arguments
//    String url = 'http://127.0.0.1:5000/api/login';
//    Map<String, String> headers = {"Content-type": "application/json"};
//    Map<String, dynamic> toJson() =>
//        {
//          'name': username,
//          'email': password,
//        };
////    String json = '{"username": $username, "password": $password}';
//    print(json);
//    // make POST request
//    Response response = await post(url, headers: headers, body: json);
//    print(response.body);
//  Future<String> _performLogin() async {
//    String username = _usernameController.text;
//    String password = _passwordController.text;
//    final response = await http.post(
//      Uri.encodeFull('http://127.0.0.1:5000/api/login'),
//      body: {
//        "username": username,
//        "password": password
//      },
//    );
//    print(response.body);
//  }
  void _performLogin() {
    String username = _usernameController.text;
    String password = _passwordController.text;
    var response = session.post('http://127.0.0.1:5000/api/login', {
        "username": username,
        "password": password
      });
    response.then((val) {
      print(val);
    });
  }
}


class Session {
  Map<String, String> headers = {};

  Future<Map> get(String url) async {
    http.Response response = await http.get(url, headers: headers);
    updateCookie(response);
    return json.decode(response.body);
  }

  Future<String> post(String url, dynamic data) async {
    http.Response response = await http.post(url, body: data, headers: headers);
    updateCookie(response);
    return response.body;
  }

  void updateCookie(http.Response response) {
    String rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      headers['cookie'] =
      (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }
  }
}

