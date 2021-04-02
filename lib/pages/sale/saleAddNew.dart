import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/pages/process/processMaterialsList.dart';
import 'package:quarry/styles/size.dart';

class SaleAddNew extends StatefulWidget {
  @override
  _SaleAddNewState createState() => _SaleAddNewState();
}

class _SaleAddNewState extends State<SaleAddNew> {
  @override
  Widget build(BuildContext context) {
    return Consumer<QuarryNotifier>(
      builder: (context,qn,child)=> Stack(
        children: [
          Container(
            height: SizeConfig.screenHeight,
            width: SizeConfig.screenWidth,
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: SizeConfig.height50,
                    width: SizeConfig.screenWidth,
                    child: Row(
                      children: [
                        IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
                          qn.updateSaleAddNew(false);
                          Timer(Duration(milliseconds: 300), (){
                            qn.updateSaleAddNewHW(false);
                            // qn.stoneSelected=null;
                             qn. MaterialSelected=null;

                            qn.  saleWeight.clear();
                            qn. salePrice.clear();

                          });
                        }),
                        SizedBox(width: SizeConfig.width20,),
                        Text("Sales ",
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
                      controller: qn.saleWeight,
                      decoration: InputDecoration(
                          border:  OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF367BF5))
                          ),
                          labelText: "Enter Material Weight"
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
                      controller: qn.salePrice,
                      decoration: InputDecoration(
                          border:  OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF367BF5))
                          ),
                          labelText: "Enter Price"
                      ),
                      keyboardType: TextInputType.number,
                    ),

                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: (){
                      qn.addSaleGridList();

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
          ),
          ProcessMaterialList(),
        ],
      ),
    );
  }
}
