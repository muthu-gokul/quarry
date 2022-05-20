
import 'dart:io';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';

class CustomAlert{
  VoidCallback? callback;
  VoidCallback? Cancelcallback;
  CustomAlert({this.callback,this.Cancelcallback});

  // void show(BuildContext context,String text,int duration){
  //  showDialog(
  //    barrierDismissible: true,
  //     context: context,
  //     builder: (ctx) {
  //       Future.delayed(Duration(milliseconds: duration), () {
  //         Navigator.of(context).pop(true);
  //       });
  //      return Scaffold(
  //        backgroundColor: Colors.transparent,
  //        body: Center(
  //          child: GestureDetector(
  //            onTap: (){
  //              // Navigator.of(ctx).pop(true);
  //            },
  //            child: Container(
  //              height: 500,
  //              width: SizeConfig.screenWidth*0.8,
  //              decoration: BoxDecoration(
  //                borderRadius: BorderRadius.circular(10),
  //                color: Colors.black.withOpacity(0.3)
  //              ),
  //              child: Center(
  //                  child: Text(text,style: TextStyle(color: Colors.white,fontSize: 100,fontFamily: 'QR'),textAlign: TextAlign.center,)
  //              ),
  //
  //             ),
  //          ),
  //        ),
  //      );
  //     }
  //   );
  // }

  void selectTableAlert(BuildContext context,String img,String title){
    showDialog(
        context: context,
        builder: (ctx) => Dialog(
          child: Container(
              height:250,
              width:400,
              decoration:BoxDecoration(
                color:Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),

              child:Column(
                  children:[
                    SvgPicture.asset(img),
                    SizedBox(height:10),
                    Text(title,
                        style:TextStyle(fontFamily:'RR',fontSize:20,color:Color(0xFF787878)))
                  ]
              )
          ),
        )

    );
  }

  void commonErrorAlert(BuildContext context,String title,String des){
    showDialog(
        context: context,
        builder: (ctx) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Container(
              // height:des.length>50?400:280,
              // width:400,
              decoration:BoxDecoration(
                color:Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: EdgeInsets.all(15),
              constraints: BoxConstraints(
                minHeight: 100,
                maxHeight: 400
              ),
              child:Column(
                mainAxisSize: MainAxisSize.min,
                  children:[
                    SvgPicture.asset('assets/svg/error-icon.svg'),
                    SizedBox(height:30),
                    Text("$title",
                        style:TextStyle(fontFamily:'RM',fontSize:22,color:AppTheme.red),textAlign: TextAlign.center,
                    ),
                    SizedBox(height:10),
                    Flexible(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Text("$des",
                            style:TextStyle(fontFamily:'RL',fontSize:18,color:Color(0xFF787878)),textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ]
              )
          ),
        )

    );
  }
  void accessDenied(BuildContext context,{String title="Access Denied"}){
    showDialog(
        context: context,
        builder: (ctx) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Container(
              height:250,
              width:400,
              decoration:BoxDecoration(
                color:Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),

              child:Column(
                  children:[
                    SizedBox(height:10),
                    SvgPicture.asset('assets/svg/error-icon.svg'),
                    SizedBox(height:30),
                    Text(title,
                        style:TextStyle(fontFamily:'RM',fontSize:22,color:AppTheme.red),textAlign: TextAlign.center,
                    ),
                    SizedBox(height:10),
                  ]
              )
          ),
        )

    );
  }
  void accessDenied2({String title="Access Denied"}){
    showDialog(
        context: Get.context!,
        builder: (ctx) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Container(
              height:250,
              width:400,
              decoration:BoxDecoration(
                color:Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),

              child:Column(
                  children:[
                    SizedBox(height:10),
                    SvgPicture.asset('assets/svg/error-icon.svg'),
                    SizedBox(height:30),
                    Text(title,
                        style:TextStyle(fontFamily:'RM',fontSize:22,color:AppTheme.red),textAlign: TextAlign.center,
                    ),
                    SizedBox(height:10),
                  ]
              )
          ),
        )

    );
  }
  void commonErrorAlert2(BuildContext context,String title,String des){
    showDialog(
        context: context,
        builder: (ctx) => Dialog(
          child: Container(
              // height:title.length>100?450:280,
              // width:400,
              decoration:BoxDecoration(
                color:Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: EdgeInsets.all(15),
              child:Column(
                mainAxisSize: MainAxisSize.min,
                  children:[
                    SizedBox(height:10),
                    SvgPicture.asset('assets/svg/error-icon.svg'),
                    SizedBox(height:30),
                    Text(title,
                      style:TextStyle(fontFamily:'RM',fontSize:18,color:AppTheme.red),textAlign: TextAlign.center,
                    ),
                    SizedBox(height:10),
                    Text(des,
                      style:TextStyle(fontFamily:'RL',fontSize:16,color:Color(0xFF787878)),textAlign: TextAlign.center,
                    ),
                  ]
              )
          ),
        )

    );
  }

  void billSuccessAlert(BuildContext context,String img,String title,String des,String amt){
    showDialog(
      barrierDismissible: false,
        context: context,
        builder: (ctx)
           {
             Future.delayed(Duration(seconds: 3), () {
               Navigator.of(context).pop(true);
             });
            return Dialog(
        child: Container(
            height: 420,
            width: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),

            child: Column(
                children: [
                  SizedBox(height: 10),
                  // SvgPicture.asset(img),
                  Image.asset("assets/images/sucess.gif"),
                  // SizedBox(height: 30),
                  Text(title,
                    style: TextStyle(fontFamily: 'RM',
                        fontSize: 18,
                        color: Color(0xFF0C9A6A)), textAlign: TextAlign.center,
                  ),
                  // SizedBox(height: 10),
                  // Text(des,
                  //   style: TextStyle(fontFamily: 'RL',
                  //       fontSize: 20,
                  //       color: Color(0xFF787878)), textAlign: TextAlign.center,
                  // ), SizedBox(height: 10),
                  // Text(amt,
                  //   style: TextStyle(fontFamily: 'RB',
                  //       fontSize: 22,
                  //       color: Color(0xFF787878)), textAlign: TextAlign.center,
                  // ),
                ]
            )
        ),
      );
           }


    );
  }

