
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quarry/model/plantDetailsModel/plantLicenseModel.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/pages/sale/salesDetail.dart';
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/constants.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/bottomBarAddButton.dart';
import 'package:quarry/widgets/customTextField.dart';
import 'package:quarry/widgets/dateRangePicker.dart' as DateRagePicker;
import 'package:quarry/widgets/sidePopUp/sidePopUpWithoutSearch.dart';
import 'package:quarry/widgets/validationErrorText.dart';





class PlantDetailsAddNew extends StatefulWidget {
  VoidCallback? drawerCallback;
  PlantDetailsAddNew({this.drawerCallback});
  @override
  PlantDetailsAddNewState createState() => PlantDetailsAddNewState();
}

class PlantDetailsAddNewState extends State<PlantDetailsAddNew> with TickerProviderStateMixin{

  bool isEdit=false;


  ScrollController? scrollController;
  ScrollController? listViewController;
  bool _keyboardVisible = false;
  bool isListScroll=false;
  bool plantTypeOpen=false;
  DateTime firstDate=DateTime.parse('1950-01-01');
  DateTime lastDate=DateTime.parse('2121-01-01');


  bool emailValid=true;
  bool plantName=false;
  bool plantType=false;
  bool contactNo=false;
  bool address=false;



  @override
  void initState() {

    WidgetsBinding.instance!.addPostFrameCallback((_){


      scrollController=new ScrollController();
      listViewController=new ScrollController();
      setState(() {
       if(Provider.of<QuarryNotifier>(context,listen: false).isPlantDetailsEdit){
         isEdit=false;
       }
       else{
         isEdit=true;
       }
      });




    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final node=FocusScope.of(context);
    //_keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    SizeConfig().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Consumer<QuarryNotifier>(
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
                      GestureDetector(
                        onVerticalDragUpdate: (details){

                          int sensitivity = 5;
                          if (details.delta.dy > sensitivity) {
                            scrollController!.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn).then((value){
                              if(isListScroll){
                                setState(() {
                                  isListScroll=false;
                                });
                              }
                            });

                          } else if(details.delta.dy < -sensitivity){
                            scrollController!.animateTo(100, duration: Duration(milliseconds: 300), curve: Curves.easeIn).then((value){

                              if(!isListScroll){
                                setState(() {
                                  isListScroll=true;
                                });
                              }
                            });
                          }
                        },
                        child: Container(
                          height: SizeConfig.screenHeight!-60,
                          width: SizeConfig.screenWidth,
                          decoration: BoxDecoration(
                              color: AppTheme.gridbodyBgColor,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                          ),
                          child: NotificationListener<ScrollNotification>(
                            onNotification: (s){
                              if(s is ScrollStartNotification){

                                if(listViewController!.offset==0 && isListScroll && scrollController!.offset==100 && listViewController!.position.userScrollDirection==ScrollDirection.idle){

                                  Timer(Duration(milliseconds: 100), (){
                                    if(listViewController!.position.userScrollDirection!=ScrollDirection.reverse){

                                      //if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
                                      if(listViewController!.offset==0){

                                        scrollController!.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn).then((value) {
                                          if(isListScroll){
                                            setState(() {
                                              isListScroll=false;
                                            });
                                          }
                                        });
                                      }

                                    }
                                  });
                                }
                              }
                              return true;
                            } ,
                            child: ListView(
                              controller: listViewController,
                              scrollDirection: Axis.vertical,
                              physics: isListScroll?AlwaysScrollableScrollPhysics():NeverScrollableScrollPhysics(),
                              children: [

                                AddNewLabelTextField(
                                  labelText: 'Plant Name',
                                  isEnabled: isEdit,
                                  regExp: '[A-Za-z  ]',
                                  textEditingController: qn.PD_quarryname,
                                  onEditComplete: (){
                                    node.unfocus();
                                    setState(() {
                                      _keyboardVisible=false;
                                    });
                                  },
                                  onChange: (v){},
                                  ontap: (){
                                    scrollController!.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                    setState(() {
                                      _keyboardVisible=true;
                                    });
                                  },
                                ),
                                !plantName?Container():ValidationErrorText(title: "* Enter Plant Name",),
                                AddNewLabelTextField(
                                  labelText: 'Address',
                                  isEnabled: isEdit,
                                  regExp: addressReg,
                                  onEditComplete: (){
                                    node.unfocus();
                                    setState(() {
                                      _keyboardVisible=false;
                                    });
                                  },
                                  onChange: (v){},
                                  ontap: (){
                                    scrollController!.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                    setState(() {
                                      _keyboardVisible=true;
                                      setState(() {
                                        _keyboardVisible=false;
                                      });
                                    });
                                  },
                                  textInputType: TextInputType.text,
                                  scrollPadding: 200,
                                  textEditingController: qn.PD_address,
                                ),
                                !address?Container():ValidationErrorText(title: "* Enter Address",),
                                AddNewLabelTextField(
                                  labelText: 'City',
                                  regExp: '[A-Za-z  ]',
                                  isEnabled: isEdit,
                                  scrollPadding: 200,
                                  textEditingController: qn.PD_city,
                                  onEditComplete: (){
                                    node.unfocus();
                                    setState(() {
                                      _keyboardVisible=false;
                                    });
                                  },
                                  onChange: (v){},
                                  ontap: (){
                                    scrollController!.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                    setState(() {
                                      _keyboardVisible=true;
                                    });
                                  },
                                ),
                                AddNewLabelTextField(
                                  labelText: 'State',
                                  isEnabled: isEdit,
                                  regExp: '[A-Za-z  ]',
                                  scrollPadding: 200,
                                  textEditingController: qn.PD_state,
                                  onEditComplete: (){
                                    node.unfocus();
                                    setState(() {
                                      _keyboardVisible=false;
                                    });
                                  },
                                  onChange: (v){},
                                  ontap: (){
                                    scrollController!.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                    setState(() {
                                      _keyboardVisible=true;
                                    });
                                  },
                                ),
                                AddNewLabelTextField(
                                  labelText: 'Country',
                                  isEnabled: isEdit,
                                  regExp: '[A-Za-z  ]',
                                  scrollPadding: 400,
                                  textEditingController: qn.PD_country,
                                  onEditComplete: (){
                                    node.unfocus();
                                    setState(() {
                                      _keyboardVisible=false;
                                    });
                                  },
                                  onChange: (v){},
                                  ontap: (){
                                    scrollController!.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                    setState(() {
                                      _keyboardVisible=true;
                                      isListScroll=true;
                                    });
                                  },
                                ),
                                AddNewLabelTextField(
                                  labelText: 'ZipCode',
                                  isEnabled: isEdit,
                                  regExp: '[0-9]',
                                  textLength: 6,
                                  textInputType: TextInputType.number,
                                  scrollPadding: 400,
                                  textEditingController: qn.PD_zipcode,
                                  onEditComplete: (){
                                    node.unfocus();
                                    setState(() {
                                      _keyboardVisible=false;
                                    });
                                  },
                                  onChange: (v){},
                                  ontap: (){
                                    scrollController!.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                    setState(() {
                                      _keyboardVisible=true;
                                      isListScroll=true;
                                    });
                                  },
                                ),
                                AddNewLabelTextField(
                                  labelText: 'Contact Number',
                                  isEnabled: isEdit,
                                  regExp: '[0-9]',
                                  textLength: 10,
                                  scrollPadding: 400,
                                  textInputType: TextInputType.number,
                                  textEditingController: qn.PD_contactNo,
                                  onEditComplete: (){
                                    node.unfocus();
                                    setState(() {
                                      _keyboardVisible=false;
                                    });
                                  },
                                  onChange: (v){},
                                  ontap: (){
                                    scrollController!.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                    setState(() {
                                      _keyboardVisible=true;
                                      isListScroll=true;
                                    });
                                  },
                                ),
                                !contactNo?Container():ValidationErrorText(title: "* Enter Contact Number",),
                                AddNewLabelTextField(
                                  labelText: 'Email',
                                  isEnabled: isEdit,
                                  textInputType: TextInputType.emailAddress,
                                  textEditingController: qn.PD_email,
                                  scrollPadding: 400,
                                  onEditComplete: (){
                                    node.unfocus();
                                    setState(() {
                                      _keyboardVisible=false;
                                    });
                                  },
                                  onChange: (v){},
                                  ontap: (){
                                    scrollController!.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                    setState(() {
                                      _keyboardVisible=true;
                                      isListScroll=true;
                                    });
                                  },
                                ),
                                emailValid?Container():ValidationErrorText(title: "* Invalid Email Address",),
                                GestureDetector(
                                  onTap: (){
                                    node.unfocus();
                                    if(isEdit){
                                      setState(() {
                                        plantTypeOpen=true;
                                      });
                                    }


                                  },
                                  child: SidePopUpParent(
                                    text: qn.PD_plantTypeName==null? "Select Plant Type":qn.PD_plantTypeName,
                                    textColor: qn.PD_plantTypeName==null? AppTheme.addNewTextFieldText.withOpacity(0.5):AppTheme.addNewTextFieldText,
                                    iconColor: qn.PD_plantTypeName==null? AppTheme.addNewTextFieldText:AppTheme.yellowColor,
                                    bgColor:!isEdit?AppTheme.disableColor: qn.PD_plantTypeName==null? AppTheme.disableColor:Colors.white,
                                  ),
                                ),
                                !plantType?Container():ValidationErrorText(title: "* Select Plant Type",),
                                AddNewLabelTextField(
                                  labelText: 'Contact Person Name',
                                  isEnabled: isEdit,
                                  regExp: '[A-Za-z  ]',
                                  scrollPadding: 400,
                                  textEditingController: qn.PD_ContactPersonName,
                                  onEditComplete: (){
                                    node.unfocus();
                                    setState(() {
                                      _keyboardVisible=false;
                                    });
                                  },
                                  onChange: (v){},
                                  ontap: (){
                                    scrollController!.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                    setState(() {
                                      _keyboardVisible=true;
                                      isListScroll=true;
                                    });
                                  },
                                ),
                                AddNewLabelTextField(
                                  labelText: 'Designation',
                                  isEnabled: isEdit,
                                  scrollPadding: 400,
                                  textEditingController: qn.PD_Designation,
                                  onEditComplete: (){
                                    node.unfocus();
                                    setState(() {
                                      _keyboardVisible=false;
                                    });
                                  },
                                  onChange: (v){},
                                  ontap: (){
                                    scrollController!.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                    setState(() {
                                      _keyboardVisible=true;
                                      isListScroll=true;
                                    });
                                  },
                                ),

////////////////////////////////////  LICENSE LIST ///////////////////////

                                Container(
                                  //  duration: Duration(milliseconds: 300),
                                  // curve: Curves.easeIn,
                                  height: qn.PO_PlantLicenseList.length == 0 ? 0 :
                                  ( qn.PO_PlantLicenseList.length * 60.0)+40,
                                  constraints: BoxConstraints(
                                      maxHeight: 300
                                  ),
                                  //  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),

                                  width: SizeConfig.screenWidth,

                                  margin: EdgeInsets.only(
                                    left: SizeConfig.width20!,
                                    right: SizeConfig.width20!,
                                    top: SizeConfig.height20!,),
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: AppTheme.addNewTextFieldBorder)
                                    /*  boxShadow: [
                                            qn.productionMaterialMappingList.length == 0 ? BoxShadow() :
                                            BoxShadow(
                                              color: AppTheme.addNewTextFieldText
                                                  .withOpacity(0.2),
                                              spreadRadius: 2,
                                              blurRadius: 15,
                                              offset: Offset(0, 0), // changes position of shadow
                                            )
                                          ]*/
                                  ),
                                  child: Column(
                                    children: [

                                      Container(
                                        height: 40,
                                        width: SizeConfig.screenWidth,
                                        padding: EdgeInsets.only(left: 10,right: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(5),topRight: Radius.circular(5),),

                                          /* border: Border(
                                                    bottom: BorderSide(color: AppTheme.addNewTextFieldBorder.withOpacity(0.5))
                                                )*/
                                        ),
                                        child: Row(
                                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(width: SizeConfig.screenWidthM40!*0.30,child: Text("License Number")),
                                            Container(padding: EdgeInsets.only(left: 10),alignment: Alignment.centerLeft, width: SizeConfig.screenWidthM40!*0.29,child: Text("License Name")),
                                            Container(padding: EdgeInsets.only(left: 10), width: SizeConfig.screenWidthM40!*0.25,child: Text("Date")),

                                          ],

                                        ),
                                      ),

                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: qn.PO_PlantLicenseList.length,
                                          itemBuilder: (context, index) {
                                            return SlideTransition(
                                              position: Tween<Offset>(begin: Offset(qn.PO_PlantLicenseList[index].isEdit! ? 0.0 :
                                              qn.PO_PlantLicenseList[index].isDelete! ?1.0:0.0,
                                                  qn.PO_PlantLicenseList[index].isEdit! ? 0.0 :qn.PO_PlantLicenseList[index].isDelete! ?0.0: 1.0),
                                                  end:qn.PO_PlantLicenseList[index].isEdit! ?Offset(1, 0): Offset.zero)
                                                  .animate(qn.PO_PlantLicenseList[index].scaleController!),

                                              child: FadeTransition(
                                                opacity: Tween(begin: qn.PO_PlantLicenseList[index].isEdit! ? 1.0 : 0.0,
                                                    end: qn.PO_PlantLicenseList[index].isEdit! ? 0.0 : 1.0)
                                                    .animate(qn.PO_PlantLicenseList[index].scaleController!),
                                                child: Container(
                                                  padding: EdgeInsets.only(top: 5, bottom: 5,left: 10,right: 10),
                                                  decoration: BoxDecoration(
                                                      border: Border(
                                                          bottom: BorderSide(color: AppTheme.addNewTextFieldBorder.withOpacity(0.5))
                                                      )
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [

                                                          Container(
                                                            width: SizeConfig.screenWidthM40!*0.30,
                                                            alignment:Alignment.centerLeft,

                                                            child: Text("${qn.PO_PlantLicenseList[index].licenseNumber}",
                                                              style: TextStyle(fontSize: 14, fontFamily: 'RR', color: AppTheme.gridTextColor, letterSpacing: 0.2),
                                                            ),
                                                          ),
                                                          Container(
                                                            padding: EdgeInsets.only(left: 10),
                                                            alignment: Alignment.centerLeft,

                                                            width: SizeConfig.screenWidthM40!*0.25,
                                                            child: Text("${qn.PO_PlantLicenseList[index].licenseDescription}",
                                                              style: TextStyle(fontSize: 14, fontFamily: 'RR', color: AppTheme.gridTextColor, letterSpacing: 0.2),
                                                            ),
                                                          ),
                                                          Container(
                                                            alignment: Alignment.centerRight,
                                                            width:SizeConfig.screenWidthM40!*0.26,
                                                            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),

                                                            child: Text("${qn.PO_PlantLicenseList[index].fromDate!=null?DateFormat('dd-MM-yyyy').format(qn.PO_PlantLicenseList[index].fromDate!):""} to \n${qn.PO_PlantLicenseList[index].toDate!=null?DateFormat('dd-MM-yyyy').format(qn.PO_PlantLicenseList[index].toDate!):""}",
                                                              style: TextStyle(fontSize: 10, fontFamily: 'RR', color: AppTheme.gridTextColor,letterSpacing: 0.2),
                                                            ),
                                                          ),
                                                          Spacer(),
                                                          GestureDetector(
                                                            onTap: () {

                                                              CustomAlert(Cancelcallback: (){
                                                                Navigator.pop(context);
                                                              },
                                                              callback: (){
                                                                Navigator.pop(context);
                                                                Timer(Duration(milliseconds: 200), (){
                                                                  if(isEdit){
                                                                    if (qn.PO_PlantLicenseList[index].isEdit!) {
                                                                      qn.PO_PlantLicenseList[index].scaleController!.forward().whenComplete(() {
                                                                        print("EIT");
                                                                        if (this.mounted) {
                                                                          setState(() {
                                                                            qn.PO_PlantLicenseList.removeAt(index);
                                                                          });
                                                                        }
                                                                      });

                                                                    }
                                                                    else {
                                                                      setState(() {
                                                                        qn.PO_PlantLicenseList[index].isDelete=true;
                                                                      });
                                                                      qn.PO_PlantLicenseList[index].scaleController!.reverse().whenComplete(() {
                                                                        if (this.mounted) {

                                                                          setState(() {
                                                                            qn.PO_PlantLicenseList.removeAt(index);
                                                                          });
                                                                        }
                                                                      });
                                                                    }
                                                                  }
                                                                });
                                                              }).yesOrNoDialog(context, "", "Are you sure want to delete this License Details ?");






                                                            },
                                                            child: Container(
                                                                height: 20,
                                                                width: 20,
                                                                child: SvgPicture.asset("assets/svg/delete.svg",color:isEdit? AppTheme.red:AppTheme.red.withOpacity(0.5),)
                                                            ),
                                                          ),

                                                        ],
                                                      ),


                                                    ],
                                                  ),

                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),





                                Container(
                                  width: SizeConfig.screenWidth,
                                  margin: EdgeInsets.only(left:SizeConfig.width20!,right:SizeConfig.width20!,top:SizeConfig.height20!,),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      color: Colors.transparent
                                  ),
                                  child:  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: SizeConfig.screenWidth!*0.42,
                                        child: TextFormField(
                                          enabled: isEdit,
                                          scrollPadding: EdgeInsets.only(bottom: 400),
                                          style:  TextStyle(fontFamily: 'RR',fontSize: 15,color:AppTheme.addNewTextFieldText,letterSpacing: 0.2),
                                          controller: qn.PD_LicenseNo,

                                          decoration: InputDecoration(
                                              fillColor:isEdit?Colors.white: Color(0xFFF2F2F2),
                                              filled: true,
                                              hintStyle: TextStyle(fontFamily: 'RL',fontSize: 14,color: AppTheme.addNewTextFieldText.withOpacity(0.9)),
                                              border:  OutlineInputBorder(
                                                  borderSide: BorderSide(color: AppTheme.addNewTextFieldBorder)
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: AppTheme.addNewTextFieldBorder)
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color:AppTheme.addNewTextFieldFocusBorder)
                                              ),
                                              hintText: "License Number",
                                              contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),




                                          ),
                                          maxLines: null,

                                          textInputAction: TextInputAction.done,

                                          onChanged: (v){

                                          },
                                        ),
                                      ),
                                      Container(
                                        width:SizeConfig.screenWidth!*0.42,
                                        child: TextFormField(
                                          enabled: isEdit,
                                          scrollPadding: EdgeInsets.only(bottom: 100),
                                          style:  TextStyle(fontFamily: 'RR',fontSize: 15,color:AppTheme.addNewTextFieldText,letterSpacing: 0.2),
                                           controller: qn.PD_LicenseDesc,
                                          decoration: InputDecoration(
                                              fillColor:isEdit?Colors.white: Color(0xFFF2F2F2),
                                              filled: true,
                                              hintStyle: TextStyle(fontFamily: 'RL',fontSize: 14,color: AppTheme.addNewTextFieldText.withOpacity(0.9)),
                                              border:  OutlineInputBorder(
                                                  borderSide: BorderSide(color: AppTheme.addNewTextFieldBorder)
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: AppTheme.addNewTextFieldBorder)
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color:AppTheme.addNewTextFieldFocusBorder)
                                              ),
                                              hintText: "License Name",
                                              contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                                            suffixIcon:  GestureDetector(
                                              onTap: () async {
                                                node.unfocus();

                                                final List<DateTime?>?  picked1 = await DateRagePicker.showDatePicker(
                                                    context: context,
                                                    initialFirstDate: new DateTime.now(),
                                                    initialLastDate: new DateTime.now(),
                                                    firstDate: firstDate,
                                                    lastDate: lastDate
                                                );
                                                if (picked1 != null && picked1.length == 2) {
                                                  setState(() {
                                                    qn.PD_fromDate=picked1[0];
                                                    qn.PD_toDate=picked1[1];
                                                  });
                                                }
                                                else if(picked1!=null && picked1.length ==1){
                                                  setState(() {
                                                    qn.PD_fromDate=picked1[0];
                                                    qn.PD_toDate=picked1[0];
                                                    // rn.reportDbHit(widget.UserId.toString(), widget.OutletId, DateFormat("dd-MM-yyyy").format( picked[0]).toString(), DateFormat("dd-MM-yyyy").format( picked[0]).toString(),"Itemwise Report", context);
                                                  });
                                                }
                                              },
                                              child: Container(
                                                height:40,
                                                width:40,

                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  // color:Color(0xFF5E5E60),
                                                ),
                                                child: Center(
                                                  child: Icon(Icons.date_range_rounded),
                                                  // child:  SvgPicture.asset(
                                                  //   'assets/reportIcons/${rn.reportIcons[index]}.svg',
                                                  //   height:25,
                                                  //   width:25,
                                                  //   color: Colors.white,
                                                  // )
                                                ),
                                              ),
                                            ),




                                          ),
                                          maxLines: null,

