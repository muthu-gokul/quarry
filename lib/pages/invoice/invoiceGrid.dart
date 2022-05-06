import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quarry/model/manageUsersModel/manageUsersPlantModel.dart';
import 'package:quarry/notifier/invoiceNotifier.dart';
import 'package:quarry/notifier/profileNotifier.dart';
import 'package:quarry/pages/invoice/invoiceAddnew.dart';
import 'package:quarry/pages/invoice/invoicePdf.dart';
import 'package:quarry/pages/invoice/invoicePlantList.dart';
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/editDelete.dart';
import 'package:quarry/widgets/navigationBarIcon.dart';
import 'package:quarry/widgets/dateRangePicker.dart' as DateRagePicker;

import '../../styles/constants.dart';


class InvoiceGrid extends StatefulWidget {
  VoidCallback? drawerCallback;
  InvoiceGrid({this.drawerCallback});
  @override
  InvoiceGridState createState() => InvoiceGridState();
}

class InvoiceGridState extends State<InvoiceGrid> with TickerProviderStateMixin{

  bool showEdit=false;
  int? selectedIndex;


  ScrollController header=new ScrollController();
  ScrollController body=new ScrollController();
  ScrollController verticalLeft=new ScrollController();
  ScrollController verticalRight=new ScrollController();

