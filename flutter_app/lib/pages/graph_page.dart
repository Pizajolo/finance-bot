import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flarts/flart.dart';
import 'package:flarts/flart_axis.dart';
import 'package:flarts/flart_data.dart';

class GraphPage extends StatefulWidget {
  final stockData;

  GraphPage(this.stockData);

  _GraphPageState createState() => _GraphPageState(stockData);
}

class _GraphPageState extends State<GraphPage> {
  final stockData;
  _GraphPageState(this.stockData);

  GlobalKey stickyKey = GlobalKey();

  List<charts.Series<Sales, DateTime>> _seriesLineData;

  List extractData() {
    List<Sales> result = [];
    for (int i = 0; i < stockData["Date"].length; i++) {
      result.add(new Sales(DateTime.parse(stockData["Date"][i]), stockData["Prices"][i]));
    }
    return result;
  }
  _generateData() {
    var linesalesdata = extractData();
//    var linesalesdata = [
//      new Sales(0, 45),
//      new Sales(1, 56),
//      new Sales(2, 55),
//      new Sales(3, 60),
//      new Sales(4, 61),
//      new Sales(5, 70),
//    ];
//    var linesalesdata1 = [
//      new Sales(0, 35),
//      new Sales(1, 46),
//      new Sales(2, 45),
//      new Sales(3, 50),
//      new Sales(4, 51),
//      new Sales(5, 60),
//    ];
//
//    var linesalesdata2 = [
//      new Sales(0, 20),
//      new Sales(1, 24),
//      new Sales(2, 25),
//      new Sales(3, 40),
//      new Sales(4, 45),
//      new Sales(5, 60),
//    ];

    _seriesLineData.add(
      charts.Series<Sales, DateTime>(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff990099)),
        id: 'Stock',
        data: linesalesdata,
        domainFn: (Sales sales, _) => sales.yearval,
        measureFn: (Sales sales, _) => sales.salesval,
      ),
    );
