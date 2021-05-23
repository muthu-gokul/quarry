
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:quarry/notifier/goodsReceivedNotifier.dart';

import 'package:quarry/pages/goodsReceived/goodsInGateForm.dart';
import 'package:quarry/pages/goodsReceived/goodsMaterialTripDetail.dart';
import 'package:quarry/pages/goodsReceived/goodsReceivedGrid.dart';
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/bottomBarAddButton.dart';
import 'package:quarry/widgets/sidePopUp/noModel/sidePopUpSearchNoModel.dart';





class GoodsToPurchase extends StatefulWidget {

  @override
  GoodsToPurchaseState createState() => GoodsToPurchaseState();
}

class GoodsToPurchaseState extends State<GoodsToPurchase> with TickerProviderStateMixin{

  bool isEdit=false;


  ScrollController scrollController;
  ScrollController listViewController;

  ScrollController header=new ScrollController();
  ScrollController body=new ScrollController();
  ScrollController verticalLeft=new ScrollController();
  ScrollController verticalRight=new ScrollController();

  TextEditingController searchController=new TextEditingController();
  bool isSupplierOpen=false;

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

  List<String> gridcol=["Material","Qty","Per Ton","Tax","Amount"];

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
                                                        children:gr.GPO_Materials.asMap().
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
                                                                  width: valueContainerWidth,
                                                                  alignment: Alignment.center,
                                                                  child: Text("${value.materialPrice}",
                                                                    style:AppTheme.ML_bgCT,
                                                                  ),
                                                                ),
                                                                Container(
                                                                  width: valueContainerWidth,
                                                                  alignment: Alignment.center,
                                                                  child: Text("${value.taxAmount}",
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
                                                               /* Container(
                                                                  width: valueContainerWidth,
                                                                  alignment: Alignment.center,
                                                                  child: Text("${value.status}",
                                                                    style:TextStyle(fontFamily: 'RL',color:gr.GPO_Materials[index].status=='Not Yet'? AppTheme.bgColor:
                                                                    gr.GPO_Materials[index].status=='Completed'?Colors.green:AppTheme.red
                                                                        ,fontSize: 12),textAlign: TextAlign.center,
                                                                  ),
                                                                ),*/


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
                                                      children: gr.GPO_Materials.asMap().
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

                              SizedBox(height: 20,),
                              Align(
                                alignment: Alignment.center,
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Do you want to raise new Purchase Order ?',
                                    style: TextStyle(fontSize: 14,fontFamily: 'RR',color: AppTheme.addNewTextFieldText),
                                    children: <TextSpan>[
                                      TextSpan(text: '', style:TextStyle(fontFamily: 'RM',color: AppTheme.bgColor,fontSize: 14)),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 10,),
                              Text("Purchase Amount",
                                style: TextStyle(fontFamily: 'RL',color: AppTheme.red,fontSize: 14),textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 3,),
                              Text("${gr.GPO_purchaseAmount}",
                                style: TextStyle(fontFamily: 'RM',color: AppTheme.red,fontSize: 25),textAlign: TextAlign.center,
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
                                        setState(() {
                                          isSupplierOpen=true;
                                        });

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
                                        gr.GPO_clear();
                                        gr.GINV_clear();
                                        Navigator.pop(context);
                                        gr.GetGoodsDbHit(context, null, null,false,GoodsReceivedGridState());
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
              //add button
              Align(
                alignment: Alignment.bottomCenter,
                child: AddButton(
                  ontap: (){
                    gr.GINV_clear();
                    gr.GPO_clear();
                    Navigator.pop(context);
                    gr.GetGoodsDbHit(context, null, null,false,GoodsReceivedGridState());
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
                        gr.GINV_clear();
                        gr.GPO_clear();
                        Navigator.pop(context);
                      },
                    ),
                    Text("Goods to Purchase",
                      style: TextStyle(fontFamily: 'RR',color: AppTheme.bgColor,fontSize: 16),
                    ),


                    SizedBox(width: SizeConfig.width10,),
                  ],
                ),
              ),
              Container(

                height: isSupplierOpen? SizeConfig.screenHeight:0,
                width: isSupplierOpen? SizeConfig.screenWidth:0,
                color: Colors.black.withOpacity(0.5),

              ),

              Container(

                height: gr.GoodsLoader? SizeConfig.screenHeight:0,
                width: gr.GoodsLoader? SizeConfig.screenWidth:0,
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child:CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppTheme.yellowColor),),
                ),
              ),






              //supplier List
              PopUpSearchOnly2(
                isOpen: isSupplierOpen,
                searchController: searchController,

                searchHintText:"Search Supplier",

                dataList:gr.filterSupplierList,
                propertyKeyId:"SupplierName",
                propertyKeyName: "SupplierName",
                selectedId: gr.GPO_SupplierId,

                searchOnchange: (v){
                  gr.searchSupplier(v.toLowerCase());
                },
                itemOnTap: (index){

                  setState(() {
                    gr.GPO_SupplierId=gr.filterSupplierList[index]['SupplierId'];
                    gr.GPO_SupplierType=gr.filterSupplierList[index]['SupplierType'];
                    isSupplierOpen=false;
                    gr.filterSupplierList=gr.supplierList;
                  });
                  searchController.clear();
                  gr.InsertPurchaseDbHit(context, GoodsReceivedGridState()).then((value){
                    Navigator.pop(context);
                    gr.GINV_clear();
                    gr.GPO_clear();
                  });
                },
                closeOnTap: (){

                  setState(() {
                    isSupplierOpen=false;
                  });
                  gr.filterSupplierList=gr.supplierList;
                  searchController.clear();
                },
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

