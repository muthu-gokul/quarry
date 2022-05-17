import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:quarry/api/ApiManager.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/pages/settings/quarryMaster/plantDetailsGrid.dart';
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quarry/widgets/customTextField.dart';
import 'package:quarry/widgets/logoPicker.dart';
import 'package:quarry/widgets/navigationBarIcon.dart';
import 'package:quarry/widgets/validationErrorText.dart';
import 'plantDetailsAddNew.dart';





class QuaryAddNew extends StatefulWidget {
  VoidCallback? drawerCallback;
  QuaryAddNew({this.drawerCallback});
  @override
  _QuaryAddNewState createState() => _QuaryAddNewState();
}

class _QuaryAddNewState extends State<QuaryAddNew> with TickerProviderStateMixin{

  bool isEdit=false;

  GlobalKey <ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();
  ScrollController? scrollController;
  ScrollController? listViewController;
  double silverBodyTopMargin=0;


  bool _keyboardVisible=false;
  bool isListScroll=false;

  bool emailValid=true;
  bool companyName=false;
  bool address=false;
  bool contactNo=false;
  bool gstNo=false;


  String? imageurl;
  String? imagestring;
  Image? imagefrompreferences;

  Future getImage() async
  {
     XFile? temp=await (ImagePicker().pickImage(source: ImageSource.gallery));
     print(temp);
    if(temp==null)return;
    File tempImage = File(temp.path);
     _cropImage(tempImage);
  }

  _cropImage(File picked) async {
    CroppedFile? cropped = await ImageCropper().cropImage(
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,

        ),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
      sourcePath: picked.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square
      ],
      maxWidth: 400,
      cropStyle: CropStyle.circle,
    );
    if (cropped != null) {
      setState(() {
        Provider.of<QuarryNotifier>(context,listen: false).sampleImage = File(cropped.path);
        Provider.of<QuarryNotifier>(context,listen: false).companyLogoUrl="";
      });
      // uploadImg();
    }

  }

