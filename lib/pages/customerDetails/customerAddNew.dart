import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/pages/sale/salesDetail.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/customTextField.dart';

class CustomerAddNew extends StatefulWidget {
  VoidCallback drawerCallback;
  CustomerAddNew({this.drawerCallback});
  @override
  _CustomerAddNewState createState() => _CustomerAddNewState();
}

class _CustomerAddNewState extends State<CustomerAddNew> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light.copyWith(
              statusBarColor:AppTheme.yellowColor
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
                                        qn.clearCustomerDetails();
                                      }),
                                      SizedBox(width: SizeConfig.width5,),
                                      Text("Customer Detail / Add New",
                                        style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize: SizeConfig.width16),
                                      ),
                                      Spacer(),

                                    ],
                                  ),
                                  Spacer(),
                                ],
                              ),
                            ),

                            Container(

                              height: SizeConfig.screenHeight-(SizeConfig.height270),


                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    AddNewLabelTextField(
                                      labelText: 'Comapany/Customer Name',
                                      textEditingController: qn.customerName,
                                    ),
                                    AddNewLabelTextField(
                                      labelText: 'Contact Number',
                                      textEditingController: qn.customerContactNumber,
                                      textInputType: TextInputType.number,

                                    ),
                                    AddNewLabelTextField(
                                      labelText: 'GST No',
                                      textEditingController: qn.customerGstNumber,
                                      scrollPadding: 100,
                                    ),
                                    AddNewLabelTextField(
                                      labelText: 'Email',
                                      textEditingController: qn.customerEmail,
                                      textInputType: TextInputType.emailAddress,
                                      scrollPadding: 100,
                                    ),
                                    AddNewLabelTextField(
                                      labelText: 'Address',
                                      maxLines: 2,
                                      textEditingController: qn.customerAddress,
                                      scrollPadding: 150,
                                    ),
                                    AddNewLabelTextField(
                                      labelText: 'City',
                                      textEditingController: qn.customerCity,
                                      scrollPadding: 200,
                                    ),
                                    AddNewLabelTextField(
                                      labelText: 'State',
                                      textEditingController: qn.customerState,
                                      scrollPadding: 200,
                                    ),
                                    AddNewLabelTextField(
                                      labelText: 'ZipCode',
                                      textEditingController: qn.customerZipcode,
                                      textInputType: TextInputType.number,
                                      scrollPadding: 250,

                                    ),
                                    SizedBox(height: SizeConfig.height50,)
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



                                    SystemChannels.textInput.invokeMethod('TextInput.hide');

                                    if(qn.customerName.text.isNotEmpty){
                                      if(qn.isCustomerEdit){
                                        qn.UpdateCustomerDetailDbhit(context).then((value){
                                          qn.clearCustomerDetails();
                                          Navigator.pop(context);

                                        });
                                      }else{
                                        qn.InsertCustomerDetailDbhit(context).then((value){
                                          qn.clearCustomerDetails();
                                          Navigator.pop(context);
                                        });
                                      }
                                    }
                                    else{
                                      CustomAlert().commonErrorAlert(context, "Enter Customer / Company Name", "");
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
                                      child: Text("Save",style: AppTheme.TSWhite20,),
                                    ),
                                  ),
                                ),
                              ),
                            )

                          ],
                        ),
                      ),
///////////////////////////////////Loader///////////////////////////////////////
                      Container(
                        height: qn.customerLoader? SizeConfig.screenHeight:0,
                        width: qn.customerLoader? SizeConfig.screenWidth:0,
                        color: Colors.black.withOpacity(0.5),
                        child: Center(
                            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppTheme.yellowColor),),
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