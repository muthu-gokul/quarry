
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quarry/model/goodsReceivedModel/goodsMaterialListModel.dart';
import 'package:quarry/notifier/goodsReceivedNotifier.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/pages/goodsReceived/goodsInGateForm.dart';
import 'package:quarry/pages/goodsReceived/goodsMaterialTripDetail.dart';
import 'package:quarry/pages/goodsReceived/goodsToPurchase.dart';
import 'package:quarry/pages/quarryMaster/plantDetailsAddNew.dart';
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';





class GoodsToInvoice extends StatefulWidget {

  @override
  GoodsToInvoiceState createState() => GoodsToInvoiceState();
}

class GoodsToInvoiceState extends State<GoodsToInvoice> with TickerProviderStateMixin{

  bool isEdit=false;


  ScrollController scrollController;
  ScrollController listViewController;

  ScrollController header=new ScrollController();
  ScrollController body=new ScrollController();
  ScrollController verticalLeft=new ScrollController();
  ScrollController verticalRight=new ScrollController();

  bool showShadow=false;

  double valueContainerWidth=100;
  double dataTableheight=400;
  double dataTableBodyheight=350;


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

  List<String> gridcol=["Material","Qty","Received Qty","Per Ton","Amount","Status"];

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

                              /**********  DataTable  ********/
                              Container(
                                  height: dataTableheight,
                                  width: SizeConfig.screenWidth,
                                  clipBehavior: Clip.antiAlias,
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
                                              width: SizeConfig.screenWidth-valueContainerWidth-SizeConfig.screenWidth*0.04,
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
                                              width: SizeConfig.screenWidth-valueContainerWidth-SizeConfig.screenWidth*0.04,
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
                                                        children:gr.GINV_Materials.asMap().
                                                        map((index, value) => MapEntry(
                                                            index,InkWell(
                                                          onTap: (){
                                                           /* if(gr.ML_Materials[index].status!='Completed'){
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
                                                              Navigator.push(context, _createRouteTripList(gr.ML_Materials[index].materialId,
                                                                  gr.ML_Materials[index].materialName,gr.ML_Materials[index].unitName,gr.ML_Materials[index].quantity
                                                              ));
                                                            }*/
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
                                                                  child: Text("${value.quantity}",
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
                                                                  child: Text("${value.materialPrice}",
                                                                    style:AppTheme.ML_bgCT,
                                                                  ),
                                                                ),
                                                                Container(
                                                                  width: valueContainerWidth,
                                                                  alignment: Alignment.center,
                                                                  child: Text("${value.amount}",
                                                                    style:AppTheme.ML_bgCT,
                                                                  ),
                                                                ),
                                                                Container(
                                                                  width: valueContainerWidth,
                                                                  alignment: Alignment.center,
                                                                  child: Text("${value.status}",
                                                                    style:TextStyle(fontFamily: 'RL',color:gr.GINV_Materials[index].status=='Not Yet'? AppTheme.bgColor:
                                                                    gr.GINV_Materials[index].status=='Completed'?Colors.green:AppTheme.red
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
                                                      color: AppTheme.addNewTextFieldText.withOpacity(0.3),
                                                      spreadRadius: 0,
                                                      blurRadius: 15,
                                                      offset: Offset(10, -8), // changes position of shadow
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
                                                      children: gr.GINV_Materials.asMap().
                                                      map((index, value) => MapEntry(
                                                          index,InkWell(
                                                        onTap: (){
                                                        /*  if(gr.ML_Materials[index].status!='Completed'){
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
                                                            Navigator.push(context, _createRouteTripList(gr.ML_Materials[index].materialId,
                                                                gr.ML_Materials[index].materialName,gr.ML_Materials[index].unitName,gr.ML_Materials[index].quantity
                                                            ));
                                                          }*/
                                                        },
                                                        child:  Container(
                                                          alignment: Alignment.center,
                                                          height: 60,
                                                          width: valueContainerWidth,
                                                          decoration: BoxDecoration(
                                                              border: Border(bottom: BorderSide(color: AppTheme.addNewTextFieldBorder.withOpacity(0.5)))
                                                          ),
                                                          child: Text("${value.materialName}",
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

                              /////////////  OtherCharges Details List  /////////////////
                              Container(

                                height: gr.GINV_OtherChargesList.length== 0 ? 0 :
                                ( gr.GINV_OtherChargesList.length * 50.0)+40,
                            //    height: 100,
                                constraints: BoxConstraints(
                                    maxHeight: 300
                                ),
                                //  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),

                                width: SizeConfig.screenWidth,

                                margin: EdgeInsets.only(left:SizeConfig.screenWidth*0.02,right:SizeConfig.screenWidth*0.02,top: 20),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: AppTheme.addNewTextFieldBorder)
                                ),
                                child: Column(
                                  children: [

                                    Container(
                                      height: 40,
                                      padding: EdgeInsets.only(left: 10,right: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(5),topRight: Radius.circular(5),),

                                        /* border: Border(
                                                    bottom: BorderSide(color: AppTheme.addNewTextFieldBorder.withOpacity(0.5))
                                                )*/
                                      ),
                                      child: Row(
                                   //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                              width: SizeConfig.screenWidthM0_04*0.44,child: Text("Other Charge")),
                                          Container( alignment: Alignment.centerLeft,width: SizeConfig.screenWidthM0_04*0.23,child: Text("  Price")),
                                          Container(alignment: Alignment.center, width: SizeConfig.screenWidthM0_04*0.25,child: Text("Action")),

                                        ],

                                      ),
                                    ),

                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: gr.GINV_OtherChargesList.length,
                                        itemBuilder: (context, index) {
                                          return
                                          /*  SlideTransition(
                                            position: Tween<Offset>(begin: Offset(qn.paymentMappingList[index].isEdit ? 0.0 :
                                            qn.paymentMappingList[index].isDelete ?1.0:0.0,
                                                qn.paymentMappingList[index].isEdit ? 0.0 :qn.paymentMappingList[index].isDelete ?0.0: 1.0),
                                                end:qn.paymentMappingList[index].isEdit ?Offset(1, 0): Offset.zero)
                                                .animate(qn.paymentMappingList[index].scaleController),

                                            child: FadeTransition(
                                              opacity: Tween(begin: qn.paymentMappingList[index].isEdit ? 1.0 : 0.0,
                                                  end: qn.paymentMappingList[index].isEdit ? 0.0 : 1.0)
                                                  .animate(qn.paymentMappingList[index].scaleController),
                                              child:*/
                                              Container(
                                                padding: EdgeInsets.only(top: 5, bottom: 5,left: 10,right: 10),
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(color: AppTheme.addNewTextFieldBorder.withOpacity(0.5))
                                                    )
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [

                                                        Container(
                                                          width: SizeConfig.screenWidthM0_04*0.44,
                                                          height: 25,
                                                          alignment:Alignment.centerLeft,

                                                          child: FittedBox(
                                                            fit: BoxFit.contain,
                                                            child: Row(
                                                              children: [
                                                                Text("${gr.GINV_OtherChargesList[index].otherChargesName}",
                                                                  style: TextStyle(fontSize: 14, fontFamily: 'RR', color: AppTheme.gridTextColor, letterSpacing: 0.2),textAlign: TextAlign.left,
                                                                ),

                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.only(left: 5),
                                                          alignment: Alignment.centerLeft,

                                                          width: SizeConfig.screenWidthM0_04*0.23,
                                                          child: Text("${gr.GINV_OtherChargesList[index].otherChargesAmount}",
                                                            style: TextStyle(fontSize: 14, fontFamily: 'RR', color: AppTheme.gridTextColor, letterSpacing: 0.2),
                                                          ),
                                                        ),
                                                        Container(
                                                          width:SizeConfig.screenWidthM0_04*0.25,
                                                          height: 30,
                                                         // padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Icon(Icons.edit),
                                                              SizedBox(width:SizeConfig.screenWidthM0_04*0.01,),
                                                              Icon(Icons.delete_outline),
                                                            ],
                                                          )
                                                        ),
                                                      ],
                                                    ),


                                                  ],
                                                ),

                                              );
                                           // ),
                                         // );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 20,),
                              Align(
                                alignment: Alignment.center,
                                child: RichText(
                                    text: TextSpan(
                                    text: 'Do you want to raise Invoice for ',
                                    style: TextStyle(fontSize: 14,fontFamily: 'RR',color: AppTheme.addNewTextFieldText),
                                     children: <TextSpan>[
                                       TextSpan(text: '${gr.GINV_PorderNo}', style:TextStyle(fontFamily: 'RM',color: AppTheme.bgColor,fontSize: 14)),
                                       ],
                                ),
                            ),
                              ),
                              SizedBox(height: 10,),
                              Text("Invoice Amount",
                              style: TextStyle(fontFamily: 'RL',color: AppTheme.red,fontSize: 14),textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 3,),
                              Text("${gr.GINV_invoiceAmount}",
                              style: TextStyle(fontFamily: 'RM',color: AppTheme.red,fontSize: 25),textAlign: TextAlign.center,
                              ),


                              SizedBox(height: 30,),



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
                        child: FloatingActionButton(backgroundColor: AppTheme.yellowColor, child: Icon(Icons.arrow_back,color: AppTheme.bgColor,
                        size: 30,
                        ), elevation: 0.1, onPressed: () {
                                  Navigator.pop(context);
                                  gr.GINV_clear();
                        }),
                      ),
                      Container(
                        width:  SizeConfig.screenWidth,
                        height: 80,
                        child: Stack(

                          children: [

                            Container(

                                width: SizeConfig.screenWidth,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,

                                  children: [

                                    GestureDetector(
                                      onTap: (){
                                          gr.GPO_assignValues();
                                          Navigator.push(context, _createRouteGoodsToPurchase());
                                      },
                                      child: Container(
                                        width: SizeConfig.screenWidth*0.4,
                                        child:Center(
                                          child: Image.asset("assets/goodsIcons/yes.jpg"),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: SizeConfig.width20,),
                                    Spacer(),
                                    SizedBox(width: SizeConfig.width20,),
                                    GestureDetector(
                                      onTap: (){
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        width: SizeConfig.screenWidth*0.4,
                                        child:Center(
                                        child: Image.asset("assets/goodsIcons/no.jpg"),
                                      ),
                                      ),
                                    ),


                              ]
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
                    IconButton(icon: Icon(Icons.clear,color:AppTheme.bgColor,), onPressed:(){
                      gr.GINV_clear();

                      Navigator.pop(context);
                    }),
                    SizedBox(width: SizeConfig.width5,),
                    Text("${gr.GINV_PorderNo} toInvoice",
                      style: TextStyle(fontFamily: 'RR',color: AppTheme.bgColor,fontSize: 16),
                    ),

                    Spacer(),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50)
                      ),
                      child: Text("${gr.GINV_Date}",
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

  Route _createRouteGoodsToPurchase() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => GoodsToPurchase(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        return SlideTransition(
          position: Tween<Offset>(begin: Offset(1.0,0.0), end: Offset.zero).animate(animation),
          child: child,
        );
      },
    );
  }
  Route _createRouteTripList(int materialId,String materialName,String unitName,double expectedQty) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => GoodsMaterialTripList(materialId,materialName,unitName,expectedQty),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        return SlideTransition(
          position: Tween<Offset>(begin: Offset(1.0,0.0), end: Offset.zero).animate(animation),
          child: child,
        );
      },
    );
  }

}

