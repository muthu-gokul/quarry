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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<UserAccessNotifier>(context, listen: false).getUserAccess(context);
    });


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

  double width1=110.0;


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
                    color: AppTheme.yellowColor,
                    child: Row(
                      children: [
                        CancelButton(
                          ontap: (){
                            Navigator.pop(context);
                          },
                          bgColor: AppTheme.bgColor,
                          iconColor: Colors.white,
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
                        for(int i=0;i<uan.headerList.length;i++)
                          Container(
                          width: width1,
                          height: 50,
                          alignment: Alignment.center,
                          child: Text("${uan.headerList[i]['UserGroupName']}",style: AppTheme.TSWhiteML),
                        ),
                      ],
                      )
                    ),
                  ),

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
                                            for(int z=0;z<uan.headerList.length;z++)
                                              GestureDetector(
                                              onTap: (){
                                                if(uan.headerList[z]['UserGroupId']==uan.restrictedUserGroupId){
                                                  CustomAlert().accessDenied(context,title: "Can't disable any privilege of ${uan.headerList[z]['UserGroupName']}..");
                                                }
                                                else{
                                                  if(userAccessMap[8]??false){
                                                    uan.updateUserAccess(context, value.parent['ModuleId'], uan.headerList[z]['UserGroupId'], value.parent[uan.headerList[z]['UserGroupId'].toString()]);
                                                  }
                                                  else{
                                                    CustomAlert().accessDenied(context);
                                                  }
                                                }
                                              },
                                              child: Container(
                                                  width: width1,
                                                  height: 50,
                                                  alignment: Alignment.center,
                                                  child: AccessIcon(value: value.parent[uan.headerList[z]['UserGroupId'].toString()])
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
                                              for(int y=0;y<uan.headerList.length;y++)
                                              GestureDetector(
                                                onTap: (){
                                                  if(uan.headerList[y]['UserGroupId']==uan.restrictedUserGroupId){
                                                    CustomAlert().accessDenied(context,title: "Can't disable any privilege of ${uan.headerList[y]['UserGroupName']}..");
                                                  }
                                                  else{
                                                    if(userAccessMap[8]??false){
                                                      uan.updateUserAccess(context, value.children[i]['ModuleId'], uan.headerList[y]['UserGroupId'], value.children[i][uan.headerList[y]['UserGroupId'].toString()]);
                                                    }
                                                    else{
                                                      CustomAlert().accessDenied(context);
                                                    }
                                                  }
                                                },
                                                child: Container(
                                                    width: width1,
                                                    height: 50,
                                                    alignment: Alignment.center,
                                                    child: AccessIcon(value: value.children[i][uan.headerList[y]['UserGroupId'].toString()])
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

