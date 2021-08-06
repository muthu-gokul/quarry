
import 'dart:io' show Platform;

import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:quarry/widgets/charts/apexChart/apexChartScript.dart';
import 'package:quarry/widgets/charts/highChart/variable_pie_script.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'highChartSCript2.dart';

class HighCharts extends StatefulWidget {
  HighCharts({Key key,  this.data,this.isHighChart,this.isLoad}) : super(key: key);
  final String data;
  bool isHighChart;
  bool isLoad;
  @override
  _HighChartsState createState() => _HighChartsState();
}


//const highChartHtml = 'https://s3.ap-south-1.amazonaws.com/www.highchart.com/highchart.html';
//WITH BORDER RADIUS INLINE
const highChartHtml = 'data:text/html;base64, PCFET0NUWVBFIGh0bWw+PGh0bWw+PGhlYWQ+PG1ldGEgY2hhcnNldD0idXRmLTgiPjxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MS4wLCBtYXhpbXVtLXNjYWxlPTEuMCwgbWluaW11bS1zY2FsZT0xLjAsIHVzZXItc2NhbGFibGU9MCIgLz48L2hlYWQ+PGJvZHk+PGRpdiBpZD0iY2hhcnQiIHN0eWxlPSJiYWNrZ3JvdW5kLWNvbG9yOiMzNDM0MzQgIWltcG9ydGFudDsgYm9yZGVyLXJhZGl1czoyNXB4ICFpbXBvcnRhbnQiPjwvZGl2PjwvYm9keT48L2h0bWw+PHNjcmlwdD5mdW5jdGlvbiBzY3V0aXNvZnQoYSl7IGV2YWwoYSk7IHJldHVybiB0cnVlO308L3NjcmlwdD48L2h0bWw+';
// const highChartHtml = 'data:text/html;base64, PCFET0NUWVBFIGh0bWw+PGh0bWw+PGhlYWQ+PG1ldGEgY2hhcnNldD0idXRmLTgiPjxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MS4wLCBtYXhpbXVtLXNjYWxlPTEuMCwgbWluaW11bS1zY2FsZT0xLjAsIHVzZXItc2NhbGFibGU9MCIgLz48L2hlYWQ+PGJvZHk+PGRpdiBpZD0iY2hhcnQiIHN0eWxlPSJiYWNrZ3JvdW5kLWNvbG9yOm5vbmUgIWltcG9ydGFudDsgYm9yZGVyLXJhZGl1czoyNXB4ICFpbXBvcnRhbnQiPjwvZGl2PjwvYm9keT48L2h0bWw+PHNjcmlwdD5mdW5jdGlvbiBzY3V0aXNvZnQoYSl7IGV2YWwoYSk7IHJldHVybiB0cnVlO308L3NjcmlwdD48L2h0bWw+';

class _HighChartsState extends State<HighCharts> {
  String _currentData;

  WebViewController _controller;

  double _opacity = Platform.isAndroid ? 0.0 : 1.0;

  @override
  void initState() {
    super.initState();
    _currentData = widget.data;
  }

  @override
  void didUpdateWidget(covariant HighCharts oldWidget) {
/*    print("widget.isLoad ${widget.isLoad}");
    print("oldWidget.isLoad ${oldWidget.isLoad}");*/
    if(widget.isLoad){
      _controller?.reload();
      _currentData = widget.data;
     // print("RELOAD ${widget.data}");
    }
    super.didUpdateWidget(oldWidget);
  }

  void init() async {
    if(widget.isHighChart){
      await _controller?.evaluateJavascript('''
      $highChartScript2
      $variablePieScript
        var a= scutisoft(`Highcharts.chart('chart',
        $_currentData
        )`);
    ''');
    }
    else{
      await _controller?.evaluateJavascript('''
      $apexChartScript
      var a=scutisoft(`$_currentData`);
    ''');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WebView(

      initialUrl: highChartHtml,
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) {
        _controller = webViewController;
      },
      onPageFinished: (String url) {
        init();
      },

    );
  }
}
