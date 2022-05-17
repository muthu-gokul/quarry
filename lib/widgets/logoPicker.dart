import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quarry/utils/widgetUtils.dart';

import '../styles/app_theme.dart';

class LogoPicker extends StatelessWidget {
  String imageUrl;
  File? imageFile;
  Function(File) onCropped;
  String description;
  String btnTitle;
  LogoPicker({required this.imageUrl,this.imageFile,required this.onCropped,this.description="Upload Your Company Logo",this.btnTitle="Choose File"});


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ProfileAvatar(imageUrl: imageUrl, imageFile: imageFile,radius: 80,),
        SizedBox(height: 20,),
        Align(
          alignment: Alignment.center,
          child: Text(description,
            style: TextStyle(fontFamily: 'RR',fontSize: 14,color: AppTheme.gridTextColor),
          ),
        ),
        SizedBox(height: 10,),
        GestureDetector(
          onTap: (){
            getImage(onCropped);
          },
          child:  Align(
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
                  child: Text(btnTitle,style: TextStyle(color:AppTheme.bgColor,fontSize:16,fontFamily: 'RM'),
                  )
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Future getImage( Function(File) onCropped) async
{
  XFile? temp=await (ImagePicker().pickImage(source: ImageSource.gallery));
  if(temp==null)return;
  File tempImage = File(temp.path);
  _cropImage(tempImage,onCropped);
}

_cropImage(File picked,Function(File) onCropped) async {
  CroppedFile? croppedFile = await ImageCropper().cropImage(
    sourcePath: picked.path,
    aspectRatioPresets: [
      CropAspectRatioPreset.square,

    ],
    uiSettings: [
      AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.red,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          showCropGrid: false,
        hideBottomControls: true
      ),
      IOSUiSettings(
        title: 'Crop Image',
      ),
    ],
    cropStyle: CropStyle.circle,
    maxWidth: 400
  );
  if (croppedFile != null) {
    onCropped(File(croppedFile.path));
  }
  // CroppedFile? cropped = await ImageCropper().cropImage(
  //   uiSettings: AndroidUiSettings(
  //       statusBarColor: Colors.red,
  //       toolbarColor: Colors.red,
  //       toolbarTitle: "Crop Image",
  //       toolbarWidgetColor: Colors.white,
  //       showCropGrid: false,
  //       hideBottomControls: true
  //   ),
  //   sourcePath: picked.path,
  //   aspectRatioPresets: [
  //     CropAspectRatioPreset.square
  //   ],
  //   maxWidth: 400,
  //   cropStyle: CropStyle.circle,
  // );
  // if (cropped != null) {
  //   onCropped(cropped);
  // }
}