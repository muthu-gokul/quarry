import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quarry/api/ApiManager.dart';
import 'package:quarry/api/sp.dart';
import 'package:quarry/model/manageUsersModel/manageUsersPlantModel.dart';
import 'package:quarry/model/plantModel/plantUserModel.dart';
import 'package:quarry/model/purchaseDetailsModel/PurchaseOrderOtherChargesMappingListModel.dart';
import 'package:quarry/model/purchaseDetailsModel/purchaseDetailGridModel.dart';
import 'package:quarry/model/purchaseDetailsModel/purchaseMaterialListModel.dart';
import 'package:quarry/model/purchaseDetailsModel/purchaseOrderMaterialMappingListModel.dart';
import 'package:quarry/model/purchaseDetailsModel/purchaseSupplierListModel.dart';
import 'package:quarry/model/purchaseDetailsModel/purchaseSupplierTypeModel.dart';
import 'package:quarry/notifier/profileNotifier.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/calculation.dart';
import '../widgets/decimal.dart';

class PurchaseNotifier extends ChangeNotifier{




  String supplierType=null;

  int supplierId=null;
  var supplierName=null;

  DateTime PurchaseDate;
  DateTime ExpectedPurchaseDate;

  int PurchaseEditId=null;


  List<PurchaseSupplierType> supplierTypeList=[];
  List<PurchaseSupplierList> suppliersList=[];
  List<PurchaseSupplierList> filterSuppliersList=[];
  List<PurchaseSupplierList> searchFilterSuppliersList=[];

  List<PurchaseMaterialsListModel> materialsList=[];
  List<PurchaseMaterialsListModel> filterMaterialsList=[];
  List<PurchaseMaterialsListModel> searchFilterMaterialsList=[];


  int PlantId=null;
  int EditPlantId=null;
  String PlantName=null;

