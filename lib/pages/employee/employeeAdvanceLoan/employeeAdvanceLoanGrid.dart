import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/enployeeAdvanceLoanNotifier.dart';
import 'package:quarry/pages/employee/employeeAdvanceLoan/employeeAdvanceLoanAddNew.dart';
import 'package:quarry/pages/employee/employeeMaster/employeeView.dart';
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/bottomBarAddButton.dart';
import 'package:quarry/widgets/navigationBarIcon.dart';



class EmployeeAdvanceLoanGrid extends StatefulWidget {
  VoidCallback? drawerCallback;
  EmployeeAdvanceLoanGrid({this.drawerCallback});


  @override
  _EmployeeAdvanceLoanGridState createState() => _EmployeeAdvanceLoanGridState();
}

class _EmployeeAdvanceLoanGridState extends State<EmployeeAdvanceLoanGrid> {
  bool showEdit=false;
  int? selectedIndex;

  ScrollController header=new ScrollController();
  ScrollController body=new ScrollController();
  ScrollController verticalLeft=new ScrollController();
  ScrollController verticalRight=new ScrollController();

  double topMargin=50;//70 || 50
  double gridBodyReduceHeight=140;// 260  // 140

  bool showShadow=false;

  @override
  void initState() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<EmployeeAdvanceLoanNotifier>(
          builder: (context,eal,child)=> Stack(
            children: [
              Container(
                height: 70,
                width: SizeConfig.screenWidth,
                color: AppTheme.yellowColor,
                padding: AppTheme.gridAppBarPadding,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: widget.drawerCallback,
                      child: NavBarIcon(),
                    ),
                    /*SizedBox(width: SizeConfig.width10,),*/
                    Text("Employee Advance/Loan Detail",
                      style: AppTheme.appBarTS,
                    ),
                  ],
                ),
              ),

