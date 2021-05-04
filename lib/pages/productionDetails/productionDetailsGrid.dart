import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/productionNotifier.dart';
import 'package:quarry/notifier/purchaseNotifier.dart';
import 'package:quarry/notifier/supplierNotifier.dart';
import 'package:quarry/pages/productionDetails/productionDetailsAddNew.dart';
import 'package:quarry/pages/purchaseDetails/purchaseAddNew.dart';
import 'package:quarry/pages/sale/saleGrid.dart';
import 'package:quarry/pages/supplierDetail/supplierAddNew.dart';
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';



class ProductionGrid extends StatefulWidget {
  VoidCallback drawerCallback;
  ProductionGrid({this.drawerCallback});
  @override
  ProductionGridState createState() => ProductionGridState();
}

class ProductionGridState extends State<ProductionGrid> with TickerProviderStateMixin{

  bool showEdit=false;
  int selectedIndex;




  ScrollController header=new ScrollController();
  ScrollController body=new ScrollController();
  ScrollController verticalLeft=new ScrollController();
  ScrollController verticalRight=new ScrollController();

  bool showShadow=false;

  @override
  void initState() {

  //  print("globalKey.currentContext.size.width  ${globalKey.currentContext.size.width}");


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
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Colors.black
        ),
        child: SafeArea(
          child: Consumer<ProductionNotifier>(
            builder: (context,pn,child)=>  Stack(
              children: [
                Container(
                  height: 50,
                  width: SizeConfig.screenWidth,
                  color: AppTheme.yellowColor,
                  child: Row(
                    children: [
                      IconButton(icon: Icon(Icons.menu), onPressed: widget.drawerCallback),
                      SizedBox(width: SizeConfig.width20,),
                      Text("Production",
                        style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize:16),
                      ),


                    ],
                  ),
                ),


                Container(
                  margin: EdgeInsets.only(top: 50),
                    padding: EdgeInsets.only(left:5,bottom:25),
                    color: AppTheme.yellowColor,
                    height: 110,
                    alignment: Alignment.topCenter,

                    child:SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                      
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: pn.gridOverAllHeader.asMap().
                          map((i, value) => MapEntry(i,
                            Container(
                              height: SizeConfig.height80,
                             width: SizeConfig.screenWidth*0.3,
                              margin: EdgeInsets.only(right: SizeConfig.width10),

                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: AppTheme.bgColor
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(value.materialName,style: TextStyle(fontFamily: 'RR',fontSize: 16,color: Colors.white,letterSpacing: 0.1),),
                                      SizedBox(height: 5,),
                                      Text( '${value.totalQuantity}',style: TextStyle(fontFamily: 'RR',fontSize: 20,color: AppTheme.yellowColor),),
                                      /*RichText(
                                        text: TextSpan(
                                          text: '${value.totalQuantity}',
                                          style: TextStyle(fontFamily: 'RM',fontSize: 20,color: AppTheme.yellowColor),
                                          children: <TextSpan>[
                                           // TextSpan(text: '${value.unitName}', style: TextStyle(fontFamily: 'RR',fontSize: 11,color: AppTheme.addNewTextFieldBorder)),
                                          ],
                                        ),
                                      ),*/
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: SizeConfig.height18),
                                    child: Text(' ${value.unitName}',
                                        style: TextStyle(fontFamily: 'RR',fontSize: 10,color: AppTheme.addNewTextFieldBorder)
                                    ),
                                  )
                                ],

                              ),
                            )
                        )
                        ).values.toList()
                      ),
                    )
                ),

                //Data TAble
                Container(
                    height: SizeConfig.screenHeight-140,
                    width: SizeConfig.screenWidth,
                    margin: EdgeInsets.only(top: 140),
                     clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                    ),
                    child: Stack(
                      children: [

                        //Scrollable
                        Positioned(
                          left:149,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: 50,
                                width: SizeConfig.screenWidth-150,
                                color: showShadow? AppTheme.bgColor.withOpacity(0.8):AppTheme.bgColor,
                                child: SingleChildScrollView(
                                  controller: header,
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                      children: pn.productionGridCol.asMap().
                                      map((i, value) => MapEntry(i, i==0?Container():
                                      Container(

                                          alignment: Alignment.center,
                                          width: 150,

                                        //  width: double.maxFinite,
                                          child: Text(value,style: AppTheme.TSWhite166,)
                                      )
                                      )).values.toList()
                                  ),
                                ),

                              ),
                              Container(
                                height: SizeConfig.screenHeight-260,
                                width: SizeConfig.screenWidth-150,
                                alignment: Alignment.topCenter,
                                color: Colors.white,
                                child: SingleChildScrollView(
                                  controller: body,
                                  scrollDirection: Axis.horizontal,
                                  child: Container(
                                    height: SizeConfig.screenHeight-260,
                                    alignment: Alignment.topCenter,
                                    color: Colors.white,
                                    child: SingleChildScrollView(
                                      controller: verticalRight,
                                      scrollDirection: Axis.vertical,
                                      child: Column(
                                          children:pn.productionGridValues.asMap().
                                          map((i, value) => MapEntry(
                                              i,InkWell(
                                            onTap: (){
                                              setState(() {

                                                if(selectedIndex==i){
                                                  selectedIndex=-1;
                                                  showEdit=false;
                                                } else{
                                                  selectedIndex=i;
                                                  showEdit=true;
                                                }


                                              });
                                            },
                                            child: Container(

                                              decoration: BoxDecoration(
                                                color: selectedIndex==i?AppTheme.yellowColor:AppTheme.gridbodyBgColor,

                                              ),
                                             height: 60,
                                             // padding: EdgeInsets.only(top: 20,bottom: 20),
                                              child: Row(
                                                children: [


                                                  Container(
                                                    alignment: Alignment.center,

                                                    width: 150,


                                                  //  width: double.maxFinite,
                                                  //  width: globalKey.currentContext.size.width,
                                                    child: Text("${value.inputMaterialName}",
                                                      style:selectedIndex==i?AppTheme.bgColorTS:AppTheme.gridTextColorTS,
                                                    ),

                                                  ),
                                                  Container(
                                                    alignment: Alignment.center,
                                                    width: 150,

                                                  //  width: double.maxFinite,
                                                   // width: globalKey.currentContext.size.width,
                                                    child: Text("${value.inputMaterialQuantity}",
                                                      style:selectedIndex==i?AppTheme.bgColorTS:AppTheme.gridTextColorTS,
                                                    ),
                                                  ),

                                                  Container(
                                                    width: 150,
                                                    ///width: double.maxFinite,
                                                  //  width: globalKey.currentContext.size.width,
                                                    alignment: Alignment.center,
                                                    child: Text("${value.outputMaterialCount}",
                                                      style:selectedIndex==i?AppTheme.bgColorTS:AppTheme.gridTextColorTS,
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
                                width: 150,
                                color: AppTheme.bgColor,
                                alignment: Alignment.center,
                                child: Text("${pn.productionGridCol[0]}",style: AppTheme.TSWhite166,),

                              ),
                              Container(
                                height: SizeConfig.screenHeight-260,
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
                                  height: SizeConfig.screenHeight-260,
                                  alignment: Alignment.topCenter,

                                  child: SingleChildScrollView(
                                    controller: verticalLeft,
                                    scrollDirection: Axis.vertical,
                                    child: Column(
                                        children: pn.productionGridValues.asMap().
                                        map((i, value) => MapEntry(
                                            i,InkWell(
                                          onTap: (){
                                            setState(() {

                                              if(selectedIndex==i){
                                                selectedIndex=-1;
                                                showEdit=false;
                                              } else{
                                                selectedIndex=i;
                                                showEdit=true;
                                              }


                                            });
                                          },
                                          child:  Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: selectedIndex==i?AppTheme.yellowColor:AppTheme.gridbodyBgColor,
                                            ),
                                          height: 60,
                                            width: 150,
                                            child: Text("${value.machineName}",
                                              style:selectedIndex==i?AppTheme.bgColorTS:AppTheme.gridTextColorTS,
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
                          decoration: BoxDecoration(
                         /*     boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.7),
                                  spreadRadius: 2,
                                  blurRadius: 15,
                                  offset: Offset(0, -20), // changes position of shadow
                                )
                              ]*/
                          ),
                          margin:EdgeInsets.only(top: 0),
                          child: CustomPaint(
                            size: Size( SizeConfig.screenWidth, 65),
                          //  painter: RPSCustomPainter(),
                            painter: RPSCustomPainter3(),
                          ),
                        ),
                        Center(
                          heightFactor: 0.5,
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: (){

                            /*  pn.updatePurchaseEdit(false);
                              pn.PurchaseDropDownValues(context);
                              pn.insertForm();*/
                              pn.updateProductionEdit(false);
                              pn.ProductionDropDownValues(context);
                              Navigator.of(context).push(_createRoute());



                            },
                            child: Container(

                              height: SizeConfig.width50,
                              width: SizeConfig.width50,
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
                                ],
                              ),
                              child: Center(
                                child: Icon(Icons.add,size: SizeConfig.height30,color: AppTheme.bgColor,),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width:  SizeConfig.screenWidth,
                          height: 80,

                          child: Stack(

                            children: [

                               AnimatedPositioned(
                                 bottom:showEdit?15:-60,
                                 duration: Duration(milliseconds: 300,),
                                 curve: Curves.bounceInOut,
                                 child: Container(

                                   width: SizeConfig.screenWidth,
                                   child: Row(
                                     crossAxisAlignment: CrossAxisAlignment.center,
                                     children: [
                                       SizedBox(width: SizeConfig.width20,),
                                       GestureDetector(
                                         onTap: (){
                                           pn.ProductionDropDownValues(context);
                                           pn.GetProductionDbHit(context, pn.productionGridValues[selectedIndex].productionId, ProductionDetailAddNewState());
                                           pn.updateProductionEdit(true);
                                           Navigator.push(context, _createRoute());
                                           setState(() {
                                             selectedIndex=-1;
                                             showEdit=false;
                                           });

                                         },
                                         child: Container(
                                           width: 70,
                                           decoration: BoxDecoration(
                                               boxShadow: [
                                                 BoxShadow(
                                                   color: AppTheme.yellowColor.withOpacity(0.7),
                                                   spreadRadius: -3,
                                                   blurRadius: 15,
                                                   offset: Offset(0, 7), // changes position of shadow
                                                 )
                                               ]
                                           ),
                                           child:FittedBox(
                                             child: Row(
                                               children: [
                                                 SvgPicture.asset("assets/svg/edit.svg",height: 20,width: 20,color: AppTheme.yellowColor,),
                                                 SizedBox(width: SizeConfig.width10,),
                                                 Text("Edit",style: TextStyle(fontSize: 20,fontFamily: 'RR',color:Color(0xFFFF9D10)),),


                                               ],
                                             ),
                                           ),
                                         ),
                                       ),
                                       Spacer(),
                                       Container(
                                         width: 90,
                                         decoration: BoxDecoration(
                                             boxShadow: [
                                               BoxShadow(
                                                 color: AppTheme.red.withOpacity(0.5),
                                                 spreadRadius: -3,
                                                 blurRadius: 25,
                                                 offset: Offset(0, 7), // changes position of shadow
                                               )
                                             ]
                                         ),
                                         child:FittedBox(
                                           child: Row(
                                             children: [
                                               Text("Delete",style: TextStyle(fontSize: 18,fontFamily: 'RR',color:Colors.red),),
                                               SizedBox(width: SizeConfig.width10,),
                                               SvgPicture.asset("assets/svg/delete.svg",height: 20,width: 20,color: AppTheme.red,),




                                             ],
                                           ),
                                         ),
                                       ),
                                       SizedBox(width: SizeConfig.width10,),
                                     ],
                                   )
                                 ),
                               )

                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                //Edit Or Delete
               /* AnimatedPositioned(
                    bottom:showEdit? 0:-80,
                    child: Container(
                      height: 80,
                      width: SizeConfig.screenWidth,
                      color: AppTheme.bgColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: (){
                              pn.insertForm();
                              Navigator.of(context).push(_createRoute());
                              pn.updatePurchaseEdit(true);
                              pn.PurchaseDropDownValues(context).then((value) {
                                pn.GetPurchaseDbHit(context, pn.purchaseGridList[selectedIndex].purchaseOrderId);
                                setState(() {
                                  showEdit=false;
                                  selectedIndex=-1;
                                });
                              });


                            },
                            child: Container(
                              height: 50,
                              width: SizeConfig.width150,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: AppTheme.indicatorColor
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset("assets/svg/edit.svg",height: 20,width: 20,color: AppTheme.yellowColor,),
                                    SizedBox(width: SizeConfig.width10,),
                                    Text("Edit",style: TextStyle(fontSize: 20,fontFamily: 'RR',color: Colors.white),),


                                  ],
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){

                              setState(() {
                                showEdit=false;
                                selectedIndex=-1;
                              });

                            },
                            child: Container(
                              height: 50,
                              width: SizeConfig.width150,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: AppTheme.indicatorColor.withOpacity(0.5)
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Delete",style: TextStyle(fontSize: 20,fontFamily: 'RR',color: Colors.white.withOpacity(0.5)),),
                                    SizedBox(width: SizeConfig.width10,),
                                    SvgPicture.asset("assets/svg/delete.svg",height: 20,width: 20,color: AppTheme.yellowColor.withOpacity(0.5),),

                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    curve: Curves.bounceOut,


                    duration: Duration(milliseconds:300)
                ),*/


                Container(

                  height: pn.ProductionLoader? SizeConfig.screenHeight:0,
                  width: pn.ProductionLoader? SizeConfig.screenWidth:0,
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
      pageBuilder: (context, animation, secondaryAnimation) => ProductionDetailAddNew(),

      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        return FadeTransition(
          opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
          child: child,
        );
      },
    );
  }
}

