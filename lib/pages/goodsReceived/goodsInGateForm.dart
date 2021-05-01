
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quarry/model/goodsReceivedModel/goodsMaterialListModel.dart';
import 'package:quarry/notifier/goodsReceivedNotifier.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/pages/quarryMaster/plantDetailsAddNew.dart';
import 'package:quarry/pages/sale/salesDetail.dart';
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/customTextField.dart';





class GoodsInGateForm extends StatefulWidget {

  @override
  GoodsInGateFormState createState() => GoodsInGateFormState();
}

class GoodsInGateFormState extends State<GoodsInGateForm> with TickerProviderStateMixin{

  bool isEdit=false;


  ScrollController scrollController;
  ScrollController listViewController;

  bool _keyboardVisible=false;
  bool isVehicleTypeOpen=false;
  
  

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final node=FocusScope.of(context);

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
                              color: AppTheme.gridbodyBgColor,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                          ),
                          child: ListView(
                            controller: listViewController,
                            children: [
                                 Image.asset("assets/images/inGate.jpg",height: 50,width: 100,),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("${gr.IGF_Materials[gr.IGF_Materials.length-1].materialName} - ${gr.IGF_Materials[gr.IGF_Materials.length-1].quantity}",
                                        style: TextStyle(fontFamily: 'RM',color: AppTheme.bgColor,fontSize: 20),
                                        textAlign: TextAlign.center,
                                      ),
                                      Padding(
                                        padding:  EdgeInsets.only(bottom: 2),
                                        child: Text(" ${gr.IGF_Materials[gr.IGF_Materials.length-1].unitName}",
                                          style: TextStyle(fontFamily: 'RR',color: AppTheme.hintColor,fontSize: 14),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                  AddNewLabelTextField(
                                    textEditingController: gr.vehicleNo,
                                    labelText: "Vehicle Number",
                                    ontap: (){
                                      setState(() {
                                        _keyboardVisible=true;
                                      });
                                    },
                                    onEditComplete: (){
                                      node.unfocus();
                                      Timer(Duration(milliseconds: 50), (){
                                        setState(() {
                                          _keyboardVisible=false;
                                        });
                                      });
                                    },
                                  ),
                              GestureDetector(
                                onTap: (){
                                  node.unfocus();

                                  Timer(Duration(milliseconds: 50), (){
                                    setState(() {
                                      _keyboardVisible=false;
                                    });
                                  });
                                  setState(() {
                                    isVehicleTypeOpen=true;
                                  });
                                },
                                child: SidePopUpParent(
                                  text: gr.selectedVehicleTypeName==null? "Select Vehicle Type":gr.selectedVehicleTypeName,
                                  textColor: gr.selectedVehicleTypeName==null? AppTheme.addNewTextFieldText.withOpacity(0.5):AppTheme.addNewTextFieldText,
                                  iconColor: gr.selectedVehicleTypeName==null? AppTheme.addNewTextFieldText:AppTheme.yellowColor,
                                  bgColor: gr.selectedVehicleTypeName==null? AppTheme.disableColor:Colors.white,

                                ),
                              ),
                              AddNewLabelTextField(
                                textEditingController: gr.loadedWeight,
                                labelText: "Loaded Weight",
                                ontap: (){
                                  scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                  setState(() {
                                    _keyboardVisible=true;
                                  });
                                },
                                onEditComplete: (){
                                  node.unfocus();
                                   Timer(Duration(milliseconds: 300), (){
                                    setState(() {
                                      _keyboardVisible=false;
                                    });
                                  });
                                },
                                textInputType: TextInputType.number,
                              ),
                            ],
                          )
                      )
                    ],
                  ),
                ),
              ),

              //bottomNav
              AnimatedPositioned(
                duration: Duration(milliseconds: 100),
                curve: Curves.easeIn,
                bottom: _keyboardVisible?-90:0,
                child: Container(
                  width: SizeConfig.screenWidth,
                  height:70,

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
                      CustomPaint(
                        size: Size( SizeConfig.screenWidth, 65),
                        painter: RPSCustomPainter3(),
                      ),
                      Center(
                        heightFactor: 0.5,
                        child: FloatingActionButton(backgroundColor: AppTheme.yellowColor, child: Icon(Icons.done,color: AppTheme.bgColor,size: 30,), elevation: 0.1, onPressed: () {

                          if(gr.vehicleNo.text.isEmpty){
                            CustomAlert().commonErrorAlert(context, "Enter Vehicle Number", "");
                          }
                          else if(gr.loadedWeight.text.isEmpty){
                            CustomAlert().commonErrorAlert(context, "Enter Loaded Weight", "");
                          }
                          else{
                            if(gr.ML_GoodsorderId==0){
                              gr.InsertGoodsDbHit(context);
                            }
                            else{
                              List js=[];
                              js=gr.IGF_Materials.map((e) => e.toJsonInWard(gr.selectedVehicleTypeId,
                                  gr.vehicleNo.text,
                                  double.parse(gr.loadedWeight.text))
                              ).toList();
                              print("Update-$js");
                              gr.UpdateGoodsDbHit(context,js);
                            }


                          }


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
                      gr.IGF_clear();
                      setState(() {
                        gr.IGF_Materials.removeLast();
                      });
                      print(gr.IGF_Materials.length);
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


              Container(
                height: isVehicleTypeOpen ? SizeConfig.screenHeight:0,
                width: isVehicleTypeOpen ? SizeConfig.screenWidth:0,
                color: Colors.black.withOpacity(0.5),
              ),


  ///////////////////////////////////////    VEHICLE TYPE    ////////////////////////////////
              Align(
                alignment: Alignment.center,
                child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                    width: SizeConfig.screenWidth,
                    height: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    clipBehavior: Clip.antiAlias,
                    margin: EdgeInsets.only(left: SizeConfig.width30,right: SizeConfig.width30),
                    transform: Matrix4.translationValues(isVehicleTypeOpen?0:SizeConfig.screenWidth, 0, 0),

                    child:Container(
                      height: 400,
                      width: SizeConfig.screenWidth,
                      color: Colors.white,
                      //  padding: EdgeInsets.only(left: SizeConfig.width20,right: SizeConfig.width20,bottom: SizeConfig.height10),
                      child:Column (
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: SizeConfig.height50,
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(icon: Icon(Icons.cancel), onPressed: (){
                                      setState(() {
                                        isVehicleTypeOpen=false;
                                      });
                                    }),
                                  ),
                                  Align(
                                      alignment: Alignment.center,
                                      child: Text('Select Vehicle Type',style:TextStyle(color:Colors.black,fontFamily: 'RR',fontSize:16),)),
                                ],
                              ),
                            ),
                            SizedBox(height: SizeConfig.height10,),




                            Container(
                              height: SizeConfig.screenHeight*(300/720),

                              margin: EdgeInsets.only(left: SizeConfig.width30,right: SizeConfig.width30),
                              child: ListView.builder(
                                itemCount: gr.vehicleTypeList.length,
                                itemBuilder: (context,index){
                                  return GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        gr.selectedVehicleTypeId=gr.vehicleTypeList[index].VehicleTypeId;
                                        gr.selectedVehicleTypeName=gr.vehicleTypeList[index].VehicleTypeName;
                                        isVehicleTypeOpen=false;
                                      });

                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 20),
                                      alignment: Alignment.center,
                                      decoration:BoxDecoration(
                                          borderRadius:BorderRadius.circular(8),
                                          border: Border.all(color: gr.selectedVehicleTypeId==null? AppTheme.addNewTextFieldBorder:gr.selectedVehicleTypeId==gr.vehicleTypeList[index].VehicleTypeId?Colors.transparent: AppTheme.addNewTextFieldBorder),
                                          color: gr.selectedVehicleTypeId==null? Colors.white: gr.selectedVehicleTypeId==gr.vehicleTypeList[index].VehicleTypeId?AppTheme.popUpSelectedColor:Colors.white
                                      ),
                                      width:300,
                                      height:50,
                                      child: Text("${gr.vehicleTypeList[index].VehicleTypeName}",
                                        style: TextStyle(color:gr.selectedVehicleTypeId==null? AppTheme.grey:gr.selectedVehicleTypeId==gr.vehicleTypeList[index].VehicleTypeId?Colors.white:AppTheme.grey,
                                            fontSize:18,fontFamily: 'RR'),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                           /* Container(

                              width:150,
                              height:SizeConfig.height50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.0),
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
                                  child: Text("+ Add New",style: TextStyle(color:Colors.black,fontSize:18,),
                                  )
                              ),


                            )*/

                            

                          ]


                      ),
                    )
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

