import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quarry/model/dropDownValues.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/pages/sale/salesDetail.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/customTextField.dart';

import 'processMaterialsList.dart';
import 'processStoneList.dart';

class ProcessAddNew extends StatefulWidget {
  @override
  _ProcessAddNewState createState() => _ProcessAddNewState();
}

class _ProcessAddNewState extends State<ProcessAddNew> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Consumer<QuarryNotifier>(
        builder: (context,qn,child)=> Container(
          height: SizeConfig.screenHeight,
          width: SizeConfig.screenWidth,
          color: Colors.white,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: SizeConfig.height50,
                      width: SizeConfig.screenWidth,
                      child: Row(
                        children: [
                          IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
                            qn.updateProcessAddNew(false);
                            Timer(Duration(milliseconds: 300), (){
                              qn.updateProcessAddNewHW(false);
                              qn.stoneSelected=null;
                              qn. MaterialSelected=null;
                              qn. processWeight.clear();
                              qn. processWastage.clear();

                            });
                          }),
                          SizedBox(width: SizeConfig.width20,),
                          Text("Material Master ",
                            style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize: SizeConfig.width16),
                          ),
                          Text("/ Add New",
                            style: TextStyle(fontFamily: 'RR',color: Color(0xFF367BF5),fontSize: SizeConfig.width16),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: SizeConfig.height25,),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: (){
                         qn.updateProcessStoneOpen(true);
                      },
                      child: Container(
                        margin: EdgeInsets.all(SizeConfig.width10),
                        padding: EdgeInsets.all(SizeConfig.width10),
                        height: SizeConfig.height50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.grey),
                            color: Color(0xFFF2F4F9)
                        ),
                        child: Row(
                          children: [
                            Text(
                              qn.stoneSelected==null?"Select Stone Name":"${qn.processStoneList[qn.stoneSelected]}",
                              style: TextStyle(fontSize: 16,fontFamily: 'RR',color: Colors.grey),),
                            Spacer(),
                            Icon(Icons.arrow_forward_ios,color: Colors.grey,)
                          ],
                        ),

                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: (){
                       qn.updateProcessMaterialOpen(true);
                      },
                      child: Container(
                        margin: EdgeInsets.all(SizeConfig.width10),
                        padding: EdgeInsets.all(SizeConfig.width10),
                        height: SizeConfig.height50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.grey),
                            color: Color(0xFFF2F4F9)
                        ),
                        child: Row(
                          children: [
                            Text(
                              qn.MaterialSelected==null?"Select Processed Material Name":"${qn.processMaterialList[qn.MaterialSelected]}",
                              style: TextStyle(fontSize: 16,fontFamily: 'RR',color: Colors.grey),),
                            Spacer(),
                            Icon(Icons.arrow_forward_ios,color: Colors.grey,)
                          ],
                        ),

                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(SizeConfig.width10),
                      height: SizeConfig.height50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        // border: Border.all(color: Colors.grey)
                      ),
                      child: TextFormField(
                        controller: qn.processWeight,
                        decoration: InputDecoration(
                            border:  OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFF367BF5))
                            ),
                            labelText: "Enter Processed Material Weight"
                        ),
                        keyboardType: TextInputType.number,
                      ),

                    ),
                    Container(
                      margin: EdgeInsets.all(SizeConfig.width10),
                      height: SizeConfig.height50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        // border: Border.all(color: Colors.grey)
                      ),
                      child: TextFormField(
                        controller: qn.processWastage,
                        decoration: InputDecoration(
                            border:  OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFF367BF5))
                            ),
                            labelText: "Wastage"
                        ),
                        keyboardType: TextInputType.number,
                      ),

                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: (){
                        qn.addmaterialProcessGridList();
                      },
                      child: Container(
                        margin: EdgeInsets.all(SizeConfig.width10),
                        height: SizeConfig.height50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Color(0xFF367BF5)
                          // border: Border.all(color: Colors.grey)
                        ),
                        child: Center(
                          child: Text("Done",style: TextStyle(fontFamily: 'RR',color: Colors.white,fontSize: 16),),
                        ),

                      ),
                    ),


                  ],
                ),
              ),
            ProcessStoneList(),
              ProcessMaterialList(),
            ],
          ),
        ),
      ),
    );
  }
}


