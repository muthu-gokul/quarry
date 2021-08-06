/*import 'dart:async';
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
        initialUrl: 'https://s3.amazonaws.com/qmsadminpanel.com/Quarry/Views/Dashboard/dashboard.html',
        javascriptMode: JavascriptMode.unrestricted,
        ),
        );
  }
}*/

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/dashboardNotifier.dart';
import 'package:quarry/pages/dashboard/salesDashBoard.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/navigationBarIcon.dart';
import 'package:quarry/widgets/dateRangePicker.dart' as DateRagePicker;

class DashBoardHome extends StatefulWidget {

  VoidCallback drawerCallback;
  DashBoardHome({this.drawerCallback});
  @override
  _DashBoardHomeState createState() => _DashBoardHomeState();
}

class _DashBoardHomeState extends State<DashBoardHome> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<DashboardNotifier>(
        builder:(ctx,db,c)=> Container(
          height: SizeConfig.screenHeight,
          width: SizeConfig.screenWidth,
          child: Column(
            children: [
              Container(
                height: 50,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: widget.drawerCallback,
                      child: NavBarIcon(),
                    ),
                    Text("Dashboard",
                        style: AppTheme.appBarTS
                    ),
                    Spacer(),

                    SizedBox(width: 20,)
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: 3,
                    itemBuilder: (ctx,i){
                  return InkWell(
                    onTap: (){
                      if(i==0){
                        Navigator.push(context, MaterialPageRoute(builder: (ctx)=>SalesDashBoard()));
                      }
                    },
                    child: Text("dgdg"),
                  );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
