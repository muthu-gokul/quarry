import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/customerNotifier.dart';
import 'package:quarry/notifier/materialNotifier.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/pages/quarryMaster/quarryLocationAddNew.dart';
import 'package:quarry/pages/sale/salesDetail.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/customTextField.dart';


class CustomerDetailAddNew extends StatefulWidget {
  @override
  CustomerDetailAddNewState createState() => CustomerDetailAddNewState();
}

class CustomerDetailAddNewState extends State<CustomerDetailAddNew> with TickerProviderStateMixin {

  GlobalKey <ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();


  ScrollController scrollController;
  ScrollController listViewController;

  bool _keyboardVisible = false;
  bool materialCategoryOpen = false;
  bool materialUnitOpen = false;



  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController = new ScrollController();
      listViewController = new ScrollController();
      setState(() {

      });


      listViewController.addListener(() {
        if (listViewController.offset > 20) {
          scrollController.animateTo(
              100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
        }
        else if (listViewController.offset == 0) {
          scrollController.animateTo(
              0, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
        }
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);

    SizeConfig().init(context);
    _keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
        key: scaffoldkey,
        body: Consumer<CustomerNotifier>(
            builder: (context, qn, child) =>
                Stack(
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
                                    image: AssetImage(
                                      "assets/images/saleFormheader.jpg",),
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
                              height: SizeConfig.screenHeight - 60,
                              width: SizeConfig.screenWidth,
                              alignment: Alignment.topCenter,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10))
                              ),
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
                                      labelText: 'Enter Customer Name',
                                      textEditingController: qn.customerName,
                                      onEditComplete: (){
                                        node.unfocus();
                                      },
                                    ),

                                    AddNewLabelTextField(
                                      labelText: 'Address',
                                      textEditingController: qn.customerAddress,
                                      onEditComplete: (){
                                        node.unfocus();
                                      },
                                    ),
                                    AddNewLabelTextField(
                                      labelText: 'City',
                                      textEditingController: qn.customerCity,
                                      onEditComplete: (){
                                        node.unfocus();
                                      },
                                    ),
                                    AddNewLabelTextField(
                                      labelText: 'State',
                                      textEditingController: qn.customerState,
                                      onEditComplete: (){
                                        node.unfocus();
                                      },
                                      scrollPadding: 100,
                                    ),
                                    // GestureDetector(
                                    //   onTap: (){
                                    //     node.unfocus();
                                    //     setState(() {
                                    //       materialUnitOpen=true;
                                    //     });
                                    //     SystemChannels.textInput.invokeMethod('TextInput.hide');
                                    //   },
                                    //   child: SidePopUpParent(
                                    //     text: qn.selectedUnitName==null? "Select Unit":qn.selectedUnitName,
                                    //     textColor: qn.selectedUnitName==null? AppTheme.addNewTextFieldText.withOpacity(0.5):AppTheme.addNewTextFieldText,
                                    //     iconColor: qn.selectedUnitName==null? AppTheme.addNewTextFieldText:AppTheme.yellowColor,
                                    //   ),
                                    // ),
                                    // AddNewLabelTextField(
                                    //   labelText: 'Price',
                                    //   textEditingController: qn.materialPrice,
                                    //   textInputType: TextInputType.number,
                                    //   scrollPadding: 100,
                                    //   suffixIcon: Container(
                                    //     margin: EdgeInsets.all(10),
                                    //     height: 15,
                                    //     width: 50,
                                    //     decoration: BoxDecoration(
                                    //         borderRadius: BorderRadius.circular(15),
                                    //         color: AppTheme.yellowColor
                                    //     ),
                                    //     child: Center(
                                    //       child: Text("Rs",style: AppTheme.TSWhite16,),
                                    //     ),
                                    //   ),
                                    // ),
                                    // AddNewLabelTextField(
                                    //   labelText: 'GST',
                                    //   textEditingController: qn.materialGst,
                                    //   textInputType: TextInputType.number,
                                    //   scrollPadding: 100,
                                    //   suffixIcon: Container(
                                    //     margin: EdgeInsets.all(10),
                                    //     height: 15,
                                    //     width: 50,
                                    //     decoration: BoxDecoration(
                                    //         borderRadius: BorderRadius.circular(15),
                                    //         color: AppTheme.yellowColor
                                    //     ),
                                    //     child: Center(
                                    //       child: Text("%",style: AppTheme.TSWhite20,),
                                    //     ),
                                    //   ),
                                    // ),
                                    AddNewLabelTextField(
                                      labelText: 'Country',
                                      textEditingController: qn.customerCountry,
                                      scrollPadding: 100,
                                      onEditComplete: (){
                                        node.unfocus();
                                      },
                                    ),
                                    AddNewLabelTextField(
                                      labelText: 'ZipCode',
                                      textEditingController: qn.customerZipcode,
                                      scrollPadding: 100,
                                      onEditComplete: (){
                                        node.unfocus();
                                      },
                                    ),
                                    AddNewLabelTextField(
                                      labelText: 'Enter Contact Number',
                                      textEditingController: qn
                                          .customerContactNumber,
                                      scrollPadding: 100,
                                      onEditComplete: (){
                                        node.unfocus();
                                      },
                                    ),
                                    AddNewLabelTextField(
                                      labelText: 'Enter EmailId ',
                                      textEditingController: qn.customerEmail,
                                      scrollPadding: 100,
                                      onEditComplete: (){
                                        node.unfocus();
                                      },
                                    ),
                                    AddNewLabelTextField(
                                      labelText: 'Enter GST No ',
                                      textEditingController: qn.customerGstNumber,
                                      scrollPadding: 100,
                                      onEditComplete: (){
                                        node.unfocus();
                                      },
                                    ),
                                    SizedBox(height: SizeConfig.height20,),
                                    Container(
                                      height: SizeConfig.height30,
                                      width: SizeConfig.screenWidth,
                                      padding: EdgeInsets.only(left: SizeConfig.width10),
                                      child: Row(
                                        children: [
                                          Checkbox(
                                             fillColor: MaterialStateColor.resolveWith((states) => AppTheme.yellowColor),
                                              value: qn.isCreditCustomer,
                                              onChanged: (v){
                                                setState(() {
                                                  qn.isCreditCustomer=v;
                                                });

                                          }),
                                          InkWell(
                                              onTap: (){
                                                setState(() {
                                                  qn.isCreditCustomer=!qn.isCreditCustomer;
                                                });
                                              },
                                              child: Text("IsCredit Customer", style:  TextStyle(fontFamily: 'RR',fontSize: 16,color:AppTheme.addNewTextFieldText,letterSpacing: 0.2),))
                                        ],
                                      ),
                                    ),


                                    AnimatedContainer(
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.easeIn,
                                      height: qn.isCreditCustomer?SizeConfig.height50:0,
                                      width: SizeConfig.screenWidth,
                                      margin: EdgeInsets.only(left:SizeConfig.width20,right:SizeConfig.width20,top:SizeConfig.height20,),
                                      padding: EdgeInsets.only(left:SizeConfig.width10,),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: AppTheme.addNewTextFieldBorder),
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      child:qn.isCreditCustomer? TextField(
                                        style:  TextStyle(fontFamily: 'RR',fontSize: 15,color:AppTheme.addNewTextFieldText,letterSpacing: 0.2),
                                        controller: qn.customerCreditLimit,
                                        decoration: InputDecoration(
                                          hintText: 'Customer Credit Limit',
                                          hintStyle: TextStyle(fontFamily: 'RL',fontSize: 15,color: AppTheme.addNewTextFieldText.withOpacity(0.9)),
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,

                                        ),
                                        keyboardType: TextInputType.number,
                                      ):Container(),
                                    ),

