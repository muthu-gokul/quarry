import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/materialNotifier.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/notifier/vehicleNotifier.dart';
import 'package:quarry/pages/quarryMaster/quarryLocationAddNew.dart';
import 'package:quarry/pages/sale/salesDetail.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/customTextField.dart';


class VehicleDetailAddNew extends StatefulWidget {
  @override
  VehicleDetailAddNewState createState() => VehicleDetailAddNewState();
}

class VehicleDetailAddNewState extends State<VehicleDetailAddNew> with TickerProviderStateMixin{

  GlobalKey <ScaffoldState> scaffoldkey=new GlobalKey<ScaffoldState>();


  ScrollController scrollController;
  ScrollController listViewController;


  bool isVehicleTypeOpen=false;
  bool _keyboardVisible = false;


  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((_){


      scrollController=new ScrollController();
      listViewController=new ScrollController();
      setState(() {

      });


      listViewController.addListener(() {

        if(listViewController.offset>20){

          scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);


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

    final node=FocusScope.of(context);

    SizeConfig().init(context);
    _keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
        key: scaffoldkey,
        body: Consumer<VehicleNotifier>(
            builder: (context,qn,child)=> Stack(
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
                                image: AssetImage("assets/images/saleFormheader.jpg",),
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
                    controller: scrollController,
                    child: Column(
                      children: [
                        SizedBox(height: 160,),
                        Container(
                          height: SizeConfig.screenHeight-60,
                          width: SizeConfig.screenWidth,

                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                          ),
                          child: ListView(
                            controller: listViewController,
                            scrollDirection: Axis.vertical,

                            children: [
                              AddNewLabelTextField(
                                labelText: 'Enter Vehicle Number',
                                textEditingController: qn.VehicleNo,
                              ),
                              AddNewLabelTextField(
                                labelText: 'VehicleDescription',
                                textEditingController: qn.VehicleDescript,
                              ),


                              GestureDetector(
                                onTap: (){
                                  node.unfocus();
                                  setState(() {
                                    isVehicleTypeOpen=true;
                                  });
                                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                                },
                                child: SidePopUpParent(
                                  text: qn.selectedVehicleTypeName==null? "Select Vehicle Type":qn.selectedVehicleTypeName,
                                  textColor: qn.selectedVehicleTypeName==null? AppTheme.addNewTextFieldText.withOpacity(0.5):AppTheme.addNewTextFieldText,
                                  iconColor: qn.selectedVehicleTypeName==null? AppTheme.addNewTextFieldText:AppTheme.yellowColor,
                                ),
                              ),





                              AddNewLabelTextField(
                                labelText: 'Model',
                                scrollPadding: 100,
                                textEditingController: qn.VehicleModel,

                              ),

                              AddNewLabelTextField(
                                labelText: 'EmptyWeight',
                                textInputType: TextInputType.number,
                                scrollPadding: 100,
                                textEditingController: qn.VehicleWeight,

                              ),

                              SizedBox(height: SizeConfig.height200,)
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),


                //HEADER
                Container(
                  height: SizeConfig.height60,
                  width: SizeConfig.screenWidth,
                  child: Row(
                    children: [
                      IconButton(icon: Icon(Icons.arrow_back), onPressed: (){

                        Navigator.pop(context);
                        qn.clearVehicleDetailForm();
                      }),
                      SizedBox(width: SizeConfig.width5,),
                      Text("Vehicle Master ",
                        style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize: SizeConfig.width16),
                      ),
                      Text(qn.isVehicleEdit?" / Edit":"/ Add New",
                        style: TextStyle(fontFamily: 'RR',color: Color(0xFF367BF5),fontSize: SizeConfig.width16),
                      ),
                      Spacer(),

                    ],
                  ),
                ),


                //Save Button
                Positioned(
                  bottom: 0,
                  child: Container(
                    height:_keyboardVisible?0: SizeConfig.height70,
                    width: SizeConfig.screenWidth,
                    color: AppTheme.grey,
                    child: Center(
                      child: GestureDetector(
                        onTap: (){
                          node.unfocus();
                          qn.InsertVehicleDbHit(context);


                        },
                        child: Container(
                          height: SizeConfig.height50,
                          width: SizeConfig.width120,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(SizeConfig.height25),
                              color: AppTheme.bgColor
                          ),
                          child: Center(
                            child: Text(qn.isVehicleEdit?"Update":"Save",style: AppTheme.TSWhite20,),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Container(
                  height: qn.vehicleLoader? SizeConfig.screenHeight:0,
                  width: qn.vehicleLoader? SizeConfig.screenWidth:0,
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child:CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppTheme.yellowColor),),
                    //Image.asset("assets/images/Loader.gif",filterQuality: FilterQuality.high,gaplessPlayback: true,isAntiAlias: true,)
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
                      height: SizeConfig.height430,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      clipBehavior: Clip.antiAlias,
                      margin: EdgeInsets.only(left: SizeConfig.width30,right: SizeConfig.width30),
                      transform: Matrix4.translationValues(isVehicleTypeOpen?0:SizeConfig.screenWidth, 0, 0),

                      child:Container(
                        height: SizeConfig.height430,
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
                                  itemCount: qn.vehicleTypeList.length,
                                  itemBuilder: (context,index){
                                    return GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          qn.selectedVehicleTypeId=qn.vehicleTypeList[index].VehicleTypeId;
                                          qn.selectedVehicleTypeName=qn.vehicleTypeList[index].VehicleTypeName;
                                          isVehicleTypeOpen=false;
                                        });

                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 20),
                                        alignment: Alignment.center,
                                        decoration:BoxDecoration(
                                            borderRadius:BorderRadius.circular(8),
                                            border: Border.all(color: qn.selectedVehicleTypeId==null? AppTheme.addNewTextFieldBorder:qn.selectedVehicleTypeId==qn.vehicleTypeList[index].VehicleTypeId?Colors.transparent: AppTheme.addNewTextFieldBorder),
                                            color: qn.selectedVehicleTypeId==null? Colors.white: qn.selectedVehicleTypeId==qn.vehicleTypeList[index].VehicleTypeId?AppTheme.popUpSelectedColor:Colors.white
                                        ),
                                        width:300,
                                        height:50,
                                        child: Text("${qn.vehicleTypeList[index].VehicleTypeName}",
                                          style: TextStyle(color:qn.selectedVehicleTypeId==null? AppTheme.grey:qn.selectedVehicleTypeId==qn.vehicleTypeList[index].VehicleTypeId?Colors.white:AppTheme.grey,
                                              fontSize:18,fontFamily: 'RR'),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),

                              Container(

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


                              )





                              /*Container(
                                width:150,
                                height:50,
                                margin: EdgeInsets.only(top: SizeConfig.height10),

                                child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                    color: AppTheme.yellowColor,
                                    elevation: 5,
                                    shadowColor: AppTheme.yellowColor,
                                    child: Center(child: Text("+ Add New",style: TextStyle(color:Colors.black,fontSize:18,),))

                                ),

                              )*/

                            ]


                        ),
                      )
                  ),
                ),













              ],
            )
        )

    );
  }
}


/*
class MachineAdd extends StatefulWidget {
  VoidCallback drawerCallback;
  MachineAdd({this.drawerCallback});
  @override
  MachineAddState createState() => MachineAddState();
}

class MachineAddState extends State<MachineAdd> with TickerProviderStateMixin{




  ScrollController scrollController;
  ScrollController listViewController;



  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((_){


      scrollController=new ScrollController();
      listViewController=new ScrollController();
      setState(() {

      });


      listViewController.addListener(() {

        if(listViewController.offset>20){

          scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);


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
    return Consumer<QuarryNotifier>(
        builder: (context,qn,child)=> Stack(
          children: [



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

                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                      ),
                      child: ListView(
                        controller: listViewController,
                        scrollDirection: Axis.vertical,

                        children: [
                          AddNewLabelTextField(
                            labelText: 'Machine Name',
                            textEditingController: qn.MD_machineName,
                          ),
                          AddNewLabelTextField(
                            labelText: 'Machine Type',
                            textEditingController: qn.MD_machineType,
                          ),
                          AddNewLabelTextField(
                            labelText: 'Machine Model',
                            textEditingController: qn.MD_machineModel,
                          ),
                          AddNewLabelTextField(
                            labelText: 'Capacity',
                            textEditingController: qn.MD_machineCapacity,
                            scrollPadding: 100,
                          ),
                          AddNewLabelTextField(
                            labelText: 'Motor Power',
                            textEditingController: qn.MD_machinePower,
                            scrollPadding: 100,
                          ),
                          AddNewLabelTextField(
                            labelText: 'Weight',
                            textEditingController: qn.MD_machineWeight,
                            scrollPadding: 100,
                          ),

                          SizedBox(height: SizeConfig.height100,)
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
                  IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
                    Navigator.pop(context);
                  }),
                  SizedBox(width: SizeConfig.width5,),
                  Text("Machine Detail",
                    style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize: SizeConfig.width16),
                  ),
                  Spacer(),

                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: SizeConfig.height70,
                width: SizeConfig.screenWidth,
                color: AppTheme.grey,
                child: Center(
                  child: GestureDetector(
                    onTap: (){


                    },
                    child: Container(
                      height: SizeConfig.height50,
                      width: SizeConfig.width120,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(SizeConfig.height25),
                          color: AppTheme.bgColor
                      ),
                      child: Center(
                        child: Text(qn.isMachineEdit?"Update":"Save",style: AppTheme.TSWhite20,),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Container(

              height: qn.insertCompanyLoader? SizeConfig.screenHeight:0,
              width: qn.insertCompanyLoader? SizeConfig.screenWidth:0,
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child:CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppTheme.yellowColor),),
                //Image.asset("assets/images/Loader.gif",filterQuality: FilterQuality.high,gaplessPlayback: true,isAntiAlias: true,)

              ),
            ),
          ],
        )
    );
  }
}
*/



