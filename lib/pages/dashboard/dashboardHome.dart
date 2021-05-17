import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/dashboardNotifier.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/navigationBarIcon.dart';

import 'package:webview_flutter/webview_flutter.dart';


class DashBoardHome extends StatefulWidget {
  VoidCallback drawerCallback;
  DashBoardHome({this.drawerCallback});

  @override
  _DashBoardHomeState createState() => _DashBoardHomeState();
}

class _DashBoardHomeState extends State<DashBoardHome> with TickerProviderStateMixin{
  bool isEdit=false;
  bool isListScroll=false;


  ScrollController scrollController;
  ScrollController listViewController;

  int selectedIndex=-1;


  List<Color> gradientColors = [
    const Color(0xFFFFC010),
    const Color(0xFFc99e28),
  ];


  @override
  void initState() {
    isEdit=false;
    WidgetsBinding.instance.addPostFrameCallback((_){


      scrollController=new ScrollController();
      listViewController=new ScrollController();
      setState(() {

      });
      if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();




    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

return Scaffold(
body: WebView(
initialUrl: 'https://www.google.com/',
javascriptMode: JavascriptMode.unrestricted,
),
);
  }




}



/*
return Scaffold(
body: WebView(
initialUrl: 'https://www.google.com/',
javascriptMode: JavascriptMode.unrestricted,
),
);*/
