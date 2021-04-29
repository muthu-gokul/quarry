
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quarry/model/goodsReceivedModel/goodsMaterialListModel.dart';
import 'package:quarry/notifier/goodsReceivedNotifier.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/pages/goodsReceived/goodsInGateForm.dart';
import 'package:quarry/pages/goodsReceived/goodsMaterialTripDetail.dart';
import 'package:quarry/pages/quarryMaster/plantDetailsAddNew.dart';
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';





class GoodsMaterialsList extends StatefulWidget {

  @override
  GoodsMaterialsListState createState() => GoodsMaterialsListState();
}

class GoodsMaterialsListState extends State<GoodsMaterialsList> with TickerProviderStateMixin{

  bool isEdit=false;


  ScrollController scrollController;
  ScrollController listViewController;
  ScrollController header=new ScrollController();
  ScrollController body=new ScrollController();


  @override
  void initState() {
    isEdit=false;
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
                        padding: EdgeInsets.only(top: 20,bottom: 60),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                        ),
                        child: ListView(
                          controller: listViewController,
                          children: [
                            Container(
                              height: 450,
                              width: SizeConfig.screenWidth,

                              margin: EdgeInsets.only(left:SizeConfig.screenWidth*0.02,right:SizeConfig.screenWidth*0.02),
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
                                            width: SizeConfig.screenWidth*0.23,
                                            alignment: Alignment.centerLeft,
                                            padding: EdgeInsets.only(left: SizeConfig.width10),
                                            child: Text("Material",style: AppTheme.TSWhiteML,),
                                          ),
                                          Container(
                                            width: SizeConfig.screenWidth*0.14,
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.only(left: SizeConfig.width10),

                                            child: Text("Qty",style: AppTheme.TSWhiteML,),
                                          ),
                                          Container(
                                            width: SizeConfig.screenWidth*0.25,

                                            alignment: Alignment.center,
                                            padding: EdgeInsets.only(left: SizeConfig.width10),

                                            child: Text("Received Qty",style: TextStyle(fontFamily: 'RR',fontSize: 14,color: Colors.white,letterSpacing: 0.1,),textAlign: TextAlign.center,),
                                          ),
                                          Container(
                                            width: SizeConfig.screenWidth*0.17,
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.only(left: SizeConfig.width10),

                                            child: Text("Per Ton",style: AppTheme.TSWhiteML,),
                                          ),
                                          Container(
                                            width: SizeConfig.screenWidth*0.17,
                                            alignment: Alignment.centerRight,

                                            child: Text("Amount",style: AppTheme.TSWhiteML,),
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
                                    height: 400,
                                    padding: EdgeInsets.only(bottom: 10),
                                    width: SizeConfig.screenWidth,
                                    decoration: BoxDecoration(
                                     /*   border: Border(bottom: BorderSide(color: AppTheme.gridTextColor.withOpacity(0.3)))*/
                                    ),
                                    child: Container(
                                      height: 400,
                                      width: SizeConfig.screenWidth,
                                      child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        itemCount: gr.ML_Materials.length,
                                        itemBuilder: (context,index){
                                          return GestureDetector(
                                            onTap: (){
                                              if(gr.ML_Materials[index].status!='Completed'){
                                                setState(() {
                                                  gr.IGF_Materials.add(
                                                      GoodsReceivedMaterialListModel(
                                                        GoodsReceivedMaterialMappingId: gr.ML_Materials[index].GoodsReceivedMaterialMappingId,
                                                        goodsReceivedId: gr.ML_Materials[index].goodsReceivedId,
                                                        materialId: gr.ML_Materials[index].materialId,
                                                        materialName: gr.ML_Materials[index].materialName,
                                                        materialPrice: gr.ML_Materials[index].materialPrice,
                                                        materialUnitId: gr.ML_Materials[index].materialUnitId,
                                                        unitName: gr.ML_Materials[index].unitName,
                                                        quantity: gr.ML_Materials[index].quantity,
                                                        receivedQuantity: 0.0,
                                                        amount: 0.0,
                                                        vehicleNumber: null,
                                                        vehicleTypeId: null,
                                                        inwardLoadedVehicleWeight: 0.0,
                                                        outwardEmptyVehicleWeight: 0.0,

                                                      )
                                                  );
                                                });
                                                Navigator.push(context, _createRoute());
                                              }
                                              else{
                                                Navigator.push(context, _createRouteTripList());
                                              }

                                            },
                                            child: Container(
                                              // height: 50,
                                              padding: EdgeInsets.only(top: 15,bottom: 15),
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
                                                   width: SizeConfig.screenWidth*0.23,
                                                      alignment: Alignment.centerLeft,
                                                      padding: EdgeInsets.only(left: SizeConfig.width10),
                                                      child: Text("${gr.ML_Materials[index].materialName}",style: AppTheme.ML_bgCT,),
                                                    ),
                                                    Container(
                                                      //width: 150,
                                                     width: SizeConfig.screenWidth*0.14,
                                                      alignment: Alignment.center,
                                                      padding: EdgeInsets.only(left: SizeConfig.width10),

                                                      child: Text("${gr.ML_Materials[index].quantity}",style: AppTheme.ML_bgCT,),
                                                    ),
                                                    Container(
                                                    //  width: 150,
                                                    width: SizeConfig.screenWidth*0.25,
                                                      alignment: Alignment.center,
                                                      padding: EdgeInsets.only(left: SizeConfig.width10),

                                                      child: Text("${gr.ML_Materials[index].receivedQuantity}",style: AppTheme.ML_bgCT,),
                                                    ),
                                                    Container(
                                                    //  width: 150,
                                                     width: SizeConfig.screenWidth*0.17,
                                                      alignment: Alignment.center,
                                                      padding: EdgeInsets.only(left: SizeConfig.width10),

                                                      child: Text("${gr.ML_Materials[index].materialPrice}",style: AppTheme.ML_bgCT,),
                                                    ),
                                                    Container(
                                                    //  width: 150,
                                                      width: SizeConfig.screenWidth*0.17,
                                                      alignment: Alignment.centerRight,

                                                      child: Text("${gr.ML_Materials[index].amount}",style: AppTheme.ML_bgCT,),
                                                    ),
                                                    Container(
                                                     // width: 150,
                                                     width: SizeConfig.screenWidth*0.25,
                                                      alignment: Alignment.centerRight,
                                                      padding: EdgeInsets.only(right: SizeConfig.width10),

                                                      child: Text("${gr.ML_Materials[index].status}",
                                                        style:TextStyle(fontFamily: 'RL',color:gr.ML_Materials[index].status=='Not Yet'? AppTheme.bgColor:
                                                        gr.ML_Materials[index].status=='Completed'?Colors.green:AppTheme.red
                                                            ,fontSize: 12),textAlign: TextAlign.right,
                                                      ),
                                                    ),
                                                  ],
                                                ),
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
                        child: FloatingActionButton(backgroundColor: AppTheme.yellowColor, child: Icon(Icons.save), elevation: 0.1, onPressed: () {

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
                      gr.ML_clear();
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
  Route _createRouteTripList() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => GoodsMaterialTripList(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        return SlideTransition(
          position: Tween<Offset>(begin: Offset(1.0,0.0), end: Offset.zero).animate(animation),
          child: child,
        );
      },
    );
  }

}

