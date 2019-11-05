import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';


class GraphPage extends StatefulWidget {
  final data;
  GraphPage(this.data);
  @override
  State<StatefulWidget> createState() => _GraphPageState(data);
}

class _GraphPageState extends State<GraphPage> {
  final data;
  _GraphPageState(this.data);

  Widget chartContainer = Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [Text('Chart Viewer')],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Analyse")),
        body: Center(
          child: Column(
            children: <Widget>[
              Container(
                height: 250,
                child: chartContainer,
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text('Bar Charts'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    child: Text('Simple'),
                    onPressed: () {
                      setState(() {
                        chartContainer = SimpleBarChart.withSampleData();
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
    );
  }
}

class SimpleBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SimpleBarChart(this.seriesList, {this.animate});

  /// Creates a [BarChart] with sample data and no transition.
  factory SimpleBarChart.withSampleData() {
    return new SimpleBarChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.LineChart(
      seriesList,
      animate: animate,
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<OrdinalSales, String>> _createSampleData() {
    final data = [
      new OrdinalSales('2014', 5),
      new OrdinalSales('2015', 25),
      new OrdinalSales('2016', 100),
      new OrdinalSales('2017', 75),
    ];

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}