  bool showShadow=false;
  bool filterOpen=false;
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
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Colors.black
        ),
        child: SafeArea(
          child: Consumer<InvoiceNotifier>(
            builder: (context,inv,child)=>  Stack(
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
                  width: SizeConfig.screenWidth,
                 // color: AppTheme.yellowColor,
                  child: Row(
                    children: [
                      GestureDetector(
                            onTap: widget.drawerCallback,
                          child: NavBarIcon()),

                      Text(inv.isInvoiceReceivable?"Receivable Invoice":"Payable Invoice",
                        style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize:16),
                      ),


                    ],
                  ),
                ),


                Container(
                    margin: EdgeInsets.only(top: 50),
                    padding: EdgeInsets.only(left:5,bottom:25),
                  //  color: AppTheme.yellowColor,
                    height: 110,
                    alignment: Alignment.topCenter,

                    child:SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(

                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: inv.counterList.asMap().
                          map((i, value) => MapEntry(i,
                              Container(
                                height: 80,
                                width: SizeConfig.screenWidth!*0.35,
                                margin: EdgeInsets.only(right: SizeConfig.width10!),

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
                                          height: 18,
                                            width: SizeConfig.screenWidth!*0.35,
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.only(left: 3,right: 3),
                                            child: FittedBox(
                                              child: Text(value.name!,style: TextStyle(fontFamily: 'RR',fontSize: 16,color: Colors.white,letterSpacing: 0.1),
                                              ),
                                            )
                                        ),
                                        SizedBox(height: 5,),
                                        Text( '${value.value}',style: TextStyle(fontFamily: 'RR',fontSize: 20,color: AppTheme.yellowColor),),

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

                Container(
                    height: SizeConfig.screenHeight!-140,
                    width: SizeConfig.screenWidth,
                    margin: EdgeInsets.only(top: 140),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        color: AppTheme.gridbodyBgColor,
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
                                      children: inv.invoiceGridCol.asMap().
                                      map((i, value) => MapEntry(i, i==0?Container():
                                      Container(
                                          alignment: Alignment.centerLeft,
                                          width: 150,
                                          child: Text(value,style: AppTheme.TSWhite166,)
                                      )
                                      )).values.toList()
                                  ),
                                ),

                              ),
                              Container(
                                height: SizeConfig.screenHeight!-260,
                                width: SizeConfig.screenWidth!-149,
                                alignment: Alignment.topCenter,
                                color: AppTheme.gridbodyBgColor,
                                child: SingleChildScrollView(
                                  controller: body,
                                  scrollDirection: Axis.horizontal,
                                  child: Container(
                                    height: SizeConfig.screenHeight!-260,
                                    alignment: Alignment.topCenter,
                                    color: AppTheme.gridbodyBgColor,
                                    child: SingleChildScrollView(
                                      controller: verticalRight,
                                      scrollDirection: Axis.vertical,
                                      child: Column(
                                          children:inv.filterInvoiceGridList.asMap().
                                          map((i, value) => MapEntry(
                                              i,InkWell(
                                            onTap: (){
                                              setState(() {

                                                if(selectedIndex==i){
                                                  selectedIndex=-1;
                                                  showEdit=false;
                                                } else{
                                                  selectedIndex=i;
                                                  showEdit=true;
                                                }


                                              });
                                            },
                                            child: Container(

                                              decoration: BoxDecoration(
                                                border: AppTheme.gridBottomborder,
                                                color: selectedIndex==i?value.invoiceType=='Receivable'? Colors.green:AppTheme.red:AppTheme.gridbodyBgColor,
                                              ),
                                              height: 50,
                                              margin: EdgeInsets.only(bottom:i==inv.filterInvoiceGridList.length-1?70: 0),
                                              // padding: EdgeInsets.only(top: 20,bottom: 20),
                                              child: Row(
                                                children: [


                                                  Container(
                                                    alignment: Alignment.centerLeft,
                                                    // padding: EdgeInsets.only(left: 20,right: 20),
                                                    width: 150,
                                                    child: Text(value.invoiceDate!=null?"${DateFormat.yMMMd().format(value.invoiceDate!)}":"",
                                                      style:selectedIndex==i?AppTheme.TSWhiteML:AppTheme.gridTextColor14,
                                                    ),

                                                  ),
                                                  Container(
                                                    alignment: Alignment.centerLeft,
                                                    width: 150,
                                                    child: Text("${value.partyName}",
                                                      style:selectedIndex==i?AppTheme.TSWhiteML:AppTheme.gridTextColor14,
                                                    ),
                                                  ),

                                                  Container(
                                                    width: 150,
                                                    alignment: Alignment.centerLeft,
                                                    child: Text("${value.grandTotalAmount}",
                                                      style:selectedIndex==i?AppTheme.TSWhiteML:AppTheme.gridTextColor14,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 150,
                                                    alignment: Alignment.centerLeft,
                                                    child: Text("${value.status}",
                                                      style:selectedIndex==i?AppTheme.TSWhiteML:value.status=='Unpaid'?AppTheme.gridTextColor14:
                                                      value.status=='Paid'?AppTheme.gridTextGreenColor14:AppTheme.gridTextRedColor14,
                                                    ),
                                                  ),



                                                ],
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
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(left: 5),
                                child:inv.invoiceGridCol.isEmpty?Container(): Text("${inv.invoiceGridCol[0]}",style: AppTheme.TSWhite166,),

                              ),
                              Container(
                                height: SizeConfig.screenHeight!-260,
                                width: 150,
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
                                  height: SizeConfig.screenHeight!-260,
                                  alignment: Alignment.topCenter,

                                  child: SingleChildScrollView(
                                    controller: verticalLeft,
                                    scrollDirection: Axis.vertical,
                                    child: Column(
                                        children: inv.filterInvoiceGridList.asMap().
                                        map((i, value) => MapEntry(
                                            i,InkWell(
                                          onTap: (){
                                            setState(() {

                                              if(selectedIndex==i){
                                                selectedIndex=-1;
                                                showEdit=false;
                                              } else{
                                                selectedIndex=i;
                                                showEdit=true;
                                              }


                                            });
                                          },
                                          child:  Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              border: AppTheme.gridBottomborder,
                                              color: selectedIndex==i?value.invoiceType=='Receivable'? Colors.green:AppTheme.red:AppTheme.gridbodyBgColor,
                                            ),
                                            height: 50,
                                            width: 150,
                                            margin: EdgeInsets.only(bottom:i==inv.filterInvoiceGridList.length-1?70: 0),
                                            child: Container(
                                              padding: EdgeInsets.only(left: 10,right: 10,top: 3,bottom: 3),

                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(50),
                                                color:value.invoiceType=='Receivable'? Colors.green:AppTheme.red,
                                              ),
                                              child: FittedBox(
                                                fit: BoxFit.contain,
                                                child: Text("${value.invoiceNumber}",
                                                    //  style:selectedIndex==i?AppTheme.bgColorTS:AppTheme.gridTextColorTS,
                                                    style:TextStyle(fontFamily: 'RR',fontSize: 12,color: Colors.white,letterSpacing: 0.1)
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

                        inv.filterInvoiceGridList.isEmpty?Container(
                          width: SizeConfig.screenWidth,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 70,),
                              Text("No Data Found",style: TextStyle(fontSize: 18,fontFamily:'RMI',color: AppTheme.addNewTextFieldText),),
                              SvgPicture.asset("assets/nodata.svg",height: 350,),

                            ],
                          ),
                        ):Container()


                      ],
                    )




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
                                bottom:showEdit?-60:0,
                                duration: Duration(milliseconds: 300,),
                                curve: Curves.bounceInOut,
                                child: Container(
                                  height: 70,
                                  width: SizeConfig.screenWidth,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Consumer<ProfileNotifier>(
                                          builder: (context,pro,child)=> GestureDetector(
                                            onTap: (){
                                              if(pro.usersPlantList.length>1){
                                                if(inv.filterUsersPlantList.isEmpty){
                                                  setState(() {
                                                    pro.usersPlantList.forEach((element) {
                                                      inv.filterUsersPlantList.add(ManageUserPlantModel(
                                                        plantId: element.plantId,
                                                        plantName: element.plantName,
                                                        isActive: element.isActive,

                                                      ));
                                                    });
                                                  });
                                                }
                                                else if(inv.filterUsersPlantList.length!=pro.usersPlantList.length){
                                                  inv.filterUsersPlantList.clear();
                                                  setState(() {
                                                    pro.usersPlantList.forEach((element) {
                                                      inv.filterUsersPlantList.add(ManageUserPlantModel(
                                                        plantId: element.plantId,
                                                        plantName: element.plantName,
                                                        isActive: element.isActive,

                                                      ));
                                                    });
                                                  });
                                                }

                                                Navigator.push(context, _createRouteInvoicePlant());
                                              }
                                            },
                                            child: SvgPicture.asset("assets/bottomIcons/plant-slection.svg",height: 40,width: 35,
                                              color: pro.usersPlantList.length<=1?AppTheme.bgColor.withOpacity(0.4):AppTheme.bgColor,),
                                          )
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
                                              inv.picked=picked1;
                                              inv.GetInvoiceDbHit(context,null);
                                            });
                                          }
                                          else if(picked1!=null && picked1.length ==1){
                                            setState(() {
                                              inv.picked=picked1;
                                              inv.GetInvoiceDbHit(context,null);
                                            });
                                          }

                                        },
                                        child: Padding(
                                          padding:  EdgeInsets.only(top: 10),
                                          child: SvgPicture.asset("assets/svg/calender.svg",width: 27,height: 30,color: AppTheme.bgColor,
                                            //    color: qn.selectedIndex==-1? AppTheme.bgColor.withOpacity(0.5):isOpen?AppTheme.bgColor:AppTheme.bgColor.withOpacity(0.5),
                                          ),
                                        ),
                                      ),

                                      SizedBox(width: SizeConfig.screenWidth!*0.25,),
                                      Container(
                                        height: 50,
                                        width: 50,
                                      ),
                                      GestureDetector(
                                        onTap: (){
                                          if(userAccessMap[47]??false){
                                            inv.insertForm();
                                            inv.clearForm();
                                            Navigator.of(context).push(_createRoute());
                                            inv.updateInvoiceEdit(false);
                                            inv.PlantUserDropDownValues(context).then((value){
                                              inv.InvoiceDropDownValues(context);
                                            });
                                          }
                                          else{
                                            CustomAlert().accessDenied2();
                                          }

                                        },
                                        child: Container(
                                          height: 40,
                                          width:40,
                                          margin: EdgeInsets.only(top: 10),
                                          child: Center(
                                            child: SvgPicture.asset("assets/bottomIcons/add-new-icon.svg",height: 32,width: 40,color: AppTheme.bgColor,),
                                          ),
                                        ),
                                      ),


                                    ],
                                  ),
                                ),
                              ),

                              EditDeletePdf(
                                showEdit: showEdit,
                                editTap: (){
                                  if(userAccessMap[48]??false){
                                    inv.insertForm();
                                    inv.updateInvoiceEdit(true);
                                    inv.InvoiceDropDownValues(context);
                                    inv.PlantUserDropDownValues(context).then((value) {
                                      inv.GetInvoiceDbHit(context, inv.filterInvoiceGridList[selectedIndex!].invoiceId);
                                      Navigator.push(context, _createRoute());
                                      setState(() {
                                        selectedIndex=-1;
                                        showEdit=false;
                                      });
                                    });
                                  }
                                  else{
                                    CustomAlert().accessDenied2();
                                  }
                                },
                                deleteTap: (){
                                  CustomAlert().accessDenied2();
                                },
                                viewTap: (){
                                  inv.GetInvoiceDbHit(context, inv.filterInvoiceGridList[selectedIndex!].invoiceId).then((value) {
                                    invoicePdf(context,true);
                                    setState(() {
                                      selectedIndex=-1;
                                      showEdit=false;
                                    });
                                  });

                                },
                                pdfTap: (){
                                  inv.GetInvoiceDbHit(context, inv.filterInvoiceGridList[selectedIndex!].invoiceId).then((value) {
                                    invoicePdf(context,false);
                                    setState(() {
                                      selectedIndex=-1;
                                      showEdit=false;
                                    });
                                  });
                                },
                              ),

                              /*EditDelete(
                                showEdit: showEdit,
                                editTap: (){
                                  inv.insertForm();
                                  inv.updateInvoiceEdit(true);
                                  inv.InvoiceDropDownValues(context);
                                  inv.PlantUserDropDownValues(context).then((value) {
                                    inv.GetInvoiceDbHit(context, inv.filterInvoiceGridList[selectedIndex].invoiceId);
                                    Navigator.push(context, _createRoute());
                                    setState(() {
                                      selectedIndex=-1;
                                      showEdit=false;
                                    });

                                  });

                                },
                              ),*/



                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),


////////////////////// animated icons   //////////
                Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: (){
                      inv.updateInvoiceReceivable(false);
                      inv.filterGridValues();
                      setState(() {
                        filterOpen=false;
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.fastOutSlowIn,

                      height: 60,
                      width: 60,
                      margin: EdgeInsets.only(bottom:filterOpen?70: 20,left:filterOpen?120: 0),
                         padding: EdgeInsets.only(top: 5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.red,
                        boxShadow: [
                          filterOpen? BoxShadow(
                            color: AppTheme.red.withOpacity(0.4),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(1, 8), // changes position of shadow
                          ):BoxShadow(),
                        ],
                      ),
                      child: Center(
                        child: SvgPicture.asset("assets/bottomIcons/payable-icon.svg",height: 40,width: 40,color: Colors.white,),
                      ),
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: (){
                      inv.updateInvoiceReceivable(true);
                      inv.filterGridValues();
                      setState(() {
                        filterOpen=false;
                      });

                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.fastOutSlowIn,

                      height: 60,
                      width: 60,
                      //  margin: EdgeInsets.only(bottom: 70,right: 120),
                      margin: EdgeInsets.only(bottom:filterOpen?70: 20,right:filterOpen?120: 0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                        boxShadow: [
                          filterOpen? BoxShadow(
                            color: Colors.green.withOpacity(0.4),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(1, 8), // changes position of shadow
                          ):BoxShadow(),
                        ],
                      ),
                      child: Center(
                          child: SvgPicture.asset("assets/bottomIcons/receivable-icon.svg",height: 40,width: 40,color: Colors.white,),

                      ),
                    ),
                  ),
                ),

                
                //filterButton
                Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: (){

                      setState(() {
                        filterOpen=!filterOpen;
                      });
                    },
                    child: Container(

                      height: 65,
                      width: 65,
                      margin: EdgeInsets.only(bottom: 18),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.yellowColor,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.yellowColor.withOpacity(0.4),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(1, 8), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Center(
                        child:filterOpen?Icon(Icons.clear,size: 30,color: AppTheme.bgColor,):
                        SvgPicture.asset("assets/bottomIcons/payReceive.svg",height: 35,width: 35,color: AppTheme.bgColor,),
                      ),
                    ),
                  ),
                ),


           



                Container(

                  height: inv.InvoiceLoader? SizeConfig.screenHeight:0,
                  width: inv.InvoiceLoader? SizeConfig.screenWidth:0,
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
      pageBuilder: (context, animation, secondaryAnimation) => InvoiceOrdersAddNew(),

      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        return FadeTransition(
          opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
          child: child,
        );
      },
    );
  }
  Route _createRouteInvoicePlant() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => InvoicePlantList(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        return SlideTransition(
          position: Tween<Offset>(begin: Offset(-1.0,0.0), end: Offset.zero).animate(animation),
          child: child,
        );
      },
    );
  }
}

