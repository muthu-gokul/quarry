import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';

class PopUpSearchOnly extends StatefulWidget {

  bool isOpen;
  TextEditingController searchController;
  String searchHintText;


  List<dynamic> dataList;
  String propertyKeyName;
  String propertyKeyId;
  int selectedId;

  Function(String) searchOnchange;
  Function(int) itemOnTap;
  VoidCallback closeOnTap;
  //VoidCallback addNewOnTap;

  PopUpSearchOnly({this.isOpen,@required this.searchController,@required this.searchOnchange,this.itemOnTap,this.dataList,
    this.propertyKeyName,this.propertyKeyId,this.selectedId,this.closeOnTap,this.searchHintText});

  @override
  _PopUpSearchOnlyState createState() => _PopUpSearchOnlyState();
}

class _PopUpSearchOnlyState extends State<PopUpSearchOnly> {
  ScrollController listController=new ScrollController();

  @override
  Widget build(BuildContext context) {
    //print(widget.dataList.length);
    return Align(
      alignment: Alignment.center,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
        width: SizeConfig.screenWidth,
        // height: SizeConfig.screenHeight*0.65,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.transparent,
        ),
        clipBehavior: Clip.antiAlias,
        padding: EdgeInsets.only(top: 20,bottom: 20,),
        margin: EdgeInsets.only(left: SizeConfig.width25,right: SizeConfig.width25),
        transform: Matrix4.translationValues(widget.isOpen?0:SizeConfig.screenWidth, 0, 0),
        child: Stack(
          children: [

            Container(

              height: SizeConfig.screenHeight*0.63,

              width: SizeConfig.screenWidth,
              margin: EdgeInsets.only(left: SizeConfig.width16,right: SizeConfig.width16,top: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white
              ),
              child: Column(
                children: [
                  Container(
                    height: 50,
                    width: SizeConfig.screenWidth,
                    margin: EdgeInsets.only(left: SizeConfig.width20,right: SizeConfig.width20,top: 25,bottom: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.addNewTextFieldText.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 15,
                            offset: Offset(0, 0), // changes position of shadow
                          )
                        ]
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: SizeConfig.width10,),
                        Icon(Icons.search,color: AppTheme.hintColor,),
                        SizedBox(width: SizeConfig.width10,),
                        Container(
                          width: SizeConfig.screenWidth*0.45,
                          child: TextField(
                            controller: widget.searchController,
                            scrollPadding: EdgeInsets.only(bottom: 400),
                            style:  TextStyle(fontFamily: 'RR',fontSize: 15,color:AppTheme.addNewTextFieldText,letterSpacing: 0.2),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                focusedErrorBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                hintText: widget.searchHintText,
                                hintStyle: AppTheme.hintText
                            ),
                            onChanged: (v){
                              widget.searchOnchange(v);

                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: SizeConfig.screenHeight*0.63- 120,
                    width: SizeConfig.screenWidth-SizeConfig.width60,
                    color: Colors.white,
                    padding: EdgeInsets.only(right: 5,left: 5),
                    child:widget.dataList.isEmpty?Container(
                      width: SizeConfig.screenWidth*0.8,
                      height: SizeConfig.screenHeight*0.2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          Text("No Data Found",style: TextStyle(fontSize: 18,fontFamily:'RMI',color: AppTheme.addNewTextFieldText),),
                          SvgPicture.asset("assets/nodata.svg",height:SizeConfig.screenHeight*0.3 ,),

                        ],
                      ),
                    ):  RawScrollbar(
                      isAlwaysShown: false,
                      thumbColor: AppTheme.srollBarColor,
                      radius: Radius.circular(AppTheme.scrollBarRadius),
                      thickness: AppTheme.scrollBarThickness,
                      controller: listController,
                      child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: widget.dataList.length,
                          controller: listController,
                          itemBuilder: (context,index){
                            return GestureDetector(
                              onTap: (){
                                widget.itemOnTap(index);



                              },
                              child: Container(
                                margin: EdgeInsets.only(left: SizeConfig.width40,right:  SizeConfig.width40,top: 20),
                                padding: EdgeInsets.only(left:5,right:5),

                                height: 40,
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: AppTheme.addNewTextFieldBorder),
                                    color: widget.selectedId==null ?Color(0xFFf8f8f8):widget.selectedId==widget.dataList[index].get(widget.propertyKeyId)?AppTheme.bgColor:Colors.white
                                ),
                                child: Center(
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: Text("${widget.dataList[index].get(widget.propertyKeyName)}",style: TextStyle(fontFamily: 'RR',fontSize: 16,
                                        color: widget.selectedId==null ?AppTheme.bgColor:widget.selectedId==widget.dataList[index].get(widget.propertyKeyId)?Colors.white:AppTheme.bgColor

                                    ),),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),


                ],
              ),

            ),
            Positioned(
              right: 8,
              child: GestureDetector(
                onTap: (){
                  widget.closeOnTap();

                },
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.bgColor
                  ),
                  child: Center(
                    child: Icon(Icons.clear,color: AppTheme.yellowColor,size: 18,),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
