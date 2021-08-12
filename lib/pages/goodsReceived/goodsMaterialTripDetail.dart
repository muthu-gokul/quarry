
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:quarry/model/goodsReceivedModel/goodsMaterialTripModel.dart';
import 'package:quarry/notifier/goodsReceivedNotifier.dart';

import 'package:quarry/pages/goodsReceived/goodsInGateForm.dart';

import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/bottomBarAddButton.dart';





class GoodsMaterialTripList extends StatefulWidget {

  int? MaterialId;
  String? MaterialName;
  String? UnitName;
  double? ExpectedQty;
  GoodsMaterialTripList(this.MaterialId,this.MaterialName,this.UnitName,this.ExpectedQty);

  @override
  GoodsMaterialTripListState createState() => GoodsMaterialTripListState();
}

class GoodsMaterialTripListState extends State<GoodsMaterialTripList> with TickerProviderStateMixin{

  bool isEdit=false;


  ScrollController? scrollController;
  ScrollController? listViewController;

  List<GoodsMaterialTripDetailsModel> materialTripList=[];
  List<GoodsMaterialExtraTripModel> GoodsMaterialExtraTripModelDetails=[];


  ScrollController header=new ScrollController();
  ScrollController body=new ScrollController();
  ScrollController verticalLeft=new ScrollController();
  ScrollController verticalRight=new ScrollController();

  bool showShadow=false;

  double valueContainerWidth=100;
  double dataTableheight=300;
  double dataTableBodyheight=250;
  List<String> gridcol=["Trip","Vehicle No","Received Qty","Balance","Status"];

