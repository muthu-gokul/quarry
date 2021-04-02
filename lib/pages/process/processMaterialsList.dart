import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/styles/size.dart';

class ProcessMaterialList extends StatefulWidget {
  @override
  _ProcessMaterialListState createState() => _ProcessMaterialListState();
}

class _ProcessMaterialListState extends State<ProcessMaterialList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<QuarryNotifier>(
          builder: (context,qn,child)=>AnimatedContainer(
            width:SizeConfig.screenWidth,
            height:SizeConfig.screenHeight,
            duration: Duration(milliseconds: 300),
            color:Colors.white,
            transform: Matrix4.translationValues(
                qn.isProcessMaterialOpen? 0 : SizeConfig.screenWidth, 0, 0),
            child: Column(
              children: [
                Container(
                  height: SizeConfig.height50,
                  width: SizeConfig.screenWidth,
                  child: Row(
                    children: [
                      IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
                        qn.updateProcessMaterialOpen(false);

                      }),
                      // SizedBox(width: SizeConfig.width5,),
                      Text("Material Processed/ ",
                        style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize: SizeConfig.width16),
                      ),
                      Text("Materials",
                        style: TextStyle(fontFamily: 'RR',color: Color(0xFF367BF5),fontSize: SizeConfig.width16),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: SizeConfig.height50,),
                // Padding(
                //   padding:  EdgeInsets.all(SizeConfig.width10),
                //   child: RichText(
                //     textAlign: TextAlign.left,
                //     text: TextSpan(children: <TextSpan>[
                //       TextSpan(
                //           text:  "Please Select your materials, you can select ",
                //           style: TextStyle(color: Colors.grey,fontFamily: 'RR',fontSize: 16)),
                //       TextSpan(
                //           text: "multiple ",
                //           style: TextStyle( color: Color(0xFF367BF5),fontFamily: 'RB',fontSize: 16)),
                //       TextSpan(
                //           text: "Materials.",
                //           style: TextStyle(color: Colors.grey,fontFamily: 'RR',fontSize: 16)),
                //     ]),
                //   ),
                // ),
                // SizedBox(height: SizeConfig.height20,),
                Wrap(

                  children: qn.processMaterialList.asMap().map((i, element) => MapEntry(i, GestureDetector(
                    onTap: (){
                      qn.updateMaterialSelected(i);

                    },
                    child: Container(
                      height: SizeConfig.height50,
                      margin: EdgeInsets.all(SizeConfig.width5),
                      padding: EdgeInsets.all(SizeConfig.width10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.grey),
                          color: qn.MaterialSelected==i?Color(0xFF367BF5):Colors.transparent
                      ),
                      child: Text(qn.processMaterialList[i],
                        style: TextStyle(fontFamily: 'RR',fontSize:SizeConfig.width16,color: qn.MaterialSelected==i?Colors.white:Colors.grey),),
                    ),
                  )
                  )
                  ).values.toList(),
                ),
                SizedBox(height: SizeConfig.height20,),
                // InkWell(
                //   onTap: (){
                //
                //   },
                //   child: Text("+ Add New Materials",
                //     style: TextStyle(fontFamily: 'RR',fontSize:SizeConfig.width16,color:Color(0xFF367BF5)),),
                // ),

              ],
            ),
          )

    );
  }
}
