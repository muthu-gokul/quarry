import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quarry/api/ApiManager.dart';
import 'package:quarry/api/sp.dart';
import 'package:quarry/model/dieselModel/dieselIssueGridModel.dart';
import 'package:quarry/model/dieselModel/dieselMachineModel.dart';
import 'package:quarry/model/dieselModel/dieselPurchaseGridModel.dart';
import 'package:quarry/model/dieselModel/dieselVehicleModel.dart';
import 'package:quarry/model/dieselModel/fuelPurchaserModel.dart';
import 'package:quarry/model/dieselModel/fuelSupplierModel.dart';
import 'package:quarry/model/plantModel/plantUserModel.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/decimal.dart';

class DieselNotifier extends ChangeNotifier{

  final call=ApiManager();



  List<PlantUserModel> plantList=[];
  int plantCount=0;
  Future<dynamic>  PlantUserDropDownValues(BuildContext context) async {
    print("ISDIESE LEDIT $isDieselEdit");
    print("USER ID ${Provider.of<QuarryNotifier>(context,listen: false).UserId}");
    plantCount=0;
    updateDieselLoader(true);
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
              if(!isDieselEdit){
                DP_PlantId=element.plantId;
                DP_PlantName=element.plantName;
              }
              if(!isDieselIssueEdit){
                DI_plantID=element.plantId;
                DI_plantName=element.plantName;
              }
            }
          });

          if(!isDieselEdit){
            if(plantCount!=1){
              DP_PlantId=null;
              DP_PlantName=null;
              plantList=plantList.where((element) => element.userId==Provider.of<QuarryNotifier>(context,listen: false).UserId).toList();
            }
          }
          if(!isDieselIssueEdit){
            if(plantCount!=1){
              DI_plantID=null;
              DI_plantName=null;
              plantList=plantList.where((element) => element.userId==Provider.of<QuarryNotifier>(context,listen: false).UserId).toList();
            }
          }
          print("plantCount$plantCount");

        }
        updateDieselLoader(false);
      });
    }
    catch(e){
      updateDieselLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.MasterdropDown}" , e.toString());
    }
  }


  List<FuelSupplierModel> fuelSupplierList=[];
  List<FuelPurchaserModel> fuelPurchaserList=[];
 // List<DieselVehicleModel> vehicleList=[];
 // List<DieselVehicleModel> filterVehicleList=[];

  List<dynamic> issuedByList=[];
  List<dynamic> filterIssuedByList=[];
  //List<DieselMachineModel> machineList=[];

  List<dynamic> machineTypeList=[];

  List<dynamic> vehicleList=[];
  List<dynamic> filterVehicleList=[];

  List<dynamic> machineList=[];
  List<dynamic> filterMachineList=[];

  DieselDropDownValues(BuildContext context) async {
    updateDieselLoader(true);
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
          "Value": "Diesel"
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
          var t2=parsed['Table2'] as List;

          var t3=parsed['Table3'] as List;
          var t4=parsed['Table4'] as List;
          var t5=parsed['Table5'] as List;

          fuelSupplierList=t.map((e) => FuelSupplierModel.fromJson(e)).toList();
          fuelPurchaserList=t1.map((e) => FuelPurchaserModel.fromJson(e)).toList();

          vehicleList=t2;
          filterVehicleList=t2;

          machineList=t3;
          filterMachineList=t3;

          issuedByList=t4;
          filterIssuedByList=t4;

          machineTypeList=t5;

        }



        updateDieselLoader(false);
      });
    }
    catch(e){
      updateDieselLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.MasterdropDown}" , e.toString());
    }
  }


  searchVehicle(String value){
    if(value.isEmpty){
      filterVehicleList=vehicleList;
    }
    else{
      filterVehicleList=vehicleList.where((element) => element['VehicleNumber'].toLowerCase().contains(value.toLowerCase())).toList();
    }
    notifyListeners();
  }


  searchMachine(String value){
    if(value.isEmpty){
      filterMachineList=machineList;
    }
    else{
      filterMachineList=machineList.where((element) => element['MachineName'].toLowerCase().contains(value.toLowerCase())).toList();
    }
    notifyListeners();
  }


  searchIssuedBy(String value){
    if(value.isEmpty){
      filterIssuedByList=issuedByList;
    }
    else{
      filterIssuedByList=issuedByList.where((element) => element['EmployeeName'].toLowerCase().contains(value.toLowerCase())).toList();
    }
    notifyListeners();
  }


  //Insert Diesel Purchase

  int DP_PlantId=null;
  String DP_PlantName=null;

  DateTime DP_currentTime;
  DateTime DP_billDate;
  int DP_supplierId=null;
  var DP_supplierName=null;
  int DP_purchaserId=null;
  var DP_purchaserName=null;
  int DP_vehicleId=null;
  var DP_vehicleName=null;
  bool DP_isVehicle=false;
  TextEditingController DP_billno=new TextEditingController();
  TextEditingController DP_location=new TextEditingController();
  TextEditingController DP_contactNo=new TextEditingController();

  TextEditingController DP_dieselQTY=new TextEditingController();
  TextEditingController DP_dieselPrice=new TextEditingController();