                                          textInputAction: TextInputAction.done,

                                          onChanged: (v){

                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: SizeConfig.height50,),

                                Container(
                                  height: SizeConfig.height70,
                                  width: SizeConfig.height70,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: AppTheme.uploadColor,width: 2)
                                  ),
                                  child: Center(
                                    child: Icon(Icons.upload_rounded,color: AppTheme.yellowColor,),
                                  ),
                                ),
                                SizedBox(height: SizeConfig.height20,),

                                Align(
                                  alignment: Alignment.center,
                                  child: Text("Upload Your License Document",
                                    style: TextStyle(fontFamily: 'RR',fontSize: 14,color: AppTheme.gridTextColor),
                                  ),
                                ),
                                SizedBox(height: SizeConfig.height10,),

                                GestureDetector(
                                  onTap: (){
                                    if(isEdit){

                                      if(qn.PD_LicenseNo.text.isEmpty){
                                        CustomAlert().commonErrorAlert(context, "Enter License Number", "");
                                      }
                                      else if(qn.PD_LicenseDesc.text.isEmpty){
                                        CustomAlert().commonErrorAlert(context, "Enter License Name", "");
                                      }
                                      else{
                                        setState(() {
                                          qn.PO_PlantLicenseList.add(
                                              PlantLicenseModel(
                                                  plantId: null,
                                                  plantLicenseId: null,
                                                  licenseNumber: qn.PD_LicenseNo.text,
                                                  licenseDescription: qn.PD_LicenseDesc.text,
                                                  fromDate: qn.PD_fromDate,
                                                  toDate: qn.PD_toDate,
                                                  documentFileName: "",
                                                  documentFolderName: "",
                                                  scaleController: AnimationController(duration: Duration(milliseconds: 300), vsync: this),
                                                  isEdit: false,
                                                  isDelete: false
                                              )
                                          );
                                        });
                                        qn.clearPlantLicenseForm();
                                        qn.PO_PlantLicenseList[qn.PO_PlantLicenseList.length-1].scaleController!.forward();
                                      }


                                    }

                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(left: SizeConfig.width90!,right:  SizeConfig.width90!,),
                                    height:45,
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
                                       // child: Text("Choose File",style: TextStyle(color:AppTheme.bgColor,fontSize:16,fontFamily: 'RM'),
                                        child: Text("Add",style: TextStyle(color:AppTheme.bgColor,fontSize:16,fontFamily: 'RM'),
                                        )
                                    ),


                                  ),
                                ),

                                SizedBox(height: SizeConfig.height200,)
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
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
                          size: Size( SizeConfig.screenWidth!, 65),
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
                    if(qn.isPlantDetailsEdit){

                      if(isEdit){

                        setState(() {
                          emailValid=EmailValidation().validateEmail(qn.PD_email.text);
                        });

                        if(qn.PD_quarryname.text.isEmpty){setState(() {plantName=true;});}
                        else{setState(() {plantName=false;});}

                        if(qn.PD_contactNo.text.isEmpty){setState(() {contactNo=true;});}
                        else{setState(() {contactNo=false;});}

                        if(qn.PD_address.text.isEmpty){setState(() {address=true;});}
                        else{setState(() {address=false;});}

                        if(qn.PD_plantTypeName==null){setState(() {plantType=true;});}
                        else{setState(() {plantType=false;});}






                        if(emailValid && !plantName && !contactNo && !plantType && !address){
                          setState(() {
                            isEdit=false;
                          });

                          qn.InsertPlantDetailDbhit(context,this);
                        }

                      }
                      else{
                        setState(() {
                          isEdit=true;
                        });
                      }
                    }
                    else{

                      setState(() {
                        emailValid=EmailValidation().validateEmail(qn.PD_email.text);
                      });

                      if(qn.PD_quarryname.text.isEmpty){setState(() {plantName=true;});}
                      else{setState(() {plantName=false;});}

                      if(qn.PD_contactNo.text.isEmpty){setState(() {contactNo=true;});}
                      else{setState(() {contactNo=false;});}

                      if(qn.PD_address.text.isEmpty){setState(() {address=true;});}
                      else{setState(() {address=false;});}

                      if(qn.PD_plantTypeName==null){setState(() {plantType=true;});}
                      else{setState(() {plantType=false;});}




                      if(emailValid && !plantName && !contactNo && !plantType && !address){
                        qn.InsertPlantDetailDbhit(context,this);
                      }


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
                      child: isEdit?Icon(Icons.done,size: SizeConfig.height30,color: AppTheme.bgColor,):
                      SvgPicture.asset("assets/svg/edit.svg",width: 20,height: 20,),

                    ),
                  ),
                ),
              ),

            /* qn.isPlantDetailsEdit? Positioned(
                bottom: 0,
                child: Container(
                  height:_keyboardVisible?0: SizeConfig.height70,
                  width: SizeConfig.screenWidth,
                  color: AppTheme.grey,
                  child: Center(
                    child: GestureDetector(
                      onTap: (){
                        if(isEdit){
                          setState(() {
                            isEdit=false;
                          });

                              qn.InsertPlantDetailDbhit(context);
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
                ),
              ):
              Positioned(
                bottom: 0,
                child: Container(
                  height:_keyboardVisible?0: SizeConfig.height70,
                  width: SizeConfig.screenWidth,
                  color: AppTheme.grey,
                  child: Center(
                    child: GestureDetector(
                      onTap: (){
                        qn.InsertPlantDetailDbhit(context);
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
                ),
              ),*/

              Container(
                height: SizeConfig.height60,
                width: SizeConfig.screenWidth,
                child: Row(
                  children: [
                    CancelButton(
                      ontap: (){
                        Navigator.pop(context);
                        qn.clearPlantForm();
                      },
                    ),

                    Text("Plant Details",
                      style: TextStyle(fontFamily: 'RR',color: AppTheme.bgColor,fontSize: 16),
                    ),
                    Text(qn.isPlantDetailsEdit?" / Edit":" / Add New",
                      style: TextStyle(fontFamily: 'RR',color:AppTheme.bgColor,fontSize: 16),
                    ),

                  ],
                ),
              ),



              Container(
                height: plantTypeOpen? SizeConfig.screenHeight:0,
                width: plantTypeOpen? SizeConfig.screenWidth:0,
                color: Colors.black.withOpacity(0.5),
              ),

              ///////////////////////////////////////      PLANT TYPE  ////////////////////////////////

              PopUpStatic(
                title: "Select Plant Type",

                isOpen: plantTypeOpen,
                dataList: qn.plantTypeList,
                propertyKeyName:"PlantTypeName",
                propertyKeyId: "PlantTypeId",
                selectedId: qn.PD_plantTypeId,
                itemOnTap: (index){
                  setState(() {
                    plantTypeOpen=false;
                    qn.PD_plantTypeId=qn.plantTypeList[index].PlantTypeId;
                    qn.PD_plantTypeName=qn.plantTypeList[index].PlantTypeName;
                  });
                },
                closeOnTap: (){
                  setState(() {
                    plantTypeOpen=false;
                  });
                },
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
      ),
    );
  }
}

