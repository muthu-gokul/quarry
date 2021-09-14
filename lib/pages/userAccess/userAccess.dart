import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/userAccessNotifier.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/constants.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/bottomBarAddButton.dart';
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
                        CancelButton(
                          ontap: (){
                            Navigator.pop(context);
                          },
                          bgColor: AppTheme.bgColor,
                          iconColor: Colors.white,
                        ),
                        /*GestureDetector(
                          onTap:widget.drawerCallback,
                          child: NavBarIcon(),
                        ),*/
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
                  /*Container(
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

                  ),*/
                  Container(
                    height: SizeConfig.screenHeight!-100,
                    width: SizeConfig.screenWidth,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      controller: body,
                      child: Container(
                        height: SizeConfig.screenHeight!-100,
                        alignment: Alignment.topCenter,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: uan.data.asMap().map((key, value) => MapEntry(key,
                                AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeIn,
                                  height:value.isOpen?((value.children.length)*50)+50: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                          border: AppTheme.gridBottomborder
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 180,
                                              height: 50,
                                             // alignment: Alignment.centerLeft,
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  value.children.isEmpty?Container(

                                                    margin: EdgeInsets.only(left: 5,right: 5),
                                                  ):
                                                  GestureDetector(
                                                    onTap:(){
                                                      setState(() {
                                                        value.isOpen=!value.isOpen;
                                                      });
                                                    },
                                                    child: Container(
                                                      height: 30,
                                                      width: 30,
                                                      margin: EdgeInsets.only(left: 5,right: 5),
                                                      decoration: BoxDecoration(
                                                        color: AppTheme.bgColor,
                                                        shape: BoxShape.circle
                                                      ),
                                                      child: Center(
                                                        child: Icon( value.isOpen?Icons.remove:Icons.add,color: Colors.white,size: 16,),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 130,
                                                      height: 50,
                                                      alignment: Alignment.centerLeft,
                                                      child: Text("${value.parent['ModuleName']}",
                                                        style: AppTheme.gridTextColorTS,
                                                      )
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: 70,
                                              height: 50,
                                              alignment: Alignment.centerLeft,
                                              child: Text("${value.parent['ModuleAction']}",style: AppTheme.gridTextColorTS),
                                            ),
                                            GestureDetector(
                                              onTap: (){
                                                if(userAccessList[3].isHasAccess){
                                                  uan.updateUserAccess(context, value.parent['ModuleId'], 1, value.parent['1']);
                                                }
                                                else{
                                                  CustomAlert().accessDenied(context,);
                                                }

                                              },
                                              child: Container(
                                                  width: 90,
                                                  height: 50,
                                                  alignment: Alignment.center,
                                                  child: AccessIcon(value: value.parent['1'])
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: (){
                                                if(userAccessList[3].isHasAccess){
                                                  uan.updateUserAccess(context, value.parent['ModuleId'], 2, value.parent['2']);
                                                }
                                                else{
                                                  CustomAlert().accessDenied(context);
                                                }
                                              },
                                              child: Container(
                                                  width: 70,
                                                  height: 50,
                                                  alignment: Alignment.center,
                                                  child: AccessIcon(value: value.parent['2'])
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: (){
                                                if(userAccessList[3].isHasAccess){
                                                  uan.updateUserAccess(context, value.parent['ModuleId'], 3, value.parent['3']);
                                                }
                                                else{
                                                  CustomAlert().accessDenied(context);
                                                }

                                              },
                                              child: Container(
                                                  width: 100,
                                                  height: 50,
                                                  alignment: Alignment.center,
                                                  child: AccessIcon(value: value.parent['3'])
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: (){
                                                if(userAccessList[3].isHasAccess){
                                                  uan.updateUserAccess(context, value.parent['ModuleId'], 4, value.parent['4']);
                                                }
                                                else{
                                                  CustomAlert().accessDenied(context);
                                                }
                                              },
                                              child: Container(
                                                  width: 150,
                                                  height: 50,
                                                  alignment: Alignment.center,
                                                  child: AccessIcon(value: value.parent['4'])
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      for(int i=0;i<value.children.length;i++)
                                        Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                              border: AppTheme.gridBottomborder
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 180,
                                                height: 50,
                                              ),
                                              Container(
                                                width: 70,
                                                height: 50,
                                                alignment: Alignment.centerLeft,
                                                child: Text("${value.children[i]['ModuleAction']}",style: AppTheme.gridTextColorTS),
                                              ),
                                              GestureDetector(
                                                onTap: (){
                                                  if(userAccessList[3].isHasAccess){
                                                    uan.updateUserAccess(context, value.children[i]['ModuleId'], 1, value.children[i]['1']);
                                                  }
                                                  else{
                                                    CustomAlert().accessDenied(context);
                                                  }
                                                },
                                                child: Container(
                                                    width: 90,
                                                    height: 50,
                                                    alignment: Alignment.center,
                                                    child: AccessIcon(value: value.children[i]['1'])
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: (){
                                                  if(userAccessList[3].isHasAccess){
                                                    uan.updateUserAccess(context, value.children[i]['ModuleId'], 2, value.children[i]['2']);
                                                  }
                                                  else{
                                                    CustomAlert().accessDenied(context);
                                                  }
                                                },
                                                child: Container(
                                                    width: 70,
                                                    height: 50,
                                                    alignment: Alignment.center,
                                                    child: AccessIcon(value: value.children[i]['2'])
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: (){
                                                  if(userAccessList[3].isHasAccess){
                                                    uan.updateUserAccess(context, value.children[i]['ModuleId'], 3, value.children[i]['3']);
                                                  }
                                                  else{
                                                    CustomAlert().accessDenied(context);
                                                  }
                                                },
                                                child: Container(
                                                    width: 100,
                                                    height: 50,
                                                    alignment: Alignment.center,
                                                    child: AccessIcon(value: value.children[i]['3'])
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: (){
                                                  if(userAccessList[3].isHasAccess){
                                                    uan.updateUserAccess(context, value.children[i]['ModuleId'], 4, value.children[i]['4']);
                                                  }
                                                  else{
                                                    CustomAlert().accessDenied(context);
                                                  }
                                                },
                                                child: Container(
                                                    width: 150,
                                                    height: 50,
                                                    alignment: Alignment.center,
                                                    child: AccessIcon(value: value.children[i]['4'])
                                                ),
                                              ),
                                            ],
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