  void dynamicTableErrorAlert(BuildContext context,String img,String title,String des){
    showDialog(
        context: context,
        builder: (ctx) => Dialog(
          child: Container(
              height:270,
              width:400,
              decoration:BoxDecoration(
                color:Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),

              child:Padding(
                padding: const EdgeInsets.only(left:10,right: 10),
                child: Column(
                    children:[
                      SizedBox(height:10),
                      SvgPicture.asset(img),
                      // SizedBox(height:10),
                      Text(title,
                          style:TextStyle(fontFamily:'RM',fontSize:22,color:AppTheme.red),textAlign: TextAlign.center,
                      ),
                      SizedBox(height:15),
                      Text(des,
                          style:TextStyle(fontFamily:'RL',fontSize:18,color:Color(0xFF787878)),textAlign: TextAlign.center,
                      ),
                    ]
                ),
              )
          ),
        )

    );
  }
  void dialogWithCallBack(BuildContext context,String img,String title,String des){
    showDialog(
        context: context,
        builder: (ctx) => Dialog(
          child: Container(
              height:330,
              width:400,
              decoration:BoxDecoration(
                color:Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),

              child:Column(
                  children:[
                    SizedBox(height:20),
                    // SvgPicture.asset(img),
                    Image.asset("assets/errors/bill-popup.png"),
                    SizedBox(height:20),
                    Text(title,
                        style:TextStyle(fontFamily:'RR',fontSize:23,color:Color(0xFF787878))),
                    GestureDetector(
                      onTap: callback,
                      child: Container(
                        height: 60.0,
                        width: 120.0,
                        margin: EdgeInsets.only(bottom: 20,top:20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppTheme.red,
                            boxShadow: [
                              BoxShadow(
                                color:AppTheme.red.withOpacity(0.6),
                                offset: const Offset(0, 8.0),
                                blurRadius: 15.0,
                                // spreadRadius: 2.0,
                              ),
                            ]
                        ),
                        child: Center(
                          child: Text("Done",
                            style: TextStyle(fontFamily:'RR',color: Colors.white,fontSize: 16),
                          ),
                        ),
                      ),
                    )

                  ]
              )
          ),
        )

    );
  }

