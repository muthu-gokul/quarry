
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/charts/apexChart/apexChartScript.dart';
import 'package:quarry/widgets/charts/highChart/variable_pie_script.dart';
import 'package:webview_flutter/platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'highChartSCript2.dart';

class HighCharts extends StatefulWidget {
  HighCharts({Key key,  this.data,this.isHighChart,this.isLoad,this.isHighChartExtraParam=false}) : super(key: key);
  final String data;
  bool isHighChart;
  bool isLoad;
  bool isHighChartExtraParam;
  @override
  _HighChartsState createState() => _HighChartsState();
}


//const highChartHtml = 'https://s3.ap-south-1.amazonaws.com/www.highchart.com/highchart.html';
//WITH BORDER RADIUS INLINE
//const highChartHtml = 'data:text/html;base64, PCFET0NUWVBFIGh0bWw+PGh0bWw+PGhlYWQ+PG1ldGEgY2hhcnNldD0idXRmLTgiPjxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MS4wLCBtYXhpbXVtLXNjYWxlPTEuMCwgbWluaW11bS1zY2FsZT0xLjAsIHVzZXItc2NhbGFibGU9MCIgLz48L2hlYWQ+PGJvZHk+PGRpdiBpZD0iY2hhcnQiIHN0eWxlPSJiYWNrZ3JvdW5kLWNvbG9yOiMzNDM0MzQgIWltcG9ydGFudDsgYm9yZGVyLXJhZGl1czoyNXB4ICFpbXBvcnRhbnQiPjwvZGl2PjwvYm9keT48L2h0bWw+PHNjcmlwdD5mdW5jdGlvbiBzY3V0aXNvZnQoYSl7IGV2YWwoYSk7IHJldHVybiB0cnVlO308L3NjcmlwdD48L2h0bWw+';
// const highChartHtml = 'data:text/html;base64, PCFET0NUWVBFIGh0bWw+PGh0bWw+PGhlYWQ+PG1ldGEgY2hhcnNldD0idXRmLTgiPjxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MS4wLCBtYXhpbXVtLXNjYWxlPTEuMCwgbWluaW11bS1zY2FsZT0xLjAsIHVzZXItc2NhbGFibGU9MCIgLz48L2hlYWQ+PGJvZHk+PGRpdiBpZD0iY2hhcnQiIHN0eWxlPSJiYWNrZ3JvdW5kLWNvbG9yOm5vbmUgIWltcG9ydGFudDsgYm9yZGVyLXJhZGl1czoyNXB4ICFpbXBvcnRhbnQiPjwvZGl2PjwvYm9keT48L2h0bWw+PHNjcmlwdD5mdW5jdGlvbiBzY3V0aXNvZnQoYSl7IGV2YWwoYSk7IHJldHVybiB0cnVlO308L3NjcmlwdD48L2h0bWw+';
// without borderRadius
const highChartHtml='data:text/html;base64, PCFET0NUWVBFIGh0bWw+PGh0bWw+PGhlYWQ+PG1ldGEgY2hhcnNldD0idXRmLTgiPjxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MS4wLCBtYXhpbXVtLXNjYWxlPTEuMCwgbWluaW11bS1zY2FsZT0xLjAsIHVzZXItc2NhbGFibGU9MCIgLz48c3R5bGU+aHRtbCxib2R5e3BhZGRpbmc6IDA7bWFyZ2luOiAwO308L3N0eWxlPjwvaGVhZD48Ym9keT48ZGl2IGlkPSJjaGFydCIgc3R5bGU9ImJhY2tncm91bmQtY29sb3I6bm9uZSAhaW1wb3J0YW50Ij48L2Rpdj48L2JvZHk+PC9odG1sPjxzY3JpcHQ+ZnVuY3Rpb24gc2N1dGlzb2Z0KGEpeyBldmFsKGEpOyByZXR1cm4gdHJ1ZTt9PC9zY3JpcHQ+PC9odG1sPg==';

//with type/javascript
//const highChartHtml='data:text/html;base64, PCFET0NUWVBFIGh0bWw+PGh0bWw+PGhlYWQ+PG1ldGEgY2hhcnNldD0idXRmLTgiPjxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MS4wLCBtYXhpbXVtLXNjYWxlPTEuMCwgbWluaW11bS1zY2FsZT0xLjAsIHVzZXItc2NhbGFibGU9MCIgLz48c3R5bGU+aHRtbCxib2R5e3BhZGRpbmc6IDA7bWFyZ2luOiAwO308L3N0eWxlPjwvaGVhZD48Ym9keT48ZGl2IGlkPSJjaGFydCIgc3R5bGU9ImJhY2tncm91bmQtY29sb3I6bm9uZSAhaW1wb3J0YW50Ij48L2Rpdj48L2JvZHk+PC9odG1sPjxzY3JpcHQgdHlwZT0idGV4dC9qYXZhc2NyaXB0Ij5mdW5jdGlvbiBzY3V0aXNvZnQoYSl7IGV2YWwoYSk7IHJldHVybiB0cnVlO308L3NjcmlwdD48L2h0bWw+';

