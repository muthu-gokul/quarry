import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/materialNotifier.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/notifier/vehicleNotifier.dart';
import 'package:quarry/pages/quarryMaster/quarryLocationAddNew.dart';
import 'package:quarry/pages/sale/salesDetail.dart';
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/customTextField.dart';
import 'package:quarry/widgets/sidePopUp/sidePopUpWithSearch.dart';


class VehicleDetailAddNew extends StatefulWidget {
  @override
  VehicleDetailAddNewState createState() => VehicleDetailAddNewState();
}

class VehicleDetailAddNewState extends State<VehicleDetailAddNew> with TickerProviderStateMixin{

  GlobalKey <ScaffoldState> scaffoldkey=new GlobalKey<ScaffoldState>();


  ScrollController scrollController;
  ScrollController listViewController;

  bool isVehicleTypeOpen=false;
  bool isAddTransportOpen=false;
  //bool _keyboardVisible = false;
  //bool isListScroll=false;
  TextEditingController transportTypeSearchController =new TextEditingController();
  TextEditingController addTransportTypeController =new TextEditingController();

  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((_){


      scrollController=new ScrollController();
      listViewController=new ScrollController();
      setState(() {

      });

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final node=FocusScope.of(context);

    SizeConfig().init(context);
    return Scaffold(
        key: scaffoldkey,
        resizeToAvoidBottomInset: false,
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
                        width: SizeConfig.screenWidth,
                        height: 205,
                        alignment: Alignment.centerLeft,

                        decoration: BoxDecoration(
                          color: AppTheme.yellowColor,
                          /* image: DecorationImage(
                                     image: AssetImage("assets/svg/gridHeader/companyDetailsHeader.jpg",),
                                   fit: BoxFit.cover
                                 )*/

                        ),
                        child: SvgPicture.asset("assets/svg/gridHeader/vehicleAddNew.svg",width: SizeConfig.screenWidth,),

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
                          height: SizeConfig.screenHeight-60,
                          width: SizeConfig.screenWidth,

                          decoration: BoxDecoration(
                              color: AppTheme.gridbodyBgColor,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                          ),
                          child:  GestureDetector(
                            onVerticalDragUpdate: (details){
                              int sensitivity = 5;
                              if (details.delta.dy > sensitivity) {
                                scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn).then((value){
                                  /* if(isListScroll){
                                    setState(() {
                                      isListScroll=false;
                                    });
                                  }*/
                                });

                              } else if(details.delta.dy < -sensitivity){
                                scrollController.animateTo(100, duration: Duration(milliseconds: 300), curve: Curves.easeIn).then((value){

                                  /*if(!isListScroll){
                                    setState(() {
                                      isListScroll=true;
                                    });
                                  }*/
                                });
                              }
                            },
                            child: ListView(
                              controller: listViewController,
                              scrollDirection: Axis.vertical,

                              children: [
                                AddNewLabelTextField(
                                  labelText: 'Enter Vehicle Number',
                                  textEditingController: qn.VehicleNo,
                                  onEditComplete: (){
                                    node.unfocus();
                                  },
                                  ontap: (){
                                    scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                  },
                                ),
                                AddNewLabelTextField(
                                  labelText: 'VehicleDescription',
                                  textEditingController: qn.VehicleDescript,
                                  onEditComplete: (){
                                    node.unfocus();
                                  },
                                  ontap: (){
                                    scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                  },
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
                                    bgColor: qn.selectedVehicleTypeName==null? AppTheme.disableColor:Colors.white,
                                  ),
                                ),





                                AddNewLabelTextField(
                                  labelText: 'Model',
                                  scrollPadding: 100,
                                  textEditingController: qn.VehicleModel,
                                  ontap: (){
                                    scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                  },
                                  onEditComplete: (){
                                    node.unfocus();
                                  },
                                ),

                                AddNewLabelTextField(
                                  labelText: 'EmptyWeight',
                                  textInputType: TextInputType.number,
                                  scrollPadding: 100,
                                  textEditingController: qn.VehicleWeight,
                                  ontap: (){
                                    scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                  },
                                  onEditComplete: (){
                                    node.unfocus();
                                  },
                                ),

                                SizedBox(height: SizeConfig.height200,)
                              ],
                            ),
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
                        style: TextStyle(fontFamily: 'RR',color: AppTheme.bgColor,fontSize:16),
                      ),
                      Text(qn.isVehicleEdit?" / Edit":"/ Add New",
                        style: TextStyle(fontFamily: 'RR',color: AppTheme.bgColor,fontSize: 16),
                      ),
                      Spacer(),

                    ],
                  ),
                ),


                //bottomNav
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: SizeConfig.screenWidth,
                    // height:_keyboardVisible?0:  70,
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
                          decoration: BoxDecoration(

                          ),
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
                      node.unfocus();
                      if(qn.VehicleNo.text.isEmpty){
                        CustomAlert().commonErrorAlert(context, "Enter Vehicle Number", "");
                      }
                      else if(qn.selectedVehicleTypeId==null){
                        CustomAlert().commonErrorAlert(context, "Select VehicleType", "");
                      }
                      else{
                        qn.InsertVehicleDbHit(context);
                      }
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
                        child: Icon(Icons.done,size: SizeConfig.height30,color: AppTheme.bgColor,),
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
                  height: isVehicleTypeOpen || isAddTransportOpen? SizeConfig.screenHeight:0,
                  width: isVehicleTypeOpen || isAddTransportOpen? SizeConfig.screenWidth:0,
                  color: Colors.black.withOpacity(0.5),
                ),