  @override
  void initState() {
    isEdit=false;

    materialTripList=Provider.of<GoodsReceivedNotifier>(context,listen: false).materialTripList.where((element) => element.materialId==widget.MaterialId).toList();
    GoodsMaterialExtraTripModelDetails=Provider.of<GoodsReceivedNotifier>(context,listen: false).GoodsMaterialExtraTripModelDetails.where((element) => element.materialId==widget.MaterialId).toList();
    WidgetsBinding.instance!.addPostFrameCallback((_){




      scrollController=new ScrollController();
      listViewController=new ScrollController();
      setState(() {

      });


      listViewController!.addListener(() {
        if(listViewController!.offset>10){
          if(scrollController!.offset==0){
            scrollController!.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
          }

        }
        else if(listViewController!.offset==0){
          scrollController!.animateTo(0, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
        }
      });

    });


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
                          height: SizeConfig.screenHeight!-60,
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

                              /**********  DataTable  ********/
                              Container(
                                  height: dataTableheight,
                                  width: SizeConfig.screenWidth,
                                  clipBehavior: Clip.antiAlias,
                                  margin: EdgeInsets.only(left:SizeConfig.screenWidth!*0.02,right:SizeConfig.screenWidth!*0.02),
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
                                  child:Stack(
                                    children: [

                                      //Scrollable
                                      Positioned(
                                        left:99,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 50,
                                              width: SizeConfig.screenWidth!-valueContainerWidth-SizeConfig.screenWidth!*0.04,
                                              color: showShadow? AppTheme.f737373.withOpacity(0.8):AppTheme.f737373,
                                              child: SingleChildScrollView(
                                                controller: header,
                                                scrollDirection: Axis.horizontal,
                                                child: Row(
                                                    children: gridcol.asMap().
                                                    map((i, value) => MapEntry(i, i==0?Container():
                                                    Container(
                                                        alignment: Alignment.center,
                                                        //  padding: EdgeInsets.only(left: 20,right: 20),
                                                        width: valueContainerWidth,
                                                        child: Text(value,style: AppTheme.TSWhiteML,)
                                                    )
                                                    )).values.toList()
                                                ),
                                              ),

                                            ),
                                            Container(
                                              height: dataTableBodyheight,
                                              width: SizeConfig.screenWidth!-valueContainerWidth-SizeConfig.screenWidth!*0.04,
                                              alignment: Alignment.topCenter,
                                              color: Colors.white,
                                              child: SingleChildScrollView(
                                                controller: body,
                                                scrollDirection: Axis.horizontal,
                                                child: Container(
                                                  height: dataTableBodyheight,
                                                  alignment: Alignment.topCenter,
                                                  color:Colors.white,
                                                  child: SingleChildScrollView(
                                                    controller: verticalRight,
                                                    scrollDirection: Axis.vertical,
                                                    child:  Column(
                                                        children:materialTripList.asMap().
                                                        map((index, value) => MapEntry(
                                                            index,InkWell(
                                                          onTap: (){
                                                          },
                                                          child: Container(

                                                            height: 60,
                                                            decoration: BoxDecoration(
                                                                border: Border(bottom: BorderSide(color: AppTheme.addNewTextFieldBorder.withOpacity(0.5)))
                                                            ),

                                                            child: Row(
                                                              children: [

                                                                Container(
                                                                  alignment: Alignment.center,
                                                                  // padding: EdgeInsets.only(left: 20,right: 20),
                                                                  width: valueContainerWidth,
                                                                  child: Text("${value.vehicleNumber}",
                                                                    style:AppTheme.ML_bgCT,
                                                                  ),

                                                                ),
                                                                Container(
                                                                  alignment: Alignment.center,
                                                                  width: valueContainerWidth,
                                                                  child: Text("${value.receivedQuantity}",
                                                                    style:AppTheme.ML_bgCT,
                                                                  ),
                                                                ),

                                                                Container(
                                                                  width: valueContainerWidth,
                                                                  alignment: Alignment.center,
                                                                  child: Text("${value.balanceQuantity}",
                                                                    style:AppTheme.ML_bgCT,
                                                                  ),
                                                                ),

                                                                Container(
                                                                  width: valueContainerWidth,
                                                                  alignment: Alignment.center,
                                                                  child: Text("${value.status}",
                                                                    style:TextStyle(fontFamily: 'RL',color:value.status=='Not Yet'? AppTheme.bgColor:
                                                                    value.status=='Completed'?Colors.green:AppTheme.red
                                                                        ,fontSize: 12),textAlign: TextAlign.center,
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
                                              width: valueContainerWidth,
                                              color: AppTheme.f737373,
                                              alignment: Alignment.center,
                                              child: Text("${gridcol[0]}",style: AppTheme.TSWhiteML,),

                                            ),
                                            Container(
                                              height: dataTableBodyheight,
                                              alignment: Alignment.topCenter,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    showShadow?  BoxShadow(
                                                      color: AppTheme.addNewTextFieldText.withOpacity(0.2),
                                                      spreadRadius: 0,
                                                      blurRadius: 15,
                                                      offset: Offset(0, -8), // changes position of shadow
                                                    ):BoxShadow(color: Colors.transparent)
                                                  ]
                                              ),
                                              child: Container(
                                                height: dataTableBodyheight,
                                                alignment: Alignment.topCenter,

                                                child: SingleChildScrollView(
                                                  controller: verticalLeft,
                                                  scrollDirection: Axis.vertical,
                                                  child:  Column(
                                                      children: materialTripList.asMap().
                                                      map((index, value) => MapEntry(
                                                          index,InkWell(
                                                        onTap: (){
                                                        },
                                                        child:  Container(
                                                          alignment: Alignment.center,
                                                          height: 60,
                                                          width: valueContainerWidth,
                                                          decoration: BoxDecoration(
                                                              border: Border(bottom: BorderSide(color: AppTheme.addNewTextFieldBorder.withOpacity(0.5)))
                                                          ),
                                                          child: Text("${value.trip}",
                                                            style: AppTheme.ML_bgCT,
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

                              ) ,




                              GoodsMaterialExtraTripModelDetails[0].isExtra==0?Container():  Column(
                                 children: [
                                   SizedBox(height: 20,),
                                   Align(
                                     alignment: Alignment.center,
                                     child: Container(
                                       height: 50,
                                       width: SizeConfig.screenWidth!*0.8,
                                       decoration: BoxDecoration(
                                           color: AppTheme.red,
                                           borderRadius: BorderRadius.circular(25)
                                       ),
                                       child: Center(
                                         child: Text("You Received Extra ${GoodsMaterialExtraTripModelDetails[0].balanceQuantity} ${GoodsMaterialExtraTripModelDetails[0].unitName??""}",
                                           style: TextStyle(fontFamily: 'RR',fontSize: 16,color: Colors.white),
                                         ),
                                       ),
                                     ),
                                   ),
                                   SizedBox(height: 20,),
                                   Align(
                                     alignment: Alignment.center,
                                     child: Text("So Extra ${GoodsMaterialExtraTripModelDetails[0].balanceQuantity} ${GoodsMaterialExtraTripModelDetails[0].unitName??""} amount of",
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
                                          child: Text("${GoodsMaterialExtraTripModelDetails[0].Amount}"),
                                         ),
                                       ),
                                       Text("  is added to your Invoice.",
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
                        size: Size( SizeConfig.screenWidth!, 55),
                        painter: RPSCustomPainter(),
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
              //add button
              Align(
                alignment: Alignment.bottomCenter,
                child: AddButton(
                  ontap: (){
                    Navigator.pop(context);

                  },
                  image: "assets/svg/drawer/back-icon.svg",
                ),
              ),

              Container(
                height: SizeConfig.height60,
                width: SizeConfig.screenWidth,
                child: Row(
                  children: [
                    CancelButton(
                      ontap: (){
                        Navigator.pop(context);
                      },
                    ),

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

