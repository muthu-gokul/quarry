import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quarry/model/manageUsersModel/manageUsersPlantModel.dart';
import 'package:quarry/notifier/profileNotifier.dart';
import 'package:quarry/notifier/purchaseNotifier.dart';
import 'package:quarry/styles/constants.dart';
import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/dateRangePicker.dart' as DateRagePicker;
import 'package:quarry/pages/purchaseDetails/purchaseAddNew.dart';
import 'package:quarry/pages/purchaseDetails/purchasePlantList.dart';
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/bottomBarAddButton.dart';
import 'package:quarry/widgets/editDelete.dart';
import 'package:quarry/widgets/navigationBarIcon.dart';



class PurchaseDetailsGrid extends StatefulWidget {
  VoidCallback? drawerCallback;
  PurchaseDetailsGrid({this.drawerCallback});
  @override
  PurchaseDetailsGridState createState() => PurchaseDetailsGridState();
}

class PurchaseDetailsGridState extends State<PurchaseDetailsGrid> with TickerProviderStateMixin{

  bool showEdit=false;
  int? selectedIndex;


  ScrollController header=new ScrollController();
  ScrollController body=new ScrollController();
  ScrollController verticalLeft=new ScrollController();
  ScrollController verticalRight=new ScrollController();
  bool showShadow=false;

  @override
  void initState() {


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
  GlobalKey <ScaffoldState> scaffoldkey=new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Colors.black
        ),
        child: SafeArea(
          child: Consumer<PurchaseNotifier>(
            builder: (context,pn,child)=>  Stack(
              children: [
                Container(
                  height: 70,
                  width: SizeConfig.screenWidth,
                  color: AppTheme.yellowColor,
                  padding: AppTheme.gridAppBarPadding,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap:widget.drawerCallback,
                        child: NavBarIcon(),
                      ),
                      Text("Purchase Details",
                        style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize:16),
                      ),


                    ],
                  ),
                ),

