import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quarry/api/ApiManager.dart';
import 'package:quarry/api/sp.dart';
import 'package:quarry/model/invoiceModel/invGridMode.dart';
import 'package:quarry/model/invoiceModel/invMaterialListModel.dart';
import 'package:quarry/model/invoiceModel/invMaterialMappingModel.dart';
import 'package:quarry/model/invoiceModel/invOtherChargesMappingModel.dart';
import 'package:quarry/model/invoiceModel/invSupplierModel.dart';
import 'package:quarry/model/invoiceModel/invTypeModel.dart';
import 'package:quarry/model/plantModel/plantUserModel.dart';
import 'package:quarry/model/purchaseDetailsModel/PurchaseOrderOtherChargesMappingListModel.dart';
import 'package:quarry/model/purchaseDetailsModel/purchaseDetailGridModel.dart';
import 'package:quarry/model/purchaseDetailsModel/purchaseMaterialListModel.dart';
import 'package:quarry/model/purchaseDetailsModel/purchaseOrderMaterialMappingListModel.dart';
import 'package:quarry/model/purchaseDetailsModel/purchaseSupplierListModel.dart';
import 'package:quarry/model/purchaseDetailsModel/purchaseSupplierTypeModel.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/pages/invoice/invoiceGrid.dart';
import 'package:quarry/widgets/alertDialog.dart';
import '../widgets/decimal.dart';

class InvoiceNotifier extends ChangeNotifier{


  final call=ApiManager();





  DateTime invoiceCurrentDate;


  int InvoiceEditId=null;
  String InvoiceEditNumber=null;




  int PlantId=null;
  int EditPlantId=null;
  String PlantName=null;

  String selectedInvoiceType=null;
  int selectedPartyId=null;
  String selectedPartyName=null;


  clearInvoiceForm(){
    selectedInvoiceType=null;
    selectedPartyId=null;
    selectedPartyName=null;
  }



