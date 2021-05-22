import 'package:flutter/material.dart' as material;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/invoiceNotifier.dart';
import 'package:open_file/open_file.dart';

import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/calculation.dart';



invoicePdf(context,bool view) async {
  var inv=Provider.of<InvoiceNotifier>(context,listen: false);
  double otherCharges=0.0;

  inv.pdfOtherCharges.forEach((element) {
    otherCharges=Calculation().add(otherCharges, element['OtherChargesAmount']);
  });


  final pw.Document pdf = pw.Document();
  pdf.addPage(
    MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
        crossAxisAlignment: CrossAxisAlignment.start,
        maxPages: 100,
        build: (Context context) => <Widget>[
          pw.Container(
              height: 1,
              color: PdfColor.fromInt(0xFFCDCDCD)
          ),
          pw.SizedBox(height: 10),
          pw.Container(

              child: pw.Row(
                  children: [

                    pw.Text("Invoice",style: pw.TextStyle(fontSize: 30,color: PdfColor.fromInt(0xFF3b3b3d),fontWeight: pw.FontWeight.bold)),
                    pw.Spacer(),
                    pw.Text(inv.pdfHeader[0]['InvoiceDate']==null?"":"${DateFormat.yMMMd().format(DateTime.parse(inv.pdfHeader[0]['InvoiceDate']))}",
                        style: pw.TextStyle(fontSize: 20,color: PdfColor.fromInt(0xFF3b3b3d),fontWeight: pw.FontWeight.bold)),

                  ]
              )
          ),
          pw.SizedBox(height: 10),
          pw.Container(
              height: 1,
              color: PdfColor.fromInt(0xFFCDCDCD)
          ),
          pw.SizedBox(height: 20),

          pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Container(
                  width: 240,
                  child:  pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text("From",style: pw.TextStyle(fontSize: 16,color: PdfColor.fromInt(0xFF3b3b3d),fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(height: 10),
                        pw.FittedBox(
                          child:  pw.Text(inv.pdfHeader[0]['InvoiceType']=='Receivable'?"${inv.pdfHeader[0]['PlantName']}":"${inv.pdfHeader[0]['PartyName']}",
                              style: pw.TextStyle(fontSize: 25,color: PdfColor.fromInt(0xFF3b3b3d),fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.SizedBox(height: 10),
                        /*pw.Text("Rajmahal complex, opp to bus stand,Hosur-635109.",style: pw.TextStyle(fontSize: 15,color: PdfColor.fromInt(0xFF3b3b3d)),
                            textAlign: pw.TextAlign.left),*/
                      ]
                  ),
                ),

                pw.Container(
                  width: 240,
                  child:  pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text("To",style: pw.TextStyle(fontSize: 16,color: PdfColor.fromInt(0xFF3b3b3d),fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(height: 10),
                        pw.FittedBox(
                          child:  pw.Text(inv.pdfHeader[0]['InvoiceType']=='Receivable'?"${inv.pdfHeader[0]['PartyName']}":"${inv.pdfHeader[0]['PlantName']}",
                              style: pw.TextStyle(fontSize: 25,color: PdfColor.fromInt(0xFF3b3b3d),fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.SizedBox(height: 10),
                        /*pw.Text("Rajmahal complex, opp to bus stand,Hosur-635109.",style: pw.TextStyle(fontSize: 15,color: PdfColor.fromInt(0xFF3b3b3d)),
                            textAlign: pw.TextAlign.right),*/
                      ]
                  ),
                ),
              ]
          ),
          pw.SizedBox(height: 20),
          pw.Container(
              height: 60,
              decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColor.fromInt(0xFFCDCDCD)),
                  color: PdfColor.fromInt(0xFFF6F7F9)
              ),
              child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                  children: [
                    pw.Container(
                        width: 180,
                        child: pw.FittedBox(
                          child:   RichText(
                            text: TextSpan(
                              text: 'Invoice : ',
                              style:pw.TextStyle(fontSize: 14,color: PdfColor.fromInt(0xFF3b3b3d),fontWeight: pw.FontWeight.bold),
                              children: <TextSpan>[
                                TextSpan(text: '${inv.pdfHeader[0]['InvoiceNumber']}', style: pw.TextStyle(fontSize: 16,color: PdfColor.fromInt(0xFF3b3b3d),fontWeight: pw.FontWeight.normal)),
                              ],
                            ),
                          ),
                        )
                    ),

                    pw.Container(
                        width: 180,
                        height: 16,
                        child: pw.FittedBox(
                          child:   RichText(
                            text: TextSpan(
                              text: 'Purchase No : ',
                              style:pw.TextStyle(fontSize: 14,color: PdfColor.fromInt(0xFF3b3b3d),fontWeight: pw.FontWeight.bold),
                              children: <TextSpan>[
                                TextSpan(text: '${inv.pdfHeader[0]['PurchaseNumber']??""}', style: pw.TextStyle(fontSize: 16,color: PdfColor.fromInt(0xFF3b3b3d),fontWeight: pw.FontWeight.normal)),
                              ],
                            ),
                          ),
                        )
                    ),
                    pw.Container(
                        width: 180,
                        height: 16,
                        child: pw.FittedBox(
                          child:   RichText(
                            text: TextSpan(
                              text: 'Expected Date : ',
                              style:pw.TextStyle(fontSize: 14,color: PdfColor.fromInt(0xFF3b3b3d),fontWeight: pw.FontWeight.bold),
                              children: <TextSpan>[
                                TextSpan(text: '${inv.pdfHeader[0]['ExpectedDate']==null?"":DateFormat.yMMMd().format(DateTime.parse(inv.pdfHeader[0]['ExpectedDate']))}',
                                    style: pw.TextStyle(fontSize: 16,color: PdfColor.fromInt(0xFF3b3b3d),fontWeight: pw.FontWeight.normal)),
                              ],
                            ),
                          ),
                        )
                    ),

                  ]
              )
          ),
          pw.SizedBox(height: 20),





          //material
          pw.Container(
              height: 50,
              decoration: pw.BoxDecoration(

                  color: PdfColor.fromInt(0xFFE9F4FF)
              ),
              child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Container(
                        width: 50,
                        child: pw.Center(
                          child: pw.Text("#",style:pw.TextStyle(fontSize: 16,color: PdfColor.fromInt(0xFF3b3b3d),fontWeight: pw.FontWeight.bold)),
                        )

                    ),

                    pw.Container(
                        width: 100,
                        height: 20,
                        child: pw.FittedBox(
                          child: pw.Text("Material Name",style:pw.TextStyle(fontSize: 14,color: PdfColor.fromInt(0xFF3b3b3d),fontWeight: pw.FontWeight.bold)),
                        )
                    ),
                    pw.Container(
                        width: 90,
                        height: 16,
                        child: pw.FittedBox(
                          child: pw.Text("Qty",style:pw.TextStyle(fontSize: 14,color: PdfColor.fromInt(0xFF3b3b3d),fontWeight: pw.FontWeight.bold)),
                        )
                    ),
                    pw.Container(
                        width: 60,
                        height: 16,
                        child: pw.FittedBox(
                          child: pw.Text("Price",style:pw.TextStyle(fontSize: 14,color: PdfColor.fromInt(0xFF3b3b3d),fontWeight: pw.FontWeight.bold)),
                        )
                    ),
                    pw.Container(
                        width: 80,
                        height: 16,
                        child: pw.FittedBox(
                          child: pw.Text("GST",style:pw.TextStyle(fontSize: 14,color: PdfColor.fromInt(0xFF3b3b3d),fontWeight: pw.FontWeight.bold)),
                        )
                    ),
                    pw.Container(
                        width: 80,
                        height: 16,
                        child: pw.FittedBox(
                          child: pw.Text("Discount",style:pw.TextStyle(fontSize: 14,color: PdfColor.fromInt(0xFF3b3b3d),fontWeight: pw.FontWeight.bold)),
                        )
                    ),

                    pw.Container(
                        width: 100,
                        height: 16,
                        alignment: pw.Alignment.centerRight,
                        child: pw.FittedBox(
                          child: pw.Text("Total",style:pw.TextStyle(fontSize: 14,color: PdfColor.fromInt(0xFF3b3b3d),fontWeight: pw.FontWeight.bold)),
                        )
                    ),

                  ]
              )
          ),

          for(int i=0;i<inv.pdfMaterial.length;i++)
            pw.Container(
                height: 50,
                decoration: pw.BoxDecoration(
                    border: pw.Border(bottom: pw.BorderSide(color: PdfColor.fromInt(0xFFCDCDCD))),

                ),
                child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      pw.Container(
                          width: 50,
                          child: pw.Center(
                            child: pw.Text("${i+1}",style:pw.TextStyle(fontSize: 16,color: PdfColor.fromInt(0xFF3b3b3d),fontWeight: pw.FontWeight.bold)),
                          )

                      ),

                      pw.Container(
                          width: 100,
                          height: 20,
                          child: pw.FittedBox(
                            child: pw.Text("${inv.pdfMaterial[i]['MaterialName']}",style:pw.TextStyle(fontSize: 14,color: PdfColor.fromInt(0xFF3b3b3d),fontWeight: pw.FontWeight.bold)),
                          )
                      ),
                      pw.Container(
                          width: 90,
                          height: 16,
                          child: pw.FittedBox(
                            child: pw.Text("${inv.pdfMaterial[i]['MaterialQuantity']}",style:pw.TextStyle(fontSize: 14,color: PdfColor.fromInt(0xFF3b3b3d),fontWeight: pw.FontWeight.bold)),
                          )
                      ),
                      pw.Container(
                          width: 60,
                          height: 16,
                          child: pw.FittedBox(
                            child: pw.Text("${inv.pdfMaterial[i]['MaterialPrice']}",style:pw.TextStyle(fontSize: 14,color: PdfColor.fromInt(0xFF3b3b3d),fontWeight: pw.FontWeight.bold)),
                          )
                      ),
                      pw.Container(
                          width: 80,
                          height: 16,
                          child: pw.FittedBox(
                            child: pw.Text("${inv.pdfMaterial[i]['TaxAmount']}",style:pw.TextStyle(fontSize: 14,color: PdfColor.fromInt(0xFF3b3b3d),fontWeight: pw.FontWeight.bold)),
                          )
                      ),
                      pw.Container(
                          width: 80,
                          height: 16,
                          child: pw.FittedBox(
                            child: pw.Text("${inv.pdfMaterial[i]['DiscountAmount']}",style:pw.TextStyle(fontSize: 14,color: PdfColor.fromInt(0xFF3b3b3d),fontWeight: pw.FontWeight.bold)),
                          )
                      ),
                      pw.Container(
                          width: 100,
                          height: 16,
                          alignment: pw.Alignment.centerRight,
                          child: pw.FittedBox(
                            child: pw.Text("${inv.pdfMaterial[i]['TotalAmount']}",style:pw.TextStyle(fontSize: 14,color: PdfColor.fromInt(0xFF3b3b3d),fontWeight: pw.FontWeight.bold)),
                          )
                      ),

                    ]
                )
            ),

          pw.SizedBox(height: 20),
          //Notes
          pw.Container(
            width: 575,
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  width: 335,
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      Text(inv.pdfHeader[0]['Notes']==null?"":"Notes: ",style: pw.TextStyle(fontSize: 18,color: PdfColor.fromInt(0xFF3b3b3d),fontWeight: pw.FontWeight.bold)),
                      Text("${inv.pdfHeader[0]['Notes']??""}",style: pw.TextStyle(fontSize: 16,color: PdfColor.fromInt(0xFF3b3b3d),fontWeight: pw.FontWeight.normal)),
                      pw.SizedBox(height: 20),
                      Text(inv.pdfHeader[0]['TermsandConditions']==null?"":"Terms and Conditions: ",style: pw.TextStyle(fontSize: 18,color: PdfColor.fromInt(0xFF3b3b3d),fontWeight: pw.FontWeight.bold)),
                      Text("${inv.pdfHeader[0]['TermsandConditions']??""}",style: pw.TextStyle(fontSize: 16,color: PdfColor.fromInt(0xFF3b3b3d),fontWeight: pw.FontWeight.normal)),
                      pw.SizedBox(height: 20),
                    ]
                  )
                ),
                pw.Container(
                    width: 240,

                    child: pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.FittedBox(
                            child: Text("Sub Total Amount : ${inv.pdfHeader[0]['Subtotal']}",style: pw.TextStyle(fontSize: 18,color: PdfColor.fromInt(0xFF3b3b3d),fontWeight: pw.FontWeight.normal))
                          ),
                          pw.SizedBox(height: 10),
                          pw.FittedBox(
                              child: Text("GST : ${inv.pdfHeader[0]['TaxAmount']}",style: pw.TextStyle(fontSize: 18,color: PdfColor.fromInt(0xFF3b3b3d),fontWeight: pw.FontWeight.normal))
                          ),
                          pw.SizedBox(height: 10),
                          inv.pdfHeader[0]['DiscountAmount']>0?pw.FittedBox(
                              child: Text("Discount : -${inv.pdfHeader[0]['DiscountAmount']}",style: pw.TextStyle(fontSize: 18,color: PdfColor.fromInt(0xFF3b3b3d),fontWeight: pw.FontWeight.normal))
                          ):pw.Container(),
                          pw.SizedBox(height:otherCharges>0? 10:0),
                          otherCharges>0?  pw.FittedBox(
                              child: Text("Other Charges : ${otherCharges}",style: pw.TextStyle(fontSize: 18,color: PdfColor.fromInt(0xFF3b3b3d),fontWeight: pw.FontWeight.normal))
                          ):pw.Container(),
                          pw.SizedBox(height: 10),
                          pw.Container(
                              height: 1,
                              color: PdfColor.fromInt(0xFFCDCDCD)
                          ),
                          pw.SizedBox(height: 20),
                          pw.FittedBox(
                              child: Text("Total : ${inv.pdfHeader[0]['GrandTotalAmount']}",style: pw.TextStyle(fontSize: 25,color: PdfColor.fromInt(0xFF3b3b3d),fontWeight: pw.FontWeight.bold))
                          ),
                          pw.SizedBox(height: 10),
                        ]
                    )
                ),
              ]
            )
          )

        ]
    ),
  );


  final String dirr ='/storage/emulated/0/quarry/invoice';

  String filename="${inv.pdfHeader[0]['InvoiceNumber']}";
  await Directory('/storage/emulated/0/quarry/invoice').create(recursive: true);
  final String path = '$dirr/$filename.pdf';


  final File file = File(path);
  await file.writeAsBytes(await pdf.save()).then((value) async {
    if(view){
      OpenFile.open(path);

    }else{
      CustomAlert().billSuccessAlert(context, "", "Successfully Downloaded @ \n\n Internal Storage/quarry/invoice/$filename.pdf", "", "");
    }


  });
}

/*
pw.Container(
height: 10,
width: 575,
color: PdfColor.fromInt(0xFFE34343)
)*/
