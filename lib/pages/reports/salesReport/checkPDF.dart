
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/widgets/alertDialog.dart';

checkpdf(context,String title,dynamic fromDate,dynamic toDate,List<dynamic> header,List<dynamic> data) async {
  List<int> data2=List.filled(50, 1);

  var qn=Provider.of<QuarryNotifier>(context,listen: false);


  int count=0;
  header.forEach((element) {
    if(element.isActive){
      count=count+1;
    }
  });

  final pw.Document pdf = pw.Document();
  pdf.addPage(
    MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: EdgeInsets.only(left: 5, top: 20, right: 5, bottom: 5),
      crossAxisAlignment: CrossAxisAlignment.start,
      maxPages: 100,
      build: (Context context) => <Widget>[

        pw.Container(
            child: pw.Row(
                children: [
                  pw.SizedBox(width: 20),
                  pw.Text("$title",style: pw.TextStyle(fontSize: 18,color: PdfColor.fromInt(0xFF3b3b3d))),
                  pw.Spacer(),
                  pw.Text("$fromDate - $toDate",style: pw.TextStyle(fontSize: 18,color: PdfColor.fromInt(0xFF3b3b3d))),
                  pw.SizedBox(width: 20),
                ]
            )
        ),
        pw.SizedBox(height: 20),
        //header
        pw.Container(
          decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColor.fromInt(0xFFCDCDCD))
          ),
          child:  pw.Row(
              children: header.asMap().
              map((i, value) => MapEntry(i,
                  value.isActive?Container(
                      margin: pw.EdgeInsets.only(right: 10),
                      //  alignment: value.alignment,
                      //  padding: value.edgeInsets,
                      width:count>7?  value.width:(480/count).toDouble(),
                      // width: value.width,
                      //height: 16,
                      constraints: BoxConstraints(
                          minWidth:count>7? 50:(480/count).toDouble(),
                          maxWidth: count>7? 70:(480/count).toDouble()
                      ),
                      child: Text(value.columnName,style: pw.TextStyle(fontSize: 12,color: PdfColor.fromInt(0xFFCDCDCD)))
                  ):Container()
              ))
                  .values.toList()
          ),
        ),
        //data rows
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:data.asMap().
            map((i, value) => MapEntry(
              i, Container(

              decoration: pw.BoxDecoration(
                  border: pw.Border(right: pw.BorderSide(color: PdfColor.fromInt(0xFFe3e3e3)),
                    left: pw.BorderSide(color: PdfColor.fromInt(0xFFe3e3e3)),
                    bottom: pw.BorderSide(color: PdfColor.fromInt(0xFFe3e3e3)),
                  )
              ),

              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,

                  children: header.asMap().map((j, v) {

                    return MapEntry(j,
                      v.isActive?!v.isDate?Container(
                        //   width: v.width,
                        width:count>7?  v.width:(480/count).toDouble(),
                        constraints: BoxConstraints(
                            minWidth:count>7? 50:(480/count).toDouble(),
                            maxWidth: count>7? 70:(480/count).toDouble()
                        ),
                        decoration: BoxDecoration(

                        ),
                        margin: pw.EdgeInsets.only(right: 10),
                        child: Text("${value[v.columnName].toString().isNotEmpty?value[v.columnName]??" ":" "}",
                          style:pw.TextStyle(fontSize: 12,color: PdfColor.fromInt(0xFF3b3b3d)),
                        ),
                      ):Container(
                        //width: v.width,
                        width:count>7?  v.width:(480/count).toDouble(),
                        constraints: BoxConstraints(
                            minWidth:count>7? 50:(480/count).toDouble(),
                            maxWidth: count>7? 70:(480/count).toDouble()
                        ),
                        decoration: BoxDecoration(

                        ),
                        margin: pw.EdgeInsets.only(right: 10),
                        child: Text("${value[v.columnName]!=null?DateFormat('dd-MM-yyyy').format(DateTime.parse(value[v.columnName])):" "}",
                          style:pw.TextStyle(fontSize: 12,color: PdfColor.fromInt(0xFF3b3b3d)),
                        ),
                      )
                          :Container(),
                    );
                  }
                  ).values.toList()
              ),
            ),

            )
            ).values.toList()
        ),


              /*Wrap(
          children: [
            Container(

              child: Column(
                children: <Widget>[
                  pw.Container(
                    child: pw.Row(
                      children: [
                        pw.SizedBox(width: 20),
                        pw.Text("$title",style: pw.TextStyle(fontSize: 18,color: PdfColor.fromInt(0xFF3b3b3d))),
                        pw.Spacer(),
                        pw.Text("$fromDate - $toDate",style: pw.TextStyle(fontSize: 18,color: PdfColor.fromInt(0xFF3b3b3d))),
                        pw.SizedBox(width: 20),
                      ]
                    )
                  ),
                  pw.SizedBox(height: 20),
                  //header
                  pw.Container(
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColor.fromInt(0xFFCDCDCD))
                    ),
                    child:  pw.Row(
                        children: header.asMap().
                        map((i, value) => MapEntry(i,
                            value.isActive?Container(
                                margin: pw.EdgeInsets.only(right: 10),
                                //  alignment: value.alignment,
                                //  padding: value.edgeInsets,
                                width:count>7?  value.width:(480/count).toDouble(),
                               // width: value.width,
                                //height: 16,
                                constraints: BoxConstraints(
                                    minWidth:count>7? 50:(480/count).toDouble(),
                                    maxWidth: count>7? 70:(480/count).toDouble()
                                ),
                                child: Text(value.columnName,style: pw.TextStyle(fontSize: 12,color: PdfColor.fromInt(0xFFCDCDCD)))
                            ):Container()
                        ))
                            .values.toList()
                    ),
                  ),
                  //data rows
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:data.asMap().
                      map((i, value) => MapEntry(
                          i, Container(

                        decoration: pw.BoxDecoration(
                            border: pw.Border(right: pw.BorderSide(color: PdfColor.fromInt(0xFFe3e3e3)),
                              left: pw.BorderSide(color: PdfColor.fromInt(0xFFe3e3e3)),
                              bottom: pw.BorderSide(color: PdfColor.fromInt(0xFFe3e3e3)),
                            )
                         ),

                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,

                              children: header.asMap().map((j, v) {

                                return MapEntry(j,
                                 v.isActive?!v.isDate?Container(
                                 //   width: v.width,
                                   width:count>7?  v.width:(480/count).toDouble(),
                                    constraints: BoxConstraints(
                                        minWidth:count>7? 50:(480/count).toDouble(),
                                        maxWidth: count>7? 70:(480/count).toDouble()
                                    ),
                                    decoration: BoxDecoration(

                                    ),
                                   margin: pw.EdgeInsets.only(right: 10),
                                    child: Text("${value[v.columnName].toString().isNotEmpty?value[v.columnName]??" ":" "}",
                                      style:pw.TextStyle(fontSize: 12,color: PdfColor.fromInt(0xFF3b3b3d)),
                                    ),
                                  ):Container(
                                    //width: v.width,
                                   width:count>7?  v.width:(480/count).toDouble(),
                                    constraints: BoxConstraints(
                                        minWidth:count>7? 50:(480/count).toDouble(),
                                        maxWidth: count>7? 70:(480/count).toDouble()
                                    ),
                                    decoration: BoxDecoration(

                                    ),
                                   margin: pw.EdgeInsets.only(right: 10),
                                    child: Text("${value[v.columnName]!=null?DateFormat('dd-MM-yyyy').format(DateTime.parse(value[v.columnName])):" "}",
                                      style:pw.TextStyle(fontSize: 12,color: PdfColor.fromInt(0xFF3b3b3d)),
                                    ),
                                  )
                                      :Container(),
                                );
                              }
                              ).values.toList()
                          ),
                        ),

                      )
                      ).values.toList()
                  ),






                ],
              ),
            )
              ]
          ),*/
            ]
        ),
  );



  final String dirr ='/storage/emulated/0/quarry/reports';

  String filename="$title";
  await Directory('/storage/emulated/0/quarry/reports').create(recursive: true);
  final String path = '$dirr/$filename.pdf';


  final File file = File(path);
  await file.writeAsBytes(await pdf.save()).then((value) async {
    CustomAlert().billSuccessAlert(context, "", "Successfully Downloaded @ \n\n Internal Storage/quarry/reports/$filename.pdf", "", "");
  });

}