double totalAmount=0.0;

 dieselCalc(){
   String qty="0.0";
   String price="0.0";

   if(DP_dieselQTY.text.isEmpty){
     qty="0.0";
   } else{
     qty=DP_dieselQTY.text;
   }

   if(DP_dieselPrice.text.isEmpty){
     price="0.0";
   }else{
     price=DP_dieselPrice.text;
   }

   totalAmount=0.0;
   if(DP_dieselQTY.text.isEmpty&& DP_dieselPrice.text.isEmpty){
     totalAmount=0.0;
   }
   else {
     totalAmount=double.parse((Decimal.parse(qty)*Decimal.parse(price)).toString());
   }
   notifyListeners();
 }


 int EditDieselPurchaseId=null;

  InsertDieselPurchaseDbHit(BuildContext context)  async{
    updateDieselLoader(true);
    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": isDieselEdit?"${Sp.updateDieselDetail}": "${Sp.insertDieselDetail}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": Provider.of<QuarryNotifier>(context,listen: false).UserId
        },
        {
          "Key": "PlantId",
          "Type": "int",
          "Value": DP_PlantId
        },
        {
          "Key": "BillNumber",
          "Type": "String",
          "Value": DP_billno.text
        },
        {
          "Key": "BillDate",
          "Type": "String",
          "Value": DateFormat("yyyy-MM-dd").format(DP_billDate).toString()
        },

        {
          "Key": "SupplierId",
          "Type": "int",
          "Value": DP_supplierId
        },
        {
          "Key": "EmployeeId",
          "Type": "int",
          "Value": DP_purchaserId
        },
        {
          "Key": "DieselBunkLocation",
          "Type": "String",
          "Value": DP_location.text
        },
        {
          "Key": "DieselBunkContactNumber",
          "Type": "String",
          "Value": DP_contactNo.text
        },
        {
          "Key": "IsVehicle",
          "Type": "int",
          "Value": DP_isVehicle?1:0
        },
        {
          "Key": "VehicleId",
          "Type": "int",
          "Value": DP_vehicleId
        },
        {
          "Key": "DieselQuantity",
          "Type": "String",
          "Value": DP_dieselQTY.text.isNotEmpty?double.parse(DP_dieselQTY.text):0.0
        },
        {
          "Key": "DieselRate",
          "Type": "String",
          "Value": DP_dieselPrice.text.isNotEmpty?double.parse(DP_dieselPrice.text):0.0
        },
        {
          "Key": "TotalAmount",
          "Type": "String",
          "Value": totalAmount
        },
        {
          "Key": "DieselPurchaseId",
          "Type": "int",
          "Value": EditDieselPurchaseId
        },
        {
          "Key": "UnitId",
          "Type": "int",
          "Value": null
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
          GetDieselPurchaseDbHit(context, null);
          clearDP_Form();

          //
        }

        updateDieselLoader(false);
      });
    }catch(e){
      updateDieselLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.insertDieselDetail}" , e.toString());
    }


  }

  clearDP_Form(){
    DP_supplierId=null;
    DP_supplierName=null;
    DP_purchaserName=null;
    DP_purchaserName=null;
    DP_vehicleId=null;
    DP_vehicleName=null;
    DP_billno.clear();
    DP_location.clear();
    DP_contactNo.clear();
    DP_isVehicle=false;

    DP_dieselQTY.clear();
    DP_dieselPrice.clear();
    totalAmount=0.0;
  }

  insertDP_Form(){
    DP_currentTime=DateTime.now();
    DP_billDate=DateTime.now();
    notifyListeners();
  }






  List<String> dieselPurchaseGridCol=["Bill Number","Purchaser Name","Location","Contact Number","Diesel Quantity","Diesel Rate","Amount","Date"];
  List<DieselPurchaseGridModel> dieselPurchaseGridList=[];
  var dieselPurchaseGridOverAllHeader={};

  GetDieselPurchaseDbHit(BuildContext context,int dieselPurchaseId)  async{

    updateDieselLoader(true);

    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": "${Sp.getDieselDetail}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": Provider.of<QuarryNotifier>(context,listen: false).UserId
        },
        {
          "Key": "DieselPurchaseId",
          "Type": "int",
          "Value": dieselPurchaseId
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
          if(dieselPurchaseId!=null ){
            EditDieselPurchaseId=t[0]['DieselPurchaseId'];
            DP_PlantId=t[0]['PlantId'];
            DP_PlantName=t[0]['PlantName'];
            DP_billno.text=t[0]['BillNumber'];
            DP_billDate=DateFormat("yyyy-MM-dd").parse(t[0]['BillDate']);
            print("DP_billDate$DP_billDate");
            DP_purchaserId=t[0]['EmployeeId'];
            DP_purchaserName=t[0]['PurchaserName'];
            DP_supplierId=t[0]['SupplierId'];
            DP_supplierName=t[0]['SupplierName'];

            DP_vehicleId=t[0]['VehicleId'];
            DP_vehicleName=t[0]['VehicleNumber'];

            DP_location.text=t[0]['DieselBunkLocation'];
            DP_contactNo.text=t[0]['DieselBunkContactNumber'];
            DP_isVehicle=t[0]['IsVehicle']==1?true:t[0]['IsVehicle']==0?false:false;

            DP_dieselQTY.text=t[0]['DieselQuantity'].toString();
            DP_dieselPrice.text=t[0]['DieselRate'].toString();
            totalAmount=t[0]['TotalAmount'];
          }
          else{

            dieselPurchaseGridOverAllHeader=parsed['Table1'][0];
            dieselPurchaseGridList=t.map((e) => DieselPurchaseGridModel.fromJson(e)).toList();
          }
        }

        updateDieselLoader(false);
      });
    }catch(e){
      updateDieselLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.getDieselDetail}" , e.toString());
    }


  }







  /**************************************  Diesel Issue   **************************************/

  DateTime DI_currentTime;
  int DI_plantID=null;
  String DI_plantName=null;
  int DI_machineID=null;
  String DI_machineName=null;
  int DI_issueID=null;
  String DI_issueName=null;
  TextEditingController DI_machineRunningMeter=new TextEditingController();
  TextEditingController DI_dieselQty=new TextEditingController();

  String DI_MachinType=null;
  bool isVehicle=false;
  bool isMachine=false;


  int EditDieselIssueId=null;

  InsertDieselIssueDbHit(BuildContext context)  async{
    updateDieselLoader(true);
    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": isDieselIssueEdit?"${Sp.updateDieselIssueDetail}": "${Sp.insertDieselIssueDetail}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": Provider.of<QuarryNotifier>(context,listen: false).UserId
        },
        {
          "Key": "PlantId",
          "Type": "int",
          "Value": DI_plantID
        },
        {
          "Key": "IsMachine",
          "Type": "int",
          "Value": isMachine?1:0
        },
        {
          "Key": "IsVehicle",
          "Type": "int",
          "Value": isVehicle?1:0
        },
        {
          "Key": "MachineId",
          "Type": "int",
          "Value":isMachine? DI_machineID:null
        },
        {
          "Key": "VehicleId",
          "Type": "int",
          "Value":isVehicle? DI_machineID:null
        },

        {
          "Key": "IssuedBy",
          "Type": "int",
          "Value": DI_issueID
        },


        {
          "Key": "DieselIssuedQuantity",
          "Type": "String",
          "Value": DI_dieselQty.text.isNotEmpty?double.parse(DI_dieselQty.text):0.0
        },
        {
          "Key": "MachineFuelReadingQuantity",
          "Type": "String",
          "Value": DI_machineRunningMeter.text.isNotEmpty?double.parse(DI_machineRunningMeter.text):0.0
        },

        {
          "Key": "DieselIssueId",
          "Type": "int",
          "Value": EditDieselIssueId
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
          GetDieselIssueDbHit(context, null);
          clearDI_form();

          //
        }

        updateDieselLoader(false);
      });
    }catch(e){
      updateDieselLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.insertDieselIssueDetail}" , e.toString());
    }


  }


  clearDI_form(){
    DI_plantID=null;
    DI_plantName=null;
    DI_machineID=null;
    DI_machineName=null;
    DI_machineRunningMeter.clear();
    DI_dieselQty.clear();
    DI_issueID=null;
    DI_issueName=null;
     DI_MachinType=null;
     isVehicle=false;
     isMachine=false;
  }

  insertDI_form(){
    DI_currentTime=DateTime.now();
  }


  List<DieselIssueGridModel> dieselIssueGridList=[];
  List<String> dieselIssueGridCol=["Date","Type","Machine/Vehicle","Fuel Reading","Issued By","Diesel Quantity"];
  var dieselIssueGridOverAllHeader={};


  GetDieselIssueDbHit(BuildContext context,int dieselIssueId)  async{

    updateDieselLoader(true);

    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": "${Sp.getDieselIssueDetail}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": Provider.of<QuarryNotifier>(context,listen: false).UserId
        },
        {
          "Key": "DieselIssueId",
          "Type": "int",
          "Value": dieselIssueId
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
          print(t);
          if(dieselIssueId!=null ){
            EditDieselIssueId=t[0]['DieselIssueId'];
            DI_plantID=t[0]['PlantId'];
            DI_plantName=t[0]['PlantName'];
            DI_MachinType=t[0]['Type'];

            DI_machineRunningMeter.text=t[0]['MachineFuelReadingQuantity'].toString();
            DI_dieselQty.text=t[0]['DieselIssuedQuantity'].toString();
            DI_issueID=t[0]['IssuedBy'];
            DI_issueName=t[0]['IssuedName'];
            isMachine=t[0]['IsMachine'];
            isVehicle=t[0]['IsVehicle'];
            if(isMachine){
              DI_machineID=t[0]['MachineId'];
              DI_machineName=t[0]['MachineName'];
            }
            else if(isVehicle){
              DI_machineID=t[0]['VehicleId'];
              DI_machineName=t[0]['VehicleNumber'];
            }


          }
          else{
            dieselIssueGridOverAllHeader=parsed['Table1'][0];
            dieselIssueGridList=t.map((e) => DieselIssueGridModel.fromJson(e)).toList();
          }
        }

        updateDieselLoader(false);
      });
    }catch(e){
      updateDieselLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.getDieselIssueDetail}" , e.toString());
    }


  }

  DeleteDieselIssueDbHit(BuildContext context,int DieselIssueId)  async{
    updateDieselLoader(true);
    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value":  "${Sp.deleteDieselIssueDetail}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": Provider.of<QuarryNotifier>(context,listen: false).UserId
        },


        {
          "Key": "DieselIssueId",
          "Type": "int",
          "Value": DieselIssueId
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


          GetDieselIssueDbHit(context, null);

        }

        updateDieselLoader(false);
      });
    }catch(e){
      updateDieselLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.deleteDieselIssueDetail}" , e.toString());
    }


  }

  bool isDieselEdit=false;
  updateDieselEdit(bool value){
    isDieselEdit=value;
    notifyListeners();
  }


  bool isDieselIssueEdit=false;
  updateDieselIssueEdit(bool value){
    isDieselIssueEdit=value;
    notifyListeners();
  }

  bool DieselLoader=false;
  updateDieselLoader(bool value){
    DieselLoader=value;
    notifyListeners();
  }
}


