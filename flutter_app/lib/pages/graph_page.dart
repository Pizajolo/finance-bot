import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/search_page.dart';
import 'package:intl/intl.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';


class GraphPage extends StatefulWidget {
  final stockData;



  GraphPage(this.stockData);

  _GraphPageState createState() => _GraphPageState(stockData);
}

class _GraphPageState extends State<GraphPage> {
  final stockData;


  _GraphPageState(this.stockData);

  var _stockName = '';
  var _returnFAI = '';
  var _returnHold = '';
  final List<String> _prices = <String>[];
  final List<String> _dates = <String>[];
  final List<MaterialColor> _colorCodes = <MaterialColor>[]; // red is sell and green buy

  List<charts.Series<Sales, DateTime>> _seriesLineData;

  List extractData() {
    List<Sales> result = [];
    for (int i = 0; i < stockData["Date"].length; i++) {
      result.add(new Sales(
          DateTime.parse(stockData["Date"][i]), stockData["Prices"][i]));
    }
    return result;
  }
   _generateTrades(){
      var buys = stockData["Buy_Prices"];
      var sells = stockData["Sell_Prices"];
      var dates = stockData["Date"];
      for(int count=0; count< buys.length; count++){
        if(buys[count] != null){
          _prices.insert(0, buys[count].toStringAsFixed(2));
          _colorCodes.insert(0, Colors.green);
          _dates.insert(0, dates[count].toString());
        }
        if(sells[count] != null){
          _prices.insert(0, sells[count].toStringAsFixed(2));
          _colorCodes.insert(0, Colors.red);
          _dates.insert(0, dates[count]);
        }
      }
   }

  _generateData() {
    var linesalesdata = extractData();

    _seriesLineData.add(
      charts.Series<Sales, DateTime>(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff990099)),
        id: 'Stock',
        data: linesalesdata,
        domainFn: (Sales sales, _) => sales.yearval,
        measureFn: (Sales sales, _) => sales.salesval,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _seriesLineData = List<charts.Series<Sales, DateTime>>();
    _generateData();
    _generateTrades();
    _stockName = stockData['Stock'];
    _returnFAI = stockData['Return-fAI'];
    _returnHold = stockData['Return-holding'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Analyse"),
      ),
      body: Container(
        color: Colors.blueAccent,
        child: StaggeredGridView.count(
          crossAxisCount: 4,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: mychart1Items(_stockName),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: myTextItems("EARNINGS (fAI)", _returnFAI),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: myTextItems("EARNINGS\n(one time Invstment)", _returnHold),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: tradesList(),
            ),
          ],
          staggeredTiles: [
            StaggeredTile.extent(4, 500.0),
            StaggeredTile.extent(2, 130.0),
            StaggeredTile.extent(2, 130.0),
            StaggeredTile.extent(4, 500.0),
          ],
        ),
      ),
    );
  }

  Widget lineChart(heightChart) {
    final simpleCurrencyFormatter =
        new charts.BasicNumericTickFormatterSpec.fromNumberFormat(
            new NumberFormat.compactSimpleCurrency());
    return Material(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(
          child: Center(
            child: Column(
              children: <Widget>[
//                Text(
//                  'Traides last Year',
//                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
//                ),
                SizedBox(
                  height: heightChart,
                  child: charts.TimeSeriesChart(_seriesLineData,
                      primaryMeasureAxis: new charts.NumericAxisSpec(
                          tickFormatterSpec: simpleCurrencyFormatter),
                      domainAxis: new charts.DateTimeAxisSpec(
                          tickFormatterSpec:
                              new charts.AutoDateTimeTickFormatterSpec(
                                  day: new charts.TimeFormatterSpec(
                                      format: 'd',
                                      transitionFormat: 'MM/dd/yyyy'))),
                      defaultRenderer: new charts.LineRendererConfig(
                          includeArea: true, stacked: true),
                      animate: true,
                      animationDuration: Duration(seconds: 5),
                      behaviors: [
                        new charts.ChartTitle('Days',
                            behaviorPosition: charts.BehaviorPosition.bottom,
                            titleOutsideJustification:
                                charts.OutsideJustification.middleDrawArea),
                      ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Material tradesList() {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color(0x802196F3),
      child: Column(children: <Widget>[
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Trades",
                  style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 420.0,
          child: ListView.separated(
            padding: const EdgeInsets.all(4),
            itemCount: _prices.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 50,
                decoration: new BoxDecoration(
                    color: _colorCodes[index],
                    borderRadius: new BorderRadius.all(const  Radius.circular(40.0),
                ),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 40.0),
                        child: Text(
                          '${_dates[index]}',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 40.0),
                        child: Text(
                          '\$${_prices[index]}',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ]
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
          ),
        )
      ]),
    );
  }

  Material myTextItems(String title, String subtitle) {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color(0x802196F3),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 30.0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Material mychart1Items(String title) {
    return Material(
        color: Colors.white,
        elevation: 14.0,
        borderRadius: BorderRadius.circular(24.0),
        shadowColor: Color(0x802196F3),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ]),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 0.0,
                    right: 0.0,
                  ),
                  child: lineChart(410.0),
                ),
              ],
            ),
          ),
        ));
  }
}

class Sales {
  DateTime yearval;
  double salesval;

  Sales(this.yearval, this.salesval);
}
