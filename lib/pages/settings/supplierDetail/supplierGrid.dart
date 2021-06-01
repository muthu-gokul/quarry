import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/supplierNotifier.dart';
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/bottomBarAddButton.dart';
import 'package:quarry/widgets/editDelete.dart';
import 'package:quarry/widgets/navigationBarIcon.dart';
import 'package:quarry/widgets/staticColumnScroll/customDataTable.dart';
import 'supplierAddNew.dart';


class SupplierDetailsGrid extends StatefulWidget {
  VoidCallback drawerCallback;
  SupplierDetailsGrid({this.drawerCallback});
  @override
  SupplierDetailsGridState createState() => SupplierDetailsGridState();
}

class SupplierDetailsGridState extends State<SupplierDetailsGrid> with TickerProviderStateMixin{

  bool showEdit=false;
  int selectedIndex;

  List<String> gridDataRowList=["SupplierName","SupplierCategoryName","Location","SupplierContactNumber"];

  //width
  double categoryWidth=0.0;
  GlobalKey categoryKey= GlobalKey();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Colors.black
        ),
        child: SafeArea(
          child: Consumer<SupplierNotifier>(
            builder: (context,sn,child)=>  Stack(
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
                      Text("Supplier Details",
                        style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize: SizeConfig.width16),
                      ),
                      Spacer(),

                    ],
                  ),
                ),

                CustomDataTable(
                  topMargin: 50,
                  gridBodyReduceHeight: 140,
                  selectedIndex: selectedIndex,
                  gridCol: sn.supplierGridCol,
                  gridData:sn.supplierGridList,
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
                            size: Size( SizeConfig.screenWidth, 65),
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


                                      GestureDetector(
                                        onTap: () async{

                                          var excel = Excel.createExcel();
                                          Sheet sheetObject = excel['Supplier Details'];
                                          excel.delete('Sheet1');

                                          CellStyle cellStyle = CellStyle( fontFamily : getFontFamily(FontFamily.Calibri),bold: true);


                                          List<String> header=[];
                                          int ascii=65;
                                          sn.supplierGridCol.forEach((element) {
                                            var cell = sheetObject.cell(CellIndex.indexByString("${String.fromCharCode(ascii)}1"));
                                            cell.cellStyle = cellStyle;
                                            ascii++;
                                            header.add(element);

                                          });
                                          sheetObject.insertRowIterables(header, 0,);

                                          List<String> body=[];
                                          for(int i=0;i<sn.supplierGridList.length;i++){
                                            body.clear();
                                            gridDataRowList.forEach((element) {
                                              body.add(sn.supplierGridList[i].get(element)==null?"":sn.supplierGridList[i].get(element).toString());

                                            });
                                            sheetObject.insertRowIterables(body, i+1,);
                                          }



                                          final String dirr ='/storage/emulated/0/Download/Quarry/Masters';

                                          String filename="Supplier Details";
                                          await Directory('/storage/emulated/0/Download/Quarry/Masters').create(recursive: true);
                                          final String path = '$dirr/$filename.xlsx';


                                          final File file = File(path);

                                          await file.writeAsBytes(await excel.encode()).then((value) async {
                                            //  OpenFile.open(path);
                                            CustomAlert().billSuccessAlert(context, "", "Successfully Downloaded @ \n\n Internal Storage/Download/Quarry/Masters/$filename.xlsx", "", "");
                                          });

                                        },
                                        child: SvgPicture.asset("assets/svg/excel.svg",width: 30,height: 30,),                                          //    color: qn.selectedIndex==-1? AppTheme.bgColor.withOpacity(0.5):isOpen?AppTheme.bgColor:AppTheme.bgColor.withOpacity(0.5),
                                      ),
                                      SizedBox(width: 20,)



                                    ],
                                  ),
                                ),
                              ),

                              EditDelete(
                                showEdit: showEdit,
                                editTap: (){
                                  sn.updateSupplierEdit(true);
                                  sn.clearForm();
                                  sn.SupplierDropDownValues(context).then((value){
                                    sn.GetSupplierDbHit(context, sn.supplierGridList[selectedIndex].supplierId,SupplierDetailAddNewState());
                                    setState(() {
                                      showEdit=false;
                                      selectedIndex=-1;
                                    });
                                  });

                                  Navigator.of(context).push(_createRoute());

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
                Align(
                  alignment: Alignment.bottomCenter,
                  child: AddButton(
                    ontap: (){
                      sn.updateSupplierEdit(false);
                      sn.SupplierDropDownValues(context);
                      Navigator.of(context).push(_createRoute());
                    },
                    image: "assets/svg/plusIcon.svg",
                  ),
                ),





                Container(

                  height: sn.SupplierLoader? SizeConfig.screenHeight:0,
                  width: sn.SupplierLoader? SizeConfig.screenWidth:0,
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
      pageBuilder: (context, animation, secondaryAnimation) => SupplierDetailAddNew(),
      //pageBuilder: (context, animation, secondaryAnimation) => QuaryAddNew(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        return FadeTransition(
          opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
          child: child,
        );
      },
    );
  }
}
