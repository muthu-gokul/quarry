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
            children: [
              pw.Container(
                height: 70,

              )
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
