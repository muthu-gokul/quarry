import 'dart:async';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quarry/model/paymentModel/paymentMappingModel.dart';
import 'package:quarry/model/productionDetailsModel/productionMaterialMappingListModel.dart';
import 'package:quarry/notifier/paymentNotifier.dart';
import 'package:quarry/notifier/productionNotifier.dart';
import 'package:quarry/notifier/reportNotifier.dart';
import 'package:quarry/notifier/reportsNotifier.dart';
import 'package:quarry/pages/sale/salesDetail.dart';
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/customTextField.dart';

class ReportSettings extends StatefulWidget {
  @override
  ReportSettingsState createState() => ReportSettingsState();
}

class ReportSettingsState extends State<ReportSettings> with TickerProviderStateMixin{

  GlobalKey <ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();


  ScrollController scrollController;
  ScrollController listViewController;

  bool _keyboardVisible = false;

  bool isListScroll=false;




  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController = new ScrollController();
      listViewController = new ScrollController();


    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);

    SizeConfig().init(context);

    return Scaffold(
      key: scaffoldkey,
      body: Consumer<ReportNotifier>(
        builder: (context, rn, child) =>
            Stack(
              children: [


                //IMAGE
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
                                image: AssetImage(
                                  "assets/images/saleFormheader.jpg",),
                                fit: BoxFit.cover
                            )

                        ),
                      ),
                    ],
                  ),
                ),

                //FORM
                Container(
                  height: SizeConfig.screenHeight,
                  // color: Colors.transparent,
                  child: SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: scrollController,
                    child: Column(
                      children: [
                        SizedBox(height: 160,),
                        Container(
                          height: SizeConfig.screenHeight - 60,
                          width: SizeConfig.screenWidth,
                          alignment: Alignment.topCenter,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))
                          ),
                          child: GestureDetector(
                            onVerticalDragUpdate: (details){

                              int sensitivity = 5;

                              if (details.delta.dy > sensitivity) {
                                scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn).then((value){
                                  if(isListScroll){

                                    setState(() {
                                      isListScroll=false;
                                    });
                                  }
                                });

                              } else if(details.delta.dy < -sensitivity){
                                scrollController.animateTo(100, duration: Duration(milliseconds: 300), curve: Curves.easeIn).then((value){

                                  if(!isListScroll){

                                    setState(() {
                                      isListScroll=true;
                                    });
                                  }

                                });
                              }
                            },
                            child: Container(
                              height: _keyboardVisible ? SizeConfig.screenHeight * 0.5 : SizeConfig.screenHeight - 100,
                              width: SizeConfig.screenWidth,

                              decoration: BoxDecoration(
                                  color: AppTheme.gridbodyBgColor,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10))
                              ),
                              child: NotificationListener<ScrollNotification>(
                                onNotification: (s){
                                  if(s is ScrollStartNotification){

                                    //    print(listViewController.position);
                                    if(listViewController.offset==0 && isListScroll && scrollController.offset==100 && listViewController.position.userScrollDirection==ScrollDirection.idle){

                                      Timer(Duration(milliseconds: 100), (){
                                        if(listViewController.position.userScrollDirection!=ScrollDirection.reverse){
                                          if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
                                            //scroll end
                                            scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn).then((value) {
                                              if(isListScroll){
                                                setState(() {
                                                  isListScroll=false;
                                                });
                                              }
                                            });
                                          }

                                        }
                                      });


                                    }
                                  }
                                },
                                child: ListView(
                                  physics: isListScroll?AlwaysScrollableScrollPhysics():NeverScrollableScrollPhysics(),
                                  controller: listViewController,
                                  scrollDirection: Axis.vertical,

                                  children: [

                                    ReportSettingsColumnFilter(
                                      title: "Column Filter",
                                      list: rn.reportsGridColumnList,
                                      instanceName: 'ColumnName',
                                    ),

                                    for(int i=0;i<rn.filtersList.length ;i++)

                                      ReportSettingsHeader(
                                        title: rn.filtersList[i].title,
                                        list: rn.filtersList[i].list,
                                        instanceName: rn.filtersList[i].instanceName,
                                      ),



                                    SizedBox(height: 80,),
                                  ],
                                ),
                              ),
                            ),
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
                      IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
                        Navigator.pop(context);
                      }),
                      SizedBox(width: SizeConfig.width5,),
                      Text("${rn.reportHeader} Settings",
                        style: TextStyle(fontFamily: 'RR', color: Colors.black, fontSize: 16),
                      ),

                    ],
                  ),
                ),


                //bottomNav
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: SizeConfig.screenWidth,
                    height:_keyboardVisible?0: 70,

                    decoration: BoxDecoration(
                        color: AppTheme.gridbodyBgColor,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.gridbodyBgColor.withOpacity(0.7),
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
                        Center(
                          heightFactor: 0.5,
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: (){
                              setState(() {
                                //  rn.tempSalesCol=List.from(rn.salesReportGridCol);
                              });


                              if(rn.TypeName=="SaleReport"){
                                rn.filterSales();
                              }
                                else if(rn.TypeName=="PurchaseReport"){
                                rn.filterPurchase();
                              }
                             else if(rn.TypeName=="CustomerSaleReport"){
                                rn.filterCustomerSale();
                              }
                              else if(rn.TypeName=="SupplierPurchaseReport"){
                                rn.filterSupplierPurchase();
                              }
                             else if(rn.TypeName=="ProductionReport"){
                                rn.filterProduction();
                              }
                             else if(rn.TypeName=="InvoiceReport"){
                                rn.filterInvoice();
                              }
                             else if(rn.TypeName=="ReceivablePaymentReport"){
                                rn.filterReceivablePaymentReport();
                              }
                             else if(rn.TypeName=="PayablePaymentReport"){
                                rn.filterPayablePaymentReport();
                              }
                             else if(rn.TypeName=="DieselPurchaseReport"){
                                rn.filterDieselPurchaseReport();
                              }
                             else if(rn.TypeName=="MachineManagementReport"){
                                rn.filterMachineManagementReport();
                              }

                              Navigator.pop(context);
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
                                child: Icon(Icons.done,size: SizeConfig.height30,color: AppTheme.bgColor,),
                              ),
                            ),
                          ),
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
                  height: rn.ReportLoader ? SizeConfig.screenHeight : 0,
                  width: rn.ReportLoader ? SizeConfig.screenWidth : 0,
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.yellowColor),),
                    //Image.asset("assets/images/Loader.gif",filterQuality: FilterQuality.high,gaplessPlayback: true,isAntiAlias: true,)

                  ),
                ),





              ],
            ),
      ),
    );

  }
}



