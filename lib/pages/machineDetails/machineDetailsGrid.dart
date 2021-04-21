import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/pages/customerDetails/customerAddNew.dart';
import 'package:quarry/pages/material/processAddNew.dart';
import 'package:quarry/pages/quarryMaster/quarryLocationAddNew.dart';
import 'package:quarry/pages/vendor/vendorLocAddNew.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/alertDialog.dart';

import 'machineDetailsAddNew.dart';



class MachineDetailsGrid extends StatefulWidget {
  VoidCallback drawerCallback;
  MachineDetailsGrid({this.drawerCallback});
  @override
  MachineDetailsGridState createState() => MachineDetailsGridState();
}

class MachineDetailsGridState extends State<MachineDetailsGrid> {

  bool showEdit=false;
  int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Colors.black
        ),
        child: SafeArea(
          child: Consumer<QuarryNotifier>(
            builder: (context,qn,child)=>  Stack(
              children: [
                Container(
                  height: SizeConfig.height50,
                  width: SizeConfig.screenWidth,
                  child: Row(
                    children: [
                      IconButton(icon: Icon(Icons.menu), onPressed: widget.drawerCallback),
                      SizedBox(width: SizeConfig.width20,),
                      Text("Machine Details",
                        style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize: SizeConfig.width16),
                      ),
                      Spacer(),

                    ],
                  ),
                ),
                Container(
                    height: SizeConfig.screenHeight-SizeConfig.height50,
                    width: SizeConfig.screenWidth,
                    margin: EdgeInsets.only(top: SizeConfig.height50),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child:DataTable(
                          headingRowColor:  MaterialStateColor.resolveWith((states) => AppTheme.bgColor),
                          showBottomBorder: true,
                          columns: qn.machineGridCol.map((e) => DataColumn(
                              label: Text(e,style: TextStyle(fontFamily: 'RB',fontSize: 16,color: Colors.white),textAlign: TextAlign.center,)
                            // label:Container(
                            //     width: 100,
                            //     child: Center(
                            //         child: Text(e,style: TextStyle(fontFamily: 'RB',fontSize: 16,color: Colors.white),textAlign: TextAlign.center,)
                            //     )
                            // ),
                          )).toList(),
                          rows: qn.machineGridList.asMap().map((i,e) => MapEntry(i,

                              DataRow(
                                  cells: [
                                    DataCell(Text(e.machineName,style: TextStyle(fontFamily: 'RR',fontSize: 14,color: AppTheme.grey),),
                                        onTap: (){
                                          setState(() {
                                            selectedIndex=i;
                                            showEdit=!showEdit;
                                          });
                                        }
                                    ),
                                    DataCell(Text(e.machineType,style: TextStyle(fontFamily: 'RR',fontSize: 14,color: Colors.black),),
                                        onTap: (){
                                          setState(() {
                                            selectedIndex=i;
                                            showEdit=!showEdit;
                                          });
                                        }
                                    ),
                                    DataCell(Text(e.machineModel,style: TextStyle(fontFamily: 'RR',fontSize: 14,color: Colors.black),),
                                        onTap: (){
                                          setState(() {
                                            selectedIndex=i;
                                            showEdit=!showEdit;
                                          });
                                        }
                                    ),
                                    DataCell(Text(e.machineWeight,style: TextStyle(fontFamily: 'RR',fontSize: 14,color: Colors.black),),
                                        onTap: (){
                                          setState(() {
                                            selectedIndex=i;
                                            showEdit=!showEdit;
                                          });
                                        }
                                    ),
                                  ])
                          )
                          ).values.toList()

                      ),
                    )
                ),

                Positioned(
                  bottom: 20,
                  right: 20,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: (){

                      qn.updateMachineEditEdit(false);
                      Navigator.of(context).push(_createRoute());



                    },
                    child: Container(
                      margin: EdgeInsets.only(right: SizeConfig.width10),
                      height: SizeConfig.width50,
                      width: SizeConfig.width50,
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
                        child: Icon(Icons.add,size: SizeConfig.height30,color: AppTheme.bgColor,),
                      ),
                    ),
                  ),
                ),

                AnimatedPositioned(
                    bottom:showEdit? 0:-80,
                    child: Container(
                      height: 80,
                      width: SizeConfig.screenWidth,
                      color: AppTheme.bgColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: (){
                              qn.updateMachineEditEdit(true);
                              setState(() {
                                showEdit=false;
                           /*     qn.SS_selectCustomerId=qn.customersList[selectedIndex].CustomerId;
                                qn.customerName.text=qn.customersList[selectedIndex].CustomerName;
                                qn.customerContactNumber.text=qn.customersList[selectedIndex].CustomerContactNumber;
                                qn.customerGstNumber.text=qn.customersList[selectedIndex].CustomerGSTNumber;
                                qn.customerEmail.text=qn.customersList[selectedIndex].CustomerEmail;
                                qn.customerAddress.text=qn.customersList[selectedIndex].CustomerAddress;
                                qn.customerCity.text=qn.customersList[selectedIndex].CustomerCity;
                                qn.customerState.text=qn.customersList[selectedIndex].CustomerState;
                                qn.customerZipcode.text=qn.customersList[selectedIndex].CustomerZipCode;*/
                              });
                              Navigator.of(context).push(_createRoute());
                            },
                            child: Container(
                              height: 50,
                              width: SizeConfig.width150,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: AppTheme.indicatorColor
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset("assets/svg/edit.svg",height: 20,width: 20,color: AppTheme.yellowColor,),
                                    SizedBox(width: SizeConfig.width10,),
                                    Text("Edit",style: TextStyle(fontSize: 20,fontFamily: 'RR',color: Colors.white),),


                                  ],
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                showEdit=false;
                              });
                              CustomAlert(
                                  callback: (){
                                    Navigator.pop(context);
                                    qn.DeleteCustomerDetailDbhit(context, qn.customersList[selectedIndex].CustomerId);
                                  }

                              ).yesOrNoDialog(context, "", "Are you sure want to Delete?");
                            },
                            child: Container(
                              height: 50,
                              width: SizeConfig.width150,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: AppTheme.indicatorColor
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Delete",style: TextStyle(fontSize: 20,fontFamily: 'RR',color: Colors.white),),
                                    SizedBox(width: SizeConfig.width10,),
                                    SvgPicture.asset("assets/svg/delete.svg",height: 20,width: 20,color: AppTheme.yellowColor,),

                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    curve: Curves.bounceOut,


                    duration: Duration(milliseconds:300)),


                Container(

                  height: qn.customerLoader? SizeConfig.screenHeight:0,
                  width: qn.customerLoader? SizeConfig.screenWidth:0,
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
      pageBuilder: (context, animation, secondaryAnimation) => MachineDetailAddNew(),
      //pageBuilder: (context, animation, secondaryAnimation) => QuaryAddNew(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        return FadeTransition(
          opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
          child: child,
        );
      },
    );
  }
}
