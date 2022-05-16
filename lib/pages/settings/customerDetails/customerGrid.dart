import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/customerNotifier.dart';
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/constants.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/bottomBarAddButton.dart';
import 'package:quarry/widgets/editDelete.dart';
import 'package:quarry/widgets/navigationBarIcon.dart';
import 'package:quarry/widgets/staticColumnScroll/customDataTable.dart';

import 'customerAddNew.dart';



class CustomerMaster extends StatefulWidget {
  VoidCallback? drawerCallback;
  CustomerMaster({this.drawerCallback});
  @override
  _CustomerMasterState createState() => _CustomerMasterState();
}

class _CustomerMasterState extends State<CustomerMaster> {

  bool showEdit=false;
  int selectedIndex=-1;
  List<String> gridDataRowList=["CustomerName","Location","CustomerContactNumber","CustomerEmail","CustomerCreditLimit"];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<CustomerNotifier>(context,listen: false).GetCustomerDetailDbhit(context,null);
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
          child: Consumer<CustomerNotifier>(
            builder: (ctx,qn,child)=>  Stack(
              children: [
                Container(
                  height: 70,
                  padding: EdgeInsets.only(bottom: 15),
                  width: SizeConfig.screenWidth,
                  color: AppTheme.yellowColor,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap:widget.drawerCallback,
                          child: NavBarIcon()
                      ),

                      Text("Customer Master",
                        style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize:16),
                      ),
                      Spacer(),

                    ],
                  ),
                ),

                CustomDataTable(
                  topMargin: 50,
                  gridBodyReduceHeight: 140,
                  selectedIndex: selectedIndex,
                  gridCol: qn.customerGridCol,
                  gridData: qn.customerGridList,
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


                                      GestureDetector(
                                        onTap: () async{

                                          var excel = Excel.createExcel();
                                          Sheet sheetObject = excel['Customer Details'];
                                          excel.delete('Sheet1');

                                          CellStyle cellStyle = CellStyle( fontFamily : getFontFamily(FontFamily.Calibri),bold: true);


                                          List<String> header=[];
                                          int ascii=65;
                                          qn.customerGridCol.forEach((element) {
                                            var cell = sheetObject.cell(CellIndex.indexByString("${String.fromCharCode(ascii)}1"));
                                            cell.cellStyle = cellStyle;
                                            ascii++;
                                              header.add(element);

                                          });
                                          sheetObject.insertRowIterables(header, 0,);

                                          List<String> body=[];
                                          for(int i=0;i<qn.customerGridList.length;i++){
                                            body.clear();
                                            gridDataRowList.forEach((element) {
                                              body.add(qn.customerGridList[i].get(element)==null?"":qn.customerGridList[i].get(element).toString());

                                            });
                                            sheetObject.insertRowIterables(body, i+1,);
                                          }



                                          final String dirr ='/storage/emulated/0/Download/Quarry/Masters';

                                          String filename="Customer Details";
                                          await Directory('/storage/emulated/0/Download/Quarry/Masters').create(recursive: true);
                                          final String path = '$dirr/$filename.xlsx';


                                          final File file = File(path);

                                          await file.writeAsBytes(await excel.encode()!).then((value) async {
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
                                  qn.updateCustomerEdit(true);
                                  qn.GetCustomerDetailDbhit(context, qn.customerGridList[selectedIndex].CustomerId);
                                  Navigator.of(context).push(_createRoute());
                                  setState(() {
                                    showEdit=false;
                                    selectedIndex=-1;
                                  });
                                },
                                deleteTap: (){
                                  CustomAlert(
                                      callback: (){
                                        Navigator.pop(context);
                                        qn.deleteById(qn.customerGridList[selectedIndex].CustomerId!);
                                        setState(() {
                                          showEdit=false;
                                          selectedIndex=-1;
                                        });
                                      },
                                      Cancelcallback: (){
                                        Navigator.pop(context);
                                      }
                                  ).yesOrNoDialog(context, "", "Are you sure want to delete this Customer ?");
                                },
                                hasEditAccess: userAccessMap[14]??false,
                                hasDeleteAccess: userAccessMap[15]??false,
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
                    //  Provider.of<CustomerNotifier>(context,listen: false).GetCustomerDetailDbhit(context,null);
                      qn.updateCustomerEdit(false);
                      Navigator.of(context).push(_createRoute());
                    },
                    image: "assets/svg/plusIcon.svg",
                    hasAccess: userAccessMap[13]??false,
                  ),
                ),





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
          ),
        ),
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => CustomerDetailAddNew(false),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        return FadeTransition(
          opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
          child: child,
        );
      },
    );
  }
}
