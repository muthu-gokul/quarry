import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/machineNotifier.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/pages/quarryMaster/quarryLocationAddNew.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/customTextField.dart';


class MachineDetailAddNew extends StatefulWidget {
  @override
  _MachineDetailAddNewState createState() => _MachineDetailAddNewState();
}

class _MachineDetailAddNewState extends State<MachineDetailAddNew> with TickerProviderStateMixin{

  GlobalKey <ScaffoldState> scaffoldkey=new GlobalKey<ScaffoldState>();


  ScrollController scrollController;
  ScrollController listViewController;



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

      listViewController.addListener(() {
         print("LISt-${listViewController.offset}");
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
    SizeConfig().init(context);
    return Scaffold(
      key: scaffoldkey,
     body: Consumer<MachineNotifier>(
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
                             labelText: 'Machine Name',
                             textEditingController: qn.MachineName,
                           ),
                           AddNewLabelTextField(
                             labelText: 'Machine Type',
                             textEditingController: qn.MachineType,
                           ),
                           AddNewLabelTextField(
                             labelText: 'Machine Model',
                             textEditingController: qn.MachineModel,
                           ),

                           AddNewLabelTextField(
                             labelText: 'Capacity',
                             textEditingController: qn.Capacity,
                             scrollPadding: 100,
                           ),
                           AddNewLabelTextField(
                              labelText: 'MoterPower',
                              textEditingController: qn.MoterPower,
                             scrollPadding: 100,
                            ),
                           AddNewLabelTextField(
                             labelText: 'MachineWeight',
                             textEditingController: qn.MachineWeight,
                             scrollPadding: 100,
                           ),
                           // // AddNewLabelTextField(
                           // //   labelText: 'Weight',
                           // //   textEditingController: qn.MD_machineWeight,
                           // //   scrollPadding: 100,
                           // // ),

                           SizedBox(height: SizeConfig.height100,)
                         ],
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
                   IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
                     qn.clearMachineDetailForm();
                     Navigator.pop(context);
                   }),
                   SizedBox(width: SizeConfig.width5,),
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
             Positioned(
               bottom: 0,
               child: Container(
                 height: SizeConfig.height70,
                 width: SizeConfig.screenWidth,
                 color: AppTheme.grey,
                 child: Center(
                   child: GestureDetector(
                     onTap: (){
                       node.unfocus();
                       qn.InsertVehicleDbHit(context);

                     },
                     child: Container(
                       height: SizeConfig.height50,
                       width: SizeConfig.width120,
                       decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(SizeConfig.height25),
                           color: AppTheme.bgColor
                       ),
                       child: Center(
                         child: Text(qn.isMachineEdit?"Update":"Save",style: AppTheme.TSWhite20,),
                       ),
                     ),
                   ),
                 ),
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


/*
class MachineAdd extends StatefulWidget {
  VoidCallback drawerCallback;
  MachineAdd({this.drawerCallback});
  @override
  MachineAddState createState() => MachineAddState();
}

class MachineAddState extends State<MachineAdd> with TickerProviderStateMixin{




  ScrollController scrollController;
  ScrollController listViewController;



  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((_){


      scrollController=new ScrollController();
      listViewController=new ScrollController();
      setState(() {

      });


      listViewController.addListener(() {

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
    SizeConfig().init(context);
    return Consumer<QuarryNotifier>(
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
                            labelText: 'Machine Name',
                            textEditingController: qn.MD_machineName,
                          ),
                          AddNewLabelTextField(
                            labelText: 'Machine Type',
                            textEditingController: qn.MD_machineType,
                          ),
                          AddNewLabelTextField(
                            labelText: 'Machine Model',
                            textEditingController: qn.MD_machineModel,
                          ),
                          AddNewLabelTextField(
                            labelText: 'Capacity',
                            textEditingController: qn.MD_machineCapacity,
                            scrollPadding: 100,
                          ),
                          AddNewLabelTextField(
                            labelText: 'Motor Power',
                            textEditingController: qn.MD_machinePower,
                            scrollPadding: 100,
                          ),
                          AddNewLabelTextField(
                            labelText: 'Weight',
                            textEditingController: qn.MD_machineWeight,
                            scrollPadding: 100,
                          ),

                          SizedBox(height: SizeConfig.height100,)
                        ],
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
                  IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
                    Navigator.pop(context);
                  }),
                  SizedBox(width: SizeConfig.width5,),
                  Text("Machine Detail",
                    style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize: SizeConfig.width16),
                  ),
                  Spacer(),

                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: SizeConfig.height70,
                width: SizeConfig.screenWidth,
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
                        child: Text(qn.isMachineEdit?"Update":"Save",style: AppTheme.TSWhite20,),
                      ),
                    ),
                  ),
                ),
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
    );
  }
}
*/