                                    SizedBox(height: SizeConfig.height100,),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),


                    //Circle Image


                    //HEADER
                    Container(
                      height: SizeConfig.height60,
                      width: SizeConfig.screenWidth,
                      child: Row(
                        children: [
                          IconButton(
                              icon: Icon(Icons.arrow_back), onPressed: () {
                            Navigator.pop(context);
                            qn.clearCustomerDetails();
                          }),
                          SizedBox(width: SizeConfig.width5,),
                          Text("Customer Detail",
                            style: TextStyle(fontFamily: 'RR',
                                color: Colors.black,
                                fontSize: SizeConfig.width16),
                          ),
                          Text(qn.isCustomerEdit ? " / Edit" : " / Add New",
                            style: TextStyle(fontFamily: 'RR',
                                color: Colors.black,
                                fontSize: SizeConfig.width16),
                          ),
                          Spacer(),

                        ],
                      ),
                    ),


                    //Save Button
                    Positioned(
                      bottom: 0,
                      child: Container(
                        height: _keyboardVisible ? 0 : SizeConfig.height70,
                        width: SizeConfig.screenWidth,
                        color: AppTheme.grey,
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              node.unfocus();
                              if(qn.customerName.text.isEmpty){
                                CustomAlert().commonErrorAlert(context, "Enter Name", "");
                              }
                              else if(qn.customerContactNumber.text.isEmpty){
                                CustomAlert().commonErrorAlert(context, "Enter Contact Number", "");
                              }
                              else{
                                qn.InsertCustomerDbHit(context);
                              }


                            },

                            child: Container(
                              height: SizeConfig.height50,
                              width: SizeConfig.width120,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(SizeConfig
                                      .height25),
                                  color: AppTheme.bgColor
                              ),
                              child: Center(
                                child: Text(qn.isCustomerEdit
                                    ? "Update"
                                    : "Save", style: AppTheme.TSWhite20,),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    Container(
                      height: qn.customerLoader ? SizeConfig.screenHeight : 0,
                      width: qn.customerLoader ? SizeConfig.screenWidth : 0,
                      color: Colors.black.withOpacity(0.5),
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.yellowColor),),
                        //Image.asset("assets/images/Loader.gif",filterQuality: FilterQuality.high,gaplessPlayback: true,isAntiAlias: true,)
                      ),
                    ),
                  ],
                )
        )
    );
  }
}



