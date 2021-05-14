import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart' as material;
import 'package:pdf/widgets.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/widgets/alertDialog.dart';

checkpdf(context) async {


  var qn=Provider.of<QuarryNotifier>(context,listen: false);



  final pw.Document pdf = pw.Document();
  pdf.addPage(
    MultiPage(
      maxPages: 100,
      build: (Context context) => <Widget>[
        Wrap(
          children: List<Widget>.generate(250, (int index) {

            return Container(
              width: 480,
              child: Column(
                children: <Widget>[
                  Header(
                      text: "Issue n°${index}",
                      textStyle: TextStyle(fontSize: 20)),
                  Text("Description :",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 15)),
                  pw.Row(
                    children: List<Widget>.generate(15, (int index){
                           return pw.Container(
                             height: 14,
                             child: pw.FittedBox(
                               child: pw.Text("Column $index")
                             )
                           );
                       })
                    )
                ],
              ),
            );
          }),
        ),
      ],
    ),
  );

  final String dir = (await getApplicationDocumentsDirectory()).path;

  final String dirr ='/storage/emulated/0/quarry/reports';

 // String filename="INV_${qn.saleDetailsGrid[saleIndex].SaleNumber}";
  String filename="check";
  await Directory('/storage/emulated/0/quarry/reports').create(recursive: true);
  final String path = '$dirr/$filename.pdf';


  final File file = File(path);
  await file.writeAsBytes(await pdf.save()).then((value) async {
    CustomAlert().billSuccessAlert(context, "", "Successfully Downloaded @ \n\n Internal Storage/quarry/reports/$filename.pdf", "", "");

  }

  );

}