class MaterialAddNew extends StatefulWidget {
  VoidCallback drawerCallback;
  MaterialAddNew({this.drawerCallback});
  @override
  _MaterialAddNewState createState() => _MaterialAddNewState();
}

class _MaterialAddNewState extends State<MaterialAddNew> {


  bool isUnitsOpen=false;


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light.copyWith(
              statusBarColor: Colors.black
          ),
          child: SafeArea(
            child: Consumer<QuarryNotifier>(
                builder: (context,qn,child)=> SingleChildScrollView(
                  child: Stack(
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
                            // height: 100,

                              // decoration: BoxDecoration(
                              //     // image: DecorationImage(
                              //     //     image: AssetImage("assets/images/saleFormheader.jpg",),
                              //     //     fit: BoxFit.fill
                              //     // ),
                              //   // color: Colors.red,
                              //
                              // ),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  image: DecorationImage(
                                          image: AssetImage("assets/images/saleFormheader.jpg",),
                                          fit: BoxFit.cover
                                      ),
                                  boxShadow: [
                                    BoxShadow(
                                      color:AppTheme.bgColor.withOpacity(0.8),
                                      offset: const Offset(0,1),
                                      blurRadius: 15.0,
                                      // spreadRadius: 2.0,
                                    ),
                                  ]
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
                                        Navigator.pop(context);
                                        qn.clearMaterialForm();
                                      }),
                                      SizedBox(width: SizeConfig.width5,),
                                      Text("Material Master / Add New",
                                        style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize: SizeConfig.width16),
                                      ),
                                      Spacer(),

                                    ],
                                  ),
                                  Spacer(),
                                  // Image.asset("assets/images/saleFormheader.jpg",height: 100,),
                                  // Container(
                                  //   height: SizeConfig.height50,
                                  //   color: Color(0xFF753F03),
                                  //
                                  // ) // Container(
                                  //   height: SizeConfig.height50,
                                  //   color: Color(0xFF753F03),
                                  //
                                  // )
                                ],
                              ),
                            ),

                            Container(

                             height: SizeConfig.screenHeight-(SizeConfig.height270),


                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    AddNewLabelTextField(
                                      labelText: 'Material Name',
                                      textEditingController: qn.materialName,
                                    ),
                                    AddNewLabelTextField(
                                      labelText: 'Material Code',
                                      textEditingController: qn.materialCode,
                                    ),
                                    AddNewLabelTextField(
                                      labelText: 'Material Description',
                                      textEditingController: qn.materialDesc,
                                      scrollPadding: 100,
                                    ),
                                    GestureDetector(
                                      onTap: (){

                                        SystemChannels.textInput.invokeMethod('TextInput.hide');
                                        setState(() {
                                          isUnitsOpen=true;
                                        });

                                      },
                                      child:SidePopUpParent(text:qn.MM_selectMaterialUnitId==null? 'Select Unit Type':qn.MM_selectMaterialUnitName,
                                      textColor: qn.MM_selectMaterialUnitId==null?AppTheme.grey:AppTheme.bgColor,
                                      ),
                                    ),
                                    AddNewLabelTextField(
                                      labelText: 'Material Price',
                                      textInputType: TextInputType.number,
                                      scrollPadding: 100,
                                      textEditingController: qn.materialUnitPrice,

                                    ),

                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: GestureDetector(
                                        onTap: (){
                                          setState(() {

                                          });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(right: SizeConfig.width20,top: SizeConfig.height10),
                                          height: SizeConfig.height30,
                                          width: SizeConfig.width150,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(3),
                                              color: AppTheme.bgColor
                                          ),
                                          child: Center(
                                            child: Text("Notes",style: AppTheme.TSWhite16,),
                                          ),
                                        ),
                                      ),
                                    ),
                                    AddNewLabelTextField(
                                      labelText: 'GST',
                                      textInputType: TextInputType.number,
                                      scrollPadding: 100,
                                      textEditingController: qn.materialGST,

                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            qn.selectTaxList.add(TaxDetails(
                                             TaxId: null,
                                             MaterialTaxMappingId: null,
                                             MaterialTaxValue: 0,
                                             TaxName: null,
                                             IsActive: 1 ,
                                             MaterialId: null,
                                             taxValue: TextEditingController()
                                            )
                                            );

                                          });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(right: SizeConfig.width20,top: SizeConfig.height10),
                                          height: SizeConfig.height30,
                                          width: SizeConfig.width150,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(3),
                                              color: AppTheme.bgColor
                                          ),
                                          child: Center(
                                            child: Text("Add GST",style: AppTheme.TSWhite16,),
                                          ),
                                        ),
                                      ),
                                    ),

                                   for(int i=0;i<qn.selectTaxList.length;i++)

                                    Container(
                                      height: SizeConfig.height60,
                                      width: double.maxFinite,
                                      margin: EdgeInsets.only(left:SizeConfig.width20,right:SizeConfig.width20,top:SizeConfig.height20,),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: SizeConfig.height60,
                                            width: SizeConfig.width150,
                                            padding: EdgeInsets.only(left: SizeConfig.width10,right:SizeConfig.width10),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(3),
                                              border: Border.all(color: AppTheme.addNewTextFieldBorder)
                                            ),
                                               child: DropdownButtonHideUnderline(
                                                  child: DropdownButton(
                                                    hint: Text("Select Tax"),
                                                   style: TextStyle(color: AppTheme.bgColor),
                                                    value: qn.selectTaxList[i].TaxName,
                                                    onChanged: (newValue) {
                                                      print(newValue);
                                                      setState(() {
                                                        qn.selectTaxList[i].TaxName = newValue;
                                                        qn.selectTaxList[i].TaxId= qn.material_TaxList.where((element) => element.TaxName.toLowerCase()==newValue.toString().toLowerCase()).toList()[0].TaxId;
                                                        // qn.selectTaxList[0].TaxId = newValue.TaxId;
                                                      });
                                                    },
                                                    dropdownColor: Colors.grey[100],
                                                    iconEnabledColor: Colors.red,

                                                    items: qn.material_TaxList.map((location) {
                                                      return DropdownMenuItem(
                                                        child: new Text(location.TaxName),
                                                        value: location.TaxName,
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                          ),

                                          SizedBox(width: SizeConfig.width10,),

                                          Container(
                                            height: SizeConfig.height60,
                                            width: SizeConfig.width70,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(3),
                                                border: Border.all(color: AppTheme.addNewTextFieldBorder)
                                            ),
                                            child: TextFormField(
                                              controller: qn.selectTaxList[i].taxValue,
                                              style: TextStyle(fontFamily: 'RR',fontSize: 20,color:AppTheme.addNewTextFieldText),
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                focusedBorder:  InputBorder.none,
                                                errorBorder:  InputBorder.none,
                                                enabledBorder:  InputBorder.none,
                                                contentPadding: new EdgeInsets.symmetric(vertical: 25.0, horizontal: 5.0),
                                              ),
                                              keyboardType: TextInputType.number,
                                            ),
                                          ),
                                          SizedBox(width: SizeConfig.width10,),
                                          Container(
                                            height: SizeConfig.height60,
                                            width: SizeConfig.width35,
                                            // decoration: BoxDecoration(
                                            //     borderRadius: BorderRadius.circular(3),
                                            //     border: Border.all(color: AppTheme.addNewTextFieldBorder)
                                            // ),
                                            child: Center(
                                              child: IconButton(icon: Icon(Icons.cancel,color: Colors.red,size: 35,), onPressed: (){
                                                setState(() {
                                                  qn.selectTaxList.removeAt(i);
                                                });
                                              }),
                                            )
                                          ),
                                        ],
                                      ),
                                    ),

                                    AddNewLabelTextField(
                                      labelText: 'HSN Code',

                                      scrollPadding: 100,
                                      textEditingController: qn.materialHSNCode,

                                    ),

                                    SizedBox(height: SizeConfig.height20,)
                                  ],
                                ),
                              ),
                            ),



                            Container(
                              height: SizeConfig.height70,
                              color: AppTheme.grey,
                              child: Center(
                                child: GestureDetector(
                                  onTap: (){
                                    // List<dynamic> js= qn.selectTaxList.map((e) => e.toJson()).toList();
                                    // print(js);
                                    qn.InsertMaterialDetailDbhit(context);

                                  },
                                  child: Container(
                                    height: SizeConfig.height50,
                                    width: SizeConfig.width120,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(SizeConfig.height25),
                                        color: AppTheme.bgColor
                                    ),
                                    child: Center(
                                      child: Text("Save",style: AppTheme.TSWhite20,),
                                    ),
                                  ),
                                ),
                              ),
                            )

                          ],
                        ),
                      ),
