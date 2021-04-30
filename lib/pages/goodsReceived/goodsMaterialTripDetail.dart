
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quarry/model/goodsReceivedModel/goodsMaterialListModel.dart';
import 'package:quarry/model/goodsReceivedModel/goodsMaterialTripModel.dart';
import 'package:quarry/notifier/goodsReceivedNotifier.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/pages/goodsReceived/goodsInGateForm.dart';
import 'package:quarry/pages/quarryMaster/plantDetailsAddNew.dart';
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';





class GoodsMaterialTripList extends StatefulWidget {

  int MaterialId;
  String MaterialName;
  String UnitName;
  double ExpectedQty;
  GoodsMaterialTripList(this.MaterialId,this.MaterialName,this.UnitName,this.ExpectedQty);

  @override
  GoodsMaterialTripListState createState() => GoodsMaterialTripListState();
}

class GoodsMaterialTripListState extends State<GoodsMaterialTripList> with TickerProviderStateMixin{

  bool isEdit=false;


  ScrollController scrollController;
  ScrollController listViewController;
  ScrollController header=new ScrollController();
  ScrollController body=new ScrollController();
  List<GoodsMaterialTripDetailsModel> materialTripList=[];

  @override
  void initState() {
    isEdit=false;

    materialTripList=Provider.of<GoodsReceivedNotifier>(context,listen: false).materialTripList.where((element) => element.materialId==widget.MaterialId).toList();
    WidgetsBinding.instance.addPostFrameCallback((_){




      scrollController=new ScrollController();
      listViewController=new ScrollController();
      setState(() {

      });


      listViewController.addListener(() {
        if(listViewController.offset>10){
          if(scrollController.offset==0){
            scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
          }

        }
        else if(listViewController.offset==0){
          scrollController.animateTo(0, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
        }
      });

    });

    header.addListener(() {
      if(body.offset!=header.offset){
        body.jumpTo(header.offset);
      }
    });

    body.addListener(() {
      if(header.offset!=body.offset){
        header.jumpTo(body.offset);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Consumer<GoodsReceivedNotifier>(
          builder: (context,gr,child)=> Stack(
            children: [



              Container(
                height: SizeConfig.screenHeight,
                width: SizeConfig.screenWidth,
                color: Colors.white,
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
                          padding: EdgeInsets.only(top: 5,bottom: 60),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                          ),
                          child: ListView(
                            controller: listViewController,
                            children: [

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset("assets/images/inGate.jpg",height: 40,width: 60,),
                                  Text("${widget.MaterialName} - ${widget.ExpectedQty}",
                                    style: TextStyle(fontFamily: 'RM',color: AppTheme.bgColor,fontSize: 20),
                                    textAlign: TextAlign.center,
                                  ),
                                  Padding(
                                    padding:  EdgeInsets.only(top: 4),
                                    child: Text(" ${widget.UnitName}",
                                      style: TextStyle(fontFamily: 'RR',color: AppTheme.hintColor,fontSize: 14),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                height: 300,
                                width: SizeConfig.screenWidth,

                                margin: EdgeInsets.only(left:SizeConfig.screenWidth*0.02,right:SizeConfig.screenWidth*0.02,top: 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.addNewTextFieldText.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 15,
                                        offset: Offset(0, 0), // changes position of shadow
                                      )
                                    ]
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: SizeConfig.screenWidth,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10),),
                                        color: AppTheme.f737373,

                                      ),
                                      child: SingleChildScrollView(
                                        controller: header,
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: SizeConfig.screenWidth*0.15,
                                              alignment: Alignment.centerLeft,
                                              padding: EdgeInsets.only(left: SizeConfig.width10),
                                              child: Text("Trip",style: AppTheme.TSWhiteML,),
                                            ),
                                            Container(
                                              width: SizeConfig.screenWidth*0.25,
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.only(left: SizeConfig.width10),

                                              child: Text("Vehicle No",style: AppTheme.TSWhiteML,),
                                            ),
                                            Container(
                                              width: SizeConfig.screenWidth*0.25,

                                              alignment: Alignment.center,
                                              padding: EdgeInsets.only(left: SizeConfig.width10),

                                              child: Text("Received",style: TextStyle(fontFamily: 'RR',fontSize: 14,color: Colors.white,letterSpacing: 0.1,),textAlign: TextAlign.center,),
                                            ),
                                            Container(
                                              width: SizeConfig.screenWidth*0.25,
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.only(left: SizeConfig.width10),

                                              child: Text("Balance",style: AppTheme.TSWhiteML,),
                                            ),
                                            Container(
                                              width: SizeConfig.screenWidth*0.25,
                                              alignment: Alignment.centerRight,
                                              padding: EdgeInsets.only(right: SizeConfig.width10),

                                              child: Text("Status",style: AppTheme.TSWhiteML,),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    Container(
                                      height: 250,
                                      padding: EdgeInsets.only(bottom: 10),
                                      width: SizeConfig.screenWidth,
                                      decoration: BoxDecoration(
                                        /*   border: Border(bottom: BorderSide(color: AppTheme.gridTextColor.withOpacity(0.3)))*/
                                      ),
                                      child: Container(
                                        height: 250,
                                        width: SizeConfig.screenWidth,
                                        child: ListView.builder(
                                          scrollDirection: Axis.vertical,
                                          itemCount: materialTripList.length,
                                          itemBuilder: (context,index){
                                            return Container(
                                              // height: 50,
                                              padding: EdgeInsets.only(top: 10,bottom: 10),
                                              width: SizeConfig.screenWidth,
                                              decoration: BoxDecoration(
                                                // color:selectedMaterialIndex==index?Colors.red: Colors.white,
                                                  border: Border(bottom: BorderSide(color: AppTheme.gridTextColor.withOpacity(0.3))
                                                  )

                                              ),
                                              child: SingleChildScrollView(
                                                controller: body,
                                                scrollDirection: Axis.horizontal,
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      //width: 150,
                                                      width: SizeConfig.screenWidth*0.15,
                                                      alignment: Alignment.centerLeft,
                                                      padding: EdgeInsets.only(left: SizeConfig.width10),
                                                      child: Text("${materialTripList[index].trip}",style: AppTheme.ML_bgCT,),
                                                    ),
                                                    Container(
                                                      //width: 150,
                                                      width: SizeConfig.screenWidth*0.25,
                                                      alignment: Alignment.center,
                                                      padding: EdgeInsets.only(left: SizeConfig.width10),

                                                      child: Text("${materialTripList[index].vehicleNumber}",style: AppTheme.ML_bgCT,),
                                                    ),
                                                    Container(
                                                      //  width: 150,
                                                      width: SizeConfig.screenWidth*0.25,
                                                      alignment: Alignment.center,
                                                      padding: EdgeInsets.only(left: SizeConfig.width10),

                                                      child: Text("${materialTripList[index].receivedQuantity}",style: AppTheme.ML_bgCT,),
                                                    ),
                                                    Container(
                                                      //  width: 150,
                                                      width: SizeConfig.screenWidth*0.25,
                                                      alignment: Alignment.center,
                                                      padding: EdgeInsets.only(left: SizeConfig.width10),

                                                      child: Text("${materialTripList[index].balanceQuantity}",style: AppTheme.ML_bgCT,),
                                                    ),

                                                    Container(
                                                      // width: 150,
                                                      width: SizeConfig.screenWidth*0.25,
                                                      alignment: Alignment.centerRight,
                                                      padding: EdgeInsets.only(right: SizeConfig.width10),

                                                      child: Text("${materialTripList[index].status}",
                                                        style:TextStyle(fontFamily: 'RL',color:materialTripList[index].status=='Not Yet'? AppTheme.bgColor:
                                                        materialTripList[index].status=='Completed'?Colors.green:AppTheme.red
                                                            ,fontSize: 12),textAlign: TextAlign.right,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),



                                  ],
                                ),
                              ) ,

                                Column(
                                 children: [
                                   SizedBox(height: 20,),
                                   Align(
                                     alignment: Alignment.center,
                                     child: Container(
                                       height: 50,
                                       width: SizeConfig.screenWidth*0.8,
                                       decoration: BoxDecoration(
                                           color: AppTheme.red,
                                           borderRadius: BorderRadius.circular(25)
                                       ),
                                       child: Center(
                                         child: Text("You Received Extra ${gr.GoodsMaterialExtraTripModelDetails.balanceQuantity} ${gr.GoodsMaterialExtraTripModelDetails.unitName??""}",
                                           style: TextStyle(fontFamily: 'RR',fontSize: 16,color: Colors.white),
                                         ),
                                       ),
                                     ),
                                   ),
                                   SizedBox(height: 20,),
                                   Align(
                                     alignment: Alignment.center,
                                     child: Text("So Generate Extra ${gr.GoodsMaterialExtraTripModelDetails.balanceQuantity} ${gr.GoodsMaterialExtraTripModelDetails.unitName??""} amount for",
                                       style: TextStyle(fontFamily: 'RR',fontSize: 14,color: AppTheme.hintColor),
                                     ),
                                   ),
                                   SizedBox(height: 3,),
                                   Row(
                                     mainAxisAlignment: MainAxisAlignment.center,
                                     children: [
                                       Container(
                                         height: 30,
                                         padding: EdgeInsets.only(left: 5,right: 5),
                                         decoration: BoxDecoration(
                                             borderRadius: BorderRadius.circular(10),
                                             color: AppTheme.yellowColor
                                         ),
                                         child: Center(
                                           //child: Text("${gr.GoodsMaterialExtraTripModelDetails.}"),
                                         ),
                                       ),
                                       Text("  Your Invoice",
                                         style: TextStyle(fontFamily: 'RR',fontSize: 14,color: AppTheme.hintColor),
                                       )
                                     ],
                                   )
                                 ],
                               ),



                            ],
                          )
                      )
                    ],
                  ),
                ),
              ),

              Positioned(
                bottom: 0,
                child: Container(
                  width: SizeConfig.screenWidth,
                  height: 60,

                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.7),
                          spreadRadius: 2,
                          blurRadius: 15,
                          offset: Offset(0, -20), // changes position of shadow
                        )
                      ]
                  ),
                  child: Stack(

                    children: [
                      CustomPaint(
                        size: Size( SizeConfig.screenWidth, 55),
                        painter: RPSCustomPainter(),
                      ),
                      Center(
                        heightFactor: 0.5,
                        child: FloatingActionButton(backgroundColor: AppTheme.yellowColor, child: Icon(Icons.arrow_back), elevation: 0.1, onPressed: () {
                                          Navigator.pop(context);
                        }),
                      ),
                      Container(
                        width:  SizeConfig.screenWidth,
                        height: 80,
                        child: Stack(

                          children: [


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
                    IconButton(icon: Icon(Icons.clear,color:AppTheme.bgColor,), onPressed:(){

                      Navigator.pop(context);
                    }),
                    SizedBox(width: SizeConfig.width5,),
                    Text("${gr.ML_PorderNo}",
                      style: TextStyle(fontFamily: 'RR',color: AppTheme.bgColor,fontSize: 16),
                    ),

                    Spacer(),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50)
                      ),
                      child: Text("${gr.ML_Date}",
                        style: TextStyle(fontFamily: 'RR',color: AppTheme.bgColor,fontSize: 16),
                      ),
                    ),
                    SizedBox(width: SizeConfig.width10,),
                  ],
                ),
              ),


              Container(

                height: gr.GoodsLoader? SizeConfig.screenHeight:0,
                width: gr.GoodsLoader? SizeConfig.screenWidth:0,
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child:CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppTheme.yellowColor),),
                ),
              ),
            ],
          )
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => GoodsInGateForm(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        return SlideTransition(
          position: Tween<Offset>(begin: Offset(1.0,0.0), end: Offset.zero).animate(animation),
          child: child,
        );
      },
    );
  }

}

