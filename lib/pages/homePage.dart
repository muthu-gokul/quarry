import 'dart:async';
import 'dart:io';

import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/pages/quarryMaster/quarryMaster.dart';
import 'package:quarry/pages/sale/salesDetail.dart';
import 'package:quarry/pages/vendor/vendorMaster.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quarry/widgets/reportpdf.dart';
import 'customerDetails/customerGrid.dart';
import 'process/MaterialMasterGrid.dart';
import 'process/processAddNew.dart';
import 'process/processMaterialsList.dart';
import 'process/processStoneList.dart';
import 'qLocMaterials.dart';
import 'qLocPAyment.dart';
import 'quarryMaster/quarryLocationAddNew.dart';
import 'sale/saleAddNew.dart';
import 'sale/saleGrid.dart';
import 'vendor/vendorLocAddNew.dart';



class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  GlobalKey <ScaffoldState> scaffoldkey=new GlobalKey<ScaffoldState>();
  var inn;

  int menuSelected;




  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    setState(() {
      menuSelected=1;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    inn=Provider.of<QuarryNotifier>(context,listen: false);
    SizeConfig().init(context);
    return Scaffold(
        key: scaffoldkey,
        drawer: Container(
          width: SizeConfig.screenWidth*0.7,
          height: double.maxFinite,
          child: Drawer(
            child:Container(
              color:Color(0xff3B3B3D),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    // padding: EdgeInsets.all(10),
                    // color:Color(0xff213141),
                    child: Column(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              // Padding(
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: Image.asset("assets/drawerImages/close-btn.png",width: 50,height: 50,),
                              // ),
                              SizedBox(width: SizeConfig.width20,),
                              SvgPicture.asset("assets/images/slide-logo.svg",height: 50,width: 250,)

                            ],
                          ),
                          //  decoration: BoxDecoration
                          //    shape: BoxShape.
                          // ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    height: SizeConfig.screenHeight*0.93,
                    child: Column(
                      children: [
                        Container(
                          height: (SizeConfig.screenHeight*0.93)-80,
                          child: ListView(
                            children: [
                              // RaisedButton(onPressed: (){
                              //   reportView(context,'df');
                              // }),
                              DrawerContent(
                                height: 50,
                                image: "assets/drawerImages/dashboard.png",
                                title: 'Company Detail',
                                titleColor: AppTheme.yellowColor,
                                callback: (){
                                  Provider.of<QuarryNotifier>(context,listen: false).GetQuarryDetailDbhit(context);
                                  setState(() {
                                    menuSelected=1;
                                    scaffoldkey.currentState.openEndDrawer();
                                  });
                                },
                              ),
                              DrawerContent(
                                height: 50,
                                image: "assets/drawerImages/dashboard.png",
                                title: 'Sales Detail',
                                titleColor: AppTheme.yellowColor,
                                callback: (){
                                  Provider.of<QuarryNotifier>(context,listen: false).initDropDownValues(context);
                                  Provider.of<QuarryNotifier>(context,listen: false).GetCustomerDetailDbhit(context);
                                  Provider.of<QuarryNotifier>(context,listen: false).GetSaleDetailDbhit(context);
                                  setState(() {
                                    menuSelected=4;
                                    scaffoldkey.currentState.openEndDrawer();
                                  });
                                },
                              ),
                              DrawerContent(
                                height: 50,
                                image: "assets/drawerImages/dashboard.png",
                                title: 'Customer Detail',
                                titleColor: AppTheme.yellowColor,
                                callback: (){
                                  Provider.of<QuarryNotifier>(context,listen: false).initDropDownValues(context);
                                  Provider.of<QuarryNotifier>(context,listen: false).GetCustomerDetailDbhit(context);
                                  setState(() {
                                    menuSelected=5;
                                    scaffoldkey.currentState.openEndDrawer();
                                  });
                                },
                              ),
                              DrawerContent(
                                height: 50,
                                image: "assets/drawerImages/dashboard.png",
                                title: 'Material Detail',
                                titleColor: AppTheme.yellowColor,
                                callback: (){
                                  setState(() {
                                    menuSelected=2;
                                    Provider.of<QuarryNotifier>(context,listen: false).initDropDownValues(context);
                                    Provider.of<QuarryNotifier>(context,listen: false).GetMaterialDetailDbhit(context);
                                    scaffoldkey.currentState.openEndDrawer();
                                  });
                                },
                              ),
                              DrawerContent(
                                height: 50,
                                image: "assets/drawerImages/dashboard.png",
                                title: 'Vendor Detail',
                                titleColor: AppTheme.grey,
                                // callback: (){
                                //   setState(() {
                                //     menuSelected=3;
                                //     scaffoldkey.currentState.openEndDrawer();
                                //   });
                                // },
                              ),
                              DrawerContent(
                                height: 50,
                                image: "assets/drawerImages/dashboard.png",
                                title: 'Dashboard',
                                titleColor: AppTheme.grey,
                                // callback: (){
                                //   setState(() {
                                //     menuSelected=3;
                                //     scaffoldkey.currentState.openEndDrawer();
                                //   });
                                // },
                              ),
                              DrawerContent(
                                height: 50,
                                image: "assets/drawerImages/dashboard.png",
                                title: 'Purchase Form',
                                titleColor: AppTheme.grey,
                                // callback: (){
                                //   setState(() {
                                //     menuSelected=3;
                                //     scaffoldkey.currentState.openEndDrawer();
                                //   });
                                // },
                              ),
                              DrawerContent(
                                height: 50,
                                image: "assets/drawerImages/dashboard.png",
                                title: 'Inventory Group',
                                titleColor: AppTheme.grey,
                                // callback: (){
                                //   setState(() {
                                //     menuSelected=3;
                                //     scaffoldkey.currentState.openEndDrawer();
                                //   });
                                // },
                              ),
                              DrawerContent(
                                height: 50,
                                image: "assets/drawerImages/dashboard.png",
                                title: 'Diesel',
                                titleColor: AppTheme.grey,
                                // callback: (){
                                //   setState(() {
                                //     menuSelected=3;
                                //     scaffoldkey.currentState.openEndDrawer();
                                //   });
                                // },
                              ),
                              DrawerContent(
                                height: 50,
                                image: "assets/drawerImages/dashboard.png",
                                title: 'Account Group',
                                titleColor: AppTheme.grey,
                                // callback: (){
                                //   setState(() {
                                //     menuSelected=3;
                                //     scaffoldkey.currentState.openEndDrawer();
                                //   });
                                // },
                              ),
                              DrawerContent(
                                height: 50,
                                image: "assets/drawerImages/dashboard.png",
                                title: 'Employee Group',
                                titleColor: AppTheme.grey,
                                // callback: (){
                                //   setState(() {
                                //     menuSelected=3;
                                //     scaffoldkey.currentState.openEndDrawer();
                                //   });
                                // },
                              ),
                              DrawerContent(
                                height: 50,
                                image: "assets/drawerImages/dashboard.png",
                                title: 'Reports',
                                titleColor: AppTheme.grey,
                                // callback: (){
                                //   setState(() {
                                //     menuSelected=3;
                                //     scaffoldkey.currentState.openEndDrawer();
                                //   });
                                // },
                              ),
                              DrawerContent(
                                height: 50,
                                image: "assets/drawerImages/dashboard.png",
                                title: 'Settings',
                                titleColor: AppTheme.grey,
                                // callback: (){
                                //   setState(() {
                                //     menuSelected=3;
                                //     scaffoldkey.currentState.openEndDrawer();
                                //   });
                                // },
                              ),

                            ],
                          ),
                        ),





                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),


        body: menuSelected==1?QuaryAddNew(drawerCallback: (){
          scaffoldkey.currentState.openDrawer();
        },):
        menuSelected==2?MaterialMaster(drawerCallback: (){
          scaffoldkey.currentState.openDrawer();
        },):
        menuSelected==3?VendorMaster(drawerCallback: (){
          scaffoldkey.currentState.openDrawer();
        },):
        menuSelected==4?SaleGrid(drawerCallback: (){
          scaffoldkey.currentState.openDrawer();
        },):
        menuSelected==5?CustomerMaster(drawerCallback: (){
          scaffoldkey.currentState.openDrawer();
        },):Container()
    );
  }
}

class DrawerContent extends StatelessWidget {

  VoidCallback callback;
  String image;
  String title;
  double height;
  Color titleColor;

  DrawerContent({this.callback,this.title,this.image,this.height,this.titleColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.maxFinite,
      // decoration:BoxDecoration(
      //   borderRadius: BorderRadius.circular(10),
      //   color: Color(0xff213141),
      // ) ,
      padding: const EdgeInsets.only(left:10.0),
      child: ListTile(
          // leading: Image.asset(image,width: 25),
          title: Text(title, style: TextStyle(fontSize: 16,color:titleColor, fontFamily:'RR'), ),
          onTap: callback
      ),
    );
  }
}








