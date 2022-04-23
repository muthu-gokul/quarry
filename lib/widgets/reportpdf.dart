
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart' as material;
import 'package:provider/provider.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/widgets/alertDialog.dart';

reportView(context,String mailid,int saleIndex) async {

  // int saleIndex;
  print(saleIndex);
  //int customerIndex;
  var qn=Provider.of<QuarryNotifier>(context,listen: false);

 // customerIndex=qn.customersList.indexWhere((element) => element.CustomerId==qn.saleDetailsGrid[saleIndex].CustomerId).toInt();

 // print(customerIndex);


  final pw.Document pdf = pw.Document();
  pdf.addPage(
    pw.Page(
      build: (pw.Context context) => pw.Center(
        child: pw.Container(
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.black)
          ),
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              pw.Container(
                // height: 70,
                decoration: pw.BoxDecoration(
                  border:pw.Border(bottom: pw.BorderSide(color: PdfColors.black))
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Container(
                      // height: 70,
                      width: 160,


                      child:
                      pw.Text(" GST: ${qn.CD_gstno.text??""}"),
                      // pw.Spacer(),

                    ),
                    pw.Container(
                      //  height: 70,
                        width: 200,

                        alignment: pw.Alignment.topCenter,
                        child:
                        pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            pw.Text("TAX INVOICE",style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 16),textAlign: pw.TextAlign.center),
                            pw.Text("${qn.CD_quarryname.text??""}",style: pw.TextStyle(),textAlign: pw.TextAlign.center),
                            pw.Text("${qn.CD_address.text??""}",textAlign: pw.TextAlign.center),
                            pw.Text("${qn.CD_city.text??""},${qn.CD_state.text??""}",textAlign: pw.TextAlign.center),
                          ]
                        ),

                    ),
                    pw.Container(
                       // height: 70,
                        width: 120,

                        child:
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          children: [
                            pw.Text("MOBILE: ${qn.CD_contactNo.text??""}")
                          ]
                        ),

                    ),
                  ]
                )

              ),
              // pw.Container(
              //   width: 200,
              //   height: 200,
              //   color: PdfColors.blue,
              //   child: pw.Row(
              //       children: [
              //         pw.Container(
              //             width: 70,
              //             child: pw.Text("Address  :")
              //         ),
              //         pw.Container(
              //           width: 150,
              //           height: 200,
              //           color: PdfColors.red,
              //           child: pw.Text("SRI MAHALAKSHMI RHYNO ROBUST SANDS PVT LTD",style: pw.TextStyle(),textAlign: pw.TextAlign.center),
              //          // child: pw.Text("SY NO 154/1B Kushthanapalli(village),Sevaganapalli(post),",textAlign: pw.TextAlign.center),
              //           // child: pw.Text("SY NO 154/1B Kushthanapalli(village),Sevaganapalli(post),Hosur,TamilNadu"
              //           //     ,style: pw.TextStyle(),textAlign: pw.TextAlign.left)
              //         ),
              //       ]
              //   ),
              // ),


              pw.Table(
                  defaultColumnWidth: pw.FixedColumnWidth(240),
                  border: pw.TableBorder.all(
                          color: PdfColors.black,
                          width: 1
                  ),
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: pw.EdgeInsets.all(10),
                          child: pw.Text("Invoice No     : ${qn.saleDetailsGrid[saleIndex].SaleNumber}"),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(10),
                          child:pw.Text("Transport Mode : ${qn.saleDetailsGrid[saleIndex].VehicleTypeName??""}"),
                        ),

                      ]
                    ),

                    pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: pw.EdgeInsets.all(10),
                            child: pw.Text("Invoice Date   : ${qn.saleDetailsGrid[saleIndex].SaleDate}"),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(10),
                            child:pw.Text("Vehicle No     : ${qn.saleDetailsGrid[saleIndex].VehicleNumber}"),
                          ),

                        ]
                    ),

                    pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: pw.EdgeInsets.all(10),
                            child: pw.Text("State   : ${qn.CD_state.text??""}"),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(10),
                            child:pw.Text("Date of Supply : ${qn.saleDetailsGrid[saleIndex].SaleDate}"),
                          ),

                        ]
                    ),

                    pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: pw.EdgeInsets.all(10),
                            child: pw.Text("Billed To   : ${qn.saleDetailsGrid[saleIndex].customerName??""}"),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(10),
                            child:pw.Text("PO No/Order No :"),
                          ),

                        ]
                    ),

                    pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: pw.EdgeInsets.all(10),
                            child: pw.Text("Name     : ${qn.saleDetailsGrid[saleIndex].customerName??""}"),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(10),
                            child:pw.Text("Delivery To :"),
                          ),

                        ]
                    ),

                    pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: pw.EdgeInsets.all(10),
                            child: pw.Container(
                              child: pw.Row(
                                  children: [
                                    pw.Container(
                                        width: 70,
                                        child: pw.Text("Address  :")
                                    ),
                                    pw.Container(
                                      width: 150,
                                      child:  pw.Text("${qn.saleDetailsGrid[saleIndex].customerAddress??""} \n ${qn.saleDetailsGrid[saleIndex].customerCity??""},${qn.saleDetailsGrid[saleIndex].customerState??""}",
                                          style: pw.TextStyle(),textAlign: pw.TextAlign.left)
                                      // child: pw.Text("SY NO 154/1B Kushthanapalli(village),Sevaganapalli(post),Hosur,TamilNadu"
                                      //     ,style: pw.TextStyle(),textAlign: pw.TextAlign.left)
                                    ),
                                  ]
                              ),
                            )
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(10),
                            child:pw.Row(
                                children: [
                                  pw.Container(
                                      width: 70,
                                      child: pw.Text("Address  :")
                                  ),
                                  pw.Container(
                                      width: 150,
                                      child: pw.Text("")
                                  ),
                                ]
                            ),
                          ),

                        ]
                    ),


                    pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: pw.EdgeInsets.all(10),
                            child: pw.Text("GSTIN     : ${qn.saleDetailsGrid[saleIndex].customerGstNumber??""}"),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(10),
                            child:pw.Text("GSTIN     :"),
                          ),

                        ]
                    ),

                    pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: pw.EdgeInsets.all(10),
                            child: pw.Text("State      : ${qn.saleDetailsGrid[saleIndex].customerState??""}"),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(10),
                            child:pw.Text("State      :"),
                          ),

                        ]
                    ),

                    pw.TableRow(
                        children: [
                          // pw.Padding(
                          //   padding: pw.EdgeInsets.all(10),
                          //   child:
                            pw.Row(
                              children: [
                                pw.Container(
                                  width: 50,
                                  height: 40,

                                  decoration: pw.BoxDecoration(
                                    border: pw.Border(right: pw.BorderSide(color: PdfColors.black))
                                  ),
                                  child: pw.Center(
                                    child: pw.Text('S.No')
                                  )
                                ),

                                pw.Container(
                                    width: 110,
                                    height: 40,
                                    decoration: pw.BoxDecoration(
                                        border: pw.Border(right: pw.BorderSide(color: PdfColors.black))
                                    ),
                                    child: pw.Center(
                                      child: pw.Text('Name of Product')
                                    )
                                ),
                                pw.Container(
                                    width: 80,
                                    height: 40,

                                    child: pw.Center(
                                      child: pw.Text('HSN Code')
                                    )
                                ),
                              ]
                            ),
                          // ),
                          pw.Row(
                                children: [
                                  pw.Container(
                                      width: 70,
                                      height: 40,
                                      decoration: pw.BoxDecoration(
                                          border: pw.Border(right: pw.BorderSide(color: PdfColors.black))
                                      ),
                                      child: pw.Center(
                                        child: pw.Text('Quantity')
                                      )
                                  ),
                                  pw.Container(
                                      width: 70,
                                      height: 40,
                                      decoration: pw.BoxDecoration(
                                          border: pw.Border(right: pw.BorderSide(color: PdfColors.black))
                                      ),
                                      child: pw.Center(
                                        child: pw.Text('Rate')
                                      )
                                  ),
                                  pw.Container(
                                      width: 70,
                                      height: 40,
                                      child: pw.Center(
                                        child: pw.Text('Amount Rs')
                                      )
                                  ),
                                ]
                            ),


                        ]
                    ),


                    pw.TableRow(
                        children: [
                          // pw.Padding(
                          //   padding: pw.EdgeInsets.all(10),
                          //   child:
                          pw.Row(
                              children: [
                                pw.Container(
                                    width: 50,
                                    height: 70,

                                    decoration: pw.BoxDecoration(
                                        border: pw.Border(right: pw.BorderSide(color: PdfColors.black))
                                    ),
                                    child: pw.Center(
                                        child: pw.Text('1')
                                    )
                                ),

                                pw.Container(
                                    width: 110,
                                    height: 70,
                                    decoration: pw.BoxDecoration(
                                        border: pw.Border(right: pw.BorderSide(color: PdfColors.black))
                                    ),
                                    child: pw.Center(
                                        child: pw.Text('${qn.saleDetailsGrid[saleIndex].MaterialName}')
                                    )
                                ),
                                pw.Container(
                                    width: 80,
                                    height: 70,
//Material HSN
                                    child: pw.Center(
                                        child: pw.Text('${qn.saleDetailsGrid[saleIndex].MaterialHSNCode}')
                                    )
                                ),
                              ]
                          ),
                          // ),
                          pw.Row(
                              children: [
                                pw.Container(
                                    width: 70,
                                    height: 70,
                                    decoration: pw.BoxDecoration(
                                        border: pw.Border(right: pw.BorderSide(color: PdfColors.black))
                                    ),
                                    child: pw.Center(
                                        child: pw.Text('${qn.saleDetailsGrid[saleIndex].OutputMaterialQty} ${qn.saleDetailsGrid[saleIndex].UnitName}')
                                    )
                                ),
                                pw.Container(
                                    width: 70,
                                    height: 70,
                                    decoration: pw.BoxDecoration(
                                        border: pw.Border(right: pw.BorderSide(color: PdfColors.black))
                                    ),
                                    child: pw.Center(
                                        child: pw.Text('${qn.saleDetailsGrid[saleIndex].MaterialUnitPrice}')
                                    )
                                ),
                                pw.Container(
                                    width: 70,
                                    height: 70,
                                    child: pw.Center(
                                        child: pw.Text('${qn.saleDetailsGrid[saleIndex].OutputQtyAmount}')
                                    )
                                ),
                              ]
                          ),

                        ]
                    ),



                    pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: pw.EdgeInsets.all(10),
                            child: pw.Text("Amount In Words  : ${qn.saleDetailsGrid[saleIndex].AmountInWords??""}"),
                          ),

                          pw.Container(
                            child: pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              children: [
                                pw.Container(
                                  height: 30,
                                  child: pw.Row(
                                    children: [
                                      pw.Container(
                                        height: 30,
                                        width: 140,
                                        padding: pw.EdgeInsets.only(left: 10),
                                        alignment: pw.Alignment.centerLeft,
                                        decoration: pw.BoxDecoration(
                                            border: pw.Border(right: pw.BorderSide(color: PdfColors.black))
                                        ),
                                        child: pw.Text("Total Amount before Tax:",style: pw.TextStyle(fontSize: 10))
                                      ),

                                      pw.Container(
                                        height: 30,
                                        width: 70,
                                        // padding: pw.EdgeInsets.only(right: 10),
                                        alignment: pw.Alignment.centerRight,
                                          child: pw.Text("${qn.saleDetailsGrid[saleIndex].OutputQtyAmount??""}")
                                      )

                                    ]
                                  )
                                ),
                                // pw.Container(
                                //     height: 30,
                                //     decoration: pw.BoxDecoration(
                                //         border: pw.Border(top: pw.BorderSide(color: PdfColors.black))
                                //     ),
                                //     child: pw.Row(
                                //         children: [
                                //           pw.Container(
                                //               height: 30,
                                //               width: 140,
                                //               padding: pw.EdgeInsets.only(left: 10),
                                //               alignment: pw.Alignment.centerLeft,
                                //               decoration: pw.BoxDecoration(
                                //                   border: pw.Border(right: pw.BorderSide(color: PdfColors.black))
                                //               ),
                                //               child: pw.Text("CGST         :   @2.5%",)
                                //           ),
                                //
                                //           pw.Container(
                                //               height: 30,
                                //               width: 70,
                                //               // padding: pw.EdgeInsets.only(right: 10),
                                //               alignment: pw.Alignment.centerRight,
                                //               child: pw.Text("23.55")
                                //           )
                                //
                                //         ]
                                //     )
                                // ),
                                qn.saleDetailsGrid[saleIndex].discountAmount!=null ?
                                qn.saleDetailsGrid[saleIndex].discountAmount!>0 ?
                                pw.Container(
                                    height: 30,
                                    decoration: pw.BoxDecoration(
                                        border: pw.Border(top: pw.BorderSide(color: PdfColors.black))
                                    ),
                                    child: pw.Row(
                                        children: [
                                          pw.Container(
                                              height: 30,
                                              width: 140,
                                              padding: pw.EdgeInsets.only(right: 10),
                                              alignment: pw.Alignment.centerRight,
                                              decoration: pw.BoxDecoration(
                                                  border: pw.Border(right: pw.BorderSide(color: PdfColors.black))
                                              ),
                                              child: pw.Text("Discount (${qn.saleDetailsGrid[saleIndex].isPercentage==1?qn.saleDetailsGrid[saleIndex].discountValue:""} ${qn.saleDetailsGrid[saleIndex].isPercentage==1?"%":"Rs"})",
                                                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold))
                                          ),

                                          pw.Container(
                                              height: 30,
                                              width: 70,
                                              // padding: pw.EdgeInsets.only(right: 10),
                                              alignment: pw.Alignment.centerRight,
                                              child: pw.Text("${qn.saleDetailsGrid[saleIndex].discountAmount}",style: pw.TextStyle(fontWeight: pw.FontWeight.bold))
                                          )

                                        ]
                                    )
                                ):pw.Container():pw.Container(),
                                pw.Container(
                                    height: 30,
                                    decoration: pw.BoxDecoration(
                                        border: pw.Border(top: pw.BorderSide(color: PdfColors.black))
                                    ),
                                    child: pw.Row(
                                        children: [
                                          pw.Container(
                                              height: 30,
                                              width: 140,
                                              padding: pw.EdgeInsets.only(left: 10),
                                              alignment: pw.Alignment.centerLeft,
                                              decoration: pw.BoxDecoration(
                                                  border: pw.Border(right: pw.BorderSide(color: PdfColors.black))
                                              ),
                                              child: pw.Text("GST         :   @${qn.saleDetailsGrid[saleIndex].TaxPercentage}%",)
                                          ),

                                          pw.Container(
                                              height: 30,
                                              width: 70,
                                              // padding: pw.EdgeInsets.only(right: 10),
                                              alignment: pw.Alignment.centerRight,
                                              child: pw.Text("${qn.saleDetailsGrid[saleIndex].TaxAmount}")
                                          )

                                        ]
                                    )
                                ),




                                   qn.saleDetailsGrid[saleIndex].RoundOffAmount!=null ?
                                   qn.saleDetailsGrid[saleIndex].RoundOffAmount!>0 || qn.saleDetailsGrid[saleIndex].RoundOffAmount!<0?
                                   pw.Container(
                                    height: 30,
                                    decoration: pw.BoxDecoration(
                                        border: pw.Border(top: pw.BorderSide(color: PdfColors.black))
                                    ),
                                    child: pw.Row(
                                        children: [
                                          pw.Container(
                                              height: 30,
                                              width: 140,
                                              padding: pw.EdgeInsets.only(right: 10),
                                              alignment: pw.Alignment.centerRight,
                                              decoration: pw.BoxDecoration(
                                                  border: pw.Border(right: pw.BorderSide(color: PdfColors.black))
                                              ),
                                              child: pw.Text("RoundOff",style: pw.TextStyle(fontWeight: pw.FontWeight.bold))
                                          ),

                                          pw.Container(
                                              height: 30,
                                              width: 70,
                                              // padding: pw.EdgeInsets.only(right: 10),
                                              alignment: pw.Alignment.centerRight,
                                              child: pw.Text("${qn.saleDetailsGrid[saleIndex].RoundOffAmount}",style: pw.TextStyle(fontWeight: pw.FontWeight.bold))
                                          )

                                        ]
                                    )
                                ):pw.Container():pw.Container(),

                                pw.Container(
                                    height: 30,
                                    decoration: pw.BoxDecoration(
                                        border: pw.Border(top: pw.BorderSide(color: PdfColors.black))
                                    ),
                                    child: pw.Row(
                                        children: [
                                          pw.Container(
                                              height: 30,
                                              width: 140,
                                              padding: pw.EdgeInsets.only(right: 10),
                                              alignment: pw.Alignment.centerRight,
                                              decoration: pw.BoxDecoration(
                                                  border: pw.Border(right: pw.BorderSide(color: PdfColors.black))
                                              ),
                                              child: pw.Text("Total",style: pw.TextStyle(fontWeight: pw.FontWeight.bold))
                                          ),

                                          pw.Container(
                                              height: 30,
                                              width: 70,
                                              // padding: pw.EdgeInsets.only(right: 10),
                                              alignment: pw.Alignment.centerRight,
                                              child: pw.Text("${qn.saleDetailsGrid[saleIndex].TotalAmount!.round()}",style: pw.TextStyle(fontWeight: pw.FontWeight.bold))
                                          )

                                        ]
                                    )
                                ),




                              ]
                            )
                          )

                        ]
                    ),



                    pw.TableRow(

                        children: [
                          pw.Container(
                            height: 95,
                            alignment: pw.Alignment.bottomCenter,
                            // padding: pw.EdgeInsets.all(10),
                            child: pw.Text("Receiver Sign"),
                          ),
                          pw.Container(
                            height: 95,
                            width: 240,
                             padding: pw.EdgeInsets.all(5),
                            child:pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              children: [
                                pw.Text("For ${qn.CD_quarryname.text??""}"),
                                pw.Spacer(),
                                pw.Text("Signature"),
                              ]
                            )
                          ),

                        ]
                    ),



                  ]
              ),








            ]
          )
        ),
      ),
    ),

  );


 //final String dirr = (await  getExternalStorageDirectory()).path;
 final String dirr ='/storage/emulated/0/Download/quarry';
