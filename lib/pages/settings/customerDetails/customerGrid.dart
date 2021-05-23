import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/customerNotifier.dart';
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/bottomBarAddButton.dart';
import 'package:quarry/widgets/editDelete.dart';
import 'package:quarry/widgets/navigationBarIcon.dart';
import 'package:quarry/widgets/staticColumnScroll/customDataTable.dart';

import 'customerAddNew.dart';



class CustomerMaster extends StatefulWidget {
  VoidCallback drawerCallback;
  CustomerMaster({this.drawerCallback});
  @override
  _CustomerMasterState createState() => _CustomerMasterState();
}

class _CustomerMasterState extends State<CustomerMaster> {

  bool showEdit=false;
  int selectedIndex=-1;
  List<String> gridDataRowList=["CustomerName","Location","CustomerContactNumber","CustomerEmail","CustomerCreditLimit"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Colors.black
        ),
        child: SafeArea(
          child: Consumer<CustomerNotifier>(
            builder: (context,qn,child)=>  Stack(
              children: [
                Container(
                  height: 70,
                  padding: EdgeInsets.only(bottom: 15),
                  width: SizeConfig.screenWidth,
                  color: AppTheme.yellowColor,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap:widget.drawerCallback,
                          child: NavBarIcon()
                      ),

                      Text("Customer Master",
                        style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize:16),
                      ),
                      Spacer(),

                    ],
                  ),
                ),

                CustomDataTable(
                  topMargin: 50,
                  gridBodyReduceHeight: 140,
                  selectedIndex: selectedIndex,
                  gridCol: qn.customerGridCol,
                  gridData: qn.customerGridList,
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
                            size: Size( SizeConfig.screenWidth, 65),
                            painter: RPSCustomPainter3(),
                          ),
                        ),

                        Container(
                          width:  SizeConfig.screenWidth,
                          height: 80,

                          child: Stack(

                            children: [
                              EditDelete(
                                showEdit: showEdit,
                                editTap: (){
                                  qn.updateCustomerEdit(true);
                                  qn.GetCustomerDetailDbhit(context, qn.customerGridList[selectedIndex].CustomerId);
                                  Navigator.of(context).push(_createRoute());
                                  setState(() {
                                    showEdit=false;
                                    selectedIndex=-1;
                                  });

                                },
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
                      qn.updateCustomerEdit(false);
                      Navigator.of(context).push(_createRoute());
                    },
                    image: "assets/svg/plusIcon.svg",
                  ),
                ),





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
      pageBuilder: (context, animation, secondaryAnimation) => CustomerDetailAddNew(false),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        return FadeTransition(
          opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
          child: child,
        );
      },
    );
  }
}
