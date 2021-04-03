import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart' as material;

reportView(context,String mailid) async {
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
                      width: 150,

                      child:
                      pw.Text("GST:5685967589675896"),
                      // pw.Spacer(),

                    ),
                    pw.Container(
                      //  height: 70,
                        width: 210,

                        alignment: pw.Alignment.topCenter,
                        child:
                        pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            pw.Text("TAX INVOICE",style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 16),textAlign: pw.TextAlign.center),
                            pw.Text("SRI MAHALAKSHMI RHYNO ROBUST SANDS PVT LTD",style: pw.TextStyle(),textAlign: pw.TextAlign.center),
                            pw.Text("SY NO 154/1B Kushthanapalli(village),Sevaganapalli(post),",textAlign: pw.TextAlign.center),
                            pw.Text("Hosur,TamilNadu",textAlign: pw.TextAlign.center),
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
                            pw.Text("MOBILE: 9788149293")
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
                          child: pw.Text("Invoice No     :"),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(10),
                          child:pw.Text("Transport Mode :"),
                        ),

                      ]
                    ),

                    pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: pw.EdgeInsets.all(10),
                            child: pw.Text("Invoice Date   :"),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(10),
                            child:pw.Text("Vehicle No     :"),
                          ),

                        ]
                    ),

                    pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: pw.EdgeInsets.all(10),
                            child: pw.Text("State   :"),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(10),
                            child:pw.Text("Date of Supply :"),
                          ),

                        ]
                    ),

                    pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: pw.EdgeInsets.all(10),
                            child: pw.Text("Billed To   :"),
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
                            child: pw.Text("Name     :"),
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
                                      child:  pw.Text("SY NO 154/1B Kushthanapalli (village), Sevaganapalli (post), Hosur, TamilNadu",
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
                            child: pw.Text("GSTIN     :"),
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
                            child: pw.Text("State      :"),
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
                                        child: pw.Text('DF FDF')
                                    )
                                ),
                                pw.Container(
                                    width: 80,
                                    height: 70,

                                    child: pw.Center(
                                        child: pw.Text('6546545')
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
                                        child: pw.Text('6 TOM')
                                    )
                                ),
                                pw.Container(
                                    width: 70,
                                    height: 70,
                                    decoration: pw.BoxDecoration(
                                        border: pw.Border(right: pw.BorderSide(color: PdfColors.black))
                                    ),
                                    child: pw.Center(
                                        child: pw.Text('545')
                                    )
                                ),
                                pw.Container(
                                    width: 70,
                                    height: 70,
                                    child: pw.Center(
                                        child: pw.Text('55')
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
                            child: pw.Text("Amount In Words  : THURTY THOUSSANFD THREE HUNDRED RUPEES ONLY"),
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
                                          child: pw.Text("45845")
                                      )

                                    ]
                                  )
                                ),
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
                                              child: pw.Text("CGST         :   @2.5%",)
                                          ),

                                          pw.Container(
                                              height: 30,
                                              width: 70,
                                              // padding: pw.EdgeInsets.only(right: 10),
                                              alignment: pw.Alignment.centerRight,
                                              child: pw.Text("23.55")
                                          )

                                        ]
                                    )
                                ),
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
                                              child: pw.Text("SGST         :   @2.5%",)
                                          ),

                                          pw.Container(
                                              height: 30,
                                              width: 70,
                                              // padding: pw.EdgeInsets.only(right: 10),
                                              alignment: pw.Alignment.centerRight,
                                              child: pw.Text("23.55")
                                          )

                                        ]
                                    )
                                ),
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
                                              child: pw.Text("Total",)
                                          ),

                                          pw.Container(
                                              height: 30,
                                              width: 70,
                                              // padding: pw.EdgeInsets.only(right: 10),
                                              alignment: pw.Alignment.centerRight,
                                              child: pw.Text("254543.55")
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
                            // padding: pw.EdgeInsets.all(10),
                            child:pw.Column(
                              children: [
                                pw.Text("For Company Name"),
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
  // pdf.addPage(pw.MultiPage(
  //     pageFormat: PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
  //     crossAxisAlignment: pw.CrossAxisAlignment.start,
  //     header: (pw.Context context) {
  //       if (context.pageNumber == 1) {
  //         return null;
  //       }
  //       return pw.Container(
  //           alignment: pw.Alignment.center,
  //           margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
  //           padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
  //           decoration: const pw.BoxDecoration(
  //               // border:Border(bottom: )
  //               // BoxBorder(bottom: true, width: 0.5, color: PdfColors.grey)
  //           ),
  //           child: pw.Text('Report',
  //               style: pw.Theme.of(context)
  //                   .defaultTextStyle
  //                   .copyWith(color: PdfColors.grey),textAlign: pw.TextAlign.center),);
  //     },
  //     footer: (pw.Context context) {
  //       return pw.Container(
  //           alignment: pw.Alignment.centerRight,
  //           margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
  //           child: pw.Text('Page ${context.pageNumber} of ${context.pagesCount}',
  //               style: pw.Theme.of(context)
  //                   .defaultTextStyle
  //                   .copyWith(color: PdfColors.grey)));
  //     },
  //     build: (pw.Context context) => <pw.Widget>[
  //       pw.Container(
  //         width: double.maxFinite,
  //          height: 650,
  //          decoration: pw.BoxDecoration(
  //            border: pw.Border.all(color:PdfColors.black)
  //          )
  //        )
  //       // Header(
  //       //     level: 0,
  //       //     child: Row(
  //       //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       //         children: <Widget>[
  //       //           Text('Report', textScaleFactor: 2),
  //       //
  //       //         ])),
  //       // Header(level: 1, text: 'What is Lorem Ipsum?',
  //       //   child:  Column(
  //       //     children: [
  //       //       Container(
  //       //           height: 230,
  //       //           child: Column(
  //       //
  //       //               children: [
  //       //                 SizedBox(height: 10,),
  //       //                 RichText(
  //       //                   text: TextSpan(
  //       //                       text: '                               Report Time: ',
  //       //
  //       //                       children: <TextSpan>[
  //       //                         TextSpan(text: '${DateFormat("dd-MM-yyyy").format(DateTime.now())} ${DateFormat.jm().format(DateTime.parse(DateTime.now().toString()))}',
  //       //
  //       //                         )
  //       //                       ]
  //       //                   ),
  //       //                 ),
  //       //                 SizedBox(height: 10,),
  //       //                 Text("Adayar Ananda Bhavan",),
  //       //                 SizedBox(height: 10,),
  //       //                 Text("Vadapalani",),
  //       //                 SizedBox(height: 10,),
  //       //                 Align(
  //       //                     alignment: Alignment.centerLeft,
  //       //                     child: Text("  X Reports :")),
  //       //
  //       //                 SizedBox(height: 5,),
  //       //
  //       //
  //       //                 Row(
  //       //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       //                   children: [
  //       //                     RichText(
  //       //                       text: TextSpan(
  //       //                           text: '  From: ',
  //       //                           children: <TextSpan>[
  //       //                             TextSpan(text: '19-10-2020 ',
  //       //                             )
  //       //                           ]
  //       //                       ),
  //       //                     ),
  //       //                     RichText(
  //       //
  //       //                       text: TextSpan(
  //       //                           text: 'To: ',
  //       //                           children: <TextSpan>[
  //       //                             TextSpan(text: ' 20-10-2020 ',
  //       //                             )
  //       //                           ]
  //       //                       ),
  //       //                     ),
  //       //                   ],
  //       //                 ),
  //       //                 SizedBox(height: 10,),
  //       //                 Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       //                   children: [
  //       //                     RichText(
  //       //                       text: TextSpan(
  //       //                           text: '  Shift Detail: ',
  //       //                           children: <TextSpan>[
  //       //                             TextSpan(text: 'M/2hrs',
  //       //                             )
  //       //                           ]
  //       //                       ),
  //       //                     ),
  //       //                     RichText(
  //       //                       text: TextSpan(
  //       //                           text: 'Username: ',
  //       //                           children: <TextSpan>[
  //       //                             TextSpan(text: 'Muthu Gokul  ',
  //       //                             )
  //       //                           ]
  //       //                       ),
  //       //                     ),
  //       //                   ],
  //       //                 ),
  //       //
  //       //               ]
  //       //           )
  //       //       ),
  //       //       Container(
  //       //         height: 180,
  //       //         child:  Column(
  //       //             mainAxisAlignment: MainAxisAlignment.center,
  //       //             children: [
  //       //               RichText(
  //       //                 text: TextSpan(
  //       //                     text: '  Sub Total   : ',
  //       //                     children: <TextSpan>[
  //       //                       TextSpan(text: '10000',
  //       //                       )
  //       //                     ]
  //       //                 ),
  //       //               ),
  //       //               SizedBox(height: 5,),
  //       //               Text("GST", ),
  //       //               SizedBox(height: 5,),
  //       //               RichText(
  //       //                 text: TextSpan(
  //       //                     text: '  SGSt   : ',
  //       //                     children: <TextSpan>[
  //       //                       TextSpan(text: '1000',
  //       //                       )
  //       //                     ]
  //       //                 ),
  //       //               ),
  //       //               RichText(
  //       //                 text: TextSpan(
  //       //                     text: ' CGST   : ',
  //       //                     children: <TextSpan>[
  //       //                       TextSpan(text: '1000',
  //       //                       )
  //       //                     ]
  //       //                 ),
  //       //               ),
  //       //               SizedBox(height: 5,),
  //       //               RichText(
  //       //                 text: TextSpan(
  //       //                     text: ' Parcel Charge   : ',
  //       //
  //       //                     children: <TextSpan>[
  //       //                       TextSpan(text: '10',
  //       //
  //       //                       )
  //       //                     ]
  //       //                 ),
  //       //               ),
  //       //               SizedBox(height: 5,),
  //       //               RichText(
  //       //                 text: TextSpan(
  //       //                     text: 'Net Total  : ',
  //       //
  //       //                     children: <TextSpan>[
  //       //                       TextSpan(text: '12010',
  //       //
  //       //                       )
  //       //                     ]
  //       //                 ),
  //       //               ),
  //       //             ],
  //       //           ),
  //       //
  //       //       ),
  //       //
  //       //     ],
  //       //   )
  //      // ),
  //
  //     ]
  // )
  // );
  //save PDF

  // Directory tempDir = await DownloadsPathProvider.downloadsDirectory;
  // String tempPath = tempDir.path;
  // var filePath = tempPath + '/report.pdf';


// /data/user/0/com.tetrosoft.quarry/app_flutter/report.pdf
  // /storage/emulated/0/Download/report.pdf
 final String dir = (await getApplicationDocumentsDirectory()).path;
 //final String dirr = (await  getExternalStorageDirectory()).path;
 final String dirr ='/storage/emulated/0/quarry';
// final String path = '$dir/report.pdf';
  print(dirr);
  await Directory('/storage/emulated/0/quarry').create(recursive: true);
  final String path = '$dirr/report.pdf';
// final String path = '/storage/emulated/0/Download/report.pdf';

   final File file = File(path);
  await file.writeAsBytes(await pdf.save()).then((value) async {
   // print(path);
/*    String username = 'muthugokul103031@gmail.com';
    String password = 'Pearl@3010';

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
