import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:provider/provider.dart';
import 'package:quarry/model/manageUsersModel/manageUsersPlantModel.dart';
import 'package:quarry/notifier/productionNotifier.dart';
import 'package:quarry/notifier/profileNotifier.dart';

import 'package:quarry/pages/productionDetails/productionDetailsAddNew.dart';
import 'package:quarry/pages/productionDetails/productionPlantList.dart';
import 'package:quarry/widgets/dateRangePicker.dart' as DateRagePicker;
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/bottomBarAddButton.dart';
import 'package:quarry/widgets/editDelete.dart';
import 'package:quarry/widgets/navigationBarIcon.dart';
import 'package:quarry/widgets/staticColumnScroll/customDataTable.dart';



class ProductionGrid extends StatefulWidget {
  VoidCallback? drawerCallback;
  ProductionGrid({this.drawerCallback});
  @override
  ProductionGridState createState() => ProductionGridState();
}

class ProductionGridState extends State<ProductionGrid> with TickerProviderStateMixin{

  bool showEdit=false;
  int? selectedIndex;




  ScrollController header=new ScrollController();
  ScrollController body=new ScrollController();
  ScrollController verticalLeft=new ScrollController();
  ScrollController verticalRight=new ScrollController();

  bool showShadow=false;
  List<String> gridDataRowList=["MachineName","InputMaterialName","InputMaterialQuantity","OutputMaterialCount","OutPutMaterialQuantity"];
  @override
  void initState() {

  //  print("globalKey.currentContext.size.width  ${globalKey.currentContext.size.width}");


    header.addListener(() {
      if(body.offset!=header.offset){
        body.jumpTo(header.offset);
      }
      if(header.offset==0){
        setState(() {
          showShadow=false;
        });
      }
      else{
        if(!showShadow){
          setState(() {
            showShadow=true;
          });
        }
      }
    });

    body.addListener(() {
      if(header.offset!=body.offset){
        header.jumpTo(body.offset);
      }
    });

    verticalLeft.addListener(() {
      if(verticalRight.offset!=verticalLeft.offset){
        verticalRight.jumpTo(verticalLeft.offset);
      }
    });

    verticalRight.addListener(() {
      if(verticalLeft.offset!=verticalRight.offset){
        verticalLeft.jumpTo(verticalRight.offset);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Colors.black
        ),
        child: SafeArea(
          child: Consumer<ProductionNotifier>(
            builder: (context,pn,child)=>  Stack(
              children: [
                Opacity(
                  opacity: 0.8,
                  child: Container(
                    width: double.maxFinite,
                    height:  160,

                    decoration: BoxDecoration(
                        // image: DecorationImage(
                        //     image: AssetImage("assets/svg/gridHeader/productionHeader.jpg",),
                        //     fit: BoxFit.cover
                        // )
                      color: AppTheme.yellowColor
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  width: SizeConfig.screenWidth,
               //   color: AppTheme.yellowColor,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: widget.drawerCallback,
                        child: NavBarIcon(),
                      ),
                      Text("Production",
                        style: AppTheme.appBarTS,
                      ),
                    ],
                  ),
                ),


                Container(
                  margin: EdgeInsets.only(top: 50),
                    padding: EdgeInsets.only(left:5,bottom:25),
                    //color: AppTheme.yellowColor,
                    height: 110,
                    alignment: Alignment.centerLeft,
                    child:SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: pn.gridCounter.
                          map((i, value) => MapEntry(i,
                            Container(
                              height: 85,
                             width: SizeConfig.screenWidth!*0.33,
                              margin: EdgeInsets.only(right: SizeConfig.width10!),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: AppTheme.counterBgColor
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(value.materialName!,style: TextStyle(fontFamily: 'RR',fontSize: 16,color:
                                  value.materialType==1?Color(0xFF1293ff):value.materialType==2?Color(0xFF01b075):Color(0xFF979797),letterSpacing: 0.1),),
                                  SizedBox(height: 5,),
                                  Container(
                                    alignment: Alignment.center,
                                    height: 30,
                                    padding: EdgeInsets.fromLTRB(10,0,10,0),
                                    child: Stack(
                                      children: [
                                        Align(
                                            alignment: Alignment.center,
                                            child: FittedBox(child: Text( '${value.totalQuantity}',style: TextStyle(fontFamily: 'RR',fontSize: 20,color: AppTheme.yellowColor),))
                                        ),
                                       Align(
                                           alignment: Alignment.bottomRight,
                                           child: Padding(
                                             padding:  EdgeInsets.only(bottom: 5),
                                             child: Text(' ${value.unitName}', style: TextStyle(fontFamily: 'RR',fontSize: 10,color: AppTheme.addNewTextFieldBorder)),
                                           )
                                       ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                        )
                        ).values.toList()
                      ),
                    )
                ),


                CustomDataTable(
                  topMargin: 140,
                  gridBodyReduceHeight: 260,
                  selectedIndex: selectedIndex,
                  gridCol: pn.productionGridCol,
                  gridData:pn.productionGridValues,
                  gridDataRowList: gridDataRowList,
                  func: (index){
                    if(selectedIndex==index){
                      setState(() {
                        selectedIndex=-1;
                        showEdit=false;
                      });

                    }
                    else{
                      setState(() {
                        selectedIndex=index;
                        showEdit=true;
                      });
                    }
                  },
                ),





                //bottomNav
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: SizeConfig.screenWidth,
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


                              AnimatedPositioned(
                                bottom:showEdit?-60:0,
                                duration: Duration(milliseconds: 300,),
                                curve: Curves.bounceOut,
                                child: Container(
                                  height: 80,
                                  width: SizeConfig.screenWidth,
                                  padding: EdgeInsets.only(bottom: 12),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Spacer(),
                                      Consumer<ProfileNotifier>(
                                          builder: (context,pro,child)=> GestureDetector(
                                            onTap: (){
                                              if(pro.usersPlantList.length>1){
                                                if(pn.filterUsersPlantList.isEmpty){
                                                  setState(() {
                                                    pro.usersPlantList.forEach((element) {
                                                      pn.filterUsersPlantList.add(ManageUserPlantModel(
                                                        plantId: element.plantId,
                                                        plantName: element.plantName,
                                                        isActive: element.isActive,

                                                      ));
                                                    });
                                                  });
                                                }
                                                else if(pn.filterUsersPlantList.length!=pro.usersPlantList.length){
                                                  pn.filterUsersPlantList.clear();
                                                  setState(() {
                                                    pro.usersPlantList.forEach((element) {
                                                      pn.filterUsersPlantList.add(ManageUserPlantModel(
                                                        plantId: element.plantId,
                                                        plantName: element.plantName,
                                                        isActive: element.isActive,

                                                      ));
                                                    });
                                                  });
                                                }

                                                Navigator.push(context, _createRouteProductionPlant());
                                              }
                                            },
                                            child: SvgPicture.asset("assets/bottomIcons/plant-slection.svg",height: 35,width: 35,
                                              color: pro.usersPlantList.length<=1?AppTheme.bgColor.withOpacity(0.4):AppTheme.bgColor,),
                                          )
                                      ),
                                      SizedBox(width: SizeConfig.screenWidth!*0.6,),
                                      GestureDetector(
                                        onTap: () async{
                                          final List<DateTime?>?  picked1 = await DateRagePicker.showDatePicker(
                                              context: context,
                                              initialFirstDate: new DateTime.now(),
                                              initialLastDate: (new DateTime.now()),
                                              firstDate: DateTime.parse('2021-01-01'),
                                              lastDate: (new DateTime.now())
                                          );
                                          if (picked1 != null && picked1.length == 2) {
                                            setState(() {
                                              pn.picked=picked1;
                                              pn.GetProductionDbHit(context,null,ProductionDetailAddNewState());
                                            });
                                          }
                                          else if(picked1!=null && picked1.length ==1){
                                            setState(() {
                                              pn.picked=picked1;
                                              pn.GetProductionDbHit(context,null,ProductionDetailAddNewState());
                                            });
                                          }

                                        },
                                        child: SvgPicture.asset("assets/svg/calender.svg",width: 27,height: 27,color: AppTheme.bgColor,
                                          //    color: qn.selectedIndex==-1? AppTheme.bgColor.withOpacity(0.5):isOpen?AppTheme.bgColor:AppTheme.bgColor.withOpacity(0.5),
                                        ),
                                      ),
                                      Spacer(),


                                    ],
                                  ),
                                ),
                              ),


                              EditDelete(
                                showEdit: showEdit,
                                editTap: (){
                                  pn.clearForm();
                                  pn.ProductionDropDownValues(context);
                                  pn.PlantUserDropDownValues(context).then((value) {


                                    pn.GetProductionDbHit(context, pn.productionGridValues[selectedIndex!].productionId, ProductionDetailAddNewState());
                                    pn.updateProductionEdit(true);
                                    Navigator.push(context, _createRoute());
                                    setState(() {
                                      selectedIndex=-1;
                                      showEdit=false;
                                    });
                                  });

                                },
                              ),




                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                //addButton
                //addButton
                Align(
                  alignment: Alignment.bottomCenter,
                  child: AddButton(
                    ontap: (){
                      pn.updateProductionEdit(false);
                      pn.ProductionDropDownValues(context);
                      pn.PlantUserDropDownValues(context);
                      Navigator.of(context).push(_createRoute());
                    },
                    image: "assets/svg/plusIcon.svg",
                  ),
                ),




                Container(

                  height: pn.ProductionLoader? SizeConfig.screenHeight:0,
                  width: pn.ProductionLoader? SizeConfig.screenWidth:0,
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppTheme.yellowColor),),
                  ),

                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => ProductionDetailAddNew(),

      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        return FadeTransition(
          opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
          child: child,
        );
      },
    );
  }
  Route _createRouteProductionPlant() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => ProductionPlantList(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        return SlideTransition(
          position: Tween<Offset>(begin: Offset(-1.0,0.0), end: Offset.zero).animate(animation),
          child: child,
        );
      },
    );
  }
}

