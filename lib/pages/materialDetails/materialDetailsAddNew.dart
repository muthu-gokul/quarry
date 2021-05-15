import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/materialNotifier.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/pages/quarryMaster/quarryLocationAddNew.dart';
import 'package:quarry/pages/sale/salesDetail.dart';
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/bottomBarAddButton.dart';
import 'package:quarry/widgets/customTextField.dart';
import 'package:quarry/widgets/sidePopUp/sidePopUpWithoutSearch.dart';
import 'package:quarry/widgets/validationErrorText.dart';


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

  bool materialName=false;
  bool materialCategory=false;
  bool materialUnit=false;
  bool materialPrice=false;
  bool materialGst=false;



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
                        width: SizeConfig.screenWidth,
                        height: 205,
                        decoration: BoxDecoration(
                          color: AppTheme.yellowColor,
                          /* image: DecorationImage(
                                     image: AssetImage("assets/svg/gridHeader/companyDetailsHeader.jpg",),
                                   fit: BoxFit.cover
                                 )*/

                        ),
                        child: SvgPicture.asset("assets/svg/gridHeader/materialMasterHeader.svg"),

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
                                  SizedBox(height:15,),
                                  AddNewLabelTextField(
                                    labelText: 'Material Name',
                                    regExp: '[A-Za-z  ]',
                                    textEditingController: qn.materialName,
                                    onEditComplete: (){
                                      node.unfocus();
                                    },
                                    ontap: (){
                                      scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                    },
                                  ),
                                  !materialName?Container():ValidationErrorText(title: "* Enter Material Name",),
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
                                  !materialCategory?Container():ValidationErrorText(title: "* Select Material Category",),

                                  AddNewLabelTextField(
                                    labelText: 'Description',
                                    regExp: '[A-Za-z.  ]',
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
                                    regExp: '[A-Za-z0-9 ]',
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
                                    regExp: '[A-Za-z0-9 ]',
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
                                  !materialUnit?Container():ValidationErrorText(title: "* Select Material Unit",),
                                  AddNewLabelTextField(
                                    labelText: 'Price',
                                    regExp: '[0-9.]',
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
                                  !materialPrice?Container():ValidationErrorText(title: "* Enter Material Price",),
                                  AddNewLabelTextField(
                                    labelText: 'GST',
                                    regExp: '[0-9.]',
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
                                  !materialGst?Container():ValidationErrorText(title: "* Enter Material GST",),

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
                      CancelButton(
                        ontap: (){
                          Navigator.pop(context);
                          qn.clearForm();
                        },
                      ),


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
                    height:65,

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
              //Add Button
               Align(
                   alignment: Alignment.bottomCenter,
                 child: AddButton(
                   ontap: (){
                     node.unfocus();
                     if(qn.materialName.text.isEmpty) {setState(() {materialName=true;});}
                     else{setState(() {materialName=false;});}

                     if(qn.selectedMatCategoryName==null) {setState(() {materialCategory=true;});}
                     else{setState(() {materialCategory=false;});}

                     if(qn.selectedUnitName==null) {setState(() {materialUnit=true;});}
                     else{setState(() {materialUnit=false;});}

                     if(qn.materialPrice.text.isEmpty) {setState(() {materialPrice=true;});}
                     else{setState(() {materialPrice=false;});}

                     if(qn.materialGst.text.isEmpty) {setState(() {materialGst=true;});}
                     else{setState(() {materialGst=false;});}


                     if(!materialName && !materialCategory && !materialUnit && !materialPrice && !materialGst){
                       qn.InsertMaterialDbHit(context);
                     }


                   },
                 ),
               ),



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



