import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/purchaseNotifier.dart';
import 'package:quarry/notifier/supplierNotifier.dart';
import 'package:quarry/pages/purchaseDetails/purchaseAddNew.dart';
import 'package:quarry/pages/supplierDetail/supplierAddNew.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';



class PurchaseDetailsGrid extends StatefulWidget {
  VoidCallback drawerCallback;
  PurchaseDetailsGrid({this.drawerCallback});
  @override
  PurchaseDetailsGridState createState() => PurchaseDetailsGridState();
}

class PurchaseDetailsGridState extends State<PurchaseDetailsGrid> with TickerProviderStateMixin{

  bool showEdit=false;
  int selectedIndex;


  ScrollController header=new ScrollController();
  ScrollController body=new ScrollController();


  @override
  void initState() {
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
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Colors.black
        ),
        child: SafeArea(
          child: Consumer<PurchaseNotifier>(
            builder: (context,pn,child)=>  Stack(
              children: [
                Container(
                  height: SizeConfig.height50,
                  width: SizeConfig.screenWidth,
                  child: Row(
                    children: [
                      IconButton(icon: Icon(Icons.menu), onPressed: widget.drawerCallback),
                      SizedBox(width: SizeConfig.width20,),
                      Text("Purchase Details",
                        style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize:16),
                      ),


                    ],
                  ),
                ),
                Container(
                    height: SizeConfig.screenHeight-SizeConfig.height50,
                    width: SizeConfig.screenWidth,
                    margin: EdgeInsets.only(top: SizeConfig.height50),
                    color: Colors.white,
                    child: Row(
                      children: [
                        //not Scrollable
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 50,
                              width: 150,
                              color: AppTheme.bgColor,
                              child: Text("${pn.purchaseGridCol[0]}",style: AppTheme.TSWhite16,),

                            ),
                            Container(
                              height: SizeConfig.screenHeight-200,
                              alignment: Alignment.topCenter,
                              child: Container(
                                height: SizeConfig.screenHeight-200,
                                alignment: Alignment.topCenter,
                              /*  decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.addNewTextFieldText.withOpacity(0.9),
                                      spreadRadius: 2,
                                      blurRadius: 15,
                                      offset: Offset(0, 0), // changes position of shadow
                                    )
                                  ]
                                ),*/
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                      children: pn.purchaseGridList.asMap().
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
                                          decoration: BoxDecoration(
                                            color: selectedIndex==i?AppTheme.yellowColor:Colors.white,
                                            boxShadow:[
                                              selectedIndex==i? BoxShadow(
                                                color: AppTheme.yellowColor.withOpacity(0.4),
                                                spreadRadius: 2,
                                                blurRadius: 5,
                                                offset: Offset(1, 8), // changes position of shadow
                                              ):BoxShadow(
                                                  color: Colors.white
                                              ),
                                            ],
                                          ),
                                          padding: EdgeInsets.only(left: 20,right: 20,bottom: 20,top: 20),
                                          width: 150,
                                          child: Text("${value.purchaseOrderNumber}",style: TextStyle(color:Colors.blue,fontSize:16),),
                                        ),
                                      )
                                      )
                                      ).values.toList()

                                    //[
                                    /*    InkWell(
                        onTap: (){
                          setState(() {
                            showEdit=!showEdit;
                          });
                        },
                        child:  Container(
                          padding: EdgeInsets.only(left: 20,right: 20),
                          width: 150,
                          child: Text("Aishu",style: TextStyle(color:Colors.blue,fontSize:16),),
                        ),
                      ),*/


                                    //],
                                  ),
                                ),


                              ),
                            ),
                          ],
                        ),


                        //Scrollable
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 50,
                              width: SizeConfig.screenWidth-150,
                              color: AppTheme.bgColor,
                              child: SingleChildScrollView(
                                controller: header,
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                    children: pn.purchaseGridCol.asMap().
                                    map((i, value) => MapEntry(i, i==0?Container():
                                    Container(
                                        padding: EdgeInsets.only(left: 20,right: 20),
                                        width: 150,
                                        child: Text(value,style: AppTheme.TSWhite16,)
                                    )
                                    )).values.toList()
                                ),
                              ),

                            ),
                            Container(
                              height: SizeConfig.screenHeight-200,
                              width: SizeConfig.screenWidth-150,
                              alignment: Alignment.topCenter,
                              child: SingleChildScrollView(
                                controller: body,
                                scrollDirection: Axis.horizontal,
                                child: Container(
                                  height: SizeConfig.screenHeight-200,
                                  alignment: Alignment.topCenter,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Column(
                                        children:pn.purchaseGridList.asMap().
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
                                              color: selectedIndex==i?AppTheme.yellowColor:Colors.white,
                                              boxShadow:[
                                                selectedIndex==i? BoxShadow(
                                                  color: AppTheme.yellowColor.withOpacity(0.4),
                                                  spreadRadius: 1,
                                                  blurRadius: 5,
                                                  offset: Offset(1, 8), // changes position of shadow
                                                ):BoxShadow(
                                                    color: Colors.white
                                                ),
                                              ],
                                            ),
                                            padding: EdgeInsets.only(top: 20,bottom: 20),
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.only(left: 20,right: 20),
                                                  width: 150,
                                                  child: Text("${DateFormat.yMMMd().format(value.expectedDate)}",style: TextStyle(color:Colors.blue,fontSize:16),),
                                                ),

                                                Container(
                                                  padding: EdgeInsets.only(left: 20,right: 20),
                                                  width: 150,
                                                  child: Text("${value.NoOfMaterial.toString()}",style: TextStyle(color:Colors.blue,fontSize:16, ),),

                                                ),
                                                Container(
                                                  width: 150,
                                                  child: Text("${value.TotalQuantity.toString()}",style: TextStyle(color:Colors.blue,fontSize:16),),
                                                ),

                                                Container(
                                                  width: 150,
                                                  child: Text("${value.taxAmount.toString()}",style: TextStyle(color:Colors.blue,fontSize:16),),
                                                ),
                                                Container(
                                                  width: 150,
                                                  child: Text("${value.Subtotal.toString()}",style: TextStyle(color:Colors.blue,fontSize:16),),
                                                ),

                                                Container(
                                                  width: 150,
                                                  child: Text("${value.netAmount.toString()}",style: TextStyle(color:Colors.blue,fontSize:16),),
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

                      ],
                    )




                ),
               /* Container(
                    height: SizeConfig.screenHeight-SizeConfig.height50,
                    width: SizeConfig.screenWidth,
                    color: Colors.white,
                    margin: EdgeInsets.only(top: SizeConfig.height50),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child:DataTable(
                          headingRowColor:  MaterialStateColor.resolveWith((states) => AppTheme.bgColor),
                          showBottomBorder: true,
                          columns: pn.purchaseGridCol.map((e) => DataColumn(
                              label: Text(e,style: TextStyle(fontFamily: 'RB',fontSize: 16,color: Colors.white),textAlign: TextAlign.center,)
                          )).toList(),
                          rows: pn.purchaseGridList.asMap().map((i,e) => MapEntry(i,

                              DataRow(
                                  color:  MaterialStateColor.resolveWith((states) =>selectedIndex==i? AppTheme.yellowColor:Colors.white),

                                  cells: [
                                    DataCell(
                                        Text(e.purchaseOrderNumber.toString(),style: TextStyle(fontFamily: 'RR',fontSize: 16,color:selectedIndex==i? AppTheme.bgColor:AppTheme.gridTextColor),),
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
                                        }
                                    ),
                                    DataCell(
                                        Text("${DateFormat.yMMMd().format(e.expectedDate)}",style: TextStyle(fontFamily: 'RR',fontSize: 16,color:selectedIndex==i? AppTheme.bgColor:AppTheme.gridTextColor),),
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
                                        }
                                    ),
                                    DataCell(Text(e.materialName??"",style: TextStyle(fontFamily: 'RR',fontSize: 16,color: selectedIndex==i? AppTheme.bgColor: AppTheme.gridTextColor),),
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
                                        }
                                    ),
                                    DataCell(Text(e.purchaseQuantity.toString(),style: TextStyle(fontFamily: 'RR',fontSize: 16,color:selectedIndex==i? AppTheme.bgColor:  AppTheme.gridTextColor),),
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
                                        }
                                    ),
                                    DataCell(Text("${e.taxAmount.toString()}",style: TextStyle(fontFamily: 'RR',fontSize: 16,color:selectedIndex==i? AppTheme.bgColor:  AppTheme.gridTextColor),),
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
                                        }
                                    ),
                                    DataCell(Text("${e.netAmount.toString()}",style: TextStyle(fontFamily: 'RR',fontSize: 16,color:selectedIndex==i? AppTheme.bgColor:  AppTheme.gridTextColor),),
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
                                        }
                                    ),

                                  ])
                          )
                          ).values.toList()

                      ),
                    )
                ),*/

                Positioned(
                  bottom: 20,
                  right: 20,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: (){

                      pn.updatePurchaseEdit(false);
                      pn.PurchaseDropDownValues(context);
                      pn.insertForm();
                      Navigator.of(context).push(_createRoute());



                    },
                    child: Container(
                      margin: EdgeInsets.only(right: SizeConfig.width10),
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


                //Edit Or Delete
                AnimatedPositioned(
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
                ),


                Container(

                  height: pn.PurchaseLoader? SizeConfig.screenHeight:0,
                  width: pn.PurchaseLoader? SizeConfig.screenWidth:0,
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
      pageBuilder: (context, animation, secondaryAnimation) => PurchaseOrdersAddNew(),

      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        return FadeTransition(
          opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
          child: child,
        );
      },
    );
  }
}
