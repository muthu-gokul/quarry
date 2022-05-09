import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quarry/model/manageUsersModel/manageUsersPlantModel.dart';
import 'package:quarry/notifier/paymentNotifier.dart';
import 'package:quarry/notifier/profileNotifier.dart';

import 'package:quarry/pages/invoicePayment/paymentAddNew.dart';
import 'package:quarry/pages/invoicePayment/paymentEdit.dart';
import 'package:quarry/pages/invoicePayment/paymentPlantList.dart';
import 'package:quarry/widgets/dateRangePicker.dart' as DateRagePicker;

import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/editDelete.dart';
import 'package:quarry/widgets/navigationBarIcon.dart';

import '../../styles/constants.dart';



class PaymentGrid extends StatefulWidget {
  VoidCallback? drawerCallback;
  PaymentGrid({this.drawerCallback});
  @override
  PaymentGridState createState() => PaymentGridState();
}

class PaymentGridState extends State<PaymentGrid> with TickerProviderStateMixin{

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
          child: Consumer<PaymentNotifier>(
            builder: (context,pn,child)=>  Stack(
              children: [
                //Image
                Container(
                  height: SizeConfig.screenHeight,
                  width: SizeConfig.screenWidth,
                  child: Column(
                    children: [
                      Opacity(
                        opacity:0.8,
                        child: Container(
                          width: double.maxFinite,
                          height: 170,


                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                  "assets/svg/gridHeader/reportsHeader.jpg",),
                                fit: BoxFit.cover
                            ),

                          ),
                        ),
                      )
                    ],
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
                      Text(pn.isPaymentReceivable?"Receivable Payment":"Payable Payment",
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
                          children: pn.counterList.asMap().
                          map((i, value) => MapEntry(i,
                              Container(
                                height: 80,
                                width: SizeConfig.screenWidth!*0.41,
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
                                            width: SizeConfig.screenWidth!*0.41,
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.only(left: 3,right: 3),
                                            child: FittedBox(
                                              child: Text(value.name!,style: TextStyle(fontFamily: 'RR',fontSize: 16,color: Colors.white,letterSpacing: 0.1),
                                              ),
                                            )
                                        ),
                                        SizedBox(height: 5,),
                                        Container(
                                          height: 18,
                                            width: SizeConfig.screenWidth!*0.41,
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.only(left: 3,right: 3),
                                            child: FittedBox(child: Text( '${value.value}',style: TextStyle(fontFamily: 'RR',fontSize: 18,color: AppTheme.yellowColor),))),

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
                                      children: pn.gridCol.asMap().
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
                                          children:pn.filterGridPaymentList.asMap().
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
                                              margin: EdgeInsets.only(bottom:i==pn.filterGridPaymentList.length-1?70: 0),
                                              // padding: EdgeInsets.only(top: 20,bottom: 20),
                                              child: Row(
                                                children: [


                                                  Container(
                                                    alignment: Alignment.centerLeft,
                                                    // padding: EdgeInsets.only(left: 20,right: 20),
                                                    width: 150,
                                                    child: Text("${DateFormat.yMMMd().format(value.invoiceDate!)}",
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
                                                    child: Text("${value.paidAmount}",
                                                      style:selectedIndex==i?AppTheme.TSWhiteML:AppTheme.gridTextColor14,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 150,
                                                    alignment: Alignment.centerLeft,
                                                    child: Text("${value.balanceAmount??"0.0"}",
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
                              pn.filterGridPaymentList.isEmpty?Container(): Container(
                                height: 50,
                                width: 150,
                                color: AppTheme.bgColor,
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(left: 5),
                                child: Text("${pn.gridCol[0]}",style: AppTheme.TSWhite166,),

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
                                        children: pn.filterGridPaymentList.asMap().
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
                                            margin: EdgeInsets.only(bottom:i==pn.filterGridPaymentList.length-1?70: 0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.only(left: 10,right: 10,top: 3,bottom: 3),

                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(50),
                                                    color:value.invoiceType=='Receivable'? Colors.green:AppTheme.red,
                                                  ),
                                                  child: FittedBox(
                                                    fit: BoxFit.contain,
                                                    child: Text("${value.invoicePaymentNumber}",
                                                        //  style:selectedIndex==i?AppTheme.bgColorTS:AppTheme.gridTextColorTS,
                                                        style:TextStyle(fontFamily: 'RR',fontSize: 12,color: Colors.white,letterSpacing: 0.1)
                                                    ),
                                                  ),
                                                ),
                                               value.DBInvoiceNumber!=0? Text("${value.invoiceNumber}",
                                                    //  style:selectedIndex==i?AppTheme.bgColorTS:AppTheme.gridTextColorTS,
                                                    style:TextStyle(fontFamily: 'RR',fontSize: 12,color:AppTheme.gridTextColor,letterSpacing: 0.1)
                                                ):Container()
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
                            ],
                          ),
                        ),

                        pn.filterGridPaymentList.isEmpty?Container(
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
                                                if(pn.filterUsersPlantList.isEmpty){
                                                  setState(() {
                                                    pro.usersPlantList.forEach((element) {
                                                      pn.filterUsersPlantList.add(ManageUserPlantModel(
                                                        plantId: element.plantId,
                                                        plantName: element.plantName,
                                                        isActive: element.isActive,

                                                      ));
                                                    });
                                                  });
                                                }
                                                else if(pn.filterUsersPlantList.length!=pro.usersPlantList.length){
                                                  pn.filterUsersPlantList.clear();
                                                  setState(() {
                                                    pro.usersPlantList.forEach((element) {
                                                      pn.filterUsersPlantList.add(ManageUserPlantModel(
                                                        plantId: element.plantId,
                                                        plantName: element.plantName,
                                                        isActive: element.isActive,

                                                      ));
                                                    });
                                                  });
                                                }

                                                Navigator.push(context, _createRoutePaymentPlant());
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
                                              pn.picked=picked1;
                                              pn.GetPaymentDbHit(context,null,PaymentEditFormState());
                                            });
                                          }
                                          else if(picked1!=null && picked1.length ==1){
                                            setState(() {
                                              pn.picked=picked1;
                                              pn.GetPaymentDbHit(context,null,PaymentEditFormState());
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

                                          if(userAccessMap[50]??false){
                                            setState(() {
                                              pn.paymentDate=DateTime.now();
                                            });
                                            pn.updatePaymentEdit(false);
                                            pn.PaymentDropDownValues(context);
                                            pn.PlantUserDropDownValues(context).then((value){
                                              Navigator.push(context, _createRoutePaymentAddnew());
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
                              EditDelete(
                                showEdit: showEdit,
                                editTap: (){
                                  if(userAccessMap[51]??false){
                                    if(pn.filterGridPaymentList[selectedIndex!].DBInvoiceNumber!=0){
                                      pn.updatePaymentEdit(true);
                                      pn.PaymentDropDownValues(context);
                                      pn.GetPaymentDbHit(context, pn.filterGridPaymentList[selectedIndex!].invoiceId,PaymentEditFormState());
                                      Navigator.push(context, _createRoute());
                                      setState(() {
                                        selectedIndex=-1;
                                        showEdit=false;
                                      });
                                    }
                                    else{
                                      CustomAlert().commonErrorAlert(context, "Its Directly Paid.You cant edit", "");
                                      setState(() {
                                        selectedIndex=-1;
                                        showEdit=false;
                                      });
                                    }
                                  }
                                  else{
                                    CustomAlert().accessDenied2();
                                  }
                                },
                                hasEditAccess: userAccessMap[51],
                              ),



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
                      pn.updatePaymentReceivable(false);
                      pn.filterGridValues();
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
                      pn.updatePaymentReceivable(true);
                      pn.filterGridValues();
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

                  height: pn.PaymentLoader? SizeConfig.screenHeight:0,
                  width: pn.PaymentLoader? SizeConfig.screenWidth:0,
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
      pageBuilder: (context, animation, secondaryAnimation) => PaymentEditForm(),

      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        return FadeTransition(
          opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
          child: child,
        );
      },
    );
  }
  Route _createRoutePaymentAddnew() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => PaymentAddNewForm(),

      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        return FadeTransition(
          opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
          child: child,
        );
      },
    );
  }
  Route _createRoutePaymentPlant() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => PaymentPlantList(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        return SlideTransition(
          position: Tween<Offset>(begin: Offset(-1.0,0.0), end: Offset.zero).animate(animation),
          child: child,
        );
      },
    );
  }
}

