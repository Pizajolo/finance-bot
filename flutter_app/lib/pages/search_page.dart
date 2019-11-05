import 'package:flutter/material.dart';
import './../utils/session.dart';
import './login_page.dart';
import './graph_page.dart';

class SearchPage extends StatefulWidget{
  final Session session;
  SearchPage(this.session);
  @override
  State<StatefulWidget> createState() => _SearchPageState(session);
}


class _SearchPageState extends State<SearchPage> {
  final Session session;
  final _searchController = TextEditingController();

  _SearchPageState(this.session);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
                  keyboardType: TextInputType.text,
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

  void _performSearch() async {
    String stock = _searchController.text;
    print("Send search request");
    var response = await session.post('http://127.0.0.1:5000/api/search', {
      'search_query': stock
    });
    if(response['code']==301){
//      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new GraphPage()));
      Navigator.of(context)
          .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
        return new GraphPage(response);
      }));
    }
    print(response['code']);
  }
}


