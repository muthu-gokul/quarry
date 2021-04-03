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

