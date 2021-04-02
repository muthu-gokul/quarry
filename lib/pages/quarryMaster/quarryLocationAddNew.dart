import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/autocompleteText.dart';
import 'package:quarry/widgets/customTextField.dart';

import '../qLocMaterials.dart';
import '../qLocPAyment.dart';

class QuarryLocationAddNew extends StatefulWidget {
  @override
  _QuarryLocationAddNewState createState() => _QuarryLocationAddNewState();
}

class _QuarryLocationAddNewState extends State<QuarryLocationAddNew> with TickerProviderStateMixin{

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

  // @override
  // void initState() {
  //   Provider.of<QuarryNotifier>(context,listen:false).animationController= AnimationController(vsync: this, duration: Duration(milliseconds: 1000),);
  //   Provider.of<QuarryNotifier>(context,listen:false).animation = CurvedAnimation(parent: Provider.of<QuarryNotifier>(context,listen:false).animationController,
  //     curve: Curves.easeIn,);
  //   super.initState();
  // }


  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.black
      ),
      child: SafeArea(
        child: Scaffold(
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
                                Navigator.pop(context);
                                 qn.updateOLSelectedTab(0);
                                 qn.updatePageViewController(0);
                              }),

                              Text("Quarry Master ",
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
                                left: qn.position,
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

                                        qn.updateOLSelectedTab(0);
                                        qn.updatePageViewController(0);


                                    },
                                    child: Container(
                                      height: SizeConfig.height90,
                                      width: SizeConfig.width90,
                                      child: Center(
                                        child: Image.asset(qn.QLSelectedTab==0?"assets/images/quarry-location-icon-white.png":
                                        "assets/images/quarry-location-icon.png"),
                                        // child: Image.asset(
                                        // "assets/images/quarry-location-icon.png"),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap:(){
                                      // setState(() {
                                      //   position=SizeConfig.width100;
                                      // });

                                        qn.updateOLSelectedTab(1);
                                        qn.updatePageViewController(1);


                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(left: SizeConfig.width10,right: SizeConfig.width5),
                                      height: SizeConfig.height90,
                                      width: SizeConfig.width90,
                                      child: Center(
                                        child: Image.asset(qn.QLSelectedTab==1?"assets/images/quarry-contact-icon-white.png":
                                        "assets/images/quarry-contact-icon.png"),
                                        // child: Image.asset(
                                        // "assets/images/quarry-contact-icon.png"),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap:(){
                                      // setState(() {
                                      //   position=((SizeConfig.width90)*2)+SizeConfig.width20;
                                      // });

                                        qn.updateOLSelectedTab(2);
                                        qn.updatePageViewController(2);

                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(left: SizeConfig.width5,right: SizeConfig.width5),
                                      height: SizeConfig.height90,
                                      width: SizeConfig.width90,
                                      child: Center(
                                        child: Image.asset(qn.QLSelectedTab==2?"assets/images/quarry-info-icon-white.png":
                                        "assets/images/quarry-info-icon.png"),
                                        // child: Image.asset(
                                        // "assets/images/quarry-info-icon.png"),
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
                            controller: qn.QLAddnewController,
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
                                        controller: qn.quarryname,
                                        decoration: InputDecoration(
                                            border:  OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.grey)
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Color(0xFF367BF5))
                                            ),
                                            labelText: "Quarry Name"
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
                                        controller: qn.location,

                                        decoration: new InputDecoration(

                                          border:  OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.grey)
                                          ),
                                          labelText: "Enter Quarry Location",

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
                                    Container(
                                      margin: EdgeInsets.all(SizeConfig.width10),
                                      height: SizeConfig.height50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),

                                      ),
                                      child:  TextFormField(
                                        scrollPadding: EdgeInsets.only(bottom: 100),
                                        decoration: InputDecoration(
                                            border:  OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.grey)
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Color(0xFF367BF5))
                                            ),
                                            labelText: "Address"
                                        ),
                                      ),

                                    ),
                                    Container(
                                      margin: EdgeInsets.all(SizeConfig.width10),
                                      padding: EdgeInsets.all(SizeConfig.width10),
                                      height: SizeConfig.height50,
                                      width: SizeConfig.screenWidth,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          border: Border.all(color: Colors.grey)
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          hint: Text("Select State", style: TextStyle( fontFamily: 'RR', color: Colors.grey,fontSize: 16)),
                                          value: selectedState,
                                          icon: Icon(
                                            Icons.keyboard_arrow_down_outlined,
                                            color: Colors.grey,
                                          ),
                                          dropdownColor: Colors.grey[200],
                                          items: stateList.map((String value) {
                                            return new DropdownMenuItem<String>(
                                              value: value,
                                              child: new Text(
                                                  value,
                                                  style: TextStyle( fontFamily: 'RR', color: Colors.black,fontSize: 16)
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (v) {
                                            setState(() {
                                              selectedState = v;
                                            });
                                          },
                                        ),
                                      ),

                                    ),
                                    Container(
                                      margin: EdgeInsets.all(SizeConfig.width10),
                                      padding: EdgeInsets.all(SizeConfig.width10),
                                      height: SizeConfig.height50,
                                      width: SizeConfig.screenWidth,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          border: Border.all(color: Colors.grey)
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          hint: Text("Select District", style: TextStyle( fontFamily: 'RR', color: Colors.grey,fontSize: 16)),
                                          value: selectedDistrict,
                                          icon: Icon(
                                            Icons.keyboard_arrow_down_outlined,
                                            color: Colors.grey,
                                          ),
                                          dropdownColor: Colors.grey[200],
                                          items: districtList.map((String value) {
                                            return new DropdownMenuItem<String>(
                                              value: value,
                                              child: new Text(
                                                  value,
                                                  style: TextStyle( fontFamily: 'RR', color: Colors.black,fontSize: 16)
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (v) {
                                            setState(() {
                                              selectedDistrict = v;
                                            });
                                          },
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
                                        scrollPadding: EdgeInsets.only(bottom: 100),
                                        decoration: InputDecoration(
                                            border:  OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.grey)
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Color(0xFF367BF5))
                                            ),
                                            labelText: "Zipcode"
                                        ),
                                        keyboardType: TextInputType.number,
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
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        // border: Border.all(color: Colors.grey)
                                      ),
                                      child: TextFormField(
                                        controller: qn.quarryInCharge,
                                        decoration: InputDecoration(
                                            border:  OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.grey)
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Color(0xFF367BF5))
                                            ),
                                            labelText: "In Charge Person"
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
                                        controller: qn.contactNo,

                                        decoration: InputDecoration(
                                            border:  OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.grey)
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Color(0xFF367BF5))
                                            ),
                                            labelText: "Contact Number"
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
                                        controller: qn.email,

                                        decoration: InputDecoration(
                                            border:  OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.grey)
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Color(0xFF367BF5))
                                            ),
                                            labelText: "Email Id"
                                        ),
                                        keyboardType: TextInputType.emailAddress,
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
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        // border: Border.all(color: Colors.grey)
                                      ),
                                      child: TextFormField(
                                        controller: qn.quarrySize,

                                        decoration: InputDecoration(
                                            border:  OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.grey)
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Color(0xFF367BF5))
                                            ),
                                            labelText: "Quarry Size"
                                        ),

                                      ),

                                    ),
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
                                              "Select Available Payment Method",
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
                                              "Vehicle Allowed",
                                              style: TextStyle(fontSize: 16,fontFamily: 'RR',color: Colors.grey),),
                                            Spacer(),
                                            Icon(Icons.arrow_forward_ios,color: Colors.grey,)
                                          ],
                                        ),

                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.all(SizeConfig.width10),
                                      padding: EdgeInsets.all(SizeConfig.width10),
                                      height: SizeConfig.height50,
                                      width: SizeConfig.screenWidth,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          border: Border.all(color: Colors.grey)
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          hint: Text("Select Gate Numbers", style: TextStyle( fontFamily: 'RR', color: Colors.grey,fontSize: 16)),
                                          value: qn.selectedGateNo,
                                          icon: Icon(
                                            Icons.keyboard_arrow_down_outlined,
                                            color: Colors.grey,
                                          ),
                                          dropdownColor: Colors.grey[200],
                                          items: GateNoList.map((String value) {
                                            return new DropdownMenuItem<String>(
                                              value: value,
                                              child: new Text(
                                                  value,
                                                  style: TextStyle( fontFamily: 'RR', color: Colors.black,fontSize: 16)
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (v) {
                                            setState(() {
                                              qn.selectedGateNo = v;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: (){
                                            qn.updateQLMaterials(true);
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
                                              "Selected Materials",
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
                            ],
                          ),
                        ),


                        Align(
                          alignment: Alignment.bottomRight,
                          child:qn.QLSelectedTab!=2? InkWell(
                            onTap: (){
                                 qn.updateOLSelectedTab(qn.QLSelectedTab+1);
                                qn.updatePageViewController(qn.QLSelectedTab);
                            },
                            child: Text("Next            ",
                            style: TextStyle(fontFamily: 'RR',fontSize: 20),),
                          ):InkWell(
                            onTap: (){
                               qn.addQLList();
                            },
                            child: Text("Done            ",
                              style: TextStyle(fontFamily: 'RR',fontSize: 20),),
                          ),
                        )






                      ],
                    ),
                  ),
                  QLOCPayment(),
                  QLOCMaterials(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}



class QuaryAddNew extends StatefulWidget {
  VoidCallback drawerCallback;
  QuaryAddNew({this.drawerCallback});
  @override
  _QuaryAddNewState createState() => _QuaryAddNewState();
}

class _QuaryAddNewState extends State<QuaryAddNew> with TickerProviderStateMixin{

  bool isEdit=false;

  @override
  void initState() {
    isEdit=false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: AppTheme.yellowColor
         ),
          child: SafeArea(
            child: Consumer<QuarryNotifier>(
                 builder: (context,qn,child)=> SingleChildScrollView(
                   child: Stack(
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
                               child: Column(
                                 mainAxisAlignment: MainAxisAlignment.start,
                                 children: [
                                   Row(
                                     children: [
                                       IconButton(icon: Icon(Icons.menu), onPressed: widget.drawerCallback),
                                       SizedBox(width: SizeConfig.width5,),
                                       Text("Company Detail",
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
                                    color: Colors.white,
                               child: SingleChildScrollView(
                                 child: Column(
                                   children: [
                                     AddNewLabelTextField(
                                       labelText: 'Quarry Name',
                                       isEnabled: isEdit,
                                       textEditingController: qn.CD_quarryname,
                                       maxLines: 2,


                                     ),
                                     AddNewLabelTextField(
                                       labelText: 'Contact Number',
                                       isEnabled: isEdit,
                                       textInputType: TextInputType.number,
                                       textEditingController: qn.CD_contactNo,
                                     ),
                                     AddNewLabelTextField(
                                       labelText: 'Address',
                                       isEnabled: isEdit,
                                       maxLines: 3,
                                       textInputType: TextInputType.text,
                                       scrollPadding: 200,
                                       textEditingController: qn.CD_address,
                                     ),
                                     AddNewLabelTextField(
                                       labelText: 'City',
                                       isEnabled: isEdit,
                                       scrollPadding: 200,
                                       textEditingController: qn.CD_city,
                                     ),
                                     AddNewLabelTextField(
                                       labelText: 'State',
                                       isEnabled: isEdit,
                                       scrollPadding: 200,
                                       textEditingController: qn.CD_state,
                                     ),
                                     AddNewLabelTextField(
                                       labelText: 'ZipCode',
                                       isEnabled: isEdit,
                                       textInputType: TextInputType.number,
                                       scrollPadding: 200,
                                       textEditingController: qn.CD_zipcode,
                                     ),
                                     AddNewLabelTextField(
                                       labelText: 'GST No',
                                       isEnabled: isEdit,
                                       scrollPadding: 200,
                                       textEditingController: qn.CD_gstno,
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
                                     if(isEdit){
                                       setState(() {
                                         isEdit=false;
                                       });
                                       qn.UpdateQuarryDetailDbhit(context);
                                     }
                                     else{
                                       setState(() {
                                         isEdit=true;
                                       });
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
                                       child: Text(!isEdit?"Edit":"Update",style: AppTheme.TSWhite20,),
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
                         child:CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppTheme.yellowColor),),
                         //Image.asset("assets/images/Loader.gif",filterQuality: FilterQuality.high,gaplessPlayback: true,isAntiAlias: true,)

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

