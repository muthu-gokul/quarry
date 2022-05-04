import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../styles/app_theme.dart';

class LogoPicker extends StatelessWidget {
  String imageUrl;
  File? imageFile;
  Function(File) onCropped;
  String description;
  String btnTitle;
  LogoPicker({required this.imageUrl,this.imageFile,required this.onCropped,this.description="Upload Your Company Logo",this.btnTitle="Choose File"});

  Future getImage() async
  {
    XFile? temp=await (ImagePicker().pickImage(source: ImageSource.gallery));
    if(temp==null)return;
    File tempImage = File(temp.path);
    _cropImage(tempImage);
  }

  _cropImage(File picked) async {
    File? cropped = await ImageCropper().cropImage(
      androidUiSettings: AndroidUiSettings(
          statusBarColor: Colors.red,
          toolbarColor: Colors.red,
          toolbarTitle: "Crop Image",
          toolbarWidgetColor: Colors.white,
          showCropGrid: false,
          hideBottomControls: true
      ),
      sourcePath: picked.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square
      ],
      maxWidth: 400,
      cropStyle: CropStyle.circle,
    );
    if (cropped != null) {
      onCropped(cropped);
      /*setState(() {
        Provider.of<QuarryNotifier>(context,listen: false).sampleImage = cropped;
        Provider.of<QuarryNotifier>(context,listen: false).companyLogoUrl="";
      });*/
      // uploadImg();
    }

  }


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.uploadColor,width: 2)
          ),
          clipBehavior: Clip.antiAlias,
          child: imageUrl.isEmpty? Center(
              child: imageFile!=null? Image.file(imageFile!):
              SvgPicture.asset("assets/svg/upload.svg",height: 30,width: 30,)
          ):Center(
            child: Image.network(imageUrl,fit: BoxFit.cover,),
          ),
        ),
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
            getImage();
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