///////////////////////////////////////    VEHICLE TYPE    ////////////////////////////////
                PopUpSearch(
                  isOpen: isVehicleTypeOpen,
                  searchController: transportTypeSearchController,
                  searchHintText: "Search Vehicle Type",

                  dataList: qn.filterVehicleTypeList,
                  propertyKeyId: "VehicleTypeId",
                  propertyKeyName: "VehicleTypeName",
                  selectedId: qn.selectedVehicleTypeId,

                  searchOnchange: (v){
                   qn.searchVehicleType(v);
                  },
                  itemOnTap: (index){
                    node.unfocus();
                    setState(() {
                      isVehicleTypeOpen=false;
                      qn.selectedVehicleTypeId=qn.filterVehicleTypeList[index].VehicleTypeId;
                      qn.selectedVehicleTypeName=qn.filterVehicleTypeList[index].VehicleTypeName;
                      qn.filterVehicleTypeList=qn.vehicleTypeList;

                    });
                    transportTypeSearchController.clear();
                  },
                  closeOnTap: (){
                    node.unfocus();
                    setState(() {
                      isVehicleTypeOpen=false;
                    });
                    transportTypeSearchController.clear();
                  },
                  addNewOnTap: (){
                    setState(() {
                      isVehicleTypeOpen=false;
                      isAddTransportOpen=true;
                    });
                  },
                ),




/////////////////// add new transport Type //////
                Align(
                  alignment: Alignment.center,
                  child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                      width: SizeConfig.screenWidth,
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      clipBehavior: Clip.antiAlias,
                      margin: EdgeInsets.only(left: SizeConfig.width30,right: SizeConfig.width30),
                      transform: Matrix4.translationValues(isAddTransportOpen?0:SizeConfig.screenWidth, 0, 0),

                      child:Container(
                        height:250,
                        width: SizeConfig.screenWidth,
                        color: Colors.white,
                        child:Column (
                            children: [
                              SizedBox(height: 40,),
                              Container(
                                height: 50,
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child:Container(
                                        height: 50,
                                        width: SizeConfig.screenWidth,
                                        margin: EdgeInsets.only(left: SizeConfig.width20,right: SizeConfig.width20),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(25),
                                            /*      border: Border.all(color: AppTheme.addNewTextFieldBorder),*/
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
                                        child:Container(
                                          padding: EdgeInsets.only(left: 20),
                                          width: SizeConfig.screenWidth*0.52,
                                          child: TextField(
                                            controller: addTransportTypeController,
                                            scrollPadding: EdgeInsets.only(bottom: 500),
                                            style:  TextStyle(fontFamily: 'RR',fontSize: 15,color:AppTheme.addNewTextFieldText,letterSpacing: 0.2),
                                            decoration: InputDecoration(

                                                border: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                errorBorder: InputBorder.none,
                                                focusedErrorBorder: InputBorder.none,
                                                enabledBorder: InputBorder.none,
                                                hintText: "Vehicle Type Name",
                                                hintStyle: AppTheme.hintText
                                            ),
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(RegExp('[A-Za-z]')),
                                            ],
                                            // keyboardType: otherChargesTextFieldOpen?TextInputType.number:TextInputType.text,
                                          ),
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                              SizedBox(height: 40,),
                              GestureDetector(
                                onTap: (){
                                  node.unfocus();
                                  qn.InsertVehicleTypeDbhit(context, addTransportTypeController.text);
                                  setState(() {
                                    isAddTransportOpen=false;
                                  });
                                  addTransportTypeController.clear();

                                },
                                child: Container(
                                  height: 40,
                                  width: 120,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: AppTheme.yellowColor
                                  ),
                                  child: Center(
                                    child: Text("Add",style:TextStyle(fontFamily: 'RR',color: AppTheme.bgColor,fontSize: 18),),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  node.unfocus();
                                  setState(() {
                                    isAddTransportOpen=false;
                                  });
                                  addTransportTypeController.clear();


                                },
                                child: Container(
                                  height: 50,
                                  width: 150,
                                  child: Center(
                                    child: Text("Cancel",style: TextStyle(fontFamily: 'RL',fontSize: 18,color: Color(0xFFA1A1A1))),
                                  ),
                                ),
                              ),




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



