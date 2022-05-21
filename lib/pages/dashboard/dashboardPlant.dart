
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/dashboardNotifier.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/bottomBarAddButton.dart';

import '../../notifier/planNotifier.dart';

class DashboardPlantList extends StatefulWidget {

  @override
  _DashboardPlantListState createState() => _DashboardPlantListState();
}

class _DashboardPlantListState extends State<DashboardPlantList> {
  ScrollController? silverController;
  double silverBodyTopMargin=0;

  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((_){
      silverController=new ScrollController();

      setState(() {
        silverBodyTopMargin=0;
      });

      silverController!.addListener(() {
        if(silverController!.offset>150){
          setState(() {
            silverBodyTopMargin=50-(-(silverController!.offset-200));
            if(silverBodyTopMargin<0){
              silverBodyTopMargin=0;
            }
          });
        }
        else if(silverController!.offset<170){
          setState(() {
            silverBodyTopMargin=0;
          });
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.yellowColor,
      body: Consumer<DashboardNotifier>(
        builder:(ctx,db,c)=> Stack(
          children: [
            NestedScrollView(
              controller: silverController,
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    elevation: 0,
                    toolbarHeight: 50,
                    backgroundColor: AppTheme.yellowColor,
                    leading: Container(),
                    actions: [
                      Container(
                        height: 50,
                        width:SizeConfig.screenWidth,
                        child: Row(
                          children: [
                            CancelButton(
                              ontap: (){
                                Navigator.pop(context);
                              },
                            ),
                            Text("Select Plant",style: TextStyle(fontFamily: 'RM',color: AppTheme.bgColor,fontSize: 16)),

                          ],
                        ),
                      ),
                    ],
                    expandedHeight: 200.0,
                    floating: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                        background: Container(
                          height: 200,
                          width: SizeConfig.screenWidth,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/images/saleFormheader.jpg",),
                                  fit: BoxFit.cover
                              )
                          ),
                        )
                    ),
                  ),
                ];
              },
              body: Container(
                width: SizeConfig.screenWidth,
                clipBehavior: Clip.antiAlias,
                margin: EdgeInsets.only(top: silverBodyTopMargin),
                padding: EdgeInsets.only(top: 30,bottom: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                  //color: Color(0xFFF6F7F9),
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                  child: Wrap(
                      children: db.plantList.asMap()
                          .map((i, value) => MapEntry(i,
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              db.selectPlantId=value['Id'].toString();
                              db.selectPlantName=value['Text'];
                            });
                            db.currentSaleDbHit(context,
                                "Sale",
                                DateFormat("yyyy-MM-dd").format(DateTime.now().subtract(Duration(days: 6))).toString(),
                                DateFormat("yyyy-MM-dd").format(DateTime.now()).toString()
                            );
                            Get.back();
                          },
                          child: Container(
                            height: 200,
                            width: SizeConfig.screenWidth!*0.5,
                            color: Colors.white,
                            child: AnimatedOpacity(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                              opacity: db.selectPlantId==value['Id'].toString()?1:0.3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 50,),
                                  Container(
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: AppTheme.uploadColor,width: 2)
                                    ),
                                    child: Center(
                                      child: SvgPicture.asset("assets/svg/Planticon.svg",height: 40,width: 40,),
                                    ),
                                  ),

                                  SizedBox(height: 20,),
                                  Text("${value['Text']}  ",
                                    style: TextStyle(color: AppTheme.bgColor,fontFamily: 'RM',fontSize: 14),
                                  ),
                                  SizedBox(height: 3,),
                                  /*Text("${value.}  ",
                                                style: TextStyle(color: AppTheme.bgColor,fontFamily: 'RR',fontSize: 12),
                                              ),*/
                                ],
                              ),
                            ),
                          ),
                        ),

                      )
                      ).values.toList()
                  ),
                ),
              ),
            ),




          ],
        ),
      ),
    );
  }
}