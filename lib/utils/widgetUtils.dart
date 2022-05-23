import 'dart:io';

import 'package:flutter/material.dart';

import '../styles/app_theme.dart';
import '../styles/size.dart';

// ignore: must_be_immutable
class ProfileAvatar extends StatelessWidget {
  String imageUrl;
  File? imageFile;
  double radius;
  ProfileAvatar({Key? key,required this.imageUrl,required this.imageFile,this.radius=120}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: radius,
      width: radius,
      decoration: BoxDecoration(
        color: AppTheme.avatarBorderColor,
        shape: BoxShape.circle
      ),
      alignment: Alignment.center,
      child: Container(
        height: radius-3,
        width: radius-3,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
          color: Colors.white
        ),
        alignment: Alignment.center,
        clipBehavior: Clip.antiAlias,
        child: imageFile!=null?Image.file(imageFile!,):
        Image.network(imageUrl,
          errorBuilder: (a,b,c){
            return Image.asset("assets/svg/drawer/avatar.png",height: radius-3,width: radius-3,fit: BoxFit.cover,);
          },
          fit: BoxFit.cover,
          height: radius-3, width: radius-3
        ),
      ),
    );
  }
}
class LogoAvatar extends StatelessWidget {
  String imageUrl;
  File? imageFile;
  double radius;
  double height;
  LogoAvatar({Key? key,required this.imageUrl,required this.imageFile,this.radius=100,this.height=100}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: radius,
      decoration: BoxDecoration(
        color: AppTheme.avatarBorderColor,
        //shape: BoxShape.circle
      ),
      alignment: Alignment.center,
      child: Container(
        height: height-3,
        width: radius-3,
        decoration: BoxDecoration(
            //shape: BoxShape.circle,
          color: Colors.white
        ),
        alignment: Alignment.center,
        clipBehavior: Clip.antiAlias,
        child: imageFile!=null?Image.file(imageFile!,):
        Image.network(imageUrl,
          errorBuilder: (a,b,c){
            return Image.asset("assets/svg/drawer/avatar.png",height: height-3,width: radius-3,fit: BoxFit.cover,);
          },
          fit: BoxFit.contain,
          height: height-3, width: radius-3
        ),
      ),
    );
  }
}



class AddNewLayout extends StatefulWidget {
  Widget child;
  Widget actionWidget;
  String image;
  AddNewLayout({required this.child,required this.actionWidget,this.image="assets/images/saleFormheader.jpg"});

  @override
  State<AddNewLayout> createState() => _AddNewLayoutState();
}

class _AddNewLayoutState extends State<AddNewLayout> {
  ScrollController? silverController;
  double silverBodyTopMargin=0;

  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((_){
      silverController=new ScrollController();

      setState(() {
        silverBodyTopMargin=0;
      });

      silverController!.addListener(() {
        if(silverController!.offset>150){
          setState(() {
            silverBodyTopMargin=50-(-(silverController!.offset-200));
            if(silverBodyTopMargin<0){
              silverBodyTopMargin=0;
            }
          });
        }
        else if(silverController!.offset<170){
          setState(() {
            silverBodyTopMargin=0;
          });
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      controller: silverController,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            elevation: 0,
            toolbarHeight: 50,
            backgroundColor: AppTheme.yellowColor,
            leading: Container(),
            actions: [
              widget.actionWidget
            ],
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  height: 200,
                  width: SizeConfig.screenWidth,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(widget.image,),
                          fit: BoxFit.cover
                      )
                  ),
                )
            ),
          ),
        ];
      },
      body: Container(
        width: SizeConfig.screenWidth,
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.only(top: silverBodyTopMargin),
        padding: EdgeInsets.only(top: 0,bottom: 30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
          //color: Color(0xFFF6F7F9),
          color: Colors.white,
        ),
        child: widget.child
      ),
    );
  }
}