////////////////////////////////////// LOADER //////////////////////////
                      Container(

                        height: qn.masterLoader? SizeConfig.screenHeight:0,
                        width: qn.masterLoader? SizeConfig.screenWidth:0,
                        color: Colors.black.withOpacity(0.5),
                        child: Center(
                            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppTheme.yellowColor),),

                        ),
                      ),

                      Container(

                        height: isUnitsOpen? SizeConfig.screenHeight:0,
                        width: isUnitsOpen? SizeConfig.screenWidth:0,
                        color: Colors.black.withOpacity(0.5),

                      ),

                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                        width: SizeConfig.screenWidth,
                        height: SizeConfig.screenHeight*0.8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                        clipBehavior: Clip.antiAlias,

                        margin: EdgeInsets.only(left: SizeConfig.width20,right: SizeConfig.width20,top: SizeConfig.screenHeight*0.1),
                        transform: Matrix4.translationValues(isUnitsOpen?0:SizeConfig.screenWidth, 0, 0),
                        child: Stack(
                          children: [
                            Container(
                              height: SizeConfig.height70,
                              width: double.maxFinite,
                              color: Color(0xFF6769F0),
                              padding: EdgeInsets.only(left: SizeConfig.width20,right: SizeConfig.width20,bottom: SizeConfig.height10),

                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Units',style: AppTheme.TSWhite20,),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: (){
                                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                                      setState(() {
                                        isUnitsOpen=false;
                                      });
                                    },
                                    child: Container(
                                      height: SizeConfig.height30,
                                      width: SizeConfig.height30,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white

                                      ),
                                      child: Center(
                                        child:  Icon(Icons.close,
                                          color: Color(0xFF6769F0),size: 28,),
                                      ),
                                    ),
                                  )

                                ],
                              ),

                            ),
                            Positioned(
                              top: SizeConfig.height60,
                              child: Container(
                                height: SizeConfig.screenHeight- SizeConfig.screenHeight*(200/1280),
                                width: SizeConfig.screenWidth-SizeConfig.width40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color(0xFFF2F4FA)
                                ),
                                child: ListView.builder(
                                    itemCount: qn.material_UnitsList.length,
                                    itemBuilder: (context,index){
                                      return GestureDetector(
                                        onTap: (){

                                          setState(() {
                                            isUnitsOpen=false;
                                            qn.MM_selectMaterialUnitId=qn.material_UnitsList[index].UnitId;
                                            qn.MM_selectMaterialUnitName=qn.material_UnitsList[index].UnitName;
                                          });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(left: SizeConfig.width50,right:  SizeConfig.width50,top: SizeConfig.height20),

                                          height: SizeConfig.height50,
                                          width: double.maxFinite,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              border: Border.all(color: AppTheme.addNewTextFieldBorder),
                                              color: qn.MM_selectMaterialUnitId==null ?Colors.white:qn.MM_selectMaterialUnitId==qn.material_UnitsList[index].UnitId?AppTheme.bgColor:Colors.white

                                          ),
                                          child: Center(
                                            child: Text("${qn.material_UnitsList[index].UnitName}",style: TextStyle(fontFamily: 'RR',fontSize: 18,
                                                color: qn.MM_selectMaterialUnitId==null ?AppTheme.bgColor:qn.MM_selectMaterialUnitId==qn.material_UnitsList[index].UnitId?Colors.white:AppTheme.bgColor

                                            ),),
                                          ),
                                        ),
                                      );
                                    }),

                              ),
                            )

                          ],
                        ),
                      ),

                    ],
                  ),
                )
            ),
          ),
        )
    );
  }
}
