import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/supplierNotifier.dart';
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/navigationBarIcon.dart';
import 'supplierAddNew.dart';


class SupplierDetailsGrid extends StatefulWidget {
  VoidCallback drawerCallback;
  SupplierDetailsGrid({this.drawerCallback});
  @override
  SupplierDetailsGridState createState() => SupplierDetailsGridState();
}

class SupplierDetailsGridState extends State<SupplierDetailsGrid> with TickerProviderStateMixin{

  bool showEdit=false;
  int selectedIndex;

  ScrollController header=new ScrollController();
  ScrollController body=new ScrollController();
  ScrollController verticalLeft=new ScrollController();
  ScrollController verticalRight=new ScrollController();
  bool showShadow=false;


  //width
  double categoryWidth=0.0;
  GlobalKey categoryKey= GlobalKey();

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      categoryWidth=categoryKey.currentContext.size.width;
      setState(() {

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
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Colors.black
        ),
        child: SafeArea(
          child: Consumer<SupplierNotifier>(
            builder: (context,sn,child)=>  Stack(
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
                      SizedBox(width: SizeConfig.width20,),
                      Text("Supplier Details",
                        style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize: SizeConfig.width16),
                      ),
                      Spacer(),

                    ],
                  ),
                ),

                Container(
                    height: SizeConfig.screenHeight-50,
                    width: SizeConfig.screenWidth,
                    margin: EdgeInsets.only(top: 50),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        color: AppTheme.gridbodyBgColor,
                        borderRadius: AppTheme.gridTopBorder
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
                                width: SizeConfig.screenWidth-149,
                                color: showShadow? AppTheme.bgColor.withOpacity(0.8):AppTheme.bgColor,
                                child: SingleChildScrollView(
                                  controller: header,
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                      children: sn.supplierGridCol.asMap().
                                      map((i, value) => MapEntry(i, i==0?Container():
                                      Container(
                                          alignment: Alignment.center,
                                          width: 150,
                                          child: Text(value,style: AppTheme.TSWhite166,)
                                      )
                                      )).values.toList()
                                  ),
                                ),

                              ),
                              Container(
                                height: SizeConfig.screenHeight-140,
                                width: SizeConfig.screenWidth-149,
                                alignment: Alignment.topCenter,
                                color: AppTheme.gridbodyBgColor,
                                child: SingleChildScrollView(
                                  controller: body,
                                  scrollDirection: Axis.horizontal,
                                  child: Container(
                                    height: SizeConfig.screenHeight-140,
                                    alignment: Alignment.topCenter,
                                    color: AppTheme.gridbodyBgColor,

                                    child: SingleChildScrollView(
                                      controller: verticalRight,
                                      scrollDirection: Axis.vertical,
                                      child: Column(
                                          children:sn.supplierGridList.asMap().
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
                                                border: AppTheme.gridBottomborder,
                                                color: selectedIndex==i?AppTheme.yellowColor:AppTheme.gridbodyBgColor,
                                              ),
                                              height: 50,
                                              // padding: EdgeInsets.only(top: 20,bottom: 20),
                                              child: Row(
                                                children: [


                                                  Container(
                                                    alignment: Alignment.centerLeft,
                                                    padding: EdgeInsets.only(left: 2,right: 2),
                                                    width: 150,

                                                    child: FittedBox(
                                                      child: Text("${value.supplierCategoryName}",
                                                        style:selectedIndex==i?AppTheme.bgColorTS14:AppTheme.gridTextColor14,
                                                      ),
                                                    ),

                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(left: 5),
                                                    alignment: Alignment.center,
                                                    width: 150,
                                                    child: Text("${value.location}",
                                                      style:selectedIndex==i?AppTheme.bgColorTS14:AppTheme.gridTextColor14,
                                                    ),
                                                  ),

                                                  Container(
                                                    width: 150,
                                                    padding: EdgeInsets.only(right: 15),
                                                    alignment: Alignment.centerRight,
                                                    child: Text("${value.supplierContactNumber}",
                                                      style:selectedIndex==i?AppTheme.bgColorTS14:AppTheme.gridTextColor14,
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
                                child: Text("${sn.supplierGridCol[0]}",style: AppTheme.TSWhite166,),

                              ),
                              Container(
                                height: SizeConfig.screenHeight-140,
                                alignment: Alignment.topCenter,
                                decoration: BoxDecoration(
                                    color: AppTheme.gridbodyBgColor,
                                    boxShadow: [
                                      showShadow?  BoxShadow(
                                        color: AppTheme.addNewTextFieldText.withOpacity(0.1),
                                        spreadRadius: 0,
                                        blurRadius: 15,
                                        offset: Offset(0, -8), // changes position of shadow
                                      ):BoxShadow(color: Colors.transparent)
                                    ]
                                ),
                                child: Container(
                                  height: SizeConfig.screenHeight-140,
                                  alignment: Alignment.topCenter,

                                  child: SingleChildScrollView(
                                    controller: verticalLeft,
                                    scrollDirection: Axis.vertical,
                                    child: Column(
                                        children: sn.supplierGridList.asMap().
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
                                              border: AppTheme.gridBottomborder,
                                              color: selectedIndex==i?AppTheme.yellowColor:AppTheme.gridbodyBgColor,
                                            ),
                                            height: 50,
                                            width: 150,
                                            child: Container(
                                              padding: EdgeInsets.only(left: 10,right: 10,top: 3,bottom: 3),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(50),
                                                //color:value.invoiceType=='Receivable'? Colors.green:AppTheme.red,
                                              ),
                                              child: FittedBox(
                                                fit: BoxFit.contain,
                                                child: Text("${value.supplierName}",
                                                  //  style:selectedIndex==i?AppTheme.bgColorTS14:AppTheme.gridTextColorTS,
                                                  style:selectedIndex==i?AppTheme.bgColorTS14:AppTheme.gridTextColor14,
                                                ),
                                              ),
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

               /* Container(
                    height: SizeConfig.screenHeight-50,
                    width: SizeConfig.screenWidth,
                    color: Colors.white,
                    margin: EdgeInsets.only(top: 50),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child:DataTable(
                          headingRowColor:  MaterialStateColor.resolveWith((states) => AppTheme.bgColor),
                          showBottomBorder: true,
                          columns: sn.supplierGridCol.map((e) => DataColumn(
                              label: Text(e,style: TextStyle(fontFamily: 'RB',fontSize: 16,color: Colors.white),textAlign: TextAlign.center,)
                          )).toList(),
                          rows: sn.supplierGridList.asMap().map((i,e) => MapEntry(i,

                              DataRow(
                                  color:  MaterialStateColor.resolveWith((states) =>selectedIndex==i? AppTheme.yellowColor:Colors.white),

                                  cells: [
                                    DataCell(
                                        Text(e.supplierName,style: TextStyle(fontFamily: 'RR',fontSize: 16,color:selectedIndex==i? AppTheme.bgColor:AppTheme.gridTextColor),),
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
                                    DataCell(Text(e.supplierCategoryName??"",style: TextStyle(fontFamily: 'RR',fontSize: 16,color: selectedIndex==i? AppTheme.bgColor: AppTheme.gridTextColor),),
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
                                    DataCell(Text(e.location.toString(),style: TextStyle(fontFamily: 'RR',fontSize: 16,color:selectedIndex==i? AppTheme.bgColor:  AppTheme.gridTextColor),),
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
                                    DataCell(Text("${e.supplierContactNumber.toString()}",style: TextStyle(fontFamily: 'RR',fontSize: 16,color:selectedIndex==i? AppTheme.bgColor:  AppTheme.gridTextColor),),
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
                            size: Size( SizeConfig.screenWidth, 65),
                            painter: RPSCustomPainter3(),
                          ),
                        ),

                        Container(
                          width:  SizeConfig.screenWidth,
                          height: 80,

                          child: Stack(

                            children: [

                              AnimatedPositioned(
                                bottom:showEdit?-60:0,
                                duration: Duration(milliseconds: 300,),
                                curve: Curves.bounceInOut,
                                child: Container(
                                  height: 70,
                                  width: SizeConfig.screenWidth,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      IconButton(icon: Icon(Icons.picture_as_pdf,color: Colors.grey,), onPressed: (){

                                      }),
                                      IconButton(icon: Icon(Icons.exit_to_app,color: Colors.grey,), onPressed: (){

                                      }),
                                      SizedBox(width: SizeConfig.width50,),
                                      IconButton(icon: Icon(Icons.add_comment_sharp,color: Colors.grey,), onPressed: (){

                                      }),
                                      GestureDetector(
                                        onTap: (){

                                        },
                                        child: IconButton(icon: Icon(Icons.share,color: Colors.grey,), onPressed: (){

                                        }),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

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
                                            sn.updateSupplierEdit(true);
                                            sn.clearForm();
                                            sn.SupplierDropDownValues(context);
                                            sn.GetSupplierDbHit(context, sn.supplierGridList[selectedIndex].supplierId,SupplierDetailAddNewState());
                                            setState(() {
                                              showEdit=false;
                                              selectedIndex=-1;
                                            });
                                            Navigator.of(context).push(_createRoute());

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
                //addButton
                Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: (){
                      sn.updateSupplierEdit(false);
                      sn.SupplierDropDownValues(context);
                      Navigator.of(context).push(_createRoute());
                    },
                    child: Container(

                      height: 65,
                      width: 65,
                      margin: EdgeInsets.only(bottom: 20),
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

                  height: sn.SupplierLoader? SizeConfig.screenHeight:0,
                  width: sn.SupplierLoader? SizeConfig.screenWidth:0,
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
      pageBuilder: (context, animation, secondaryAnimation) => SupplierDetailAddNew(),
      //pageBuilder: (context, animation, secondaryAnimation) => QuaryAddNew(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        return FadeTransition(
          opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
          child: child,
        );
      },
    );
  }
}