/*
  uploadImg() async{
    final postUri = Uri.parse("${ApiManager().baseUrl}api/Common/Upload?BaseFolder=Company");
    print(postUri);

    http.MultipartRequest request = http.MultipartRequest('POST', postUri);
    List files=[sampleImage];
    for(int i=0;i<1;i++){
      File imageFile = files[i];
      var stream = new http.ByteStream(imageFile.openRead());
      var length = await imageFile.length();

      var multipartFile = new http.MultipartFile("files_1", stream, length,
          filename: imageFile.path.split('/').last);
      // var multipartFile = new http.MultipartFile.fromString("image", imageFile.path);
      request.files.add(multipartFile);
    }

    print(request.files[0].filename);
    print(request.files[0].contentType);
    var response = await request.send();
    final res = await http.Response.fromStream(response);
    print(res.body);

    //image_picker1901717223796553713
  }
*/

  @override
  void initState() {
    isEdit=false;
    WidgetsBinding.instance.addPostFrameCallback((_){


      scrollController=new ScrollController();
      listViewController=new ScrollController();
      setState(() {
        silverBodyTopMargin=0;
      });


    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
   // _keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    final node = FocusScope.of(context);

    return Scaffold(
      key: scaffoldkey,
      resizeToAvoidBottomInset: false,
      body: Consumer<QuarryNotifier>(
                 builder: (context,qn,child)=> Stack(
                   children: [


                     Container(
                       height: SizeConfig.screenHeight,
                       width: SizeConfig.screenWidth,
                       child: Column(
                         children: [
                           Container(
                             width: SizeConfig.screenWidth,
                             height: 205,
                             decoration: BoxDecoration(
                               color: AppTheme.yellowColor,


                             ),
                           child: SvgPicture.asset("assets/svg/gridHeader/companyDetailsHeader.svg"),

                           ),
                         ],
                       ),
                     ),

                     Container(
                       height: SizeConfig.screenHeight,
                       // color: Colors.transparent,
                       child: SingleChildScrollView(
                         physics: NeverScrollableScrollPhysics(),
                         controller: scrollController,
                         child: Column(
                           children: [
                             SizedBox(height: 160,),
                             GestureDetector(
                               onVerticalDragUpdate: (details){

                                 int sensitivity = 5;

                                 if (details.delta.dy > sensitivity) {
                                   scrollController!.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn).then((value){
                                     if(isListScroll){
                                       setState(() {
                                         isListScroll=false;
                                       });
                                     }
                                   });

                                 } else if(details.delta.dy < -sensitivity){
                                   scrollController!.animateTo(100, duration: Duration(milliseconds: 300), curve: Curves.easeIn).then((value){

                                     if(!isListScroll){
                                       setState(() {
                                         isListScroll=true;
                                       });
                                     }
                                   });
                                 }
                               },


                               /*onVerticalDragDown: (v){

                                 if(scrollController.offset==0 && listViewController.offset==0){
                                   scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                 }*/

                              // },
                               child: Container(
                                 height: SizeConfig.screenHeight!-60,
                                 width: SizeConfig.screenWidth,
                                 alignment: Alignment.topCenter,
                                 decoration: BoxDecoration(
                                     color: AppTheme.gridbodyBgColor,
                                     borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                                 ),
                                 child: NotificationListener<ScrollNotification>(
                                   onNotification: (s){
                                     if(s is ScrollStartNotification){

                                       if(listViewController!.offset==0 && isListScroll && scrollController!.offset==100 && listViewController!.position.userScrollDirection==ScrollDirection.idle){

                                         Timer(Duration(milliseconds: 100), (){
                                           if(listViewController!.position.userScrollDirection!=ScrollDirection.reverse){

                                             //if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
                                             if(listViewController!.offset==0){

                                               scrollController!.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn).then((value) {
                                                 if(isListScroll){
                                                   setState(() {
                                                     isListScroll=false;
                                                   });
                                                 }
                                               });
                                             }

                                           }
                                         });
                                       }
                                     }
                                     return true;
                                   } ,
                                   child: ListView(
                                     controller: listViewController,
                                     scrollDirection: Axis.vertical,
                                     physics: isListScroll?AlwaysScrollableScrollPhysics():NeverScrollableScrollPhysics(),

                                     children: [
                                       SizedBox(height:15,),
                                       AddNewLabelTextField(
                                         ontap: (){
                                           scrollController!.animateTo(100, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                                           setState(() {
                                             _keyboardVisible=true;
                                           });
                                         },
                                         labelText: 'Company Name',
                                         isEnabled: isEdit,
                                         regExp: '[A-Za-z  ]',
                                         textEditingController: qn.CD_quarryname,
                                         maxlines: null,
                                         onChange: (v){},
                                         onEditComplete: (){
                                           node.unfocus();
                                           Timer(Duration(milliseconds: 50), (){
                                             setState(() {
                                               _keyboardVisible=false;
                                             });
                                           });
                                         },
                                       ),
                                       !companyName?Container():ValidationErrorText(title: "* Enter Company Name",),
                                       AddNewLabelTextField(
                                         labelText: 'Address',
                                         isEnabled: isEdit,
                                         maxlines: null,
                                         textInputType: TextInputType.text,
                                         scrollPadding: 200,
                                         textEditingController: qn.CD_address,
                                         onChange: (v){},
                                         ontap: (){
                                           scrollController!.animateTo(100, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                                           setState(() {
                                             _keyboardVisible=true;
                                           });
                                         },
                                         onEditComplete: (){
                                           node.unfocus();
                                           Timer(Duration(milliseconds: 50), (){
                                             setState(() {
                                               _keyboardVisible=false;
                                             });
                                           });
                                         },
                                       ),
                                       !address?Container():ValidationErrorText(title: "* Enter Address",),
                                       AddNewLabelTextField(
                                         labelText: 'City',
                                         isEnabled: isEdit,
                                         regExp: '[A-Za-z  ]',
                                         scrollPadding: 200,
                                         textEditingController: qn.CD_city,
                                         onChange: (v){},
                                         ontap: (){
                                           scrollController!.animateTo(100, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                                           setState(() {
                                             _keyboardVisible=true;
                                           });
                                         },
                                         onEditComplete: (){
                                           node.unfocus();
                                           Timer(Duration(milliseconds: 50), (){
                                             setState(() {
                                               _keyboardVisible=false;
                                             });
                                           });
                                         },
                                       ),
                                       AddNewLabelTextField(
                                         labelText: 'State',
                                         isEnabled: isEdit,
                                         regExp: '[A-Za-z  ]',
                                         scrollPadding: 200,
                                         textEditingController: qn.CD_state,
                                         onChange: (v){},
                                         ontap: (){
                                           scrollController!.animateTo(100, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                                           setState(() {
                                             _keyboardVisible=true;
                                             isListScroll=true;
                                           });
                                         },
                                         onEditComplete: (){
                                           node.unfocus();
                                           Timer(Duration(milliseconds: 50), (){
                                             setState(() {
                                               _keyboardVisible=false;
                                             });
                                           });
                                         },
                                       ),
                                       AddNewLabelTextField(
                                         labelText: 'Country',
                                         isEnabled: isEdit,
                                         regExp: '[A-Za-z  ]',
                                         scrollPadding: 200,
                                         textEditingController: qn.CD_country,
                                         onChange: (v){},
                                         ontap: (){
                                           scrollController!.animateTo(100, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                                           setState(() {
                                             _keyboardVisible=true;
                                             isListScroll=true;
                                           });
                                         },
                                         onEditComplete: (){
                                           node.unfocus();
                                           Timer(Duration(milliseconds: 50), (){
                                             setState(() {
                                               _keyboardVisible=false;
                                             });
                                           });
                                         },
                                       ),
                                       AddNewLabelTextField(
                                         labelText: 'ZipCode',
                                         textLength: 6,
                                         regExp: '[0-9]',
                                         isEnabled: isEdit,
                                         textInputType: TextInputType.number,
                                         scrollPadding: 400,
                                         textEditingController: qn.CD_zipcode,
                                         onChange: (v){},
                                         ontap: (){
                                           scrollController!.animateTo(100, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                                           setState(() {
                                             _keyboardVisible=true;
                                             isListScroll=true;
                                           });
                                         },
                                         onEditComplete: (){
                                           node.unfocus();
                                           Timer(Duration(milliseconds: 50), (){
                                             setState(() {
                                               _keyboardVisible=false;
                                             });
                                           });
                                         },
                                       ),
                                       AddNewLabelTextField(
                                         scrollPadding: 500,
                                         textLength: 10,
                                         labelText: 'Contact Number',
                                         regExp: '[0-9]',
                                         isEnabled: isEdit,
                                         textInputType: TextInputType.number,
                                         textEditingController: qn.CD_contactNo,
                                         onChange: (v){},
                                         ontap: (){
                                           scrollController!.animateTo(100, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                                           setState(() {
                                             _keyboardVisible=true;
                                             isListScroll=true;
                                           });
                                         },
                                         onEditComplete: (){
                                           node.unfocus();
                                           Timer(Duration(milliseconds: 50), (){
                                             setState(() {
                                               _keyboardVisible=false;
                                               isListScroll=true;
                                             });
                                           });
                                         },
                                       ),
                                       !contactNo?Container():ValidationErrorText(title: "* Enter Contact Number",),
                                       AddNewLabelTextField(
                                         labelText: 'Email',
                                         isEnabled: isEdit,
                                         textInputType: TextInputType.emailAddress,
                                         textEditingController: qn.CD_email,
                                         scrollPadding: 500,
                                         onChange: (v){},
                                         ontap: (){
                                           scrollController!.animateTo(100, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                                           setState(() {
                                             _keyboardVisible=true;
                                             isListScroll=true;
                                           });
                                         },
                                         onEditComplete: (){
                                           node.unfocus();
                                           Timer(Duration(milliseconds: 50), (){
                                             setState(() {
                                               _keyboardVisible=false;
                                             });
                                           });
                                         },
                                       ),
                                       emailValid?Container():ValidationErrorText(title: "* Invalid Email Address",),
                                       AddNewLabelTextField(
                                         labelText: 'Website',
                                         isEnabled: isEdit,
                                         textEditingController: qn.CD_website,
                                         scrollPadding: 500,
                                         onChange: (v){},
                                         ontap: (){
                                           scrollController!.animateTo(100, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                                           setState(() {
                                             _keyboardVisible=true;
                                             isListScroll=true;
                                           });
                                         },
                                         onEditComplete: (){
                                           node.unfocus();
                                           Timer(Duration(milliseconds: 50), (){
                                             setState(() {
                                               _keyboardVisible=false;
                                               isListScroll=true;
                                             });
                                           });
                                         },
                                       ),

                                       AddNewLabelTextField(
                                         labelText: 'GST No',
                                         isEnabled: isEdit,
                                         regExp: '[A-Za-z0-9]',
                                         scrollPadding: 500,
                                         textEditingController: qn.CD_gstno,
                                         onChange: (v){},
                                         ontap: (){
                                           scrollController!.animateTo(100, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                                           setState(() {
                                             _keyboardVisible=true;
                                           });
                                         },
                                         onEditComplete: (){
                                           node.unfocus();
                                           Timer(Duration(milliseconds: 50), (){
                                             setState(() {
                                               _keyboardVisible=false;
                                             });
                                           });
                                         },
                                       ),
                                       !gstNo?Container():ValidationErrorText(title: "* Enter GST Number",),
                                       AddNewLabelTextField(
                                         labelText: 'PAN No',
                                         isEnabled: isEdit,
                                         scrollPadding: 500,
                                         textEditingController: qn.CD_Panno,
                                         onChange: (v){},
                                         ontap: (){
                                           scrollController!.animateTo(100, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                                           setState(() {
                                             _keyboardVisible=true;
                                           });
                                         },
                                         onEditComplete: (){
                                           node.unfocus();
                                           Timer(Duration(milliseconds: 50), (){
                                             setState(() {
                                               _keyboardVisible=false;
                                             });
                                           });
                                         },
                                       ),
                                       AddNewLabelTextField(
                                         labelText: 'CIN No',
                                         isEnabled: isEdit,
                                         regExp: '[A-Za-z0-9]',
                                         scrollPadding: 500,
                                         textEditingController: qn.CD_Cinno,
                                         onChange: (v){},
                                         ontap: (){
                                           scrollController!.animateTo(100, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                                           setState(() {
                                             _keyboardVisible=true;
                                           });
                                         },
                                         onEditComplete: (){
                                           node.unfocus();
                                           Timer(Duration(milliseconds: 50), (){
                                             setState(() {
                                               _keyboardVisible=false;
                                             });
                                           });
                                         },
                                       ),

                                       SizedBox(height: SizeConfig.height20,),

                                       LogoPicker(
                                           imageUrl: qn.companyLogoUrl,
                                           imageFile: qn.sampleImage,
                                           onCropped: (file){
                                             setState(() {
                                               qn.sampleImage=file;
                                               qn.companyLogoUrl="";
                                             });
                                           }
                                       ),


                                       SizedBox(height: 70),


                                       Container(
                                         height: 70,
                                         width: 70,
                                         decoration: BoxDecoration(
                                             shape: BoxShape.circle,
                                             border: Border.all(color: AppTheme.uploadColor,width: 2)
                                         ),
                                         child: Center(
                                           child: SvgPicture.asset("assets/svg/Planticon.svg",height: 40,width: 40,),
                                         ),
                                       ),
                                       SizedBox(height: SizeConfig.height20,),
                                       Align(
                                         alignment: Alignment.center,
                                         child: Text("Do you want to add Plant?",
                                           style: TextStyle(fontFamily: 'RR',fontSize: 14,color: AppTheme.gridTextColor),
                                         ),
                                       ),
                                       SizedBox(height: SizeConfig.height10,),

                                       GestureDetector(
                                         onTap: (){
                                           if(qn.plantGridList.isEmpty){
                                             Navigator.push(context, _createRoutePlantDetailsAddNew());
                                           }
                                           else{
                                             Navigator.push(context, _createRoute());
                                           }
                                         },
                                         child: Align(
                                           alignment: Alignment.center,
                                           child: Container(
                                             width: 150,
                                             height:45,
                                             decoration: BoxDecoration(
                                               borderRadius: BorderRadius.circular(25.0),
                                               color: AppTheme.yellowColor,
                                               boxShadow: [
                                                 BoxShadow(
                                                   color: AppTheme.yellowColor.withOpacity(0.4),
                                                   spreadRadius: 1,
                                                   blurRadius: 5,
                                                   offset: Offset(1, 8), // changes position of shadow
                                                 ),
                                               ],
                                             ),
                                             child: Center(
                                                 child: Text(qn.plantGridList.isEmpty?"+ Add Plant":"Plants",
                                                   style: TextStyle(color:AppTheme.bgColor,fontSize:16,fontFamily: 'RM'),
                                                 )
                                             ),


                                           ),
                                         ),
                                       ),


                                       SizedBox(height: SizeConfig.height100,)
                                     ],
                                   ),
                                 ),
                               ),
                             )
                           ],
                         ),
                       ),
                     ),


                     Container(
                       height: 60,
                       width: SizeConfig.screenWidth,
                       child: Row(
                         children: [
                           GestureDetector(
                             onTap: widget.drawerCallback,
                             child: NavBarIcon(),
                           ),

                           Text("Company Detail",
                             style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize:16),
                           ),
                           Spacer(),

                         ],
                       ),
                     ),


                     //bottomNav
                     Positioned(
                       bottom: 0,
                       child: Container(
                         width: SizeConfig.screenWidth,
                         height:_keyboardVisible?0: 70,

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
                                     bottom:isEdit?8:-60,
                                     duration: Duration(milliseconds: 300,),
                                     curve: Curves.bounceOut,
                                     child: Container(

                                         width: SizeConfig.screenWidth,
                                         child: Row(
                                           mainAxisAlignment: MainAxisAlignment.center,
                                           crossAxisAlignment: CrossAxisAlignment.end,
                                           children: [
                                             SizedBox(width: SizeConfig.width10,),
                                             GestureDetector(
                                               onTap: (){

                                                 setState(() {
                                                   emailValid=EmailValidation().validateEmail(qn.CD_email.text);
                                                 });

                                                 if(qn.CD_quarryname.text.isEmpty){setState(() {companyName=true;});}
                                                 else{setState(() {companyName=false;});}

                                                 if(qn.CD_address.text.isEmpty){setState(() {address=true;});}
                                                 else{setState(() {address=false;});}

                                                 if(qn.CD_contactNo.text.isEmpty){setState(() {contactNo=true;});}
                                                 else{setState(() {contactNo=false;});}

                                                 if(qn.CD_gstno.text.isEmpty){setState(() {gstNo=true;});}
                                                 else{setState(() {gstNo=false;});}

                                                 if(emailValid && !companyName && !address && !contactNo && !gstNo){
                                                   node.unfocus();

                                                   setState(() {
                                                     isEdit=false;
                                                   });
                                                   qn.UpdateQuarryDetailDbhit(context);

                                                 }

                                               },
                                               child: Container(
                                                 width: 110,
                                             //   height: 40,
                                                /* decoration: BoxDecoration(
                                                     boxShadow: [
                                                       BoxShadow(
                                                         color: AppTheme.yellowColor.withOpacity(0.7),
                                                         spreadRadius: -3,
                                                         blurRadius: 15,
                                                         offset: Offset(0, 7), // changes position of shadow
                                                       )
                                                     ]
                                                 ),*/
                                                 child:FittedBox(child: Image.asset("assets/bottomIcons/update-text-icon.png")),
                                               ),
                                             ),
                                             Spacer(),
                                             GestureDetector(
                                               onTap: (){
                                                 setState(() {
                                                   isEdit=false;
                                                    emailValid=true;
                                                    companyName=false;
                                                    address=false;
                                                    contactNo=false;
                                                    gstNo=false;
                                                 });
                                                 qn.GetQuarryDetailDbhit(context);
                                               },
                                               child: Container(
                                                 width: 110,
                                                 child:FittedBox(
                                                   child: Image.asset("assets/bottomIcons/cancel-text-icon.png")
                                                 ),
                                               ),
                                             ),
                                             SizedBox(width: SizeConfig.width10,),
                                           ],
                                         )
                                     ),
                                   )

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
                       child: GestureDetector(
                         onTap: (){
                             setState(() {
                               isEdit=true;
                             });
                         },
                         child: Container(

                           height:_keyboardVisible?0: 65,
                           width: 65,
                           margin: EdgeInsets.only(bottom: 20),
                           decoration: BoxDecoration(
                             shape: BoxShape.circle,
                             color: AppTheme.yellowColor,
                             boxShadow: [
                               BoxShadow(
                                 color: AppTheme.yellowColor.withOpacity(0.4),
                                 spreadRadius: 1,
                                 blurRadius: 5,
                                 offset: Offset(1, 8), // changes position of shadow
                               ),
                             ],
                           ),
                           child: Center(
                             child:_keyboardVisible?Container(): SvgPicture.asset("assets/svg/edit.svg",color: AppTheme.bgColor,height: 30,width: 30,),
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
            ),
    );
  }


  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => PlantDetailsGrid(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        return FadeTransition(
          opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
          child: child,
        );
      },
    );
  }
  Route _createRoutePlantDetailsAddNew() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => PlantDetailsAddNew(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        return FadeTransition(
          opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
          child: child,
        );
      },
    );
  }
}