  void yesOrNoDialog(BuildContext context,String img,String title,){
    showDialog(
      barrierDismissible: false,
        context: context,
        builder: (ctx) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),
          child: Container(
              height:400,
              width:400,
        //      padding: EdgeInsets.only(top: 20,bottom: 20),
              decoration:BoxDecoration(
                color:Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),

              child:Column(
                  children:[
                    SizedBox(height:25),
                    // SvgPicture.asset(img),
                    Image.asset("assets/images/delete.jpg"),
                    SizedBox(height:20),
                    Text(title, style:TextStyle(fontFamily:'RR',fontSize:20,color:Color(0xFF787878)),textAlign: TextAlign.center,),

                    SizedBox(height:10),
                    GestureDetector(
                      onTap: callback,
                      child: Container(
                        height: 50.0,
                        width: SizeConfig.width120,
                        margin: EdgeInsets.only(bottom: 20,top:20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppTheme.red,
                        ),
                        child: Center(
                          child: Text("Delete",
                            style: TextStyle(fontFamily:'RR',color: Colors.white,fontSize: 20),
                          ),
                        ),
                      ),
                    ),


                    GestureDetector(
                      onTap: Cancelcallback,
                      child: Container(
                        height: 30.0,
                        width: SizeConfig.width100,
                        child: Center(
                          child: Text("Cancel",
                            style: TextStyle(fontFamily:'RR',color: Color(0xFF8d8d8d),fontSize: 20),
                          ),
                        ),
                      ),
                    ),



                  ]
              )
          ),
        )

    );
  }

  void confirmDialog(String title,){
    showDialog(
      barrierDismissible: false,
        context: Get.context!,
        builder: (ctx) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),
          child: Container(
              // height:400,
              // width:400,
              padding: EdgeInsets.only(top: 20,bottom: 20),
              decoration:BoxDecoration(
                color:Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child:Column(
                mainAxisSize: MainAxisSize.min,
                  children:[
                    SizedBox(height:25),
                    // SvgPicture.asset(img),
                    Image.asset("assets/bottomIcons/exclamation-mark.png",height: 80,),

                    SizedBox(height:20),
                    Text(title, style:TextStyle(fontFamily:'RR',fontSize:20,color:Color(0xFF787878)),textAlign: TextAlign.center,),

                    SizedBox(height:10),
                    GestureDetector(
                      onTap: callback,
                      child: Container(
                        height: 50.0,
                        width: SizeConfig.width120,
                        margin: EdgeInsets.only(bottom: 20,top:20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppTheme.red,
                        ),
                        child: Center(
                          child: Text("Confirm",
                            style: TextStyle(fontFamily:'RR',color: Colors.white,fontSize: 20),
                          ),
                        ),
                      ),
                    ),


                    GestureDetector(
                      onTap: Cancelcallback,
                      child: Container(
                        height: 30.0,
                        width: SizeConfig.width100,
                        child: Center(
                          child: Text("Cancel",
                            style: TextStyle(fontFamily:'RR',color: Color(0xFF8d8d8d),fontSize: 20),
                          ),
                        ),
                      ),
                    ),



                  ]
              )
          ),
        )

    );
  }
  void networkIssue(BuildContext context,String text,int duration){
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (ctx) {
          if(duration>0){
            Future.delayed(Duration(milliseconds: duration), () {
              Navigator.of(ctx).pop(true);
            });
          }

          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: GestureDetector(
                onTap: (){
                  Navigator.of(ctx).pop(true);
                },
                child: Container(
                  height: 350,
                  width: 400,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black.withOpacity(0.3)
                  ),
                  child: Center(
                      child: Text(text,style: TextStyle(color: Colors.white,fontSize: 100,fontFamily: 'QR'),textAlign: TextAlign.center,)
                  ),

                ),
              ),
            ),
          );
        }
    );
  }
  void getPremiumAlert(BuildContext context){
    showDialog(
        context: context,
        builder: (ctx) => Dialog(
          child: Container(
              height:300,
              width:450,
              decoration:BoxDecoration(
                color:Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),

              child:Column(
                  children:[
                    SizedBox(height:35),
                    SvgPicture.asset('assets/errors/premium-icon.svg'),
                    SizedBox(height:20),
                    Text("Get Premium",
                      style:TextStyle(fontFamily:'RM',fontSize:50,color:Color(0xFF666878)),textAlign: TextAlign.center,
                    ),
                    SizedBox(height:10),
                    RichText(
                      text: TextSpan(
                          text: 'Access for Exciting ',
                          style: TextStyle(fontFamily:'RR',fontSize:20,color:Color(0xFF797983)),
                          children: <TextSpan>[
                            TextSpan(text: 'Features',
                                style: TextStyle(fontFamily:'RR',fontSize:19,color:AppTheme.red),

                            )
                          ]
                      ),
                    ),
                    // Text("Access for Exciting Features",
                    //   style:TextStyle(fontFamily:'RR',fontSize:20,color:Color(0xFF797983)),textAlign: TextAlign.center,
                    // ),
                  ]
              )
          ),
        )

    );
  }


  void deletePopUp(){
    showDialog(
        barrierDismissible: true,
        context: Get.context!,
        builder: (ctx)
        {
          /*Future.delayed(Duration(seconds: 3), () {
            Navigator.of(context).pop(true);
          });*/
          return Dialog(
            child: Container(
                // height: 420,
                width: 300,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 10),
                      // SvgPicture.asset(img),
                      Image.asset("assets/images/sucess.gif"),
                      // SizedBox(height: 30),
                      Text("Deleted Successfully",
                        style: TextStyle(fontFamily: 'RM',
                            fontSize: 22,
                            color: Color(0xFF0C9A6A)), textAlign: TextAlign.center,
                      ),
                      // SizedBox(height: 10),
                      // Text(des,
                      //   style: TextStyle(fontFamily: 'RL',
                      //       fontSize: 20,
                      //       color: Color(0xFF787878)), textAlign: TextAlign.center,
                      // ), SizedBox(height: 10),
                      // Text(amt,
                      //   style: TextStyle(fontFamily: 'RB',
                      //       fontSize: 22,
                      //       color: Color(0xFF787878)), textAlign: TextAlign.center,
                      // ),
                    ]
                )
            ),
          );
        }


    );
  }
}


