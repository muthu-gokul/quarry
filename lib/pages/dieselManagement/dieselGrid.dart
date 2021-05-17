import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/dieselNotifier.dart';
import 'package:quarry/notifier/productionNotifier.dart';
import 'package:quarry/pages/dieselManagement/dieselIssueAddNew.dart';
import 'package:quarry/pages/productionDetails/productionDetailsAddNew.dart';
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/bottomBarAddButton.dart';
import 'package:quarry/widgets/navigationBarIcon.dart';
import 'package:quarry/widgets/staticColumnScroll/customDataTable2.dart';

import 'dieselPurchaseAddNew.dart';



class DieselGrid extends StatefulWidget {
  VoidCallback drawerCallback;
  DieselGrid({this.drawerCallback});
  @override
  DieselGridState createState() => DieselGridState();
}

class DieselGridState extends State<DieselGrid> with TickerProviderStateMixin{

  bool showEdit=false;
  int selectedIndex;

  PageController pageController;

  ScrollController header=new ScrollController();
  ScrollController body=new ScrollController();
  ScrollController verticalLeft=new ScrollController();
  ScrollController verticalRight=new ScrollController();

  bool showShadow=false;
  int pageIndex=0;

  @override
  void initState() {
    pageController=new PageController(initialPage: 0);
    header.addListener(() {
      if(body.offset!=header.offset){
        body.jumpTo(header.offset);
      }
      if(header.offset==0){
        setState(() {
          showShadow=false;
        });
      }
      else{
        if(!showShadow){
          setState(() {
            showShadow=true;
          });
        }
      }
    });

    body.addListener(() {
      if(header.offset!=body.offset){
        header.jumpTo(body.offset);
      }
    });

    verticalLeft.addListener(() {
      if(verticalRight.offset!=verticalLeft.offset){
        verticalRight.jumpTo(verticalLeft.offset);
      }
    });

    verticalRight.addListener(() {
      if(verticalLeft.offset!=verticalRight.offset){
        verticalLeft.jumpTo(verticalRight.offset);
      }
    });
    super.initState();
  }

