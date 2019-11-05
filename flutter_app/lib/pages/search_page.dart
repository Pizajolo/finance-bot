import 'package:flutter/material.dart';
import './../utils/session.dart';
import './login_page.dart';

class SearchPage extends StatelessWidget {
  final Session session;
  final _searchController = TextEditingController();

  SearchPage(this.session);

  @override
  Widget build(BuildContext context) {
    return new Material(
        color: Colors.blueAccent,
        child:
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(
                "Analyse",
                style: new TextStyle(
                    color: Colors.white,
                    fontSize: 50.0,
                    fontWeight: FontWeight.bold),
              ),
              new Text("Stocks",
                  style: new TextStyle(
                      color: Colors.white,
                      fontSize: 50.0,
                      fontWeight: FontWeight.bold)),
              new Padding(
                padding: new EdgeInsets.all(50.0),
                child: new TextFormField(
                  controller: _searchController,
                  keyboardType: TextInputType.emailAddress,
                  autofocus: false,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0)),
                  ),
                ),
              ),
              new Padding(
                padding: EdgeInsets.symmetric(vertical: 0.0),
                child: MaterialButton(
                  minWidth: 200.0,
                  height: 50.0,
                  onPressed: _performSearch,
                  color: Colors.lightBlue,
                  child: Text('Search',
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

  void _performSearch() async {}
}
