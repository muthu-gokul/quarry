import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/materialNotifier.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/pages/quarryMaster/quarryLocationAddNew.dart';
import 'package:quarry/pages/sale/salesDetail.dart';
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/customTextField.dart';
import 'package:quarry/widgets/sidePopUp/sidePopUpWithoutSearch.dart';


class MaterialDetailAddNew extends StatefulWidget {
  @override
  MaterialDetailAddNewState createState() => MaterialDetailAddNewState();
}

class MaterialDetailAddNewState extends State<MaterialDetailAddNew> with TickerProviderStateMixin{

  GlobalKey <ScaffoldState> scaffoldkey=new GlobalKey<ScaffoldState>();


  ScrollController scrollController;
  ScrollController listViewController;

  bool _keyboardVisible = false;

  bool materialCategoryOpen = false;
  bool materialUnitOpen = false;



  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((_){


      scrollController=new ScrollController();
      listViewController=new ScrollController();
      setState(() {

      });

/*
      listViewController.addListener(() {

        if(listViewController.offset>20){

          scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);


        }
        else if(listViewController.offset==0){
          scrollController.animateTo(0, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
        }
      });*/

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
        resizeToAvoidBottomInset: false,
        body: Consumer<MaterialNotifier>(
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
                    physics: NeverScrollableScrollPhysics(),
                    controller: scrollController,
                    child: Column(
                      children: [
                        SizedBox(height: 160,),
                        Container(
                          height: SizeConfig.screenHeight-60,
                          width: SizeConfig.screenWidth,
                          alignment: Alignment.topCenter,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                          ),
                          child: GestureDetector(
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
                            child: Container(
                             // height:_keyboardVisible?SizeConfig.screenHeight*0.5 :SizeConfig.screenHeight-100,
                              height:SizeConfig.screenHeight-100,
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
                                    labelText: 'Material Name',
                                    textEditingController: qn.materialName,
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
                                        materialCategoryOpen=true;
                                      });

                                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                                    },
                                    child: SidePopUpParent(
                                      text: qn.selectedMatCategoryName==null? "Select Material Category":qn.selectedMatCategoryName,
                                      textColor: qn.selectedMatCategoryName==null? AppTheme.addNewTextFieldText.withOpacity(0.5):AppTheme.addNewTextFieldText,
                                      iconColor: qn.selectedMatCategoryName==null? AppTheme.addNewTextFieldText:AppTheme.yellowColor,
                                    ),
                                  ),

                                  AddNewLabelTextField(
                                    labelText: 'Description',
                                    textEditingController: qn.materialDescription,
                                    ontap: (){
                                      scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                    },
                                    onEditComplete: (){
                                      node.unfocus();
                                    },
                                  ),
                                  AddNewLabelTextField(
                                    labelText: 'Material Code',
                                    textEditingController: qn.materialCode,
                                    ontap: (){
                                      scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                    },
                                    onEditComplete: (){
                                      node.unfocus();
                                    },
                                  ),
                                  AddNewLabelTextField(
                                    labelText: 'HSN Code',
                                    textEditingController: qn.materialHSNcode,
                                    scrollPadding: 100,
                                    ontap: (){
                                      scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                    },
                                    onEditComplete: (){
                                      node.unfocus();
                                    },
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      node.unfocus();
                                      setState(() {
                                        materialUnitOpen=true;
                                      });
                                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                                    },
                                    child: SidePopUpParent(
                                      text: qn.selectedUnitName==null? "Select Unit":qn.selectedUnitName,
                                      textColor: qn.selectedUnitName==null? AppTheme.addNewTextFieldText.withOpacity(0.5):AppTheme.addNewTextFieldText,
                                      iconColor: qn.selectedUnitName==null? AppTheme.addNewTextFieldText:AppTheme.yellowColor,
                                    ),
                                  ),
                                  AddNewLabelTextField(
                                    labelText: 'Price',
                                    textEditingController: qn.materialPrice,
                                    textInputType: TextInputType.number,
                                    scrollPadding: 300,
                                    onEditComplete: (){
                                      node.unfocus();
                                    },
                                    ontap: (){
                                      scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                    },
                                    suffixIcon: Container(
                                      margin: EdgeInsets.all(10),
                                      height: 15,
                                      width: 50,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          color: AppTheme.yellowColor
                                      ),
                                      child: Center(
                                        child: Text("Rs",style: AppTheme.TSWhiteML,),
                                      ),
                                    ),
                                  ),
                                  AddNewLabelTextField(
                                    labelText: 'GST',
                                    textEditingController: qn.materialGst,
                                    textInputType: TextInputType.number,
                                    scrollPadding: 300,
                                    onEditComplete: (){
                                      node.unfocus();
                                    },
                                    ontap: (){
                                      scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                    },
                                    suffixIcon: Container(
                                      margin: EdgeInsets.all(10),
                                      height: 15,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: AppTheme.yellowColor
                                      ),
                                      child: Center(
                                        child: Text("%",style: AppTheme.TSWhite166,),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height:_keyboardVisible?SizeConfig.screenHeight*0.5 : SizeConfig.height50,)
                                ],
                              ),
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
                        qn.clearForm();
                      }),
                      SizedBox(width: SizeConfig.width5,),
                      Text("Material Detail",
                        style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize: 16),
                      ),
                      Text(qn.isMaterialEdit?" / Edit":" / Add New",
                        style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize: 16),
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
                        Container(
                          decoration: BoxDecoration(

                          ),
                          margin:EdgeInsets.only(top: 0),
                          child: CustomPaint(
                            size: Size( SizeConfig.screenWidth, 65),
                            painter: RPSCustomPainter3(),
                          ),
                        ),
                        Center(
                          heightFactor: 0.5,
                          child: FloatingActionButton(backgroundColor: AppTheme.yellowColor, child: Icon(Icons.save), elevation: 0.1, onPressed: () {
                            node.unfocus();
                            if(qn.materialName.text.isEmpty)
                            {
                              CustomAlert().commonErrorAlert(context, "Enter Material Name", "");
                            }
                            else  if(qn.selectedMatCategoryName==null){
                              CustomAlert().commonErrorAlert(context, "Select Material Type", "");
                            }
                            else if(qn.selectedUnitName==null)
                            {
                              CustomAlert().commonErrorAlert(context, "Select Unit", "");
                            }
                            else if(qn.materialPrice.text.isEmpty)
                            {
                              CustomAlert().commonErrorAlert(context, "Enter Material Price", "");
                            }
                            else if(qn.materialGst.text.isEmpty)
                            {
                              CustomAlert().commonErrorAlert(context, "Enter Material GST", "");
                            }
                            else {
                              qn.InsertMaterialDbHit(context);
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

              /*  //Save Button
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
                          if(qn.selectedMatCategoryName==null){
                            CustomAlert().commonErrorAlert(context, "Select Material Type", "");
                          }
                          else if(qn.materialName.text.isEmpty)
                          {
                            CustomAlert().commonErrorAlert(context, "Enter Material Name", "");
                          }
                          else if(qn.materialCode.text.isEmpty)
                          {
                            CustomAlert().commonErrorAlert(context, "Enter Material Code", "");
                          }
                          else if(qn.selectedUnitName==null)
                          {
                            CustomAlert().commonErrorAlert(context, "Select Unit", "");
                          }
                          else {
                            qn.InsertMaterialDbHit(context);
                          }


                        },
                        child: Container(
                          height: SizeConfig.height50,
                          width: SizeConfig.width120,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(SizeConfig.height25),
                              color: AppTheme.bgColor
                          ),
                          child: Center(
                            child: Text(qn.isMaterialEdit?"Update":"Save",style: AppTheme.TSWhite20,),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),*/

                Container(
                  height: qn.materialLoader? SizeConfig.screenHeight:0,
                  width: qn.materialLoader? SizeConfig.screenWidth:0,
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child:CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppTheme.yellowColor),),
                    //Image.asset("assets/images/Loader.gif",filterQuality: FilterQuality.high,gaplessPlayback: true,isAntiAlias: true,)
                  ),
                ),


                Container(
                  height: materialCategoryOpen || materialUnitOpen? SizeConfig.screenHeight:0,
                  width: materialCategoryOpen || materialUnitOpen? SizeConfig.screenWidth:0,
                  color: Colors.black.withOpacity(0.5),
                ),


///////////////////////////////////////      MATERIAL CATEGORY ////////////////////////////////

                PopUpStatic(
                  title: "Select Material Category",

                  isOpen: materialCategoryOpen,
                  dataList: qn.materialCategoryList,
                  propertyKeyName:"MaterialCategoryName",
                  propertyKeyId: "MaterialCategoryId",
                  selectedId: qn.selectedMatCategoryId,
                  itemOnTap: (index){
                    setState(() {
                      materialCategoryOpen=false;
                      qn.selectedMatCategoryId=qn.materialCategoryList[index].MaterialCategoryId;
                      qn.selectedMatCategoryName=qn.materialCategoryList[index].MaterialCategoryName;
                    });
                  },
                  closeOnTap: (){
                    setState(() {
                      materialCategoryOpen=false;
                    });
                  },
                ),






///////////////////////////////////////      MATERIAL UNIT  ////////////////////////////////

                PopUpStatic(
                  title: "Select Unit",

                  isOpen: materialUnitOpen,
                  dataList: qn.materialUnits,
                  propertyKeyName:"UnitName",
                  propertyKeyId: "UnitId",
                  selectedId: qn.selectedUnitId,
                  itemOnTap: (index){
                    setState(() {
                      materialUnitOpen=false;
                      qn.selectedUnitId=qn.materialUnits[index].UnitId;
                      qn.selectedUnitName=qn.materialUnits[index].UnitName;
                    });
                  },
                  closeOnTap: (){
                    setState(() {
                      materialUnitOpen=false;
                    });
                  },
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