  List<GridStyleModel> gridDataRowList=[
    GridStyleModel(columnName: "Bill Number"),
    GridStyleModel(columnName: "Date"),
    GridStyleModel(columnName: "Supplier Name"),
    GridStyleModel(columnName: "Purchaser Name"),
    GridStyleModel(columnName: "Location",width: 200),
    GridStyleModel(columnName: "Quantity"),
    GridStyleModel(columnName: "Diesel Price"),
    GridStyleModel(columnName: "Total Price"),

  ];
  List<GridStyleModel> gridDataRowListDieselIssue=[
    GridStyleModel(columnName: "Date"),
    GridStyleModel(columnName: "Type"),
    GridStyleModel(columnName: "Machine/Vehicle"),
    GridStyleModel(columnName: "Diesel Quantity"),
    GridStyleModel(columnName: "Issued By"),
    GridStyleModel(columnName: "Fuel Reading"),


  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Colors.black
        ),
        child: SafeArea(
          child: Consumer<DieselNotifier>(
            builder: (context,dn,child)=>  Stack(
              children: [

                PageView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: pageController,
                  onPageChanged: (i){
                    setState(() {
                      pageIndex=i;
                    });
                  },
                  children: [
                    //Diesel Purchase
                    Stack(
                      children: [
                        Opacity(
                          opacity: 0.8,
                          child: Container(
                            width: double.maxFinite,
                            height:  200,

                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("assets/svg/gridHeader/reportsHeader.jpg",),
                                    fit: BoxFit.cover
                                )

                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          width: SizeConfig.screenWidth,
                         // color: AppTheme.yellowColor,

                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: widget.drawerCallback,
                                child: NavBarIcon(),
                              ),
                              /*SizedBox(width: SizeConfig.width10,),*/
                              Text("Diesel Management",
                                style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize:16),
                              ),
                              Spacer(),
                              Container(
                                height: 30,
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.white
                                ),
                                child: Center(
                                  child: Text("Diesel Purchase",style: TextStyle(fontFamily: 'RR',fontSize: 14,color: Colors.green),),
                                ),
                              ),
                              SizedBox(width: SizeConfig.width10,),

                            ],
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 50),
                            padding: EdgeInsets.only(left:5),
                          //  color: AppTheme.yellowColor,
                            height: 110,
                            alignment: Alignment.topCenter,

                            child:SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(

                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: dn.dieselPurchaseGridOverAllHeader.
                                  map((i, value) => MapEntry(i,
                                      Container(
                                        height: 80,
                                        width: SizeConfig.screenWidth*0.35,
                                        margin: EdgeInsets.only(right: SizeConfig.width10),
                                        //padding: EdgeInsets.only(right: SizeConfig.width10),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color: AppTheme.bgColor
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                    padding: EdgeInsets.only(left: 5,right: 5),
                                                    height: 15,
                                                    width: SizeConfig.screenWidth*0.35,
                                                    child: FittedBox(child: Text("$i",style: TextStyle(fontFamily: 'RR',fontSize: 14,color: Colors.white),))),
                                                SizedBox(height: 5,),
                                                Container(
                                                  height: 25,
                                                  padding: EdgeInsets.only(left: 5,right: 5),
                                                  width: SizeConfig.screenWidth*0.35,
                                                  child: FittedBox(

                                                    child:Text("$value",style: TextStyle(fontFamily: 'RM',fontSize: 16,color: AppTheme.yellowColor,letterSpacing: 0.1),),
                                                  ),
                                                )
                                              ],
                                            ),

                                          ],

                                        ),
                                      )
                                  )
                                  ).values.toList()
                              ),
                            )
                        ),
                        CustomDataTable2(
                          topMargin: 140,
                          gridBodyReduceHeight: 260,
                          selectedIndex: selectedIndex,

                          gridData: dn.dieselPurchaseGridList,
                          gridDataRowList: gridDataRowList,
                          func: (index){
                            if(selectedIndex==index){
                              setState(() {
                                selectedIndex=-1;
                                showEdit=false;
                              });

                            }
                            else{
                              setState(() {
                                selectedIndex=index;
                                showEdit=true;
                              });
                            }
                          },
                        ),

                      ],
                    ),

                    //Diesel Management
                    Stack(
                      children: [
                        Opacity(
                          opacity: 0.8,
                          child: Container(
                            width: double.maxFinite,
                            height:  160,

                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("assets/svg/gridHeader/reportsHeader.jpg",),
                                    fit: BoxFit.cover
                                )

                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          padding: EdgeInsets.only(bottom: 10),
                          width: SizeConfig.screenWidth,
                         // color: AppTheme.yellowColor,
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: widget.drawerCallback,
                                child: NavBarIcon(),
                              ),
                              Text("Diesel Management",
                                style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize:16),
                              ),
                              Spacer(),
                              Container(
                                height: 30,
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.white
                                ),
                                child: Center(
                                  child: Text("Diesel Issue",style: TextStyle(fontFamily: 'RR',fontSize: 14,color: Colors.red),),
                                ),
                              ),
                              SizedBox(width: SizeConfig.width10,),


                            ],
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 50),
                            padding: EdgeInsets.only(left:5),
                          //  color: AppTheme.yellowColor,
                            height: 110,
                            alignment: Alignment.topCenter,

                            child:SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(

                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: dn.dieselIssueGridOverAllHeader.
                                  map((i, value) => MapEntry(i,
                                      Container(
                                        height: 80,
                                        width: SizeConfig.screenWidth*0.35,
                                        margin: EdgeInsets.only(right: SizeConfig.width10),
                                        //padding: EdgeInsets.only(right: SizeConfig.width10),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color: AppTheme.bgColor
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                    height: 15,
                                                    padding: EdgeInsets.only(left: 5,right: 5),
                                                    width: SizeConfig.screenWidth*0.35,
                                                    child: FittedBox(child: Text("$i",style: TextStyle(fontFamily: 'RR',fontSize: 14,color: Colors.white),))),
                                                SizedBox(height: 5,),
                                                Container(
                                                  height: 25,
                                                  padding: EdgeInsets.only(left: 5,right: 5),
                                                  width: SizeConfig.screenWidth*0.35,
                                                  child: FittedBox(

                                                    child:Text("$value",style: TextStyle(fontFamily: 'RM',fontSize: 16,color: AppTheme.yellowColor,letterSpacing: 0.1),),
                                                  ),
                                                )
                                              ],
                                            ),

                                          ],

                                        ),
                                      )
                                  )
                                  ).values.toList()
                              ),
                            )
                        ),

                        CustomDataTable2(
                          topMargin: 140,
                          gridBodyReduceHeight: 260,
                          selectedIndex: selectedIndex,

                          gridData: dn.dieselIssueGridList,
                          gridDataRowList: gridDataRowListDieselIssue,
                          func: (index){
                            if(selectedIndex==index){
                              setState(() {
                                selectedIndex=-1;
                                showEdit=false;
                              });

                            }
                            else{
                              setState(() {
                                selectedIndex=index;
                                showEdit=true;
                              });
                            }
                          },
                        ),



                      ],
                    ),
                  ],
                ),







                //bottomNav
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: SizeConfig.screenWidth,
                    height: 70,

                    decoration: BoxDecoration(
                        color: AppTheme.gridbodyBgColor,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.gridbodyBgColor,
                            spreadRadius: 2,
                            blurRadius: 15,
                            offset: Offset(0, -20), // changes position of shadow
                          )
                        ]
                    ),
                    child: Stack(

                      children: [
                        Container(
                          decoration: BoxDecoration(
                          ),
                          margin:EdgeInsets.only(top: 0),
                          child: CustomPaint(
                            size: Size( SizeConfig.screenWidth, 65),
                            //  painter: RPSCustomPainter(),
                            painter: RPSCustomPainter3(),
                          ),
                        ),

                        Container(
                          width:  SizeConfig.screenWidth,
                          height: 80,

                          child: Stack(

                            children: [

                              AnimatedPositioned(
                                bottom:showEdit?-60:5,
                                duration: Duration(milliseconds: 300,),
                                curve: Curves.bounceInOut,
                                child: Container(
                                    width: SizeConfig.screenWidth,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(width: SizeConfig.width20,),
                                        GestureDetector(
                                          onTap: (){
                                            pageController.animateToPage(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                                          },
                                          child: Container(
                                            width: 70,

                                            child:Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Image.asset("assets/images/Empty-vehicle-active.png",height: 40,width: 40,),
                                                Text('Purchase',style: TextStyle(fontFamily: 'RR',fontSize: 14,color: AppTheme.hintColor),),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        GestureDetector(
                                          onTap: (){
                                            pageController.animateToPage(1, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                                            dn.GetDieselIssueDbHit(context, null);
                                          },
                                          child: Container(
                                            width: 90,

                                            child:Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Image.asset("assets/images/Loaded-vehicle-active.png",height: 40,width: 40,),
                                                Text('Issue',style: TextStyle(fontFamily: 'RR',fontSize: 14,color: AppTheme.hintColor),),

                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: SizeConfig.width10,),
                                      ],
                                    )
                                ),
                              ),

                              AnimatedPositioned(
                                bottom:showEdit?15:-60,
                                duration: Duration(milliseconds: 300,),
                                curve: Curves.bounceInOut,
                                child: Container(

                                    width: SizeConfig.screenWidth,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(width: SizeConfig.width20,),
                                        GestureDetector(
                                          onTap: (){

                                            if(pageIndex==0){
                                              dn.insertDP_Form();
                                              dn.updateDieselEdit(true);
                                              dn.PlantUserDropDownValues(context).then((value) {
                                                dn.DieselDropDownValues(context);
                                                dn.GetDieselPurchaseDbHit(context, dn.dieselPurchaseGridList[selectedIndex].dieselPurchaseId);
                                                setState(() {
                                                  selectedIndex=-1;
                                                  showEdit=false;
                                                });
                                              });
                                              Navigator.push(context, _createRoute());
                                            }
                                            else if(pageIndex==1){
                                              dn.insertDI_form();
                                              dn.updateDieselIssueEdit(true);
                                              dn.PlantUserDropDownValues(context).then((value) {
                                                dn.DieselDropDownValues(context);
                                                dn.GetDieselIssueDbHit(context, dn.dieselIssueGridList[selectedIndex].dieselIssueId);
                                                setState(() {
                                                  selectedIndex=-1;
                                                  showEdit=false;
                                                });
                                              });
                                              Navigator.push(context, _createRouteDieselIssue());
                                            }





                                          },
                                          child: Container(
                                            width: 70,
                                            decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: AppTheme.yellowColor.withOpacity(0.7),
                                                    spreadRadius: -3,
                                                    blurRadius: 15,
                                                    offset: Offset(0, 7), // changes position of shadow
                                                  )
                                                ]
                                            ),
                                            child:FittedBox(
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset("assets/svg/edit.svg",height: 20,width: 20,color: AppTheme.yellowColor,),
                                                  SizedBox(width: SizeConfig.width10,),
                                                  Text("Edit",style: TextStyle(fontSize: 20,fontFamily: 'RR',color:Color(0xFFFF9D10)),),


                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        GestureDetector(
                                          onTap: (){
                                            if(pageIndex==1){
                                              dn.DeleteDieselIssueDbHit(context, dn.dieselIssueGridList[selectedIndex].dieselIssueId);
                                              setState(() {
                                                showEdit=false;
                                                selectedIndex=-1;
                                              });
                                            }
                                          },
                                          child: Container(
                                            width: 90,
                                            decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: AppTheme.red.withOpacity(0.5),
                                                    spreadRadius: -3,
                                                    blurRadius: 25,
                                                    offset: Offset(0, 7), // changes position of shadow
                                                  )
                                                ]
                                            ),
                                            child:FittedBox(
                                              child: Row(
                                                children: [
                                                  Text("Delete",style: TextStyle(fontSize: 18,fontFamily: 'RR',color:Colors.red),),
                                                  SizedBox(width: SizeConfig.width10,),
                                                  SvgPicture.asset("assets/svg/delete.svg",height: 20,width: 20,color: AppTheme.red,),




                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: SizeConfig.width10,),
                                      ],
                                    )
                                ),
                              )

                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                //addButton
                Align(
                  alignment: Alignment.bottomCenter,
                  child: AddButton(
                    ontap: (){
                      if(pageIndex==0){
                        dn.updateDieselEdit(false);
                        dn.PlantUserDropDownValues(context);
                        dn.DieselDropDownValues(context);
                        dn.insertDP_Form();
                        Navigator.push(context, _createRoute());
                      }
                      else if(pageIndex==1){
                        dn.updateDieselIssueEdit(false);
                        dn.PlantUserDropDownValues(context);
                        dn.DieselDropDownValues(context);
                        dn.insertDI_form();
                        Navigator.push(context, _createRouteDieselIssue());
                      }
                    },
                    image: "assets/svg/plusIcon.svg",
                  ),
                ),


                Container(

                  height: dn.DieselLoader? SizeConfig.screenHeight:0,
                  width: dn.DieselLoader? SizeConfig.screenWidth:0,
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppTheme.yellowColor),),
                  ),

                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => DieselPurchaseForm(),

      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        return FadeTransition(
          opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
          child: child,
        );
      },
    );
  }
  Route _createRouteDieselIssue() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => DieselIssueForm(),

      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        return FadeTransition(
          opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
          child: child,
        );
      },
    );
  }
}