              Container(
            height: SizeConfig.screenHeight!-topMargin,
            width: SizeConfig.screenWidth,
            margin: EdgeInsets.only(top: topMargin),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
                color:AppTheme.gridbodyBgColor,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
            ),
            child: Stack(
              children: [

                //Scrollable
                Positioned(
                  left:149,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 50,
                        width: SizeConfig.screenWidth!-149,
                        color: showShadow? AppTheme.bgColor.withOpacity(0.8):AppTheme.bgColor,
                        child: SingleChildScrollView(
                          controller: header,
                          scrollDirection: Axis.horizontal,
                          child: Row(
                              children: eal.gridDataRowList.asMap().
                              map((i, value) => MapEntry(i, i==0?Container():
                              Container(
                                  alignment: value.alignment,
                                  padding: value.edgeInsets,
                                  width: value.width,
                                  constraints: BoxConstraints(
                                      minWidth: 150,
                                      maxWidth: 200
                                  ),
                                  child: FittedBox(child: Text(value.columnName!,style: AppTheme.TSWhite166,))
                              )
                              )).values.toList()
                          ),
                        ),

                      ),
                      Container(
                        height: SizeConfig.screenHeight!-gridBodyReduceHeight,
                        width: SizeConfig.screenWidth!-149,
                        alignment: Alignment.topCenter,
                        color: AppTheme.gridbodyBgColor,
                        child: SingleChildScrollView(
                          controller: body,
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            height: SizeConfig.screenHeight!-gridBodyReduceHeight,
                            alignment: Alignment.topCenter,
                            color:AppTheme.gridbodyBgColor,
                            child: SingleChildScrollView(
                              controller: verticalRight,
                              scrollDirection: Axis.vertical,
                              child: Column(
                                  children:eal.gridData!.asMap().
                                  map((i, value) => MapEntry(
                                      i,InkWell(
                                    //   onTap: widget.voidCallback,
                                    onTap: (){
                                      if(selectedIndex==i){
                                        setState(() {
                                          selectedIndex=-1;
                                          showEdit=false;
                                        });

                                      }
                                      else{
                                        setState(() {
                                          selectedIndex=i;
                                          showEdit=true;
                                        });
                                      }
                                      //setState(() {});
                                    },
                                    child: Container(

                                      decoration: BoxDecoration(
                                        border: AppTheme.gridBottomborder,
                                        color: selectedIndex==i?AppTheme.yellowColor:AppTheme.gridbodyBgColor,
                                      ),
                                      height: 50,
                                      margin: EdgeInsets.only(bottom:i==eal.gridData!.length-1?70: 0),
                                      child: Row(
                                          children: eal.gridDataRowList.asMap().map((j, v) {


                                            if((7.0*value[v.columnName].toString().length)>v.width){
                                              setState(() {
                                                v.width=7.0*value[v.columnName].toString().length;
                                              });
                                            }

                                            return MapEntry(j,
                                              j==0?Container():v.columnName!='Amount'?Container(
                                                width: v.width,
                                                height: 50,
                                                alignment: v.alignment,
                                                padding: v.edgeInsets,
                                                constraints: BoxConstraints(
                                                    minWidth: 150,
                                                    maxWidth: 200
                                                ),
                                                decoration: BoxDecoration(

                                                ),

                                                child: Text("${value[v.columnName].toString().isNotEmpty?value[v.columnName]??" ":" "}",
                                                  style:selectedIndex==i?AppTheme.bgColorTS14:AppTheme.gridTextColor14,
                                                ),
                                              ):Container(
                                                width: v.width,
                                                height: 50,
                                                alignment: v.alignment,
                                                padding: v.edgeInsets,
                                                constraints: BoxConstraints(
                                                    minWidth: 150,
                                                    maxWidth: 200
                                                ),
                                                decoration: BoxDecoration(

                                                ),

                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [

                                                   value['AmountType']=="Loan" ?SizedBox(
                                                     width:30,
                                                     child: GestureDetector(
                                                       onTap: (){
                                                         showDialog(context: context, builder: (ctx)=> Dialog(
                                                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                                           clipBehavior: Clip.antiAlias,
                                                           child: Container(
                                                             height: 400,
                                                             margin: EdgeInsets.only(left:SizeConfig.width20!,right:SizeConfig.width20!,),
                                                             width: SizeConfig.screenWidth,
                                                             color: Colors.white,
                                                         //    padding: EdgeInsets.only(left: 5),
                                                             child: Column(
                                                               mainAxisAlignment:MainAxisAlignment.start,
                                                               crossAxisAlignment: CrossAxisAlignment.center,
                                                               children: [
                                                                 SvgPicture.asset("assets/svg/loan/Loan-header.svg",height: 200,width: 200,),
                                                                 Text("Loan Details",style: TextStyle(fontFamily: 'RM',fontSize: 18,color: AppTheme.bgColor),),
                                                                 SizedBox(height: 20,),
                                                                 Container(
                                                                //   margin: EdgeInsets.only(left:SizeConfig.width20,right:SizeConfig.width20,),
                                                                   height:40,
                                                                   width: SizeConfig.screenWidthM40,
                                                                   decoration: BoxDecoration(
                                                                       color: tableColor,
                                                                       borderRadius: BorderRadius.only(topLeft: Radius.circular(3),topRight: Radius.circular(3)),
                                                                       border: Border.all(color: AppTheme.addNewTextFieldBorder)


                                                                   ),
                                                                   child:Row(
                                                                     children: [
                                                                       Container(
                                                                           padding: EdgeInsets.only(left: SizeConfig.width10!),
                                                                           width: (SizeConfig.screenWidthM40!*0.35),
                                                                           child: Text("Loan Amount",style: tableTextStyle,)
                                                                       ),

                                                                       Container(
                                                                           height: 50,
                                                                           width: 1,
                                                                           color: AppTheme.addNewTextFieldBorder
                                                                       ),

                                                                       Container(
                                                                         padding: EdgeInsets.only(left: SizeConfig.width10!),
                                                                         height: 16,
                                                                         alignment: Alignment.centerLeft,
                                                                         width: (SizeConfig.screenWidthM40!*0.35),
                                                                         child: FittedBox(child: Text("${value['LoanAmount']}",

                                                                           style:tableTextStyle,
                                                                         ),

                                                                         ),
                                                                       ),
                                                                     ],
                                                                   ),
                                                                 ),
                                                                 Container(
                                                                //   margin: EdgeInsets.only(left:SizeConfig.width20,right:SizeConfig.width20,),
                                                                   height:40,
                                                                   width: SizeConfig.screenWidthM40,
                                                                   decoration: BoxDecoration(
                                                                       color: tableColor,
                                                                       border: Border(left: BorderSide(color: AppTheme.addNewTextFieldBorder),
                                                                         right: BorderSide(color: AppTheme.addNewTextFieldBorder),bottom: BorderSide(color: AppTheme.addNewTextFieldBorder),

                                                                       )


                                                                   ),
                                                                   child:Row(
                                                                     children: [
                                                                       Container(
                                                                           padding: EdgeInsets.only(left: SizeConfig.width10!),
                                                                           width: (SizeConfig.screenWidthM40!*0.35),
                                                                           child: Text("Due Month",style: tableTextStyle,)
                                                                       ),

                                                                       Container(
                                                                           height: 50,
                                                                           width: 1,
                                                                           color: AppTheme.addNewTextFieldBorder
                                                                       ),

                                                                       Container(
                                                                         padding: EdgeInsets.only(left: SizeConfig.width10!),
                                                                         height: 16,
                                                                         alignment: Alignment.centerLeft,
                                                                         width: (SizeConfig.screenWidthM40!*0.35),
                                                                         child: FittedBox(child: Text("${value['DueMonth']}",

                                                                           style:tableTextStyle,
                                                                         ),

                                                                         ),
                                                                       ),
                                                                     ],
                                                                   ),
                                                                 ),
                                                                 Container(
                                                                //   margin: EdgeInsets.only(left:SizeConfig.width20,right:SizeConfig.width20,),
                                                                   height:40,
                                                                   width: SizeConfig.screenWidthM40,
                                                                   decoration: BoxDecoration(
                                                                       color: tableColor,
                                                                       border: Border(left: BorderSide(color: AppTheme.addNewTextFieldBorder),
                                                                         right: BorderSide(color: AppTheme.addNewTextFieldBorder),bottom: BorderSide(color: AppTheme.addNewTextFieldBorder),

                                                                       )


                                                                   ),
                                                                   child:Row(
                                                                     children: [
                                                                       Container(
                                                                           padding: EdgeInsets.only(left: SizeConfig.width10!),
                                                                           width: (SizeConfig.screenWidthM40!*0.35),
                                                                           child: Text("LoanEMI/Month",style: tableTextStyle,)
                                                                       ),

                                                                       Container(
                                                                           height: 50,
                                                                           width: 1,
                                                                           color: AppTheme.addNewTextFieldBorder
                                                                       ),

                                                                       Container(
                                                                         padding: EdgeInsets.only(left: SizeConfig.width10!),
                                                                         height: 16,
                                                                         alignment: Alignment.centerLeft,
                                                                         width: (SizeConfig.screenWidthM40!*0.35),
                                                                         child: FittedBox(child: Text("${value['LoanEMI/Month']}",

                                                                           style:tableTextStyle,
                                                                         ),

                                                                         ),
                                                                       ),
                                                                     ],
                                                                   ),
                                                                 ),

                                                               ],
                                                             ),
                                                           ),

                                                         ));
                                                       },
                                                       child: SvgPicture.asset("assets/svg/loan/Loan-icon.svg",height: 30,width: 30,),
                                                     ),
                                                   ):Container(),
                                                    SizedBox(width: 10),

                                                    value['AmountType']=="Loan" ? Container(
                                                      height:20,
                                                      width:120,
                                                      child: FittedBox(
                                                        child: Text("${value['LoanEMI/Month'].toString().isNotEmpty? "${value['LoanEMI/Month']??" "} EMI/Month" :" "}",
                                                          style:selectedIndex==i?AppTheme.bgColorTS14:AppTheme.gridTextColor14),
                                                      ),
                                                    ):
                                                            Text("${value[v.columnName].toString().isNotEmpty?value[v.columnName]??" ":" "}",
                                                      style:selectedIndex==i?AppTheme.bgColorTS14:AppTheme.gridTextColor14,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }
                                          ).values.toList()
                                      ),
                                    ),
                                  )
                                  )
                                  ).values.toList()
                              ),
                            ),


                          ),
                        ),
                      ),
                    ],
                  ),
                ),


                //not Scrollable
                Positioned(
                  left: 0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 50,
                        width: 150,
                        color: AppTheme.bgColor,
                        padding: eal.gridDataRowList[0].edgeInsets,
                        alignment: eal.gridDataRowList[0].alignment,
                        child: Text("${eal.gridDataRowList[0].columnName}",style: AppTheme.TSWhite166,),

                      ),
                      Container(
                        height: SizeConfig.screenHeight!-gridBodyReduceHeight,
                        alignment: Alignment.topCenter,
                        decoration: BoxDecoration(
                            color:showShadow? AppTheme.gridbodyBgColor:Colors.transparent,
                            boxShadow: [
                              showShadow?  BoxShadow(
                                color: AppTheme.addNewTextFieldText.withOpacity(0.1),
                                spreadRadius: 0,
                                blurRadius: 15,
                                offset: Offset(0, -8), // changes position of shadow
                              ):BoxShadow(color: Colors.transparent)
                            ]
                        ),
                        child: Container(
                          height: SizeConfig.screenHeight!-gridBodyReduceHeight,
                          alignment: Alignment.topCenter,

                          child: SingleChildScrollView(
                            controller: verticalLeft,
                            scrollDirection: Axis.vertical,
                            child: Column(
                                children: eal.gridData!.asMap().
                                map((i, value) => MapEntry(
                                    i,InkWell(
                                  onTap: (){
                                    if(selectedIndex==i){
                                      setState(() {
                                        selectedIndex=-1;
                                        showEdit=false;
                                      });

                                    }
                                    else{
                                      setState(() {
                                        selectedIndex=i;
                                        showEdit=true;
                                      });
                                    }
                                    //setState(() {});
                                  },
                                  child:  Container(
                                    alignment:eal.gridDataRowList[0].alignment,
                                    padding: eal.gridDataRowList[0].edgeInsets,
                                    margin: EdgeInsets.only(bottom:i==eal.gridData!.length-1?70: 0),
                                    decoration: BoxDecoration(
                                      border: AppTheme.gridBottomborder,
                                      color: selectedIndex==i?AppTheme.yellowColor:AppTheme.gridbodyBgColor,

                                    ),
                                    height: 50,
                                    width: 150,
                                    constraints: BoxConstraints(
                                        maxWidth: 150
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        //color:value.invoiceType=='Receivable'? Colors.green:AppTheme.red,
                                      ),
                                      child: FittedBox(
                                        fit: BoxFit.contain,
                                        child: Text("${value[eal.gridDataRowList[0].columnName]}",
                                          style:selectedIndex==i?AppTheme.bgColorTS14:AppTheme.gridTextColor14,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                )
                                ).values.toList()


                            ),
                          ),


                        ),
                      ),
                    ],
                  ),
                ),


              ],
            )

        ),
              



