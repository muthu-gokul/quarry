import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/materialNotifier.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/pages/quarryMaster/quarryLocationAddNew.dart';
import 'package:quarry/pages/sale/salesDetail.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/customTextField.dart';


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
                            onVerticalDragDown: (v){
                              if(scrollController.offset==100 && listViewController.offset==0){
                                scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                              }
                              else if(scrollController.offset==0 && listViewController.offset==0){
                                scrollController.animateTo(100, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                              }

                            },
                            child: Container(
                              height:_keyboardVisible?SizeConfig.screenHeight*0.5 :SizeConfig.screenHeight-100,
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
                                    scrollPadding: 100,
                                    onEditComplete: (){
                                      node.unfocus();
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
                                        child: Text("Rs",style: AppTheme.TSWhite16,),
                                      ),
                                    ),
                                  ),
                                  AddNewLabelTextField(
                                    labelText: 'GST',
                                    textEditingController: qn.materialGst,
                                    textInputType: TextInputType.number,
                                    scrollPadding: 100,
                                    onEditComplete: (){
                                      node.unfocus();
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
                                        child: Text("%",style: AppTheme.TSWhite20,),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: SizeConfig.height50,)
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
                        style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize: SizeConfig.width16),
                      ),
                      Text(qn.isMaterialEdit?" / Edit":" / Add New",
                        style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize: SizeConfig.width16),
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
                      transform: Matrix4.translationValues(materialCategoryOpen?0:SizeConfig.screenWidth, 0, 0),

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
                                           materialCategoryOpen=false;
                                         });
                                       }),
                                     ),
                                     Align(
                                         alignment: Alignment.center,
                                         child: Text('Select Material Category',style:TextStyle(color:Colors.black,fontFamily: 'RR',fontSize:16),)),
                                   ],
                                 ),
                               ),
                              SizedBox(height: SizeConfig.height10,),
                              Container(
                                height: SizeConfig.screenHeight*(300/720),
                                /*color: Colors.red,*/
                                margin: EdgeInsets.only(left: SizeConfig.width30,right: SizeConfig.width30),
                                child: ListView.builder(
                                  itemCount: qn.materialCategoryList.length,
                                  itemBuilder: (context,index){
                                    return GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          qn.selectedMatCategoryId=qn.materialCategoryList[index].MaterialCategoryId;
                                          qn.selectedMatCategoryName=qn.materialCategoryList[index].MaterialCategoryName;
                                          materialCategoryOpen=false;
                                        });

                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 20),
                                        alignment: Alignment.center,
                                        decoration:BoxDecoration(
                                            borderRadius:BorderRadius.circular(8),
                                            border: Border.all(color: qn.selectedMatCategoryId==null? AppTheme.addNewTextFieldBorder:qn.selectedMatCategoryId==qn.materialCategoryList[index].MaterialCategoryId?Colors.transparent: AppTheme.addNewTextFieldBorder),
                                            color: qn.selectedMatCategoryId==null? Colors.white: qn.selectedMatCategoryId==qn.materialCategoryList[index].MaterialCategoryId?AppTheme.popUpSelectedColor:Colors.white
                                        ),
                                        width:300,
                                        height:50,
                                        child: Text("${qn.materialCategoryList[index].MaterialCategoryName}",
                                          style: TextStyle(color:qn.selectedMatCategoryId==null? AppTheme.grey:qn.selectedMatCategoryId==qn.materialCategoryList[index].MaterialCategoryId?Colors.white:AppTheme.grey,
                                              fontSize:18,fontFamily: 'RR'),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),




                            ]


                        ),
                      )
                  ),
                ),



///////////////////////////////////////      MATERIAL UNIT  ////////////////////////////////
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
                      transform: Matrix4.translationValues(materialUnitOpen?0:SizeConfig.screenWidth, 0, 0),

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
                                          materialUnitOpen=false;
                                        });
                                      }),
                                    ),
                                    Align(
                                        alignment: Alignment.center,
                                        child: Text('Select Unit',style:TextStyle(color:Colors.black,fontFamily: 'RR',fontSize:16),)),
                                  ],
                                ),
                              ),
                              SizedBox(height: SizeConfig.height10,),




                              Container(
                                height: SizeConfig.screenHeight*(300/720),
                                /*color: Colors.red,*/
                                margin: EdgeInsets.only(left: SizeConfig.width30,right: SizeConfig.width30),
                                child: ListView.builder(
                                  itemCount: qn.materialUnits.length,
                                  itemBuilder: (context,index){
                                    return GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          qn.selectedUnitId=qn.materialUnits[index].UnitId;
                                          qn.selectedUnitName=qn.materialUnits[index].UnitName;
                                          materialUnitOpen=false;
                                        });

                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 20),
                                        alignment: Alignment.center,
                                        decoration:BoxDecoration(
                                            borderRadius:BorderRadius.circular(8),
                                            border: Border.all(color: qn.selectedUnitId==null? AppTheme.addNewTextFieldBorder:
                                            qn.selectedUnitId==qn.materialUnits[index].UnitId?Colors.transparent:
                                            AppTheme.addNewTextFieldBorder
                                            ),
                                            color: qn.selectedUnitId==null? Colors.white: qn.selectedUnitId==qn.materialUnits[index].UnitId?AppTheme.popUpSelectedColor:Colors.white
                                        ),
                                        width:300,
                                        height:50,
                                        child: Text("${qn.materialUnits[index].UnitName}",
                                          style: TextStyle(color:qn.selectedUnitId==null? AppTheme.grey:qn.selectedUnitId==qn.materialUnits[index].UnitId?Colors.white:AppTheme.grey,
                                              fontSize:18,fontFamily: 'RR'),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),







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



