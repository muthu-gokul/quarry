
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quarry/model/plantDetailsModel/plantLicenseModel.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/pages/sale/salesDetail.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/customTextField.dart';
import 'package:quarry/widgets/dateRangePicker.dart' as DateRagePicker;





class PlantDetailsAddNew extends StatefulWidget {
  VoidCallback drawerCallback;
  PlantDetailsAddNew({this.drawerCallback});
  @override
  PlantDetailsAddNewState createState() => PlantDetailsAddNewState();
}

class PlantDetailsAddNewState extends State<PlantDetailsAddNew> with TickerProviderStateMixin{

  bool isEdit=false;


  ScrollController scrollController;
  ScrollController listViewController;
  bool _keyboardVisible = false;
  bool plantTypeOpen=false;
  DateTime firstDate=DateTime.parse('1950-01-01');
  DateTime lastDate=DateTime.parse('2121-01-01');
  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((_){


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


      listViewController.addListener(() {
        print("List SCROLL--${listViewController.offset}");
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
    _keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    SizeConfig().init(context);
    return Scaffold(
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
                              labelText: 'Plant Name',
                              isEnabled: isEdit,
                              textEditingController: qn.PD_quarryname,
                              onEditComplete: (){
                                node.unfocus();
                              },


                            ),
                            AddNewLabelTextField(
                              labelText: 'Address',
                              isEnabled: isEdit,
                              onEditComplete: (){
                                node.unfocus();
                              },
                              textInputType: TextInputType.text,
                              scrollPadding: 200,
                              textEditingController: qn.PD_address,
                            ),
                            AddNewLabelTextField(
                              labelText: 'City',
                              isEnabled: isEdit,
                              scrollPadding: 200,
                              textEditingController: qn.PD_city,
                              onEditComplete: (){
                                node.unfocus();
                              },
                            ),
                            AddNewLabelTextField(
                              labelText: 'State',
                              isEnabled: isEdit,
                              scrollPadding: 200,
                              textEditingController: qn.PD_state,
                              onEditComplete: (){
                                node.unfocus();
                              },
                            ),
                            AddNewLabelTextField(
                              labelText: 'Country',
                              isEnabled: isEdit,
                              scrollPadding: 200,
                              textEditingController: qn.PD_country,
                              onEditComplete: (){
                                node.unfocus();
                              },
                            ),
                            AddNewLabelTextField(
                              labelText: 'ZipCode',
                              isEnabled: isEdit,
                              textInputType: TextInputType.number,
                              scrollPadding: 200,
                              textEditingController: qn.PD_zipcode,
                              onEditComplete: (){
                                node.unfocus();
                              },
                            ),
                            AddNewLabelTextField(
                              labelText: 'Contact Number',
                              isEnabled: isEdit,
                              textInputType: TextInputType.number,
                              textEditingController: qn.PD_contactNo,
                              onEditComplete: (){
                                node.unfocus();
                              },
                            ),
                            AddNewLabelTextField(
                              labelText: 'Email',
                              isEnabled: isEdit,
                              textInputType: TextInputType.emailAddress,
                              textEditingController: qn.PD_email,
                              scrollPadding: 100,
                              onEditComplete: (){
                                node.unfocus();
                              },
                            ),
                            GestureDetector(
                              onTap: (){
                                node.unfocus();
                                setState(() {
                                  plantTypeOpen=true;
                                });
                                SystemChannels.textInput.invokeMethod('TextInput.hide');
                              },
                              child: SidePopUpParent(
                                text: qn.PD_plantTypeName==null? "Select Plant Type":qn.PD_plantTypeName,
                                textColor: qn.PD_plantTypeName==null? AppTheme.addNewTextFieldText.withOpacity(0.5):AppTheme.addNewTextFieldText,
                                iconColor: qn.PD_plantTypeName==null? AppTheme.addNewTextFieldText:AppTheme.yellowColor,
                              ),
                            ),
                            AddNewLabelTextField(
                              labelText: 'Contact Person Name',
                              isEnabled: isEdit,
                              scrollPadding: 200,
                              textEditingController: qn.PD_ContactPersonName,
                              onEditComplete: (){
                                node.unfocus();
                              },
                            ),
                            AddNewLabelTextField(
                              labelText: 'Designation',
                              isEnabled: isEdit,
                              scrollPadding: 200,
                              textEditingController: qn.PD_Designation,
                              onEditComplete: (){
                                node.unfocus();
                              },
                            ),

////////////////////////////////////  LICENSE LIST ///////////////////////
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                              height: qn.PO_PlantLicenseList.length==0?0:qn.PO_PlantLicenseList.length*60.0,
                              padding: EdgeInsets.fromLTRB(10,5,10,5),
                             /* constraints: BoxConstraints(
                                minHeight: 60,
                                maxHeight: qn.PO_PlantLicenseList.length*70.0
                              ),*/
                              width: SizeConfig.screenWidth,
                              margin: EdgeInsets.only(left:SizeConfig.width20,right:SizeConfig.width20,top:SizeConfig.height20,),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  qn.PO_PlantLicenseList.length==0?BoxShadow():
                                  BoxShadow(
                                    color: AppTheme.addNewTextFieldText.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 15,
                                    offset: Offset(0, 0), // changes position of shadow
                                  )
                                ]
                              ),
                              child: ListView.builder(
                                itemCount: qn.PO_PlantLicenseList.length,
                                itemBuilder: (context,index){
                                  return Container(
                                    padding: EdgeInsets.only(top: 5,bottom: 5),
                                    decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(color: AppTheme.addNewTextFieldBorder))
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: SizeConfig.width80,
                                          child: Text("${qn.PO_PlantLicenseList[index].licenseNumber}",
                                            style: TextStyle(fontSize: 14,fontFamily: 'RR',color: AppTheme.gridTextColor,letterSpacing: 0.2),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(left: 5),
                                          alignment: Alignment.centerLeft,
                                          width: SizeConfig.width80,
                                          child: Text("${qn.PO_PlantLicenseList[index].licenseDescription}",
                                            style: TextStyle(fontSize: 14,fontFamily: 'RR',color: AppTheme.gridTextColor,letterSpacing: 0.2),
                                          ),
                                        ),
                                        Container(

                                          alignment: Alignment.centerRight,
                                          width: SizeConfig.width70+SizeConfig.width5,
                                          child: Text("${qn.PO_PlantLicenseList[index].fromDate!=null?DateFormat.yMMMd().format(qn.PO_PlantLicenseList[index].fromDate):""} to \n${qn.PO_PlantLicenseList[index].toDate!=null?DateFormat.yMMMd().format(qn.PO_PlantLicenseList[index].toDate):""}",
                                            style: TextStyle(fontSize: 12,fontFamily: 'RR',color: AppTheme.gridTextColor,letterSpacing: 0.2),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: (){
                                            if(isEdit){
                                              setState(() {
                                                qn.PO_PlantLicenseList.removeAt(index);
                                              });
                                            }

                                          },
                                          child: Container(
                                            height: 25,
                                            width: 25,
                                            child: Icon(Icons.delete,color:isEdit?Colors.red: Colors.red.withOpacity(0.5),)
                                          ),
                                        ),

                                      ],
                                    ),

                                  );
                                },
                              ),
                            ),


                            Container(
                              width: SizeConfig.screenWidth,
                              margin: EdgeInsets.only(left:SizeConfig.width20,right:SizeConfig.width20,top:SizeConfig.height20,),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: Colors.transparent
                              ),
                              child:  Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: SizeConfig.width130,
                                    child: TextFormField(
                                      enabled: isEdit,
                                      scrollPadding: EdgeInsets.only(bottom: 100),
                                      style:  TextStyle(fontFamily: 'RR',fontSize: 15,color:AppTheme.addNewTextFieldText,letterSpacing: 0.2),
                                      controller: qn.PD_LicenseNo,
                                      decoration: InputDecoration(
                                          fillColor:isEdit?Colors.white: Color(0xFFF2F2F2),
                                          filled: true,
                                          hintStyle: TextStyle(fontFamily: 'RL',fontSize: 15,color: AppTheme.addNewTextFieldText.withOpacity(0.9)),
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
                                    width: SizeConfig.width130,
                                    child: TextFormField(
                                      enabled: isEdit,
                                      scrollPadding: EdgeInsets.only(bottom: 100),
                                      style:  TextStyle(fontFamily: 'RR',fontSize: 15,color:AppTheme.addNewTextFieldText,letterSpacing: 0.2),
                                       controller: qn.PD_LicenseDesc,
                                      decoration: InputDecoration(
                                          fillColor:isEdit?Colors.white: Color(0xFFF2F2F2),
                                          filled: true,
                                          hintStyle: TextStyle(fontFamily: 'RL',fontSize: 15,color: AppTheme.addNewTextFieldText.withOpacity(0.9)),
                                          border:  OutlineInputBorder(
                                              borderSide: BorderSide(color: AppTheme.addNewTextFieldBorder)
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: AppTheme.addNewTextFieldBorder)
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color:AppTheme.addNewTextFieldFocusBorder)
                                          ),
                                          hintText: "Description",
                                          contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                                        suffixIcon:  GestureDetector(
                                          onTap: () async {
                                            node.unfocus();

                                            final List<DateTime>  picked1 = await DateRagePicker.showDatePicker(
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
                                            height: SizeConfig.height50,
                                            width: SizeConfig.height50,

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
                                      documentFolderName: ""
                                    )
                                  );
                                });
                                qn.clearPlantLicenseForm();
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: SizeConfig.width90,right:  SizeConfig.width90,),
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
                                    child: Text("Choose File",style: TextStyle(color:AppTheme.bgColor,fontSize:16,fontFamily: 'RM'),
                                    )
                                ),


                              ),
                            ),

                            SizedBox(height: SizeConfig.height100,)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),

             qn.isPlantDetailsEdit? Positioned(
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
              ),

              Container(
                height: SizeConfig.height60,
                width: SizeConfig.screenWidth,
                child: Row(
                  children: [
                    IconButton(icon: Icon(Icons.clear,color: Colors.white,), onPressed: (){
                      Navigator.pop(context);
                      qn.clearPlantForm();
                    }),
                    SizedBox(width: SizeConfig.width5,),
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
                    transform: Matrix4.translationValues(plantTypeOpen?0:SizeConfig.screenWidth, 0, 0),

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
                                        plantTypeOpen=false;
                                      });
                                    }),
                                  ),
                                  Align(
                                      alignment: Alignment.center,
                                      child: Text('Select Plant Type',style:TextStyle(color:Colors.black,fontFamily: 'RR',fontSize:16),)),
                                ],
                              ),
                            ),
                            SizedBox(height: SizeConfig.height10,),




                            Container(
                              height: SizeConfig.screenHeight*(300/720),
                              /*color: Colors.red,*/
                              margin: EdgeInsets.only(left: SizeConfig.width30,right: SizeConfig.width30),
                              child: ListView.builder(
                                itemCount: qn.plantTypeList.length,
                                itemBuilder: (context,index){
                                  return GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        qn.PD_plantTypeId=qn.plantTypeList[index].PlantTypeId;
                                        qn.PD_plantTypeName=qn.plantTypeList[index].PlantTypeName;
                                        plantTypeOpen=false;
                                      });

                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 20),
                                      alignment: Alignment.center,
                                      decoration:BoxDecoration(
                                          borderRadius:BorderRadius.circular(8),
                                          border: Border.all(color: qn.PD_plantTypeId==null? AppTheme.addNewTextFieldBorder:qn.PD_plantTypeId==qn.plantTypeList[index].PlantTypeId?Colors.transparent: AppTheme.addNewTextFieldBorder),
                                          color: qn.PD_plantTypeId==null? Colors.white: qn.PD_plantTypeId==qn.plantTypeList[index].PlantTypeId?AppTheme.popUpSelectedColor:Colors.white
                                      ),
                                      width:300,
                                      height:50,
                                      child: Text("${qn.plantTypeList[index].PlantTypeName}",
                                        style: TextStyle(color:qn.PD_plantTypeId==null? AppTheme.grey:qn.PD_plantTypeId==qn.plantTypeList[index].PlantTypeId?Colors.white:AppTheme.grey,
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