  List<PlantUserModel> plantList=[];
  int plantCount=0;
  Future<dynamic>  PlantUserDropDownValues(BuildContext context) async {
    print("ISDIESE LEDIT $isInvoiceEdit");
    print("USER ID ${Provider.of<QuarryNotifier>(context,listen: false).UserId}");
    plantCount=0;
    updateInvoiceLoader(true);
    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": "${Sp.MasterdropDown}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": Provider.of<QuarryNotifier>(context,listen: false).UserId
        },
        {
          "Key": "TypeName",
          "Type": "String",
          "Value": "User"
        },
        {
          "Key": "database",
          "Type": "String",
          "Value": Provider.of<QuarryNotifier>(context,listen: false).DataBaseName
        },
      ]
    };
    try{
      await call.ApiCallGetInvoke(body,context).then((value) {
        if(value!=null){
          var parsed=json.decode(value);

          var t=parsed['Table'] as List;
          var t1=parsed['Table1'] as List;
          plantList=t1.map((e) => PlantUserModel.fromJson(e)).toList();
          plantList.forEach((element) {
            if(element.userId==Provider.of<QuarryNotifier>(context,listen: false).UserId){
              plantCount=plantCount+1;
              if(!isInvoiceEdit){
                PlantId=element.plantId;
                PlantName=element.plantName;
              }

            }
          });

          if(!isInvoiceEdit){
            if(plantCount!=1){
              PlantId=null;
              PlantName=null;
              plantList=plantList.where((element) => element.userId==Provider.of<QuarryNotifier>(context,listen: false).UserId).toList();

            }
          }

          if(isInvoiceEdit){
            PlantId=null;
            PlantName=null;
            plantList=plantList.where((element) => element.userId==Provider.of<QuarryNotifier>(context,listen: false).UserId).toList();
          }

          }
          print("plantCount$plantCount");
         updateInvoiceLoader(false);
        });


    }
    catch(e){
      updateInvoiceLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.MasterdropDown}" , e.toString());
    }
  }


  List<InvoiceTypeModel> invoiceTypeList=[];
  List<InvoiceSupplierModel> invoiceSupplierList=[];
  List<InvoiceSupplierModel> filterInvoiceSupplierList=[];
  List<InvoiceMaterialModel> filtermaterialList=[];
  List<InvoiceMaterialModel> materialList=[];

  Future<dynamic> InvoiceDropDownValues(BuildContext context) async {
    updateInvoiceLoader(true);
    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": "${Sp.MasterdropDown}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": Provider.of<QuarryNotifier>(context,listen: false).UserId
        },
        {
          "Key": "TypeName",
          "Type": "String",
          "Value": "Invoice"
        },
        {
          "Key": "database",
          "Type": "String",
          "Value": Provider.of<QuarryNotifier>(context,listen: false).DataBaseName
        }
      ]
    };

    try{
      await call.ApiCallGetInvoke(body,context).then((value) {
        if(value!=null){
          var parsed=json.decode(value);
          var t=parsed['Table'] as List;
          var t1=parsed['Table1'] as List;
          var t2=parsed['Table2'] as List;


          invoiceTypeList=t.map((e) => InvoiceTypeModel.fromJson(e)).toList();
          invoiceSupplierList=t1.map((e) => InvoiceSupplierModel.fromJson(e)).toList();
          filterInvoiceSupplierList=t1.map((e) => InvoiceSupplierModel.fromJson(e)).toList();

          materialList=t2.map((e) => InvoiceMaterialModel.fromJson(e)).toList();
          filtermaterialList=t2.map((e) => InvoiceMaterialModel.fromJson(e)).toList();




        }
        updateInvoiceLoader(false);
      });
    }
    catch(e){
      updateInvoiceLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.MasterdropDown}" , e.toString());
    }
  }


  TextEditingController searchController=new TextEditingController();

  searchMaterial(String value){
    if(value.isEmpty){
      filtermaterialList=materialList;
    }
    else{
      filtermaterialList=materialList.where((element) => element.materialName.toLowerCase().contains(value.toLowerCase())).toList();
    }
    notifyListeners();
  }



  List<InvoiceMaterialMappingListModel> invoiceMaterialMappingList=[];
  List<InvoiceOtherChargesMappingList> invoiceOtherChargesMappingList=[];

  bool isDiscountPercentage=true;
  updateisDiscountPercentage(bool value){
    isDiscountPercentage=value;
    notifyListeners();
  }


  removepurchaseOrdersMappingList(int index){
    invoiceMaterialMappingList.removeAt(index);
    notifyListeners();
  }


  updateIsDiscountFromQtyShowDialog(int index,String discountvalue,String purchaseqty){

    if(discountvalue.isEmpty){
      invoiceMaterialMappingList[index].IsDiscount=0;
      invoiceMaterialMappingList[index].IsAmount=0;
      invoiceMaterialMappingList[index].IsPercentage=0;
      invoiceMaterialMappingList[index].DiscountValue=0.0;
      invoiceMaterialMappingList[index].DiscountAmount=0.0;
      invoiceMaterialMappingList[index].DiscountedSubTotal=0.0;

      if(purchaseqty.isEmpty){
        invoiceMaterialMappingList[index].purchaseQty..text="";
        purchaseOrdersCalc(index,"0");
      }else{
        invoiceMaterialMappingList[index].purchaseQty..text=purchaseqty;
        purchaseOrdersCalc(index,purchaseqty);
      }

    }
    else{
      invoiceMaterialMappingList[index].IsDiscount=1;
      if(isDiscountPercentage){
        invoiceMaterialMappingList[index].IsPercentage=1;
        invoiceMaterialMappingList[index].IsAmount=0;
      }else{
        invoiceMaterialMappingList[index].IsPercentage=0;
        invoiceMaterialMappingList[index].IsAmount=1;
      }
      invoiceMaterialMappingList[index].DiscountValue=double.parse(discountvalue);
      invoiceMaterialMappingList[index].DiscountAmount=0.0;
      invoiceMaterialMappingList[index].DiscountedSubTotal=0.0;

      if(purchaseqty.isEmpty){
        invoiceMaterialMappingList[index].purchaseQty..text="";
        purchaseOrdersCalc(index,"0");
      }else{
        invoiceMaterialMappingList[index].purchaseQty..text=purchaseqty;
        purchaseOrdersCalc(index,purchaseqty);
      }


    }


    notifyListeners();
  }


  purchaseOrdersCalc(int index,String purchaseQty){
    print("purchaseQty1  $purchaseQty");

    if(purchaseQty.isEmpty){

      invoiceMaterialMappingList[index].TotalAmount=0.0;
      invoiceMaterialMappingList[index].Subtotal=0.0;
      invoiceMaterialMappingList[index].TaxAmount=0.0;
      invoiceMaterialMappingList[index].DiscountAmount=0.0;
      invoiceMaterialMappingList[index].DiscountedSubTotal=0.0;
      overAllTotalCalc();
    }
    else{


      if( invoiceMaterialMappingList[index].IsDiscount==0){
        invoiceMaterialMappingList[index].Subtotal=double.parse((Decimal.parse(purchaseQty)*Decimal.parse(invoiceMaterialMappingList[index].MaterialPrice.toString())).toString());
        invoiceMaterialMappingList[index].TaxAmount=double.parse(((Decimal.parse(invoiceMaterialMappingList[index].TaxValue.toString())*(Decimal.parse(invoiceMaterialMappingList[index].Subtotal.toString())-Decimal.parse(invoiceMaterialMappingList[index].DiscountAmount.toString())))/Decimal.parse("100")).toString());
        invoiceMaterialMappingList[index].TotalAmount=double.parse((Decimal.parse(invoiceMaterialMappingList[index].Subtotal.toString())+Decimal.parse(invoiceMaterialMappingList[index].TaxAmount.toString())).toString());
        invoiceMaterialMappingList[index].DiscountAmount=0.0;
        invoiceMaterialMappingList[index].DiscountedSubTotal=0.0;
      }
      else if(invoiceMaterialMappingList[index].IsDiscount==1){

        if(invoiceMaterialMappingList[index].IsPercentage==1){
          invoiceMaterialMappingList[index].Subtotal=double.parse((Decimal.parse(purchaseQty)*Decimal.parse(invoiceMaterialMappingList[index].MaterialPrice.toString())).toString());
          invoiceMaterialMappingList[index].DiscountAmount=double.parse(((Decimal.parse(invoiceMaterialMappingList[index].DiscountValue.toString())*Decimal.parse(invoiceMaterialMappingList[index].Subtotal.toString()))/Decimal.parse("100")).toString());
          invoiceMaterialMappingList[index].DiscountedSubTotal=double.parse((((Decimal.parse(invoiceMaterialMappingList[index].Subtotal.toString()))-Decimal.parse(invoiceMaterialMappingList[index].DiscountAmount.toString()))).toString());

          invoiceMaterialMappingList[index].TaxAmount=double.parse(((((Decimal.parse(invoiceMaterialMappingList[index].Subtotal.toString()))-Decimal.parse(invoiceMaterialMappingList[index].DiscountAmount.toString())) * Decimal.parse(invoiceMaterialMappingList[index].TaxValue.toString()) )/Decimal.parse("100")).toString());
          invoiceMaterialMappingList[index].TotalAmount=double.parse((Decimal.parse(invoiceMaterialMappingList[index].Subtotal.toString())+Decimal.parse(invoiceMaterialMappingList[index].TaxAmount.toString())-Decimal.parse(invoiceMaterialMappingList[index].DiscountAmount.toString())).toString());

        }
        else if(invoiceMaterialMappingList[index].IsAmount==1){

          invoiceMaterialMappingList[index].Subtotal=double.parse((Decimal.parse(purchaseQty)*Decimal.parse(invoiceMaterialMappingList[index].MaterialPrice.toString())).toString());
          invoiceMaterialMappingList[index].DiscountAmount=double.parse((Decimal.parse(invoiceMaterialMappingList[index].DiscountValue.toString())).toString());
          invoiceMaterialMappingList[index].DiscountedSubTotal=double.parse((((Decimal.parse(invoiceMaterialMappingList[index].Subtotal.toString()))-Decimal.parse(invoiceMaterialMappingList[index].DiscountAmount.toString()))).toString());


          invoiceMaterialMappingList[index].TaxAmount=double.parse(((((Decimal.parse(invoiceMaterialMappingList[index].Subtotal.toString()))-Decimal.parse(invoiceMaterialMappingList[index].DiscountAmount.toString())) * Decimal.parse(invoiceMaterialMappingList[index].TaxValue.toString()) )/Decimal.parse("100")).toString());
          invoiceMaterialMappingList[index].TotalAmount=double.parse((Decimal.parse(invoiceMaterialMappingList[index].Subtotal.toString())+Decimal.parse(invoiceMaterialMappingList[index].TaxAmount.toString())-Decimal.parse(invoiceMaterialMappingList[index].DiscountAmount.toString())).toString());
        }

      }
      overAllTotalCalc();
    }
    notifyListeners();
  }



  double subtotal=0.0;
  double taxAmount=0.0;
  double discountAmount=0.0;
  double discountedSubtotal=0.0;
  double grandTotal=0.0;
  double otherCharges=0.0;


  overAllTotalCalc(){
    subtotal=0.0;
    taxAmount=0.0;
    discountAmount=0.0;
    discountedSubtotal=0.0;
    grandTotal=0.0;
    otherCharges=0.0;
    invoiceOtherChargesMappingList.forEach((element) {
      print(element.OtherChargesAmount);
      otherCharges=double.parse((Decimal.parse(otherCharges.toString()) + Decimal.parse(element.OtherChargesAmount==null?"0.0":element.OtherChargesAmount.toString())).toString());
    });
    invoiceMaterialMappingList.forEach((element) {
      subtotal=double.parse((Decimal.parse(subtotal.toString()) + Decimal.parse(element.Subtotal.toString())).toString());
      taxAmount=double.parse((Decimal.parse(taxAmount.toString()) + Decimal.parse(element.TaxAmount.toString())).toString());
      discountAmount=double.parse((Decimal.parse(discountAmount.toString()) + Decimal.parse(element.DiscountAmount.toString())).toString());
      discountedSubtotal=double.parse((Decimal.parse(subtotal.toString()) - Decimal.parse(discountedSubtotal.toString())).toString());
      grandTotal=double.parse((Decimal.parse(grandTotal.toString()) + Decimal.parse(element.TotalAmount.toString()) + Decimal.parse(otherCharges.toString())).toString());
    });

    notifyListeners();
  }







  InsertInvoiceDbHit(BuildContext context)  async{
    updateInvoiceLoader(true);
    print(PlantId);
    List js=[];
    js=invoiceMaterialMappingList.map((e) => e.toJson()).toList();
    print(js);
    List oa=[];
    oa=invoiceOtherChargesMappingList.map((e) => e.toJson()).toList();
    print(oa);

    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": isInvoiceEdit?"${Sp.updateInvoiceDetail}":"${Sp.insertInvoiceDetail}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": Provider.of<QuarryNotifier>(context,listen: false).UserId
        },

        {
          "Key": "InvoiceId",
          "Type": "int",
          "Value": InvoiceEditId
        },
        {
          "Key": "PlantId",
          "Type": "int",
          "Value": PlantId
        },
        {
          "Key": "PurchaseOrderId",
          "Type": "int",
          "Value": null
        },

        {
          "Key": "InvoiceType",
          "Type": "String",
          "Value": selectedInvoiceType
        },
        {
          "Key": "PartyId",
          "Type": "int",
          "Value": selectedPartyId
        },
        {
          "Key": "Subtotal",
          "Type": "String",
          "Value": subtotal
        },
        {
          "Key": "DiscountAmount",
          "Type": "String",
          "Value": discountAmount
        },
        {
          "Key": "DiscountedSubtotal",
          "Type": "String",
          "Value": discountedSubtotal
        },
        {
          "Key": "TaxAmount",
          "Type": "String",
          "Value": taxAmount
        },
        {
          "Key": "GrandTotalAmount",
          "Type": "String",
          "Value": grandTotal
        },

        {
          "Key": "InvoiceMaterialMappingList",
          "Type": "datatable",
          "Value": js
        },
        {
          "Key": "InvoiceOtherChargesMappingList",
          "Type": "datatable",
          "Value": oa
        },
        {
          "Key": "database",
          "Type": "String",
          "Value": Provider.of<QuarryNotifier>(context,listen: false).DataBaseName
        }
      ]
    };

    try{
      await call.ApiCallGetInvoke(body,context).then((value) {

        if(value!=null){
          var parsed=json.decode(value);
          Navigator.pop(context);
          GetInvoiceDbHit(context, null);

          clearForm();

        }

        updateInvoiceLoader(false);
      });
    }catch(e){
      updateInvoiceLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.insertInvoiceDetail}" , e.toString());
    }


  }












  List<String> invoiceGridCol=["Invoice Number","Date","Party Name","Net Amount"];

  List<InvoiceGridModel> invoiceGridList=[];
  List<InvoiceGridModel> filterInvoiceGridList=[];


  GetInvoiceDbHit(BuildContext context,int InvoiceId)  async{
    updateInvoiceLoader(true);

    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": "${Sp.getInvoiceDetail}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": Provider.of<QuarryNotifier>(context,listen: false).UserId
        },
        {
          "Key": "InvoiceId",
          "Type": "int",
          "Value": InvoiceId
        },
        {
          "Key": "database",
          "Type": "String",
          "Value": Provider.of<QuarryNotifier>(context,listen: false).DataBaseName
        }
      ]
    };

    try{
      await call.ApiCallGetInvoke(body,context).then((value) {
        if(value!=null){
          var parsed=json.decode(value);
          var t=parsed['Table'] as List;
          if(InvoiceId!=null){
            print(t);
            var t1=parsed['Table1'] as List;
            print(t1);
            var t2=parsed['Table2'] as List;
            print(t2);

            InvoiceEditId=t[0]['InvoiceId'];

            InvoiceEditNumber=t[0]['InvoiceNumber'];

            PlantId=t[0]['PlantId'];
            PlantName=t[0]['PlantName'];



            selectedInvoiceType=t[0]['InvoiceType'];
            selectedPartyId=t[0]['PartyId'];
            selectedPartyName=t[0]['PartyName'];

            filterInvoiceSupplierList=invoiceSupplierList.where((element) => element.supplierType.toLowerCase()==selectedInvoiceType.toLowerCase()).toList();

            if(selectedInvoiceType=='Payable'){
              filtermaterialList=materialList.where((element) => element.supplierId==selectedPartyId && element.supplierType=='Payable').toList();
            }
            else{
              filtermaterialList=materialList.where((element) => element.supplierType=='Receivable').toList();
            }


            subtotal=t[0]['Subtotal'];
            discountAmount=t[0]['DiscountAmount'];
            discountedSubtotal=t[0]['DiscountedSubtotal'];
            taxAmount=t[0]['TaxAmount'];
            grandTotal=t[0]['GrandTotalAmount'];


            invoiceMaterialMappingList=t1.map((e) => InvoiceMaterialMappingListModel.fromJson(e)).toList();
            invoiceOtherChargesMappingList=t2.map((e) => InvoiceOtherChargesMappingList.fromJson(e)).toList();
            invoiceOtherChargesMappingList.forEach((element) {

              otherCharges=double.parse((Decimal.parse(otherCharges.toString()) + Decimal.parse(element.OtherChargesAmount==null?"0.0":element.OtherChargesAmount.toString())).toString());
            });



            notifyListeners();
          }
          else{
            invoiceGridList=t.map((e) => InvoiceGridModel.fromJson(e)).toList();
            filterInvoiceGridList=t.map((e) => InvoiceGridModel.fromJson(e)).toList();
            if(isInvoiceReceivable){
              filterInvoiceGridList=invoiceGridList.where((element) => element.invoiceType=="Receivable").toList();
            }
            else{
              filterInvoiceGridList=invoiceGridList.where((element) => element.invoiceType=="Payable").toList();
            }
          }
        }



        updateInvoiceLoader(false);
      });
    }catch(e){
      updateInvoiceLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.getInvoiceDetail}" , e.toString());
    }


  }



  updateEdit(int index){

  }

  insertForm(){
    invoiceCurrentDate=DateTime.now();

    notifyListeners();
  }



  clearForm(){

    PlantId=null;
    PlantName=null;
    selectedPartyId=null;
    selectedPartyName=null;
    selectedInvoiceType=null;
    EditPlantId=null;
    searchController.clear();
    invoiceMaterialMappingList.clear();
    subtotal=0.0;
    taxAmount=0.0;
    discountAmount=0.0;
    discountedSubtotal=0.0;
    grandTotal=0.0;
    otherCharges=0.0;
    invoiceOtherChargesMappingList.clear();
  }


  filterGridValues(){
    if(isInvoiceReceivable){
      filterInvoiceGridList=invoiceGridList.where((element) => element.invoiceType=="Receivable").toList();
    }
    else{
      filterInvoiceGridList=invoiceGridList.where((element) => element.invoiceType=="Payable").toList();
    }
    notifyListeners();
  }

  bool isInvoiceReceivable=true;
  updateInvoiceReceivable(bool value){
    isInvoiceReceivable=value;
    notifyListeners();
  }


bool isInvoiceEdit=false;
updateInvoiceEdit(bool value){
  isInvoiceEdit=value;
  notifyListeners();
}

bool InvoiceLoader=false;
updateInvoiceLoader(bool value){
  InvoiceLoader=value;
  notifyListeners();
}

}