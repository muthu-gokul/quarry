import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quarry/model/manageUsersModel/manageUsersPlantModel.dart';
import 'package:quarry/notifier/dieselNotifier.dart';
import 'package:quarry/notifier/productionNotifier.dart';
import 'package:quarry/notifier/profileNotifier.dart';
import 'package:quarry/pages/dieselManagement/dieselIssueAddNew.dart';
import 'package:quarry/pages/dieselManagement/dieselPlantList.dart';
import 'package:quarry/pages/productionDetails/productionDetailsAddNew.dart';
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/constants.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/bottomBarAddButton.dart';
import 'package:quarry/widgets/editDelete.dart';
import 'package:quarry/widgets/navigationBarIcon.dart';
import 'package:quarry/widgets/staticColumnScroll/customDataTable2.dart';
import 'package:quarry/widgets/dateRangePicker.dart' as DateRagePicker;
import 'dieselPurchaseAddNew.dart';



class DieselGrid extends StatefulWidget {
  VoidCallback? drawerCallback;
  DieselGrid({this.drawerCallback});
  @override
  DieselGridState createState() => DieselGridState();
}

class DieselGridState extends State<DieselGrid> with TickerProviderStateMixin{

  bool showEdit=false;
  int? selectedIndex;

  PageController? pageController;

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
                                        width: SizeConfig.screenWidth!*0.35,
                                        margin: EdgeInsets.only(right: SizeConfig.width10!),
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
                                                    width: SizeConfig.screenWidth!*0.35,
                                                    child: FittedBox(child: Text("$i",style: TextStyle(fontFamily: 'RR',fontSize: 14,color: Colors.white),))),
                                                SizedBox(height: 5,),
                                                Container(
                                                  height: 25,
                                                  padding: EdgeInsets.only(left: 5,right: 5),
                                                  width: SizeConfig.screenWidth!*0.35,
                                                  child: FittedBox(

                                                    child:Text("${value??"0.0"}",style: TextStyle(fontFamily: 'RM',fontSize: 16,color: AppTheme.yellowColor,letterSpacing: 0.1),),
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
                                        width: SizeConfig.screenWidth!*0.38,
                                        margin: EdgeInsets.only(right: SizeConfig.width10!),
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
                                                    height: 16,
                                                    padding: EdgeInsets.only(left: 5,right: 5),
                                                    width: SizeConfig.screenWidth!*0.35,
                                                    child: FittedBox(child: Text("$i",style: TextStyle(fontFamily: 'RR',fontSize: 14,color: Colors.white),))),
                                                SizedBox(height: 5,),
                                                Container(
                                                  height: 23,
                                                  padding: EdgeInsets.only(left: 5,right: 5),
                                                  width: SizeConfig.screenWidth!*0.35,
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
                            size: Size( SizeConfig.screenWidth!, 65),
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
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        SizedBox(width: 15,),
                                        Consumer<ProfileNotifier>(
                                            builder: (context,pro,child)=> GestureDetector(
                                              onTap: (){
                                                if(pro.usersPlantList.length>1){
                                                  if(dn.filterUsersPlantList.isEmpty){
                                                    setState(() {
                                                      pro.usersPlantList.forEach((element) {
                                                        dn.filterUsersPlantList.add(ManageUserPlantModel(
                                                          plantId: element.plantId,
                                                          plantName: element.plantName,
                                                          isActive: element.isActive,

                                                        ));
                                                      });
                                                    });
                                                  }
                                                  else if(dn.filterUsersPlantList.length!=pro.usersPlantList.length){
                                                    dn.filterUsersPlantList.clear();
                                                    setState(() {
                                                      pro.usersPlantList.forEach((element) {
                                                        dn.filterUsersPlantList.add(ManageUserPlantModel(
                                                          plantId: element.plantId,
                                                          plantName: element.plantName,
                                                          isActive: element.isActive,

                                                        ));
                                                      });
                                                    });
                                                  }

                                                  Navigator.push(context, _createRouteDieselPlant());
                                                }
                                              },
                                              child: SvgPicture.asset("assets/bottomIcons/plant-slection.svg",height: 45,width: 35,
                                                color: pro.usersPlantList.length<=1?AppTheme.bgColor.withOpacity(0.4):AppTheme.bgColor,),
                                            )
                                        ),
                                     //   SizedBox(width: 20,),
                                        GestureDetector(
                                          onTap: (){
                                            dn.GetDieselPurchaseDbHit(context, null);
                                            pageController!.animateToPage(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                                          },
                                          child: Container(
                                            width: 70,
                                            height: 45,
                                            child:Opacity(
                                                opacity: pageIndex==0?1:0.5,
                                                child: SvgPicture.asset(pageIndex==0?"assets/bottomIcons/diesel-in.svg":
                                                  "assets/bottomIcons/diesel-in-gray.svg",)
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        GestureDetector(
                                          onTap: (){
                                            pageController!.animateToPage(1, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                                            dn.GetDieselIssueDbHit(context, null);
                                          },
                                          child: Container(
                                            width: 70,
                                             height: 40,
                                            margin: EdgeInsets.only(bottom: 5,right: 10),
                                            child:Opacity(
                                                opacity: pageIndex==1?1:0.5,
                                                child: SvgPicture.asset(pageIndex==1?"assets/bottomIcons/diesel-out.svg":
                                                  "assets/bottomIcons/diesel-out-gray.svg",)
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async{
                                            final List<DateTime?>?  picked1 = await DateRagePicker.showDatePicker(
                                                context: context,
                                                initialFirstDate: new DateTime.now(),
                                                initialLastDate: (new DateTime.now()),
                                                firstDate: DateTime.parse('2021-01-01'),
                                                lastDate: (new DateTime.now())
                                            );
                                            if (picked1 != null && picked1.length == 2) {
                                              setState(() {
                                                dn.picked=picked1;
                                                if(pageIndex==0){
                                                  dn.GetDieselPurchaseDbHit(context,null);
                                                }else{
                                                  dn.GetDieselIssueDbHit(context,null);
                                                }

                                              });
                                            }
                                            else if(picked1!=null && picked1.length ==1){
                                              setState(() {
                                                dn.picked=picked1;
                                                if(pageIndex==0){
                                                  dn.GetDieselPurchaseDbHit(context,null);
                                                }else{
                                                  dn.GetDieselIssueDbHit(context,null);
                                                }
                                              });
                                            }

                                          },
                                          child: Padding(
                                            padding:  EdgeInsets.only(bottom: 10),
                                            child: SvgPicture.asset("assets/svg/calender.svg",width: 27,height: 30,color: AppTheme.bgColor,
                                              //    color: qn.selectedIndex==-1? AppTheme.bgColor.withOpacity(0.5):isOpen?AppTheme.bgColor:AppTheme.bgColor.withOpacity(0.5),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width:20,),
                                      ],
                                    )
                                ),
                              ),

                              EditDelete(
                                showEdit: showEdit,
                                editTap: (){
                                  if(pageIndex==0){
                                    dn.insertDP_Form();
                                    dn.updateDieselEdit(true);
                                    dn.PlantUserDropDownValues(context).then((value) {
                                      dn.DieselDropDownValues(context);
                                      dn.GetDieselPurchaseDbHit(context, dn.dieselPurchaseGridList[selectedIndex!].dieselPurchaseId);
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
                                      dn.GetDieselIssueDbHit(context, dn.dieselIssueGridList[selectedIndex!].dieselIssueId);
                                      setState(() {
                                        selectedIndex=-1;
                                        showEdit=false;
                                      });
                                    });
                                    Navigator.push(context, _createRouteDieselIssue());
                                  }

                                },
                                deleteTap: (){
                                 /* if(pageIndex==1){
                                    dn.DeleteDieselIssueDbHit(context, dn.dieselIssueGridList[selectedIndex].dieselIssueId);
                                    setState(() {
                                      showEdit=false;
                                      selectedIndex=-1;
                                    });
                                  }*/
                                },
                                hasEditAccess: userAccessMap[57],
                                hasDeleteAccess: userAccessMap[58],
                              ),

                              /*  if(pageIndex==1){
                                              dn.DeleteDieselIssueDbHit(context, dn.dieselIssueGridList[selectedIndex].dieselIssueId);
                                              setState(() {
                                                showEdit=false;
                                                selectedIndex=-1;
                                              });
                                            }*/




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
                    hasAccess: userAccessMap[56],
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
  Route _createRouteDieselPlant() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => DieselPlantList(pageIndex),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        return SlideTransition(
          position: Tween<Offset>(begin: Offset(-1.0,0.0), end: Offset.zero).animate(animation),
          child: child,
        );
      },
    );
  }
}

