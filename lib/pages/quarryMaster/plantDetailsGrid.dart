
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/pages/quarryMaster/plantDetailsAddNew.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';





class PlantDetailsGrid extends StatefulWidget {
  VoidCallback drawerCallback;
  PlantDetailsGrid({this.drawerCallback});
  @override
  PlantDetailsGridState createState() => PlantDetailsGridState();
}

class PlantDetailsGridState extends State<PlantDetailsGrid> with TickerProviderStateMixin{

  bool isEdit=false;


  ScrollController scrollController;
  ScrollController listViewController;



  @override
  void initState() {
    isEdit=false;
    WidgetsBinding.instance.addPostFrameCallback((_){


      scrollController=new ScrollController();
      listViewController=new ScrollController();
      setState(() {

      });


      listViewController.addListener(() {
        print("List SCROLL--${listViewController.offset}");
        if(listViewController.offset>20){

          scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);


        }
        else if(listViewController.offset==0){
          scrollController.animateTo(0, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
        }
      });

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Consumer<QuarryNotifier>(
          builder: (context,qn,child)=> Stack(
            children: [



              Container(
                height: SizeConfig.screenHeight,
                width: SizeConfig.screenWidth,
                child: Column(
                  children: [
                    Container(
                      width: double.maxFinite,
                      height: SizeConfig.height200,

                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/saleFormheader.jpg",),
                              fit: BoxFit.cover
                          )

                      ),
                      /*  child:
                             Column(
                               mainAxisAlignment: MainAxisAlignment.start,
                               children: [
                                 Row(
                                   children: [
                                     IconButton(icon: Icon(Icons.menu), onPressed: widget.drawerCallback),
                                     SizedBox(width: SizeConfig.width5,),
                                     Text("Company Detail",
                                       style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize: SizeConfig.width16),
                                     ),
                                     Spacer(),

                                   ],
                                 ),
                                 Spacer(),
                                 // Image.asset("assets/images/saleFormheader.jpg",height: 100,),
                                 // Container(
                                 //   height: SizeConfig.height50,
                                 //   color: Color(0xFF753F03),
                                 //
                                 // ) // Container(
                                 //   height: SizeConfig.height50,
                                 //   color: Color(0xFF753F03),
                                 //
                                 // )
                               ],
                             ),*/
                    ),





                  ],
                ),
              ),


              Container(
                height: SizeConfig.screenHeight,
                // color: Colors.transparent,
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      SizedBox(height: 160,),
                      Container(
                        height: SizeConfig.screenHeight-60,
                        width: SizeConfig.screenWidth,

                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                        ),
                        child: ListView(
                          controller: listViewController,
                          scrollDirection: Axis.vertical,

                          children: [
                            Container(
                              height: 200,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: 200,
                                    width: SizeConfig.screenWidth*0.5,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10))
                                    ),
                                    child: Center(
                                      child: GestureDetector(
                                        onTap: (){
                                          qn.PlantDropDownValues(context);
                                          qn.clearPlantLicenseForm();
                                          qn.updatePlantDetailEdit(false);
                                          Navigator.push(context, _createRoute());

                                        },
                                        child: Container(
                                          height: 80,
                                          width: 80,
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
                                            ]
                                          ),
                                          child: Center(
                                            child: Icon(Icons.add,color: Colors.white,size: 40,),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  qn.plantGridList.isNotEmpty? GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, _createRoute());
                                      qn.GetplantDetailDbhit(context, qn.plantGridList[0].plantId);

                                    },
                                    child: Container(
                                      height: 200,
                                      width: SizeConfig.screenWidth*0.5,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(topRight: Radius.circular(10))
                                      ),
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
                                          ),

                                          SizedBox(height: 20,),
                                          Text("${qn.plantGridList[0].plantName}  ",
                                          style: TextStyle(color: AppTheme.bgColor,fontFamily: 'RM',fontSize: 14),
                                          ),
                                          SizedBox(height: 3,),
                                          Text("${qn.plantGridList[0].location}  ",
                                            style: TextStyle(color: AppTheme.bgColor,fontFamily: 'RR',fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ):Container(
                                    height: 200,
                                    width: SizeConfig.screenWidth*0.5,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),



                            SingleChildScrollView(
                              child: Wrap(
                                  children: qn.plantGridList.asMap()
                                      .map((i, value) => MapEntry(i,    i==0?Container():
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, _createRoute());
                                      qn.GetplantDetailDbhit(context, qn.plantGridList[i].plantId);

                                    },
                                    child: Container(
                                      height: 200,
                                      width: SizeConfig.screenWidth*0.5,
                                      color: Colors.white,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(height: 50,),
                                          GestureDetector(
                                            onTap: (){
                                              qn.GetplantDetailDbhit(context, qn.plantGridList[i].plantId);
                                              Navigator.push(context, _createRoute());
                                            },
                                            child: Container(
                                              height: 80,
                                              width: 80,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(color: AppTheme.uploadColor,width: 2)
                                              ),
                                            ),
                                          ),

                                          SizedBox(height: 20,),
                                          Text("${qn.plantGridList[i].plantName}  ",
                                            style: TextStyle(color: AppTheme.bgColor,fontFamily: 'RM',fontSize: 14),
                                          ),
                                          SizedBox(height: 3,),
                                          Text("${qn.plantGridList[i].location}  ",
                                            style: TextStyle(color: AppTheme.bgColor,fontFamily: 'RR',fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  )
                                  ).values.toList()
                              ),
                            )


                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: SizeConfig.height60,
                width: SizeConfig.screenWidth,
                child: Row(
                  children: [
                    IconButton(icon: Icon(Icons.clear,color: Colors.white,), onPressed: (){
                      Navigator.pop(context);
                    }),
                    SizedBox(width: SizeConfig.width5,),
                    Text("Our Plants",
                      style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize: SizeConfig.width16),
                    ),

                  ],
                ),
              ),


              Container(

                height: qn.insertCompanyLoader? SizeConfig.screenHeight:0,
                width: qn.insertCompanyLoader? SizeConfig.screenWidth:0,
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child:CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppTheme.yellowColor),),
                  //Image.asset("assets/images/Loader.gif",filterQuality: FilterQuality.high,gaplessPlayback: true,isAntiAlias: true,)

                ),
              ),
            ],
          )
      ),
    );
  }
  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => PlantDetailsAddNew(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        return FadeTransition(
          opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
          child: child,
        );
      },
    );
  }
}