  final call=ApiManager();
  List<PlantUserModel> plantList=[];
  int plantCount;
  Future<dynamic>  PlantUserDropDownValues(BuildContext context) async {

    plantCount=0;
    updatePurchaseLoader(true);
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
              if(!isPurchaseEdit){
                PlantId=element.plantId;
                PlantName=element.plantName;
              }

            }
          });

          if(!isPurchaseEdit){
            if(plantCount!=1){
              PlantId=null;
              PlantName=null;
              plantList=plantList.where((element) => element.userId==Provider.of<QuarryNotifier>(context,listen: false).UserId).toList();

            }
          }

          if(isPurchaseEdit){
            PlantId=null;
            PlantName=null;
            plantList=plantList.where((element) => element.userId==Provider.of<QuarryNotifier>(context,listen: false).UserId).toList();
          }

        }
        print("plantCount$plantCount");
        updatePurchaseLoader(false);
      });


    }
    catch(e){
      updatePurchaseLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.MasterdropDown}" , e.toString());
    }
  }


  Future<dynamic> PurchaseDropDownValues(BuildContext context) async {
    print(context);
    updatePurchaseLoader(true);
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
          "Value": "Purchase"
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
          var t3=parsed['Table3'] as List;
          var t4=parsed['Table4'] as List;


          materialsList=t1.map((e) => PurchaseMaterialsListModel.fromJson(e)).toList();
          filterMaterialsList=materialsList;
          searchFilterMaterialsList=materialsList;

          supplierTypeList=t2.map((e) => PurchaseSupplierType.fromJson(e)).toList();

          suppliersList =t3.map((e) => PurchaseSupplierList.fromJson(e)).toList();
          filterSuppliersList=suppliersList;
          searchFilterSuppliersList=suppliersList;

        }
        updatePurchaseLoader(false);
      });
    }
    catch(e){
      updatePurchaseLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.MasterdropDown}" , e.toString());
    }
  }


 TextEditingController searchController=new TextEditingController();

 searchMaterial(String value){
   if(value.isEmpty){
   //  filterMaterialsList=materialsList;
     searchFilterMaterialsList=filterMaterialsList;
   }
   else{
    // filterMaterialsList=materialsList.where((element) => element.materialName.toLowerCase().contains(value.toLowerCase())).toList();
     searchFilterMaterialsList=filterMaterialsList.where((element) => element.materialName.toLowerCase().contains(value.toLowerCase())).toList();
   }
   notifyListeners();
 }

 searchSupplier(String value){
   if(value.isEmpty){

     searchFilterSuppliersList=filterSuppliersList;
   }
   else{
     searchFilterSuppliersList=filterSuppliersList.where((element) => element.supplierName.toLowerCase().contains(value.toLowerCase())).toList();
   }
   notifyListeners();
 }



  List<PurchaseOrderMaterialMappingListModel> purchaseOrdersMappingList=[];
  List<PurchaseOrderOtherChargesMappingList> purchaseOrdersOtherChargesMappingList=[];

  bool isDiscountPercentage=true;
  updateisDiscountPercentage(bool value){
    isDiscountPercentage=value;
    notifyListeners();
  }


  removepurchaseOrdersMappingList(int index){
    purchaseOrdersMappingList.removeAt(index);
    notifyListeners();
  }

  bool isTax=false;
  updateIsTax(bool value){
    isTax=value;
    notifyListeners();
  }

  updateIsDiscountFromQtyShowDialog(int index,String discountvalue,String purchaseqty){

    if(discountvalue.isEmpty){
      purchaseOrdersMappingList[index].IsDiscount=0;
      purchaseOrdersMappingList[index].IsAmount=0;
      purchaseOrdersMappingList[index].IsPercentage=0;
      purchaseOrdersMappingList[index].DiscountValue=0.0;
      purchaseOrdersMappingList[index].DiscountAmount=0.0;

      if(purchaseqty.isEmpty){
        purchaseOrdersMappingList[index].purchaseQty..text="";
        purchaseOrdersCalc(index,"0");
      }else{
        purchaseOrdersMappingList[index].purchaseQty..text=purchaseqty;
        purchaseOrdersCalc(index,purchaseqty);
      }

    }
    else{
      purchaseOrdersMappingList[index].IsDiscount=1;
      if(isDiscountPercentage){
        purchaseOrdersMappingList[index].IsPercentage=1;
        purchaseOrdersMappingList[index].IsAmount=0;
      }else{
        purchaseOrdersMappingList[index].IsPercentage=0;
        purchaseOrdersMappingList[index].IsAmount=1;
      }
      purchaseOrdersMappingList[index].DiscountValue=double.parse(discountvalue);
      purchaseOrdersMappingList[index].DiscountAmount=0.0;

      if(purchaseqty.isEmpty){
        purchaseOrdersMappingList[index].purchaseQty..text="";
        purchaseOrdersCalc(index,"0");
      }else{
        purchaseOrdersMappingList[index].purchaseQty..text=purchaseqty;
        purchaseOrdersCalc(index,purchaseqty);
      }


    }


    notifyListeners();
  }


  purchaseOrdersCalc(int index,String purchaseQty){

    if(purchaseQty.isEmpty){

      purchaseOrdersMappingList[index].TotalAmount=0.0;
      purchaseOrdersMappingList[index].Amount=0.0;
      purchaseOrdersMappingList[index].TaxAmount=0.0;
      purchaseOrdersMappingList[index].DiscountAmount=0.0;
      overAllTotalCalc();
    }
    else{


      if( purchaseOrdersMappingList[index].IsDiscount==0){
        purchaseOrdersMappingList[index].Amount=double.parse((Decimal.parse(purchaseQty)*Decimal.parse(purchaseOrdersMappingList[index].MaterialPrice.toString())).toString());

        if(isTax){
          purchaseOrdersMappingList[index].TaxAmount=double.parse(((Decimal.parse(purchaseOrdersMappingList[index].TaxValue.toString())*(Decimal.parse(purchaseOrdersMappingList[index].Amount.toString())-Decimal.parse(purchaseOrdersMappingList[index].DiscountAmount.toString())))/Decimal.parse("100")).toString());
        }else{
          purchaseOrdersMappingList[index].TaxAmount=0.0;
        }

        purchaseOrdersMappingList[index].TotalAmount=double.parse((Decimal.parse(purchaseOrdersMappingList[index].Amount.toString())+Decimal.parse(purchaseOrdersMappingList[index].TaxAmount.toString())).toString());

      }
      else if(purchaseOrdersMappingList[index].IsDiscount==1){
        if(purchaseOrdersMappingList[index].IsPercentage==1){
          purchaseOrdersMappingList[index].Amount=double.parse((Decimal.parse(purchaseQty)*Decimal.parse(purchaseOrdersMappingList[index].MaterialPrice.toString())).toString());
          purchaseOrdersMappingList[index].DiscountAmount=double.parse(((Decimal.parse(purchaseOrdersMappingList[index].DiscountValue.toString())*Decimal.parse(purchaseOrdersMappingList[index].Amount.toString()))/Decimal.parse("100")).toString());
          if(isTax){
            purchaseOrdersMappingList[index].TaxAmount=double.parse(((((Decimal.parse(purchaseOrdersMappingList[index].Amount.toString()))-Decimal.parse(purchaseOrdersMappingList[index].DiscountAmount.toString())) * Decimal.parse(purchaseOrdersMappingList[index].TaxValue.toString()) )/Decimal.parse("100")).toString());
          }else{
            purchaseOrdersMappingList[index].TaxAmount=0.0;
          }
          purchaseOrdersMappingList[index].TotalAmount=double.parse((Decimal.parse(purchaseOrdersMappingList[index].Amount.toString())+Decimal.parse(purchaseOrdersMappingList[index].TaxAmount.toString())-Decimal.parse(purchaseOrdersMappingList[index].DiscountAmount.toString())).toString());

        }
        else if(purchaseOrdersMappingList[index].IsAmount==1){

          purchaseOrdersMappingList[index].Amount=double.parse((Decimal.parse(purchaseQty)*Decimal.parse(purchaseOrdersMappingList[index].MaterialPrice.toString())).toString());

          purchaseOrdersMappingList[index].DiscountAmount=double.parse((Decimal.parse(purchaseOrdersMappingList[index].DiscountValue.toString())).toString());
          if(isTax){
            purchaseOrdersMappingList[index].TaxAmount=double.parse(((((Decimal.parse(purchaseOrdersMappingList[index].Amount.toString()))-Decimal.parse(purchaseOrdersMappingList[index].DiscountAmount.toString())) * Decimal.parse(purchaseOrdersMappingList[index].TaxValue.toString()) )/Decimal.parse("100")).toString());
          }else{
            purchaseOrdersMappingList[index].TaxAmount=0.0;
          }
          purchaseOrdersMappingList[index].TotalAmount=double.parse((Decimal.parse(purchaseOrdersMappingList[index].Amount.toString())+Decimal.parse(purchaseOrdersMappingList[index].TaxAmount.toString())-Decimal.parse(purchaseOrdersMappingList[index].DiscountAmount.toString())).toString());
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
    purchaseOrdersOtherChargesMappingList.forEach((element) {
      otherCharges=double.parse((Decimal.parse(otherCharges.toString()) + Decimal.parse(element.OtherChargesAmount.toString())).toString());
    });
    purchaseOrdersMappingList.forEach((element) {
      subtotal=double.parse((Decimal.parse(subtotal.toString()) + Decimal.parse(element.Amount.toString())).toString());
      taxAmount=double.parse((Decimal.parse(taxAmount.toString()) + Decimal.parse(element.TaxAmount.toString())).toString());
      discountAmount=double.parse((Decimal.parse(discountAmount.toString()) + Decimal.parse(element.DiscountAmount.toString())).toString());
      discountedSubtotal=double.parse((Decimal.parse(subtotal.toString()) - Decimal.parse(discountedSubtotal.toString())).toString());
      grandTotal=double.parse((Decimal.parse(grandTotal.toString()) + Decimal.parse(element.TotalAmount.toString())).toString());
    });
    grandTotal=Calculation().add(grandTotal, otherCharges);



    notifyListeners();
  }







  InsertPurchaseDbHit(BuildContext context)  async{
    updatePurchaseLoader(true);
    print(PlantId);
    List js=[];
    js=purchaseOrdersMappingList.map((e) => e.toJson()).toList();
    print(js);
    List oa=[];
    oa=purchaseOrdersOtherChargesMappingList.map((e) => e.toJson()).toList();
    print(oa);

    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": isPurchaseEdit?"${Sp.updatePurchaseDetail}":"${Sp.insertPurchaseDetail}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": Provider.of<QuarryNotifier>(context,listen: false).UserId
        },

        {
          "Key": "PurchaseOrderId",
          "Type": "int",
          "Value": PurchaseEditId
        },
        {
          "Key": "PlantId",
          "Type": "int",
          "Value": isPurchaseEdit?EditPlantId: PlantId
        },
        {
          "Key": "ExpectedDate",
          "Type": "String",
          "Value":ExpectedPurchaseDate!=null? DateFormat("yyyy-MM-dd").format(ExpectedPurchaseDate).toString():null
        },
        {
          "Key": "SupplierType",
          "Type": "String",
          "Value": supplierType
        },
        {
          "Key": "Supplier",
          "Type": "int",
          "Value": supplierId
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
          "Key": "IsTax",
          "Type": "int",
          "Value": isTax?1:0
        },

        {
          "Key": "PurchaseOrderMaterialMappingList",
          "Type": "datatable",
          "Value": js
        },
        {
          "Key": "PurchaseOrderOtherChargesMappingList",
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
          clearForm();
          GetPurchaseDbHit(context, null,);
        }

        updatePurchaseLoader(false);
      });
    }catch(e){
      updatePurchaseLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.insertPurchaseDetail}" , e.toString());
    }


  }









  List<DateTime> picked=[];
  List<ManageUserPlantModel> filterUsersPlantList=[];


  List<String> purchaseGridCol=["Order Number","Supplier Name","Expected Date","No of Material","Purchase Quantity","Tax Amount","Sub Total","Net Amount","Status"];
  List<PurchaseOrderGridModel> purchaseGridList=[];
  List<PurchaseOrderGridModel> filterPurchaseGridList=[];


  GetPurchaseDbHit(BuildContext context,int PurchaseOrderId)  async{
    updatePurchaseLoader(true);
    String fromDate,toDate;

    if(picked.isEmpty){
      fromDate=DateFormat("yyyy-MM-dd").format(DateTime.now()).toString();
      toDate=DateFormat("yyyy-MM-dd").format(DateTime.now()).toString();
    }
    else if(picked.length==1){
      fromDate=DateFormat("yyyy-MM-dd").format(picked[0]).toString();
      toDate=DateFormat("yyyy-MM-dd").format(picked[0]).toString();
    }
    else if(picked.length==2){
      fromDate=DateFormat("yyyy-MM-dd").format(picked[0]).toString();
      toDate=DateFormat("yyyy-MM-dd").format(picked[1]).toString();
    }

    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": "${Sp.getPurchaseDetail}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": Provider.of<QuarryNotifier>(context,listen: false).UserId
        },
        {
          "Key": "PurchaseOrderId",
          "Type": "int",
          "Value": PurchaseOrderId
        },
        {
          "Key": "FromDate",
          "Type": "String",
          "Value": fromDate
        },
        {
          "Key": "ToDate",
          "Type": "String",
          "Value":toDate
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
          if(filterUsersPlantList.isEmpty){

            Provider.of<ProfileNotifier>(context, listen: false).usersPlantList.forEach((element) {
              filterUsersPlantList.add(ManageUserPlantModel(
                plantId: element.plantId,
                plantName: element.plantName,
                isActive: element.isActive,
              ));
            });

          } else if(filterUsersPlantList.length!=Provider.of<ProfileNotifier>(context, listen: false).usersPlantList.length){
            filterUsersPlantList.clear();

            Provider.of<ProfileNotifier>(context, listen: false).usersPlantList.forEach((element) {
                filterUsersPlantList.add(ManageUserPlantModel(
                  plantId: element.plantId,
                  plantName: element.plantName,
                  isActive: element.isActive,

                ));
              });

          }
          var parsed=json.decode(value);
          var t=parsed['Table'] as List;
          if(PurchaseOrderId!=null){
            print("t_$t");
            var t1=parsed['Table1'] as List;
            print(t1);
            var t2=parsed['Table2'] as List;
            print(t2);

            PurchaseEditId=t[0]['PurchaseOrderId'];
            EditPlantId=t[0]['PlantId'];
            PlantId=t[0]['PlantId'];
            PlantName=t[0]['PlantName'];

            supplierType=t[0]['SupplierType'];
            supplierId=t[0]['Supplier'];
            supplierName=t[0]['SupplierName'];

            filterSuppliersList=suppliersList.where((element) => element.supplierType.toLowerCase()==supplierType.toLowerCase()).toList();
            searchFilterSuppliersList=filterSuppliersList;

            if(supplierType=='External'){
              filterMaterialsList=materialsList.where((element) => element.supplierId==supplierId && element.SupplierType=='External' ).toList();
              searchFilterMaterialsList=filterMaterialsList;

            }
            else{
              filterMaterialsList=materialsList.where((element) => element.SupplierType=='Internal').toList();
              searchFilterMaterialsList=filterMaterialsList;
            }


            ExpectedPurchaseDate=t[0]['ExpectedDate']!=null?DateTime.parse(t[0]['ExpectedDate']):DateTime.now();

            subtotal=t[0]['Subtotal'];
            taxAmount=t[0]['GST'];
            grandTotal=t[0]['Total'];
            discountAmount=t[0]['Discount']??0.0;
            isTax=t[0]['IsTax'];

            purchaseOrdersMappingList=t1.map((e) => PurchaseOrderMaterialMappingListModel.fromJson(e)).toList();
            purchaseOrdersOtherChargesMappingList=t2.map((e) => PurchaseOrderOtherChargesMappingList.fromJson(e)).toList();
            purchaseOrdersOtherChargesMappingList.forEach((element) {
              otherCharges=double.parse((Decimal.parse(otherCharges.toString()) + Decimal.parse(element.OtherChargesAmount.toString())).toString());
            });
            if(t[0]['Status']=='Not Yet'){
              isPurchaseView=false;
            }else{
              isPurchaseView=true;
            }

            notifyListeners();
          }
          else{
            print(t);
            filterPurchaseGridList=t.map((e) => PurchaseOrderGridModel.fromJson(e)).toList();
            filterPurchaseGrid();

          }
        }



        updatePurchaseLoader(false);
      });
    }catch(e){
      updatePurchaseLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.getPurchaseDetail}" , e.toString());
    }
  }

  filterPurchaseGrid(){
    purchaseGridList.clear();
    filterUsersPlantList.forEach((element) {

      if(element.isActive){
        purchaseGridList=purchaseGridList+filterPurchaseGridList.where((ele) => ele.PlantId==element.plantId).toList();
      }
    });
    purchaseGridList.sort((a,b)=>a.purchaseOrderId.compareTo(b.purchaseOrderId));
    notifyListeners();
  }



  updateEdit(int index){

  }

  insertForm(){
    PurchaseDate=DateTime.now();
    ExpectedPurchaseDate=null;
    notifyListeners();
  }



  clearForm(){
     supplierType=null;

     supplierId=null;
     supplierName=null;
     EditPlantId=null;
     searchController.clear();
     purchaseOrdersMappingList.clear();
      subtotal=0.0;
      taxAmount=0.0;
      discountAmount=0.0;
      discountedSubtotal=0.0;
      grandTotal=0.0;
      otherCharges=0.0;
      isTax=false;
     purchaseOrdersOtherChargesMappingList.clear();
  }

  bool isPurchaseEdit=false;
  updatePurchaseEdit(bool value){
    isPurchaseEdit=value;
    notifyListeners();
  }

  bool isPurchaseView=false;
  updatePurchaseView(bool value){
    isPurchaseView=value;
    notifyListeners();
  }

  bool PurchaseLoader=false;
  updatePurchaseLoader(bool value){
    PurchaseLoader=value;
    notifyListeners();
  }



}