// final String path = '$dir/report.pdf';

  String filename="INV_${qn.saleDetailsGrid[saleIndex].SaleNumber}";
  await Directory('/storage/emulated/0/Download/quarry').create(recursive: true);
  final String path = '$dirr/$filename.pdf';
// final String path = '/storage/emulated/0/Download/report.pdf';
  print(path);
   final File file = File(path);
  await file.writeAsBytes(await pdf.save()).then((value) async {

    OpenFile.open(path);


  //  CustomAlert().billSuccessAlert(context, "", "Successfully Downloaded @ \n\n Internal Storage/Download/quarry/$filename.pdf", "", "");




   // print(path);
/*    String username = 'muthugokul103031@gmail.com';


    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username)
      ..recipients.add('$mailid') //recipent email
    //..ccRecipients.addAll(['gokulmohan3010@gmail.com', 'gokulmohan3010@gmail.com']) //cc Recipents emails
    // ..bccRecipients.add(Address('gokulmohan3010@gmail.com')) //bcc Recipents emails
      ..subject = 'Report' //subject of the email
      ..attachments.add(FileAttachment(file))
    ; //body of the email

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString()); //print if the email is sent
    } on MailerException catch (e) {
      print('Message not sent. \n'+ e.toString()); //print if the email is not sent
    }*/
} 

);

}