                Container(
                    height: SizeConfig.screenHeight!-50,
                    width: SizeConfig.screenWidth,
                    margin: EdgeInsets.only(top: 50),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        color: AppTheme.gridbodyBgColor,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))
                    ),
                    child: Stack(
                      children: [

                        //Scrollable
                        Positioned(
                          left:149,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: 50,
                                width: SizeConfig.screenWidth!-149,
                                color: showShadow? AppTheme.bgColor.withOpacity(0.8):AppTheme.bgColor,
                                child: SingleChildScrollView(
                                  controller: header,
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                      children: pn.purchaseGridCol.asMap().
                                      map((i, value) => MapEntry(i, i==0?Container():
                                      Container(
                                          alignment: Alignment.center,
                                          width: 150,
                                          child: Text(value,style: AppTheme.TSWhite166,)
                                      )
                                      )).values.toList()
                                  ),
                                ),

                              ),
                              Container(
                                height: SizeConfig.screenHeight!-140,
                                width: SizeConfig.screenWidth!-149,
                                alignment: Alignment.topCenter,
                                color: AppTheme.gridbodyBgColor,
                                child: SingleChildScrollView(
                                  controller: body,
                                  scrollDirection: Axis.horizontal,
                                  child: Container(
                                    height: SizeConfig.screenHeight!-140,
                                    alignment: Alignment.topCenter,
                                    color: AppTheme.gridbodyBgColor,
                                    child: SingleChildScrollView(
                                      controller: verticalRight,
                                      scrollDirection: Axis.vertical,
                                      child: Column(
                                          children:pn.purchaseGridList.asMap().
                                          map((i, value) => MapEntry(
                                              i,InkWell(
                                            onTap: (){
                                              setState(() {

                                                if(selectedIndex==i){
                                                  selectedIndex=-1;
                                                  showEdit=false;
                                                } else{
                                                  selectedIndex=i;
                                                  showEdit=true;
                                                }


                                              });
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(bottom:i==pn.purchaseGridList.length-1?70: 0),
                                              decoration: BoxDecoration(
                                                border: AppTheme.gridBottomborder,
                                                color: selectedIndex==i?AppTheme.yellowColor:AppTheme.gridbodyBgColor,
                                              ),
                                              height: 50,
                                              // padding: EdgeInsets.only(top: 20,bottom: 20),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    alignment: Alignment.center,
                                                    // padding: EdgeInsets.only(left: 20,right: 20),
                                                    width: 150,
                                                    child: Text("${value.supplierName}",
                                                      style:selectedIndex==i?AppTheme.bgColorTS14:AppTheme.gridTextColor14,
                                                    ),

                                                  ),
                                                  Container(
                                                    alignment: Alignment.center,
                                                    //  padding: EdgeInsets.only(left: 20,right: 20),
                                                    width: 150,
                                                    child: Text(value.expectedDate!=null?"${DateFormat.yMMMd().format(value.expectedDate!)}":"",
                                                      style:selectedIndex==i?AppTheme.bgColorTS14:AppTheme.gridTextColor14,
                                                    ),
                                                  ),
                                                  Container(
                                                    alignment: Alignment.center,
                                                    // padding: EdgeInsets.only(left: 20,right: 20),
                                                    width: 150,
                                                    child: Text("${value.NoOfMaterial.toString()}",
                                                      style:selectedIndex==i?AppTheme.bgColorTS14:AppTheme.gridTextColor14,
                                                    ),

                                                  ),
                                                  Container(
                                                    alignment: Alignment.center,
                                                    width: 150,
                                                    child: Text("${value.TotalQuantity.toString()}",
                                                      style:selectedIndex==i?AppTheme.bgColorTS14:AppTheme.gridTextColor14,
                                                    ),
                                                  ),

                                                  Container(
                                                    width: 150,
                                                    alignment: Alignment.center,
                                                    child: Text("${value.taxAmount.toString()}",
                                                      style:selectedIndex==i?AppTheme.bgColorTS14:AppTheme.gridTextColor14,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 150,
                                                    alignment: Alignment.center,
                                                    child: Text("${value.Subtotal.toString()}",
                                                      style:selectedIndex==i?AppTheme.bgColorTS14:AppTheme.gridTextColor14,
                                                    ),
                                                  ),

                                                  Container(
                                                    width: 150,
                                                    alignment: Alignment.center,
                                                    child: Text("${value.netAmount.toString()}",
                                                      style:selectedIndex==i?AppTheme.bgColorTS14:AppTheme.gridTextColor14,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 150,
                                                    alignment: Alignment.center,
                                                    child: Text("${value.status}",
                                                      style:selectedIndex==i?AppTheme.bgColorTS14:
                                                      TextStyle(fontFamily: 'RR',color:value.status=='Not Yet'? AppTheme.gridTextColor:
                                                          value.status=='Completed'?Colors.green:AppTheme.red,fontSize: 14),
                                                    ),
                                                  ),


                                                ],
                                              ),
                                            ),
                                          )
                                          )
                                          ).values.toList()
                                      ),
                                    ),


                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),


                        //not Scrollable
                        Positioned(
                          left: 0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: 50,
                                width: 150,
                                color: AppTheme.bgColor,
                                alignment: Alignment.center,
                                child: Text("${pn.purchaseGridCol[0]}",style: AppTheme.TSWhite166,),

                              ),
                              Container(
                                height: SizeConfig.screenHeight!-140,
                                alignment: Alignment.topCenter,
                                decoration: BoxDecoration(
                                    color: AppTheme.gridbodyBgColor,
                                    boxShadow: [
                                      showShadow?  BoxShadow(
                                        color: AppTheme.addNewTextFieldText.withOpacity(0.1),
                                        spreadRadius: 0,
                                        blurRadius: 15,
                                        offset: Offset(0, -8), // changes position of shadow
                                      ):BoxShadow(color: Colors.transparent)
                                    ]
                                ),
                                child: Container(
                                  height: SizeConfig.screenHeight!-140,
                                  alignment: Alignment.topCenter,

                                  child: SingleChildScrollView(
                                    controller: verticalLeft,
                                    scrollDirection: Axis.vertical,
                                    child: Column(
                                        children: pn.purchaseGridList.asMap().
                                        map((i, value) => MapEntry(
                                            i,InkWell(
                                          onTap: (){
                                            setState(() {

                                              if(selectedIndex==i){
                                                selectedIndex=-1;
                                                showEdit=false;
                                              } else{
                                                selectedIndex=i;
                                                showEdit=true;
                                              }


                                            });
                                          },
                                          child:  Container(
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.only(bottom:i==pn.purchaseGridList.length-1?70: 0),
                                            decoration: BoxDecoration(
                                              border: AppTheme.gridBottomborder,
                                              color: selectedIndex==i?AppTheme.yellowColor:AppTheme.gridbodyBgColor,
                                            ),
                                            height: 50,
                                            width: 150,
                                            child: Container(
                                              padding: EdgeInsets.only(left: 10,right: 10,top: 3,bottom: 3),

                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(50),
                                                //color:value.invoiceType=='Receivable'? Colors.green:AppTheme.red,
                                              ),
                                              child: FittedBox(
                                                fit: BoxFit.contain,
                                                child: Text("${value.purchaseOrderNumber.toString()}",
                                                    //  style:selectedIndex==i?AppTheme.bgColorTS14:AppTheme.gridTextColorTS,
                                                  style:selectedIndex==i?AppTheme.bgColorTS14:AppTheme.gridTextColor14,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                        )
                                        ).values.toList()


                                    ),
                                  ),


                                ),
                              ),
                            ],
                          ),
                        ),

                        pn.purchaseGridList.isEmpty?Container(
                          width: SizeConfig.screenWidth,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 70,),
                              Text("No Data Found",style: TextStyle(fontSize: 18,fontFamily:'RMI',color: AppTheme.addNewTextFieldText),),
                              SvgPicture.asset("assets/nodata.svg",height: 350,),

                            ],
                          ),
                        ):Container()

                      ],
                    )
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

                                                Navigator.push(context, _createRouteGoodsPlant());
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
                                              pn.GetPurchaseDbHit(context,null);
                                            });
                                          }
                                          else if(picked1!=null && picked1.length ==1){
                                            setState(() {
                                              pn.picked=picked1;
                                              pn.GetPurchaseDbHit(context,null);
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

                                  if(userAccessList[8].isHasAccess){
                                    pn.insertForm();
                                    Navigator.of(context).push(_createRoute());
                                    pn.updatePurchaseEdit(true);
                                    pn.PurchaseDropDownValues(context).then((value) {
                                      pn.GetPurchaseDbHit(context, pn.purchaseGridList[selectedIndex!].purchaseOrderId);
                                      setState(() {
                                        showEdit=false;
                                        selectedIndex=-1;
                                      });
                                    });
                                  }
                                  else{
                                    CustomAlert().accessDenied(context);
                                  }




                                },
                              ),

                              /*AnimatedPositioned(
                                bottom:showEdit?5:-60,
                                duration: Duration(milliseconds: 300,),
                                curve: Curves.bounceOut,
                                child: Container(

                                    width: SizeConfig.screenWidth,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [

                                        GestureDetector(
                                          onTap: (){
                                            pn.insertForm();
                                            Navigator.of(context).push(_createRoute());
                                            pn.updatePurchaseEdit(true);
                                            pn.PurchaseDropDownValues(context).then((value) {
                                              pn.GetPurchaseDbHit(context, pn.purchaseGridList[selectedIndex].purchaseOrderId);
                                              setState(() {
                                                showEdit=false;
                                                selectedIndex=-1;
                                              });
                                            });

                                          },
                                          child:Container(
                                            width: 130,
                                            height: 50,
                                            padding: EdgeInsets.only(left: 20),
                                            child:FittedBox(
                                              child: Container(
                                                  height: 55,
                                                  width: 130,
                                                  alignment: Alignment.centerLeft,
                                                  child: FittedBox(child: Image.asset("assets/bottomIcons/edit-text-icon.png"))
                                              ),
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        Container(
                                          width: 130,
                                          height: 50,
                                          padding: EdgeInsets.only(right: 20),
                                          child:FittedBox(
                                            child: Container(
                                                height: 47,
                                                width: 130,
                                                alignment: Alignment.centerRight,
                                                child: FittedBox(child: Image.asset("assets/bottomIcons/delete-text-icon.png"))
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                ),
                              ),*/

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
                  child: AddButton(
                    ontap: (){
                      if(userAccessList[8].isHasAccess){
                        pn.updatePurchaseView(false);
                        pn.updatePurchaseEdit(false);
                        pn.PlantUserDropDownValues(context);
                        pn.PurchaseDropDownValues(context);
                        pn.insertForm();
                        if(selectedIndex!=-1){
                          setState(() {
                            selectedIndex=-1;
                          });
                        }
                        Navigator.of(context).push(_createRoute());
                      }
                      else{
                        CustomAlert().accessDenied(context);
                      }

                    },
                    image: "assets/svg/plusIcon.svg",
                  ),
                ),




                Container(

                  height: pn.PurchaseLoader? SizeConfig.screenHeight:0,
                  width: pn.PurchaseLoader? SizeConfig.screenWidth:0,
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
      pageBuilder: (context, animation, secondaryAnimation) => PurchaseOrdersAddNew(),

      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        return FadeTransition(
          opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
          child: child,
        );
      },
    );
  }
  Route _createRouteGoodsPlant() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => PurchasePlantList(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        return SlideTransition(
          position: Tween<Offset>(begin: Offset(-1.0,0.0), end: Offset.zero).animate(animation),
          child: child,
        );
      },
    );
  }
}