              //bottomNav
              Positioned(
                bottom: 0,
                child: Container(
                  width: SizeConfig.screenWidth,
                  height: 65,

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
                        margin:EdgeInsets.only(top: 0),
                        child: CustomPaint(
                          size: Size( SizeConfig.screenWidth!, 65),
                          painter: RPSCustomPainter3(),
                        ),
                      ),

                      Container(
                        width:  SizeConfig.screenWidth,
                        height: 80,

                        child: Stack(

                          children: [
                            AnimatedPositioned(
                              bottom:showEdit?5:-60,
                              duration: Duration(milliseconds: 300,),
                              curve: Curves.bounceOut,
                              child: Container(

                                  width: SizeConfig.screenWidth,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [

                                      GestureDetector(
                                        onTap: (){
                                          eal.updateisEdit(true);
                                          eal.EmployeeAdvanceDropDownValues(context).then((value) {
                                            eal.GetEmployeeAttendanceLoanDbHit(context, eal.gridData![selectedIndex!]['EmployeeId']);
                                            Navigator.push(context, _createRoute());
                                            setState(() {
                                              showEdit=false;
                                              selectedIndex=-1;
                                            });
                                          });

                                        },
                                        child:Container(
                                          width: 130,
                                          height: 50,
                                          padding: EdgeInsets.only(left: 20),
                                          child:FittedBox(
                                            child: Container(
                                                height: 55,
                                                width: 130,
                                                alignment: Alignment.centerLeft,
                                                child: FittedBox(child: Image.asset("assets/bottomIcons/edit-text-icon.png"))
                                            ),
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                        width: 130,
                                        height: 50,
                                        padding: EdgeInsets.only(right: 20),
                                        child:FittedBox(
                                          child: Container(
                                              height: 47,
                                              width: 130,
                                              alignment: Alignment.centerRight,
                                              child: FittedBox(child: Image.asset("assets/bottomIcons/delete-text-icon.png"))
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                              ),
                            ),



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

                    eal.updateisEdit(false);
                    eal.EmployeeAdvanceDropDownValues(context);
                    Navigator.push(context, _createRoute());
                  },
                  image: "assets/svg/plusIcon.svg",
                ),
              ),





              Container(

                height: eal.EmployeeAttendanceLoader? SizeConfig.screenHeight:0,
                width: eal.EmployeeAttendanceLoader? SizeConfig.screenWidth:0,
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppTheme.yellowColor),),
                ),
              )

            ],
          )
      ),
    );
  }
  TextStyle tableTextStyle=TextStyle(fontFamily: 'RR',color: AppTheme.gridTextColor);
  // Color tableColor=AppTheme.disableColor.withOpacity(0.5);
  Color tableColor=AppTheme.gridbodyBgColor;
  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => EmployeeAdvanceAddNew(),

      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        return FadeTransition(
          opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
          child: child,
        );
      },
    );
  }
  Route _createRouteView() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => EmployeeMasterView(),

      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        return FadeTransition(
          opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
          child: child,
        );
      },
    );
  }
}