//with jqueryscript
//const highChartHtml='data:text/html;base64, PCFET0NUWVBFIGh0bWw+PGh0bWw+DQogICAgPGhlYWQ+PG1ldGEgY2hhcnNldD0idXRmLTgiPg0KICAgIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MS4wLCBtYXhpbXVtLXNjYWxlPTEuMCwgbWluaW11bS1zY2FsZT0xLjAsIHVzZXItc2NhbGFibGU9MCIgLz48c3R5bGU+aHRtbCxib2R5e3BhZGRpbmc6IDA7bWFyZ2luOiAwO308L3N0eWxlPg0KICAgIDxzY3JpcHQNCiAgc3JjPSJodHRwczovL2NvZGUuanF1ZXJ5LmNvbS9qcXVlcnktMy42LjAuanMiDQo+PC9zY3JpcHQ+DQogICAgPC9oZWFkPg0KICAgIA0KICAgIDxib2R5Pg0KICAgICAgICA8ZGl2IGlkPSJjaGFydCIgc3R5bGU9ImJhY2tncm91bmQtY29sb3I6bm9uZSAhaW1wb3J0YW50Ij4NCiAgICAgICAgICAgIA0KICAgICAgICA8L2Rpdj4NCiAgICAgICAgPC9ib2R5Pg0KICAgICAgICA8L2h0bWw+DQogICAgICAgIDxzY3JpcHQgdHlwZT0idGV4dC9qYXZhc2NyaXB0Ij5mdW5jdGlvbiBzY3V0aXNvZnQoYSl7IGV2YWwoYSk7IHJldHVybiB0cnVlO308L3NjcmlwdD4NCiAgICAgICAgPC9odG1sPg==';


//with trycatch
//const highChartHtml='data:text/html;base64, PCFET0NUWVBFIGh0bWw+PGh0bWw+DQogICAgPGhlYWQ+PG1ldGEgY2hhcnNldD0idXRmLTgiPg0KICAgIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MS4wLCBtYXhpbXVtLXNjYWxlPTEuMCwgbWluaW11bS1zY2FsZT0xLjAsIHVzZXItc2NhbGFibGU9MCIgLz48c3R5bGU+aHRtbCxib2R5e3BhZGRpbmc6IDA7bWFyZ2luOiAwO308L3N0eWxlPg0KICAgIDxzY3JpcHQNCiAgc3JjPSJodHRwczovL2NvZGUuanF1ZXJ5LmNvbS9qcXVlcnktMy42LjAuanMiDQo+PC9zY3JpcHQ+DQogICAgPC9oZWFkPg0KICAgIA0KICAgIDxib2R5Pg0KICAgICAgICA8ZGl2IGlkPSJjaGFydCIgc3R5bGU9ImJhY2tncm91bmQtY29sb3I6bm9uZSAhaW1wb3J0YW50Ij4NCiAgICAgICAgICAgIA0KICAgICAgICA8L2Rpdj4NCiAgICAgICAgPC9ib2R5Pg0KICAgICAgICA8L2h0bWw+DQogICAgICAgIDxzY3JpcHQgdHlwZT0idGV4dC9qYXZhc2NyaXB0Ij4NCiAgICAgICAgdHJ5IHsNCiAgICAgICAgICAgIGZ1bmN0aW9uIHNjdXRpc29mdChhKXsgDQogICAgICAgICAgICAgICAgZXZhbChhKTsgDQogICAgICAgICAgICAgICAgcmV0dXJuIHRydWU7DQogICAgICAgICAgICB9DQogICAgICAgICAgfQ0KICAgICAgICBjYXRjaChlcnIpIHsNCiAgICAgICAgIGRvY3VtZW50LmdldEVsZW1lbnRCeUlkKCJjaGFydCIpLmlubmVySFRNTCA9IGVyci5tZXNzYWdlOw0KICAgICAgICB9DQogICAgICAgICAgICANCiAgICAgICAgICAgIDwvc2NyaXB0Pg0KICAgICAgICA8L2h0bWw+';




class _HighChartsState extends State<HighCharts> {
  String _currentData;

  WebViewController _controller;

  double _opacity = Platform.isAndroid ? 0.0 : 1.0;
  bool load;
  @override
  void initState() {
    super.initState();
    _currentData = widget.data;
    load=true;
  }

  @override
  void didUpdateWidget(covariant HighCharts oldWidget) {
/*    print("widget.isLoad ${widget.isLoad}");
    print("oldWidget.isLoad ${oldWidget.isLoad}");*/
    if(widget.isLoad){
      setState(() {
        _currentData = widget.data;
      });
      _controller.reload();
     // print("RELOAD ${widget.data}");
    }
    super.didUpdateWidget(oldWidget);
  }
  void init() async {
   /* setState(() {
      load=true;
    });*/
    if(widget.isHighChart){
      if(widget.isHighChartExtraParam){
        await _controller.evaluateJavascript('''
      $highChartScript2
      $variablePieScript
        var a= scutisoft(`$_currentData`);
    ''');
      }
      else{
        await _controller.evaluateJavascript('''
      $highChartScript2
      $variablePieScript
        var a= scutisoft(`Highcharts.chart('chart',
        $_currentData
        )`);
    ''');
      }
    }
    else{
      await _controller.evaluateJavascript('''
      $apexChartScript
      var a=scutisoft(`$_currentData`);
    ''');
    }

    setState(() {
      load=false;
    });
  }


  /*void init() async {
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
  }*/

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: load||widget.isLoad,
      opacity: 0.1,

      progressIndicator: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppTheme.yellowColor),),
      child: WebView(

        initialUrl: highChartHtml,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller = webViewController;
        },
        onPageStarted: (String url){
         // init();
        },
        onPageFinished: (String url) {
          /*setState(() {
            load=false;
          });*/
          init();
        },
        onWebResourceError: (WebResourceError webResourceError){
        //  CustomAlert().commonErrorAlert2(context, "Chart", "${webResourceError.description}");
        },
      ),
    );
  }
}