class ReportSettingsHeader extends StatefulWidget {


  String title;
  List<dynamic> list=[];
  String instanceName;

  ReportSettingsHeader({  this.title,this.list,this.instanceName});

  @override
  _ReportSettingsHeaderState createState() => _ReportSettingsHeaderState();
}

class _ReportSettingsHeaderState extends State<ReportSettingsHeader> with TickerProviderStateMixin{
  Animation arrowAnimation;
  AnimationController arrowAnimationController;
  bool open=false;

  @override
  void initState() {
    arrowAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    arrowAnimation = Tween(begin: 0.0, end:-3.14).animate(arrowAnimationController);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: (){
            arrowAnimationController.isCompleted
                ? arrowAnimationController.reverse()
                : arrowAnimationController.forward();

            setState(() {
              open=!open;
            });
          },
          child: Container(
            height: 50,
            width: SizeConfig.screenWidth,
            margin: EdgeInsets.only(left: SizeConfig.width20,right: SizeConfig.width20,top: 20),
            padding: EdgeInsets.only(left: SizeConfig.width10,right: SizeConfig.width10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: AppTheme.yellowColor,
            ),
            child: Row(
              children: [
                Text(widget.title,style:TextStyle(fontFamily: 'RM',color: AppTheme.bgColor,fontSize: 16)),
                Spacer(),
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.bgColor
                  ),
                  child:  AnimatedBuilder(
                    animation: arrowAnimationController,
                    builder: (context, child) =>
                        Transform.rotate(
                          angle: arrowAnimation.value,
                          child: Icon(
                            Icons.keyboard_arrow_up_rounded,
                            size: 25.0,
                            color: Colors.white,
                          ),
                        ),
                  ),
                )
              ],
            ),
          ),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
          width: SizeConfig.screenWidth,
          height:!open ?0: widget.list.length*50.0,
          margin: EdgeInsets.only(left: SizeConfig.width40,right: SizeConfig.width40),
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.list.length,
            itemBuilder: (context,index){
              return  Container(
                height: 50,
                child: Row(
                  children: [
                    Container(
                      width:SizeConfig.screenWidth*0.6,
                        child: Text("${widget.list[index][widget.instanceName]}",style:TextStyle(fontFamily: 'RR',color: AppTheme.bgColor,fontSize: 14),)
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: (){

                        setState(() {
                           if(widget.list[index]['IsActive']==1){
                            widget.list[index]['IsActive']=0;
                          }
                          else if(widget.list[index]['IsActive']==0){
                            widget.list[index]['IsActive']=1;
                          }

                        //  widget.list[index].isActive=!widget.list[index].isActive;
                        });


                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(color:widget.list[index]['IsActive']==1?Colors.transparent: AppTheme.addNewTextFieldBorder.withOpacity(0.5)),
                            color:widget.list[index]['IsActive']==1?AppTheme.yellowColor: AppTheme.disableColor
                        ),
                        child: Center(
                          child: Icon(Icons.done,color:widget.list[index]['IsActive']==1?AppTheme.bgColor: AppTheme.addNewTextFieldBorder.withOpacity(0.8),size: 15,),
                        ),

                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}



class ReportSettingsColumnFilter extends StatefulWidget {

  String title;
  List<dynamic> list=[];
  String instanceName;

  ReportSettingsColumnFilter({  this.title,this.list,this.instanceName});
  @override
  _ReportSettingsColumnFilterState createState() => _ReportSettingsColumnFilterState();
}

class _ReportSettingsColumnFilterState extends State<ReportSettingsColumnFilter> with TickerProviderStateMixin{


  Animation arrowAnimation;
  AnimationController arrowAnimationController;
  bool open=false;

  @override
  void initState() {
    arrowAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    arrowAnimation = Tween(begin: 0.0, end:-3.14).animate(arrowAnimationController);

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: (){
            arrowAnimationController.isCompleted
                ? arrowAnimationController.reverse()
                : arrowAnimationController.forward();

            setState(() {
              open=!open;
            });
          },
          child: Container(
            height: 50,
            width: SizeConfig.screenWidth,
            margin: EdgeInsets.only(left: SizeConfig.width20,right: SizeConfig.width20,top: 20),
            padding: EdgeInsets.only(left: SizeConfig.width10,right: SizeConfig.width10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: AppTheme.yellowColor,
            ),
            child: Row(
              children: [
                Text(widget.title,style:TextStyle(fontFamily: 'RM',color: AppTheme.bgColor,fontSize: 16)),
                Spacer(),
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.bgColor
                  ),
                  child:  AnimatedBuilder(
                    animation: arrowAnimationController,
                    builder: (context, child) =>
                        Transform.rotate(
                          angle: arrowAnimation.value,
                          child: Icon(
                            Icons.keyboard_arrow_up_rounded,
                            size: 25.0,
                            color: Colors.white,
                          ),
                        ),
                  ),
                )
              ],
            ),
          ),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
          width: SizeConfig.screenWidth,
          height:!open ?0: widget.list.length*50.0,
          margin: EdgeInsets.only(left: SizeConfig.width40,right: SizeConfig.width40),
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.list.length,
            itemBuilder: (context,index){
              return index==0?Container():  Container(
                height: 50,
                child: Row(
                  children: [
                    Text("${widget.list[index].get(widget.instanceName)}",style:TextStyle(fontFamily: 'RR',color: AppTheme.bgColor,fontSize: 14),),
                    Spacer(),
                    GestureDetector(
                      onTap: (){

                        setState(() {

                         /* if(widget.list[index]['IsActive']==1){
                            widget.list[index]['IsActive']=0;
                          }
                          else if(widget.list[index]['IsActive']==0){
                            widget.list[index]['IsActive']=1;
                          }*/

                          widget.list[index].isActive=!widget.list[index].isActive;
                        });


                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(color:widget.list[index].isActive?Colors.transparent: AppTheme.addNewTextFieldBorder.withOpacity(0.5)),
                            color:widget.list[index].isActive?AppTheme.yellowColor: AppTheme.disableColor
                        ),
                        child: Center(
                          child: Icon(Icons.done,color:widget.list[index].isActive?AppTheme.bgColor: AppTheme.addNewTextFieldBorder.withOpacity(0.8),size: 15,),
                        ),

                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
