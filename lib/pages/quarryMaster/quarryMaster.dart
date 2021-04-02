import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';

import 'quarryLocationAddNew.dart';

class QuarryMaster extends StatefulWidget {
  VoidCallback drawerCallback;
  QuarryMaster({this.drawerCallback});
  @override
  _QuarryMasterState createState() => _QuarryMasterState();
}

class _QuarryMasterState extends State<QuarryMaster> {

  // @override
  // void didChangeDependencies() {
  //   Provider.of<QuarryNotifier>(context,listen: false).GetQuarryDetailDbhit(context);
  //   // Provider.of<QuarryNotifier>(context,listen: false).initDropDownValues(context);
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
            statusBarColor: AppTheme.yellowColor
        ),
        child: SafeArea(
          child: Consumer<QuarryNotifier>(
            builder: (context,qn,child)=>  Stack(
              children: [
                Container(
                  height: SizeConfig.height50,
                  width: SizeConfig.screenWidth,
                  child: Row(
                    children: [
                      IconButton(icon: Icon(Icons.menu), onPressed: widget.drawerCallback),
                      SizedBox(width: SizeConfig.width20,),
                      Text("Quarry Master",
                        style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize: SizeConfig.width16),
                      ),
                      Spacer(),

                    ],
                  ),
                ),
                Container(
                  height: SizeConfig.screenHeight-SizeConfig.height50,
                  width: SizeConfig.screenWidth,
                  margin: EdgeInsets.only(top: SizeConfig.height50),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child:DataTable(
                      headingRowColor:  MaterialStateColor.resolveWith((states) => Color(0xFF367BF5)),
                      showBottomBorder: true,
                      columns: qn.quarryLocGridCol.map((e) => DataColumn(

                        label: Text(e,style: TextStyle(fontFamily: 'RB',fontSize: 16,color: Colors.white),),

                      )).toList(),

                      rows: qn.quarryLocGridList.map((e) => DataRow(cells: [
                        DataCell(Text(e.quarryname,style: TextStyle(fontFamily: 'RR',fontSize: 14,color: Colors.black),),),
                        DataCell(Text(e.location,style: TextStyle(fontFamily: 'RR',fontSize: 14,color: Colors.black),),),
                        DataCell(Text(e.quarryInCharge,style: TextStyle(fontFamily: 'RR',fontSize: 14,color: Colors.black),),),
                        DataCell(Text(e.contactNo,style: TextStyle(fontFamily: 'RR',fontSize: 14,color: Colors.black),),),
                        DataCell(Text(e.email,style: TextStyle(fontFamily: 'RR',fontSize: 14,color: Colors.black),),),
                        DataCell(Text(e.noOfGates,style: TextStyle(fontFamily: 'RR',fontSize: 14,color: Colors.black),),),
                        DataCell(Text(e.quarrySize,style: TextStyle(fontFamily: 'RR',fontSize: 14,color: Colors.black),),),
                      ]
                      )
                      ).toList(),




                    )

                  ),
                ),

                Positioned(
                  bottom: 20,
                  right: 20,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: (){
                      Navigator.of(context).push(_createRoute());



                    },
                    child: Container(
                      margin: EdgeInsets.only(right: SizeConfig.width10),
                      height: SizeConfig.width50,
                      width: SizeConfig.width50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF367BF5),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF367BF5).withOpacity(0.4),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(1, 8), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(Icons.add,size: SizeConfig.height30,color: Colors.white,),
                      ),
                    ),
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
      pageBuilder: (context, animation, secondaryAnimation) => QuarryLocationAddNew(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        return FadeTransition(
          opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
          child: child,
        );
      },
    );
  }
}
