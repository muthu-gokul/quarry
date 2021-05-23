import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:quarry/notifier/vehicleNotifier.dart';
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/bottomBarAddButton.dart';
import 'package:quarry/widgets/editDelete.dart';
import 'package:quarry/widgets/navigationBarIcon.dart';
import 'package:quarry/widgets/staticColumnScroll/customDataTable.dart';

import 'vehicleDetailsAddNew.dart';





class VehicleDetailsGrid extends StatefulWidget {
  VoidCallback drawerCallback;
  VehicleDetailsGrid({this.drawerCallback});
  @override
  VehicleDetailsGridState createState() => VehicleDetailsGridState();
}

class VehicleDetailsGridState extends State<VehicleDetailsGrid> {

  bool showEdit=false;
  int selectedIndex;

  List<String> gridDataRowList=["VehicleNumber","VehicleTypeName","VehicleModel","EmptyWeightOfVehicle","VehicleDescription"];

  @override
  void initState() {

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
          child: Consumer<VehicleNotifier>(
            builder: (context,mn,child)=>  Stack(
              children: [
                Container(
                  height: 70,
                  width: SizeConfig.screenWidth,
                  color: AppTheme.yellowColor,
                  padding: AppTheme.gridAppBarPadding,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap:widget.drawerCallback,
                        child: NavBarIcon(),
                      ),
                      SizedBox(width: SizeConfig.width20,),
                      Text("Vehicle Details",
                        style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize: SizeConfig.width16),
                      ),
                      Spacer(),

                    ],
                  ),
                ),

                CustomDataTable(
                  topMargin: 50,
                  gridBodyReduceHeight: 140,
                  selectedIndex: selectedIndex,
                  gridCol: mn.VehicleGridCol,
                  gridData:mn.vehicleGridList,
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
                                  mn.updateVehicleEdit(true);
                                  mn.vehicleDropDownValues(context).then((value){
                                    mn.GetVehicleDbHit(context, mn.vehicleGridList[selectedIndex].VehicleId);
                                    setState(() {
                                      showEdit=false;
                                      selectedIndex=-1;
                                    });
                                  });

                                  Navigator.of(context).push(_createRoute());

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
                      mn.updateVehicleEdit(false);
                      mn.vehicleDropDownValues(context);
                      Navigator.of(context).push(_createRoute());
                    },
                    image: "assets/svg/plusIcon.svg",
                  ),
                ),


                
                



                Container(

                  height: mn.vehicleLoader? SizeConfig.screenHeight:0,
                  width: mn.vehicleLoader? SizeConfig.screenWidth:0,
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
      pageBuilder: (context, animation, secondaryAnimation) => VehicleDetailAddNew(),
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
