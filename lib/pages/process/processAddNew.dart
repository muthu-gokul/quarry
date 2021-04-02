import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
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
                                          fit: BoxFit.fill
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



                                    ),
                                    AddNewLabelTextField(
                                      labelText: 'Material Code',



                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        setState(() {

                                        });

                                      },
                                      child:SidePopUpParent(text: 'Select Unit Type',),
                                    ),
                                    AddNewLabelTextField(
                                      labelText: 'Material Price',
                                      textInputType: TextInputType.number,

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
                                      labelText: 'Address',

                                      maxLines: 3,
                                      textInputType: TextInputType.text,
                                      scrollPadding: 200,
                                      textEditingController: qn.CD_address,
                                    ),
                                    AddNewLabelTextField(
                                      labelText: 'Quarry Name',

                                      textEditingController: qn.CD_quarryname,

                                    ),
                                    AddNewLabelTextField(
                                      labelText: 'Contact Number',

                                      textInputType: TextInputType.number,
                                      textEditingController: qn.CD_contactNo,
                                    ),
                                    AddNewLabelTextField(
                                      labelText: 'Address',

                                      maxLines: 3,
                                      textInputType: TextInputType.text,
                                      scrollPadding: 200,
                                      textEditingController: qn.CD_address,
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

                      Container(

                        height: qn.insertCompanyLoader? SizeConfig.screenHeight:0,
                        width: qn.insertCompanyLoader? SizeConfig.screenWidth:0,
                        color: Colors.black.withOpacity(0.5),
                        child: Center(
                          child: Image.asset("assets/images/Loader.gif",filterQuality: FilterQuality.high,gaplessPlayback: true,isAntiAlias: true,)
                          ,
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
