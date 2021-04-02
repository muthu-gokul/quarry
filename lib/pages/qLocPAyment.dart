import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/styles/size.dart';

class QLOCPayment extends StatefulWidget {
  @override
  _QLOCPaymentState createState() => _QLOCPaymentState();
}

class _QLOCPaymentState extends State<QLOCPayment> {
  @override
  Widget build(BuildContext context) {
    return Consumer<QuarryNotifier>(
        builder: (context,qn,child)=>AnimatedContainer(
      width: SizeConfig.screenWidth,
      height: SizeConfig.screenHeight,
      duration: Duration(milliseconds: 300),
      color:Colors.white,

      transform: Matrix4.translationValues(
          qn.isQLOCPaymentOpen? 0 : SizeConfig.screenWidth, 0, 0),
          child: Column(
            children: [
              Container(
                height: SizeConfig.height50,
                width: SizeConfig.screenWidth,
                child: Row(
                  children: [
                    IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
                      qn.updateQLOCPayment(false);

                    }),
                    // SizedBox(width: SizeConfig.width5,),
                    Text("Quarry/Add New ",
                      style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize: SizeConfig.width16),
                    ),
                    Text("/ Payment Methods",
                      style: TextStyle(fontFamily: 'RR',color: Color(0xFF367BF5),fontSize: SizeConfig.width16),
                    ),
                  ],
                ),
              ),
              SizedBox(height: SizeConfig.height50,),
              Padding(
                padding:  EdgeInsets.all(SizeConfig.width10),
                child: RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(children: <TextSpan>[
                    TextSpan(
                        text:  "Please Select your Payment method, you can select ",
                        style: TextStyle(color: Colors.grey,fontFamily: 'RR',fontSize: 16)),
                    TextSpan(
                        text: "multiple ",
                        style: TextStyle( color: Color(0xFF367BF5),fontFamily: 'RB',fontSize: 16)),
                    TextSpan(
                        text: "payment methods.",
                        style: TextStyle(color: Colors.grey,fontFamily: 'RR',fontSize: 16)),
                  ]),
                ),
              ),
              Wrap(
                children: qn.paymentList.asMap().map((i, element) => MapEntry(i, GestureDetector(
                onTap: (){
                  if(qn.paymentListSelected.contains(i)){
                   setState(() {
                     qn.paymentListSelected.remove(i);
                   });
                  }else{
                   setState(() {
                     qn.paymentListSelected.add(i);
                   });
                  }

                },
                child: Container(
                  height: SizeConfig.height50,
                  width: SizeConfig.screenWidth,
                  margin: EdgeInsets.all(SizeConfig.width10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.grey),
                    color: qn.paymentListSelected.contains(i)?Color(0xFF367BF5):Colors.transparent
                  ),
                  child: Center(
                    child: Text(qn.paymentList[i],
                    style: TextStyle(fontFamily: 'RR',fontSize:SizeConfig.width16,color: qn.paymentListSelected.contains(i)?Colors.white:Colors.grey),),
                  ),
                ),
                )
                )
                ).values.toList(),
              )
            ],
          ),
        )
    );
  }
}
