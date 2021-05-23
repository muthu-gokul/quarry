import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:quarry/notifier/machineNotifier.dart';

import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/bottomBarAddButton.dart';
import 'package:quarry/widgets/customTextField.dart';
import 'package:quarry/widgets/validationErrorText.dart';


class MachineDetailAddNew extends StatefulWidget {
  @override
  _MachineDetailAddNewState createState() => _MachineDetailAddNewState();
}

class _MachineDetailAddNewState extends State<MachineDetailAddNew> with TickerProviderStateMixin{

  GlobalKey <ScaffoldState> scaffoldkey=new GlobalKey<ScaffoldState>();


  ScrollController scrollController;
  ScrollController listViewController;
  bool _keyboardVisible = false;

  bool machineName=false;

  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((_){


      scrollController=new ScrollController();
      listViewController=new ScrollController();
      setState(() {

      });


     /* scrollController.addListener(() {
        if(scrollController.offset>20){
          scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);

        }
      });*/

/*      listViewController.addListener(() {
       //  print("LISt-${listViewController.offset}");
        if(listViewController.offset>20){

          scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);


        }
        else if(listViewController.offset==0){
          scrollController.animateTo(0, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
        }
      });*/

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final node=FocusScope.of(context);
    SizeConfig().init(context);
   // _keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: scaffoldkey,
     body: Consumer<MachineNotifier>(
         builder: (context,qn,child)=> Stack(
           children: [



             //IMAGE
             Container(
               height: SizeConfig.screenHeight,
               width: SizeConfig.screenWidth,
               child: Column(
                 children: [
                   Container(
                     width: SizeConfig.screenWidth,
                     height: 180,
                     decoration: BoxDecoration(
                       color: AppTheme.yellowColor,
                        image: DecorationImage(
                                     image: AssetImage("assets/svg/gridHeader/machineHeader.jpg",),
                                   fit: BoxFit.cover
                                 )

                     ),
                    // child: SvgPicture.asset("assets/svg/gridHeader/machineHeader.svg"),

                   ),
                 ],
               ),
             ),

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
                       height: SizeConfig.screenHeight-60,
                       width: SizeConfig.screenWidth,
                       alignment: Alignment.topCenter,
                       decoration: BoxDecoration(
                           color: Colors.white,
                           borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                       ),
                       child: GestureDetector(
                     /*    onVerticalDragDown: (v){
                           if(scrollController.offset==100 && listViewController.offset==0){
                             scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                           }
                           else if(scrollController.offset==0 && listViewController.offset==0){
                             scrollController.animateTo(100, duration: Duration(milliseconds: 300), curve: Curves.easeIn);

                           }

                         },*/
                         onVerticalDragUpdate: (details){
                           int sensitivity = 5;
                           if (details.delta.dy > sensitivity) {
                             scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn).then((value){
                               /* if(isListScroll){
                                    setState(() {
                                      isListScroll=false;
                                    });
                                  }*/
                             });

                           } else if(details.delta.dy < -sensitivity){
                             scrollController.animateTo(100, duration: Duration(milliseconds: 300), curve: Curves.easeIn).then((value){

                               /*if(!isListScroll){
                                    setState(() {
                                      isListScroll=true;
                                    });
                                  }*/
                             });
                           }
                         },
                         child: Container(
                        //   height:_keyboardVisible?SizeConfig.screenHeight*0.5 :SizeConfig.screenHeight-100,
                           height: SizeConfig.screenHeight-100,
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
                                 labelText: 'Machine Name',
                                 regExp: '[A-Za-z0-9  ]',
                                 textEditingController: qn.MachineName,
                                 onEditComplete: (){
                                   node.unfocus();
                                 },
                                 ontap: (){
                                   scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                 },
                               ),
                               !machineName?Container():ValidationErrorText(title: "* Enter Machine Name",),
                               AddNewLabelTextField(
                                 labelText: 'Machine Type',
                                 regExp: '[A-Za-z0-9  ]',
                                 textEditingController: qn.MachineType,
                                 ontap: (){
                                   scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                 },
                                 onEditComplete: (){
                                   node.unfocus();
                                 },
                               ),
                               AddNewLabelTextField(
                                 labelText: 'Machine Model',
                                 regExp: '[A-Za-z0-9  ]',
                                 textEditingController: qn.MachineModel,
                                 ontap: (){
                                   scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                 },
                                 onEditComplete: (){
                                   node.unfocus();
                                 },
                               ),

                               AddNewLabelTextField(
                                 labelText: 'Capacity',
                                 regExp: '[0-9.  ]',
                                 textEditingController: qn.Capacity,
                                 textInputType: TextInputType.number,
                                 scrollPadding: 100,
                                 ontap: (){
                                   scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                 },
                                 onEditComplete: (){
                                   node.unfocus();
                                 },
                               ),
                               AddNewLabelTextField(
                                  labelText: 'Motor Power',
                                 regExp: '[A-Za-z0-9  ]',
                                  textEditingController: qn.MoterPower,
                                 scrollPadding: 400,
                                 ontap: (){
                                   scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                   setState(() {
                                     _keyboardVisible=true;
                                   });
                                 },
                                 onEditComplete: (){
                                   node.unfocus();
                                   setState(() {
                                     _keyboardVisible=false;
                                   });
                                 },
                                ),
                               AddNewLabelTextField(
                                 labelText: 'Machine Specification',
                                 textEditingController: qn.MachineSpecification,
                                 regExp: '[A-Za-z0-9  ]',
                                 scrollPadding: 450,
                                 ontap: (){
                                   scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                   setState(() {
                                     _keyboardVisible=true;
                                   });
                                 },
                                 onEditComplete: (){
                                   node.unfocus();
                                   setState(() {
                                     _keyboardVisible=false;
                                   });
                                 },
                               ),
                               // // AddNewLabelTextField(
                               // //   labelText: 'Weight',
                               // //   textEditingController: qn.MD_machineWeight,
                               // //   scrollPadding: 100,
                               // // ),


                               SizedBox(height: _keyboardVisible? SizeConfig.screenHeight*0.5:200,)
                             ],
                           ),
                         ),
                       ),
                     )
                   ],
                 ),
               ),
             ),
             Container(
               height: SizeConfig.height60,
               width: SizeConfig.screenWidth,
               child: Row(
                 children: [
                   CancelButton(
                     ontap: (){
                       qn.clearMachineDetailForm();
                       Navigator.pop(context);
                     },
                   ),

                   Text("Machine Detail",
                     style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize: SizeConfig.width16),
                   ),
                   Text(qn.isMachineEdit?" / Edit":" / Add New",
                     style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize: SizeConfig.width16),
                   ),
                   Spacer(),

                 ],
               ),
             ),


             //bottomNav
             Positioned(
               bottom: 0,
               child: Container(
                 width: SizeConfig.screenWidth,
                 height:  70,

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
                         size: Size( SizeConfig.screenWidth, 65),
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
             //add button
             Align(
               alignment: Alignment.bottomCenter,
               child: AddButton(
                 ontap: (){
                   node.unfocus();
                   if(qn.MachineName.text.isEmpty) {setState(() {machineName=true;});}
                   else{setState(() {machineName=false;});}

                   if(!machineName){
                     qn.InsertVehicleDbHit(context);
                   }


                 },
               ),
             ),




             Container(

               height: qn.machineLoader? SizeConfig.screenHeight:0,
               width: qn.machineLoader? SizeConfig.screenWidth:0,
               color: Colors.black.withOpacity(0.5),
               child: Center(
                 child:CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppTheme.yellowColor),),
                 //Image.asset("assets/images/Loader.gif",filterQuality: FilterQuality.high,gaplessPlayback: true,isAntiAlias: true,)

               ),
             ),
           ],
         )
     )

     );
  }
}






