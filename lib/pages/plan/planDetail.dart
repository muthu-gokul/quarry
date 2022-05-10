import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:quarry/pages/plan/planPlantList.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/alertDialog.dart';

import '../../notifier/planNotifier.dart';
import '../../notifier/profileNotifier.dart';
import '../../references/bottomNavi.dart';
import '../../styles/app_theme.dart';
import '../../widgets/navigationBarIcon.dart';

class PlanDetail extends StatefulWidget {
  VoidCallback? drawerCallback;
  PlanDetail({this.drawerCallback});

  @override
  State<PlanDetail> createState() => _PlanDetailState();
}

class _PlanDetailState extends State<PlanDetail> {
  final PlanNotifier planNotifier = Get.put(PlanNotifier());
  @override
  void initState() {
    planNotifier.init();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: SizeConfig.screenHeight,
        width: SizeConfig.screenWidth,
        child: Stack(
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
                  Text("Plan Detail",
                    style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize:16),
                  ),
                ],
              ),
            ),

            Container(
              height: SizeConfig.screenHeight!-50,
              width: SizeConfig.screenWidth,
              margin: EdgeInsets.only(top: 50),
              padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  color: AppTheme.gridbodyBgColor,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Plant",style: ts18(AppTheme.bgColor,fontsize: 17),),
                  SizedBox(height: 5,),
                  Obx(
                      ()=>Text("${planNotifier.selectPlantName}",style: ts15(AppTheme.gridTextColor),),
                  )
                ],
              ),
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
                            bottom:0,
                            duration: Duration(milliseconds: 300,),
                            curve: Curves.bounceOut,
                            child: Container(
                              height: 80,
                              width: SizeConfig.screenWidth,
                              padding: EdgeInsets.only(bottom: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Spacer(),
                                  Consumer<ProfileNotifier>(
                                      builder: (context,pro,child)=> GestureDetector(
                                        onTap: (){
                                         /* if(pro.usersPlantList.length>1){
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


                                          }*/
                                          Navigator.push(context, _plantRoute());
                                        },
                                        child: SvgPicture.asset("assets/bottomIcons/plant-slection.svg",height: 35,width: 35,
                                          color: pro.usersPlantList.length<=1?AppTheme.bgColor.withOpacity(0.4):AppTheme.bgColor,),
                                      )
                                  ),
                                  SizedBox(width: SizeConfig.screenWidth!*0.6,),

                                  Spacer(),

                                  GestureDetector(
                                    onTap: (){
                                      if(planNotifier.selectPlantId.isEmpty){
                                        CustomAlert().commonErrorAlert(context, "Select Plant", "");
                                        return;
                                      }
                                      Navigator.push(context, _planRoute());
                                    },
                                    child: Container(
                                        height: 50,
                                        width: 50,
                                        alignment: Alignment.bottomCenter,
                                        child: Image.asset("assets/bottomIcons/plan-choose.png",height: 30,)
                                    ),
                                  ),
                                  Spacer(),

                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
  Route _plantRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => PlanPlantList(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        return SlideTransition(
          position: Tween<Offset>(begin: Offset(-1.0,0.0), end: Offset.zero).animate(animation),
          child: child,
        );
      },
    );
  }

  Route _planRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => PlanDrpList(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        return SlideTransition(
          position: Tween<Offset>(begin: Offset(1.0,0.0), end: Offset.zero).animate(animation),
          child: child,
        );
      },
    );
  }
}