//    _seriesLineData.add(
//      charts.Series(
//        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff109618)),
//        id: 'Air Pollution',
//        data: linesalesdata1,
//        domainFn: (Sales sales, _) => sales.yearval,
//        measureFn: (Sales sales, _) => sales.salesval,
//      ),
//    );
//    _seriesLineData.add(
//      charts.Series(
//        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xffff9900)),
//        id: 'Air Pollution',
//        data: linesalesdata2,
//        domainFn: (Sales sales, _) => sales.yearval,
//        measureFn: (Sales sales, _) => sales.salesval,
//      ),
//    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _seriesLineData = List<charts.Series<Sales, DateTime>>();
    _generateData();
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
              child:
                  mychart1Items("Sales by Month", "421.3M", "+12.9% of target"),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: myTextItems("EARNINGS (fAI)", "48.6%"),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: myTextItems("EARNINGS\n(one time Invstment)", "25.5%"),
            ),
          ],
          staggeredTiles: [
            StaggeredTile.extent(4, 500.0),
            StaggeredTile.extent(2, 130.0),
            StaggeredTile.extent(2, 130.0),
          ],
        ),
      ),
    );
  }

  Widget lineChart(widthChart, heightChart) {
    final simpleCurrencyFormatter = new charts.BasicNumericTickFormatterSpec.fromNumberFormat(new NumberFormat.compactSimpleCurrency());
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
                  width: widthChart,
                  height: heightChart,
                  child: charts.TimeSeriesChart(_seriesLineData,
                      primaryMeasureAxis: new charts.NumericAxisSpec(
                          tickFormatterSpec: simpleCurrencyFormatter),
                      domainAxis: new charts.DateTimeAxisSpec(
                          tickFormatterSpec: new charts.AutoDateTimeTickFormatterSpec(
                              day: new charts.TimeFormatterSpec(
                                  format: 'd', transitionFormat: 'MM/dd/yyyy'))),
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

  Material mychart1Items(String title, String priceVal, String subtitle) {
    return Material(
        color: Colors.white,
        elevation: 14.0,
        borderRadius: BorderRadius.circular(24.0),
        shadowColor: Color(0x802196F3),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    left: 0.0,
                    right: 0.0,
                  ),
                  child: lineChart(400.0,450.0),
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

//class GraphPage extends StatefulWidget {
//  final data;
//
//  GraphPage(this.data);
//
//  @override
//  State<StatefulWidget> createState() => _GraphPageState(data);
//}
//
//class _GraphPageState extends State<GraphPage> {
//  final stockData;
//
//  _GraphPageState(this.stockData);
//
//  var data = [];
//  var data1 = [0.0, -2.0, 3.5, -2.0, 0.5, 0.7, 0.8, 1.0, 2.0, 3.0, 3.2];
//  bool isShowingMainData;
//
//  @override
//  void initState() {
//    super.initState();
//    isShowingMainData = true;
//    print(stockData["Prices"]);
//    data = stockData["Prices"];
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("Analyse"),
//      ),
//      body: Container(
//        color: Colors.blueAccent,
//        child: StaggeredGridView.count(
//          crossAxisCount: 4,
//          crossAxisSpacing: 12.0,
//          mainAxisSpacing: 12.0,
//          children: <Widget>[
//            Padding(
//              padding: const EdgeInsets.all(8.0),
//              child:
//              sample3(),
//            ),
//            Padding(
//              padding: const EdgeInsets.only(left: 8.0),
//              child: myTextItems("EARNINGS (fAI)", "48.6%"),
//            ),
//            Padding(
//              padding: const EdgeInsets.only(right: 8.0),
//              child: myTextItems("EARNINGS\n(one time Invstment)", "25.5%"),
//            ),
//          ],
//          staggeredTiles: [
//            StaggeredTile.extent(4, 500.0),
//            StaggeredTile.extent(2, 130.0),
//            StaggeredTile.extent(2, 130.0),
//          ],
//        ),
//      ),
//    );
//  }
//
//  List extractData() {
//    List result = [];
//    for (int i = 0; i < stockData["Date"].length; i++) {
//      result.add(
//          [stockData["Prices"][i], DateTime.parse(stockData["Date"][i])]);
//    }
//    return result;
//  }
//
//  List extractX() {
//    List result = [];
//    for (int i = 0; i < stockData["Date"].length; i++) {
//      result.add(DateTime.parse(stockData["Date"][i]));
//    }
//    return new List<DateTime>.from(result);
//  }
//
//  Widget sample3() {
//    final dates = extractX();
//    final fromDate = dates[0];
//    final toDate = dates[dates.length - 1];
//    print(fromDate);
//    print(toDate);
//    return Material(
//      color: Colors.white,
//      elevation: 14.0,
//      borderRadius: BorderRadius.circular(24.0),
//      shadowColor: Color(0x802196F3),
//      child:,
//    );
//  }
//
//  Material myTextItems(String title, String subtitle) {
//    return Material(
//      color: Colors.white,
//      elevation: 14.0,
//      borderRadius: BorderRadius.circular(24.0),
//      shadowColor: Color(0x802196F3),
//      child: Center(
//        child: Padding(
//          padding: EdgeInsets.all(8.0),
//          child: Row(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//              Column(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  Padding(
//                    padding: EdgeInsets.all(8.0),
//                    child: Text(
//                      title,
//                      style: TextStyle(
//                        fontSize: 18.0,
//                        color: Colors.blueAccent,
//                      ),
//                    ),
//                  ),
//                  Padding(
//                    padding: EdgeInsets.all(8.0),
//                    child: Text(
//                      subtitle,
//                      style: TextStyle(
//                        fontSize: 30.0,
//                      ),
//                    ),
//                  ),
//                ],
//              ),
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//
//}

//class _GraphPageState extends State<GraphPage> {
//  final stockData;
//
//  _GraphPageState(this.stockData);
//
//  var data = [];
//  var data1 = [0.0, -2.0, 3.5, -2.0, 0.5, 0.7, 0.8, 1.0, 2.0, 3.0, 3.2];
//  bool isShowingMainData;
//
//  @override
//  void initState() {
//    super.initState();
//    isShowingMainData = true;
//    print(stockData["Prices"]);
//    data = stockData["Prices"];
//  }
//
//  Material myTextItems(String title, String subtitle) {
//    return Material(
//      color: Colors.white,
//      elevation: 14.0,
//      borderRadius: BorderRadius.circular(24.0),
//      shadowColor: Color(0x802196F3),
//      child: Center(
//        child: Padding(
//          padding: EdgeInsets.all(8.0),
//          child: Row(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//              Column(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  Padding(
//                    padding: EdgeInsets.all(8.0),
//                    child: Text(
//                      title,
//                      style: TextStyle(
//                        fontSize: 18.0,
//                        color: Colors.blueAccent,
//                      ),
//                    ),
//                  ),
//                  Padding(
//                    padding: EdgeInsets.all(8.0),
//                    child: Text(
//                      subtitle,
//                      style: TextStyle(
//                        fontSize: 30.0,
//                      ),
//                    ),
//                  ),
//                ],
//              ),
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//
//  Material mychart1Items(String title, String priceVal, String subtitle) {
//    return Material(
//        color: Colors.white,
//        elevation: 14.0,
//        borderRadius: BorderRadius.circular(24.0),
//        shadowColor: Color(0x802196F3),
//        child: Center(
//          child: Padding(
//            padding: EdgeInsets.all(8.0),
//            child: ListView(
//              children: <Widget>[
//                Padding(
//                  padding: const EdgeInsets.only(
//                    left: 0.0,
//                    right: 0.0,
//                  ),
//                  child: lineChart(),
//                ),
//              ],
//            ),
//          ),
//        ));
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("Analyse"),
//      ),
//      body: Container(
//        color: Colors.blueAccent,
//        child: StaggeredGridView.count(
//          crossAxisCount: 4,
//          crossAxisSpacing: 12.0,
//          mainAxisSpacing: 12.0,
//          children: <Widget>[
//            Padding(
//              padding: const EdgeInsets.all(8.0),
//              child:
//                  mychart1Items("Sales by Month", "421.3M", "+12.9% of target"),
//            ),
//            Padding(
//              padding: const EdgeInsets.only(left: 8.0),
//              child: myTextItems("EARNINGS (fAI)", "48.6%"),
//            ),
//            Padding(
//              padding: const EdgeInsets.only(right: 8.0),
//              child: myTextItems("EARNINGS\n(one time Invstment)", "25.5%"),
//            ),
//          ],
//          staggeredTiles: [
//            StaggeredTile.extent(4, 500.0),
//            StaggeredTile.extent(2, 130.0),
//            StaggeredTile.extent(2, 130.0),
//          ],
//        ),
//      ),
//    );
//  }
//
//  AspectRatio lineChart() {
//    return AspectRatio(
//      aspectRatio: 1.23,
//      child: Container(
//        decoration: BoxDecoration(
//            borderRadius: const BorderRadius.all(Radius.circular(18)),
//            gradient: LinearGradient(
//              colors: const [
//                Colors.white,
//                Colors.white,
//              ],
//              begin: Alignment.bottomCenter,
//              end: Alignment.topCenter,
//            )),
//        child: Stack(
//          children: <Widget>[
//            Column(
//              crossAxisAlignment: CrossAxisAlignment.stretch,
//              children: <Widget>[
//                const SizedBox(
//                  height: 37,
//                ),
//                Text(
//                  'Unfold Shop 2018',
//                  style: TextStyle(
//                    color: const Color(0xff827daa),
//                    fontSize: 16,
//                  ),
//                  textAlign: TextAlign.center,
//                ),
//                const SizedBox(
//                  height: 4,
//                ),
//                Text(
//                  'One Year Trading',
//                  style: TextStyle(
//                      color: Colors.white,
//                      fontSize: 32,
//                      fontWeight: FontWeight.bold,
//                      letterSpacing: 2),
//                  textAlign: TextAlign.center,
//                ),
//                const SizedBox(
//                  height: 37,
//                ),
//                Expanded(
//                  child: Padding(
//                      padding: const EdgeInsets.only(right: 16.0, left: 6.0),
//                      child: LineChart(
//                        isShowingMainData ? sampleData1() : sampleData2(),
//                        swapAnimationDuration: Duration(milliseconds: 250),
//                      )),
//                ),
//                const SizedBox(
//                  height: 10,
//                ),
//              ],
//            ),
//            IconButton(
//              icon: Icon(
//                Icons.refresh,
//                color: Colors.white.withOpacity(isShowingMainData ? 1.0 : 0.5),
//              ),
//              onPressed: () {
//                setState(() {
//                  isShowingMainData = !isShowingMainData;
//                });
//              },
//            )
//          ],
//        ),
//      ),
//    );
//  }
//
//  LineChartData sampleData1() {
//    return LineChartData(
//      lineTouchData: LineTouchData(
//        touchTooltipData: LineTouchTooltipData(
//          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
//        ),
//        touchCallback: (LineTouchResponse touchResponse) {
//          print(touchResponse);
//        },
//        handleBuiltInTouches: true,
//      ),
//      gridData: const FlGridData(
//        show: false,
//      ),
//      titlesData: FlTitlesData(
//        bottomTitles: SideTitles(
//          showTitles: true,
//          reservedSize: 22,
//          textStyle: TextStyle(
//            color: const Color(0xff72719b),
//            fontWeight: FontWeight.bold,
//            fontSize: 16,
//          ),
//          margin: 10,
//          getTitles: (value) {
//            switch (value.toInt()) {
//              case 2:
//                return 'SEPT';
//              case 7:
//                return 'OCT';
//              case 12:
//                return 'DEC';
//            }
//            return '';
//          },
//        ),
//        leftTitles: SideTitles(
//          showTitles: true,
//          textStyle: TextStyle(
//            color: const Color(0xff75729e),
//            fontWeight: FontWeight.bold,
//            fontSize: 14,
//          ),
//          getTitles: (value) {
//            switch (value.toInt()) {
//              case 1:
//                return '1m';
//              case 2:
//                return '2m';
//              case 3:
//                return '3m';
//              case 4:
//                return '5m';
//            }
//            return '';
//          },
//          margin: 8,
//          reservedSize: 30,
//        ),
//      ),
//      borderData: FlBorderData(
//          show: true,
//          border: Border(
//            bottom: BorderSide(
//              color: const Color(0xff4e4965),
//              width: 4,
//            ),
//            left: BorderSide(
//              color: Colors.transparent,
//            ),
//            right: BorderSide(
//              color: Colors.transparent,
//            ),
//            top: BorderSide(
//              color: Colors.transparent,
//            ),
//          )),
//      minX: 0,
//      maxX: 14,
//      maxY: 4,
//      minY: 0,
//      lineBarsData: linesBarData1(),
//    );
//  }
//
//  List<LineChartBarData> linesBarData1() {
//    LineChartBarData lineChartBarData1 = const LineChartBarData(
//      spots: [
//        FlSpot(1, 1),
//        FlSpot(3, 1.5),
//        FlSpot(5, 1.4),
//        FlSpot(7, 3.4),
//        FlSpot(10, 2),
//        FlSpot(12, 2.2),
//        FlSpot(13, 1.8),
//      ],
//      isCurved: true,
//      colors: [
//        Color(0xff4af699),
//      ],
//      barWidth: 8,
//      isStrokeCapRound: true,
//      dotData: FlDotData(
//        show: false,
//      ),
//      belowBarData: BarAreaData(
//        show: false,
//      ),
//    );
//    final LineChartBarData lineChartBarData2 = LineChartBarData(
//      spots: [
//        FlSpot(1, 1),
//        FlSpot(3, 2.8),
//        FlSpot(7, 1.2),
//        FlSpot(10, 2.8),
//        FlSpot(12, 2.6),
//        FlSpot(13, 3.9),
//      ],
//      isCurved: true,
//      colors: [
//        Color(0xffaa4cfc),
//      ],
//      barWidth: 8,
//      isStrokeCapRound: true,
//      dotData: FlDotData(
//        show: false,
//      ),
//      belowBarData: BarAreaData(show: false, colors: [
//        Color(0x00aa4cfc),
//      ]),
//    );
//    LineChartBarData lineChartBarData3 = LineChartBarData(
//      spots: const [
//        FlSpot(1, 2.8),
//        FlSpot(3, 1.9),
//        FlSpot(6, 3),
//        FlSpot(10, 1.3),
//        FlSpot(13, 2.5),
//      ],
//      isCurved: true,
//      colors: const [
//        Color(0xff27b6fc),
//      ],
//      barWidth: 8,
//      isStrokeCapRound: true,
//      dotData: const FlDotData(
//        show: false,
//      ),
//      belowBarData: const BarAreaData(
//        show: false,
//      ),
//    );
//    return [
//      lineChartBarData1,
//      lineChartBarData2,
//      lineChartBarData3,
//    ];
//  }
//
//  LineChartData sampleData2() {
//    return LineChartData(
//      lineTouchData: const LineTouchData(
//        enabled: false,
//      ),
//      gridData: const FlGridData(
//        show: false,
//      ),
//      titlesData: FlTitlesData(
//        bottomTitles: SideTitles(
//          showTitles: true,
//          reservedSize: 22,
//          textStyle: TextStyle(
//            color: const Color(0xff72719b),
//            fontWeight: FontWeight.bold,
//            fontSize: 16,
//          ),
//          margin: 10,
//          getTitles: (value) {
//            switch (value.toInt()) {
//              case 2:
//                return 'SEPT';
//              case 7:
//                return 'OCT';
//              case 12:
//                return 'DEC';
//            }
//            return '';
//          },
//        ),
//        leftTitles: SideTitles(
//          showTitles: true,
//          textStyle: TextStyle(
//            color: const Color(0xff75729e),
//            fontWeight: FontWeight.bold,
//            fontSize: 14,
//          ),
//          getTitles: (value) {
//            switch (value.toInt()) {
//              case 1:
//                return '1m';
//              case 2:
//                return '2m';
//              case 3:
//                return '3m';
//              case 4:
//                return '5m';
//              case 5:
//                return '6m';
//            }
//            return '';
//          },
//          margin: 8,
//          reservedSize: 30,
//        ),
//      ),
//      borderData: FlBorderData(
//          show: true,
//          border: Border(
//            bottom: BorderSide(
//              color: const Color(0xff4e4965),
//              width: 4,
//            ),
//            left: BorderSide(
//              color: Colors.transparent,
//            ),
//            right: BorderSide(
//              color: Colors.transparent,
//            ),
//            top: BorderSide(
//              color: Colors.transparent,
//            ),
//          )),
//      minX: 0,
//      maxX: 14,
//      maxY: 6,
//      minY: 0,
//      lineBarsData: linesBarData2(),
//    );
//  }
//
//  List<LineChartBarData> linesBarData2() {
//    return [
//      const LineChartBarData(
//        spots: [
//          FlSpot(1, 1),
//          FlSpot(3, 4),
//          FlSpot(5, 1.8),
//          FlSpot(7, 5),
//          FlSpot(10, 2),
//          FlSpot(12, 2.2),
//          FlSpot(13, 1.8),
//        ],
//        isCurved: true,
//        curveSmoothness: 0,
//        colors: [
//          Color(0x444af699),
//        ],
//        barWidth: 4,
//        isStrokeCapRound: true,
//        dotData: FlDotData(
//          show: false,
//        ),
//        belowBarData: BarAreaData(
//          show: false,
//        ),
//      ),
//      const LineChartBarData(
//        spots: [
//          FlSpot(1, 1),
//          FlSpot(3, 2.8),
//          FlSpot(7, 1.2),
//          FlSpot(10, 2.8),
//          FlSpot(12, 2.6),
//          FlSpot(13, 3.9),
//        ],
//        isCurved: true,
//        colors: [
//          Color(0x99aa4cfc),
//        ],
//        barWidth: 4,
//        isStrokeCapRound: true,
//        dotData: FlDotData(
//          show: false,
//        ),
//        belowBarData: BarAreaData(show: true, colors: [
//          Color(0x33aa4cfc),
//        ]),
//      ),
//      const LineChartBarData(
//        spots: [
//          FlSpot(1, 3.8),
//          FlSpot(3, 1.9),
//          FlSpot(6, 5),
//          FlSpot(10, 3.3),
//          FlSpot(13, 4.5),
//        ],
//        isCurved: true,
//        curveSmoothness: 0,
//        colors: [
//          Color(0x4427b6fc),
//        ],
//        barWidth: 2,
//        isStrokeCapRound: true,
//        dotData: FlDotData(
//          show: true,
//        ),
//        belowBarData: BarAreaData(
//          show: false,
//        ),
//      ),
//    ];
//  }
//}
