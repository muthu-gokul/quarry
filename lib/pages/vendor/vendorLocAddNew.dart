import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/autocompleteText.dart';

class VendorAddNew extends StatefulWidget {
  @override
  _VendorAddNewState createState() => _VendorAddNewState();
}

class _VendorAddNewState extends State<VendorAddNew> with TickerProviderStateMixin{

  String currentText = "";
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();

  List<String> suggestions = ["Chennai", "Coimbatore", "Chidambaram", "Theni", "Thirunelveli", "Hosur", "Krishnagiri",
    "Dharmapuri", "Dindigul", "Kanyakumari", "NagerCoil", "Madurai", "Salem"
  ];
  String selectedState;
  List<String> stateList=["Tamilnadu","Karntaka","Kerala","Karnataka","Madhya Pradesh","Delhi","Kolkata","Punjab"];

  String selectedDistrict;
  List<String> districtList=["Thiruvallur","Theni","Vellore","Chennai","Madurai","Bangalore","Pondicherry","Thiruvandapuram",   "Hosur",
    "Krishnagiri", "Dharmapuri", "Dindigul", "Kanyakumari", "NagerCoil", "Salem"];


  List<String> GateNoList=["1","2","3","4","5","6","7","8", "9","10"];
  @override
  Widget build(BuildContext context) {
    return Consumer<QuarryNotifier>(
      builder: (context,qn,child)=> Container(
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
                      qn.updateQVendorAddNew(false);
                      Timer(Duration(milliseconds: 300), (){
                        qn.updateVendorAddNewHW(false);
                        qn.updateVendorSelectedTab(0);
                        qn.updateVendorPageViewController(0);
                      });
                    }),
                    SizedBox(width: SizeConfig.width20,),
                    Text("Vendor Master ",
                      style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize: SizeConfig.width16),
                    ),
                    Text("/ Add New",
                      style: TextStyle(fontFamily: 'RR',color: Color(0xFF367BF5),fontSize: SizeConfig.width16),
                    ),
                  ],
                ),
              ),

              Container(
                height: SizeConfig.height100,
                width: SizeConfig.screenWidth,
                margin: EdgeInsets.all(SizeConfig.width10),
                child: Stack(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: SizeConfig.height90,
                          width: SizeConfig.width90,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.grey)
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.only(left: SizeConfig.width10,right: SizeConfig.width5),
                          height: SizeConfig.height90,
                          width: SizeConfig.width90,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.grey)
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: SizeConfig.width5,right: SizeConfig.width5),
                          height: SizeConfig.height90,
                          width: SizeConfig.width90,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.grey)
                          ),
                        ),

                      ],
                    ),
                    AnimatedPositioned(
                      left: qn.Vendorposition,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                      child: Container(
                        height: SizeConfig.height90,
                        width: SizeConfig.width90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.grey),
                          color: Color(0xFF367BF5),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF367BF5).withOpacity(0.4),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(1, 8), // changes position of shadow
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap:(){
                            // setState(() {
                            //   position=0;
                            // });

                            qn.updateVendorSelectedTab(0);
                            qn.updateVendorPageViewController(0);


                          },
                          child: Container(
                            height: SizeConfig.height90,
                            width: SizeConfig.width90,
                            child: Center(
                              child: Image.asset(qn.VendorSelectedTab==0?"assets/images/vendor-location-icon-white.png":
                              "assets/images/vendor-location-icon.png"),
                              // child: Image.asset(
                              //     "assets/images/vendor-location-icon.png"),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap:(){
                            // setState(() {
                            //   position=SizeConfig.width100;
                            // });

                            qn.updateVendorSelectedTab(1);
                            qn.updateVendorPageViewController(1);


                          },
                          child: Container(
                            margin: EdgeInsets.only(left: SizeConfig.width10,right: SizeConfig.width5),
                            height: SizeConfig.height90,
                            width: SizeConfig.width90,
                            child: Center(
                              child: Image.asset(qn.VendorSelectedTab==1?"assets/images/vendor-payment-white.png":
                              "assets/images/vendor-payment.png"),
                              // child: Image.asset(
                              //     "assets/images/vendor-payment.png"),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap:(){
                            // setState(() {
                            //   position=((SizeConfig.width90)*2)+SizeConfig.width20;
                            // });

                            qn.updateVendorSelectedTab(2);
                            qn.updateVendorPageViewController(2);

                          },
                          child: Container(
                            margin: EdgeInsets.only(left: SizeConfig.width5,right: SizeConfig.width5),
                            height: SizeConfig.height90,
                            width: SizeConfig.width90,
                            child: Center(
                              child: Image.asset(qn.VendorSelectedTab==2?"assets/images/vendor-Materialt-white.png":
                              "assets/images/vendor-Materialt.png"),
                              // child: Image.asset(
                              //     "assets/images/vendor-Materialt.png"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Container(
                height: SizeConfig.screenHeight-SizeConfig.height250,
                width: SizeConfig.screenWidth,
                child: PageView(
                  controller: qn.VendorAddnewController,
                  scrollDirection: Axis.horizontal,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    Container(
                      height: SizeConfig.screenHeight-SizeConfig.height250,
                      width: SizeConfig.screenWidth,
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.all(SizeConfig.width10),
                            height: SizeConfig.height50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              // border: Border.all(color: Colors.grey)
                            ),
                            child: TextFormField(
                               controller: qn.vendorId,
                              decoration: InputDecoration(
                                  border:  OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey)
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFF367BF5))
                                  ),
                                  labelText: "Vendor Id"
                              ),
                            ),

                          ),
                          Container(
                            margin: EdgeInsets.all(SizeConfig.width10),
                            height: SizeConfig.height50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),

                            ),
                            child:  TextFormField(
                              controller: qn.vendorName,
                              scrollPadding: EdgeInsets.only(bottom: 200),
                              decoration: InputDecoration(
                                  border:  OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey)
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFF367BF5))
                                  ),
                                  labelText: "Enter Vendor Name"
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
                            child: SimpleAutoCompleteTextField(
                              key: key,
                              controller: qn.vendorlocation,

                              decoration: new InputDecoration(

                                border:  OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)
                                ),
                                labelText: "Enter Vendor Location",

                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFF367BF5))
                                ),
                              ),


                              suggestions: suggestions,
                              textChanged: (text) => currentText = text,
                              clearOnSubmit: false,
                              textSubmitted: (text) => setState(() {

                                // if (text != "") {
                                //   added.add(text);
                                // }
                              }),
                            ),

                          ),
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: (){

                            },
                            child: Container(
                              margin: EdgeInsets.all(SizeConfig.width10),
                              padding: EdgeInsets.all(SizeConfig.width10),
                              height: SizeConfig.height50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Colors.grey)
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    "Permanent Address",
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

                            },
                            child: Container(
                              margin: EdgeInsets.all(SizeConfig.width10),
                              padding: EdgeInsets.all(SizeConfig.width10),
                              height: SizeConfig.height50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Colors.grey)
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    "Shipping Address",
                                    style: TextStyle(fontSize: 16,fontFamily: 'RR',color: Colors.grey),),
                                  Spacer(),
                                  Icon(Icons.arrow_forward_ios,color: Colors.grey,)
                                ],
                              ),

                            ),
                          ),




                        ],
                      ),
                    ),
                    Container(
                      height: SizeConfig.screenHeight-SizeConfig.height250,
                      width: SizeConfig.screenWidth,
                      child: Column(
                        children: [
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: (){
                              qn.updateQLOCPayment(true);
                            },
                            child: Container(
                              margin: EdgeInsets.all(SizeConfig.width10),
                              padding: EdgeInsets.all(SizeConfig.width10),
                              height: SizeConfig.height50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Colors.grey)
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    "Select Payment Mode",
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
                              controller: qn.vendorPaymentTerms,
                              decoration: InputDecoration(
                                  border:  OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey)
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFF367BF5))
                                  ),
                                  labelText: "Enter Payment Terms"
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
                              controller: qn.vendorContactNo,
                              decoration: InputDecoration(
                                  border:  OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey)
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFF367BF5))
                                  ),
                                  labelText: "Vendor Contact Number"
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


                              decoration: InputDecoration(
                                  border:  OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey)
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFF367BF5))
                                  ),
                                  labelText: "Vendor Email Id"
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),

                          ),
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: (){

                            },
                            child: Container(
                              margin: EdgeInsets.all(SizeConfig.width10),
                              padding: EdgeInsets.all(SizeConfig.width10),
                              height: SizeConfig.height50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Colors.grey)
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    "Vendor Account Information",
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

                            },
                            child: Container(
                              margin: EdgeInsets.all(SizeConfig.width10),
                              padding: EdgeInsets.all(SizeConfig.width10),
                              height: SizeConfig.height50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Colors.grey)
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    "Other Information",
                                    style: TextStyle(fontSize: 16,fontFamily: 'RR',color: Colors.grey),),
                                  Spacer(),
                                  Icon(Icons.arrow_forward_ios,color: Colors.grey,)
                                ],
                              ),

                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: SizeConfig.screenHeight-SizeConfig.height250,
                      width: SizeConfig.screenWidth,
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.all(SizeConfig.width10),
                            height: SizeConfig.height50,
                            width: SizeConfig.screenWidth,
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                               border: Border.all(color: Colors.grey),
                              color: Color(0xFFF2F4F9)
                            ),
                            child: Text("   Material Names",style: TextStyle(fontFamily: 'RR',fontSize: 16),),

                          ),

                          SizedBox(height: SizeConfig.height20,),
                          Wrap(

                            children: qn.materialsList.asMap().map((i, element) => MapEntry(i, GestureDetector(
                              onTap: (){
                                if(qn.materialsSelected.contains(i)){
                                  setState(() {
                                    qn.materialsSelected.remove(i);
                                  });
                                }else{
                                  setState(() {
                                    qn.materialsSelected.add(i);
                                  });
                                }

                              },
                              child: Container(
                                height: SizeConfig.height50,
                                margin: EdgeInsets.all(SizeConfig.width5),
                                padding: EdgeInsets.all(SizeConfig.width10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: Colors.grey),
                                    color: qn.materialsSelected.contains(i)?Color(0xFF367BF5):Colors.transparent
                                ),
                                child: Text(qn.materialsList[i],
                                  style: TextStyle(fontFamily: 'RR',fontSize:SizeConfig.width16,color: qn.materialsSelected.contains(i)?Colors.white:Colors.grey),),
                              ),
                            )
                            )
                            ).values.toList(),
                          ),
                          SizedBox(height: SizeConfig.height20,),
                          InkWell(
                            onTap: (){

                            },
                            child: Text("+ Add New Materials",
                              style: TextStyle(fontFamily: 'RR',fontSize:SizeConfig.width16,color:Color(0xFF367BF5)),),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),


              Align(
                alignment: Alignment.bottomRight,
                child:qn.VendorSelectedTab!=2? InkWell(
                  onTap: (){
                    qn.updateVendorSelectedTab(qn.VendorSelectedTab+1);
                    qn.updateVendorPageViewController(qn.VendorSelectedTab);
                  },
                  child: Text("Next            ",
                    style: TextStyle(fontFamily: 'RR',fontSize: 20),),
                ):InkWell(
                  onTap: (){
                    qn.addVendorGrid();
                  },
                  child: Text("Done            ",
                    style: TextStyle(fontFamily: 'RR',fontSize: 20),),
                ),
              )






            ],
          ),
        ),
      ),
    );
  }
}
