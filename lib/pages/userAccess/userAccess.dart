import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/userAccessNotifier.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/loader.dart';
import 'package:quarry/widgets/navigationBarIcon.dart';
class UserAccess extends StatefulWidget {
  VoidCallback? drawerCallback;
  UserAccess({this.drawerCallback});

  @override
  _UserAccessState createState() => _UserAccessState();
}

class _UserAccessState extends State<UserAccess> {

  ScrollController header=new ScrollController();
  ScrollController body=new ScrollController();

  @override
  void initState() {
    Provider.of<UserAccessNotifier>(context, listen: false).getUserAccess(context);

    header.addListener(() {
      if(body.offset!=header.offset){
        body.jumpTo(header.offset);
      }
    });

    body.addListener(() {
      if(header.offset!=body.offset){
        header.jumpTo(body.offset);
      }
    });
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UserAccessNotifier>(
        builder:(ctx,uan,child)=> Stack(
          children: [
            Container(
              height: SizeConfig.screenHeight,
              width: SizeConfig.screenWidth,
              child: Column(
                children: [
                  Container(
                    height: 50,
                    width: SizeConfig.screenWidth,
                    color: Colors.white,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap:widget.drawerCallback,
                          child: NavBarIcon(),
                        ),
                        Text("User Access"),
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    width: SizeConfig.screenWidth,
                    color: AppTheme.bgColor,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      controller: header,
                      child:Row(
                      children: [
                        Container(
                          width: 180,
                          height: 50,
                          alignment: Alignment.centerLeft,
                          child: Text("   Module",style: AppTheme.TSWhiteML,),
                        ),
                        Container(
                          width: 70,
                          height: 50,
                          alignment: Alignment.centerLeft,
                          child: Text("Actions",style: AppTheme.TSWhiteML),
                        ),
                        Container(
                          width: 90,
                          height: 50,
                          alignment: Alignment.center,
                          child: Text("Super Admin",style: AppTheme.TSWhiteML),
                        ),
                        Container(
                          width: 70,
                          height: 50,
                          alignment: Alignment.center,
                          child: Text("Admin",style: AppTheme.TSWhiteML),
                        ),
                        Container(
                          width: 100,
                          height: 50,
                          alignment: Alignment.center,
                          child: Text("Accounts User",style: AppTheme.TSWhiteML),
                        ),
                        Container(
                          width: 150,
                          height: 50,
                          alignment: Alignment.center,
                          child: Text("Weigh Bridge User",style: AppTheme.TSWhiteML),
                        ),
                      ],
                      )
                    ),
                  ),
                  //{ModuleId: 16, ModuleName: EmployeeAttendance, AccessUrl: api, ModuleAction: View, 1: 1, 2: 1, 3: 1, 4: 1}
                  Container(
                    height: SizeConfig.screenHeight!-100,
                    width: SizeConfig.screenWidth,
                   //  color: AppTheme.bgColor,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      controller: body,
                      child: Container(
                          height: SizeConfig.screenHeight!-100,
                       alignment: Alignment.topCenter,
                       //   width: SizeConfig.screenWidth,
                    //    color: AppTheme.bgColor,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                           // physics: NeverScrollableScrollPhysics(),
                            child: Column(
                                    children: uan.moduleList.asMap().map((key, value) => MapEntry(key,
                                    Container(
                                      height: 50,
                                 //     width: SizeConfig.screenWidth,
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 180,
                                            height: 50,
                                            alignment: Alignment.centerLeft,
                                            child: Text("   ${value['ModuleName']}",style: AppTheme.gridTextColorTS,),
                                          ),
                                          Container(
                                            width: 70,
                                            height: 50,
                                            alignment: Alignment.centerLeft,
                                            child: Text("${value['ModuleAction']}",style: AppTheme.gridTextColorTS),
                                          ),
                                          GestureDetector(
                                            onTap: (){
                                              uan.updateUserAccess(context, value['ModuleId'], 1, value['1']);
                                            },
                                            child: Container(
                                              width: 90,
                                              height: 50,
                                              alignment: Alignment.center,
                                              child: AccessIcon(value: value['1'])
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: (){
                                              uan.updateUserAccess(context, value['ModuleId'], 2, value['2']);
                                            },
                                            child: Container(
                                              width: 70,
                                              height: 50,
                                              alignment: Alignment.center,
                                              child: AccessIcon(value: value['2'])
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: (){
                                              uan.updateUserAccess(context, value['ModuleId'], 3, value['3']);
                                            },
                                            child: Container(
                                              width: 100,
                                              height: 50,
                                              alignment: Alignment.center,
                                              child: AccessIcon(value: value['3'])
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: (){
                                              uan.updateUserAccess(context, value['ModuleId'], 4, value['4']);
                                            },
                                            child: Container(
                                              width: 150,
                                              height: 50,
                                              alignment: Alignment.center,
                                              child: AccessIcon(value: value['4'])
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))).values.toList(),
                                  ),
                          ),
                        ),

                    ),

                  ),
                ],
              ),
            ),
            Loader(
              isLoad: uan.isLoad,
            )
          ],
        ),
      ),
    );
  }
}

class AccessIcon extends StatelessWidget {
  int value;
  AccessIcon({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 25,
        width: 25,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: value==1?Color(0xFF60C6AD):Colors.grey[300]
        ),
        alignment: Alignment.center,
        child: value==1?Icon(Icons.done,color: Colors.white,size: 18,):
                        Icon(Icons.clear,color: Colors.grey,),
        //child: Text("${value['1']}",style: AppTheme.gridTextColorTS)
    );
  }
}

