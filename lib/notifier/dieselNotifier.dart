import 'dart:convert';
import 'dart:developer';
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
import 'package:quarry/model/manageUsersModel/manageUsersPlantModel.dart';
import 'package:quarry/model/parameterMode.dart';
import 'package:quarry/model/plantModel/plantUserModel.dart';
import 'package:quarry/notifier/profileNotifier.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/styles/constants.dart';
import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/calculation.dart';
import 'package:quarry/widgets/decimal.dart';

class DieselNotifier extends ChangeNotifier{

  final call=ApiManager();



  List<PlantUserModel> plantList=[];
  int plantCount=0;
  Future<dynamic>  PlantUserDropDownValues(BuildContext context) async {

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

          var t=parsed['Table'] as List?;
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


        }
        updateDieselLoader(false);
      });
    }
    catch(e){
      updateDieselLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.MasterdropDown}" , e.toString());
    }
  }


  List<dynamic>? fuelSupplierList=[];
  List<dynamic>? filterFuelSupplierList=[];

  List<dynamic>? fuelPurchaserList=[];
  List<dynamic>? filterFuelPurchaserList=[];
 // List<DieselVehicleModel> vehicleList=[];
 // List<DieselVehicleModel> filterVehicleList=[];

  List<dynamic>? issuedByList=[];
  List<dynamic>? filterIssuedByList=[];
  //List<DieselMachineModel> machineList=[];

  List<dynamic>? machineTypeList=[];

  List<dynamic>? vehicleList=[];
  List<dynamic>? filterVehicleList=[];

  List<dynamic>? machineList=[];
  List<dynamic>? filterMachineList=[];

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
        if(value!="null"){
          var parsed=json.decode(value);


          var t=parsed['Table'] as List?;
          var t1=parsed['Table1'] as List?;
          var t2=parsed['Table2'] as List?;

          var t3=parsed['Table3'] as List?;
          var t4=parsed['Table4'] as List?;
          var t5=parsed['Table5'] as List?;


          fuelSupplierList=t;
          filterFuelSupplierList=t;
          fuelPurchaserList=t1;
          filterFuelPurchaserList=t1;

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
      filterVehicleList=vehicleList!.where((element) => element['VehicleNumber'].toLowerCase().contains(value.toLowerCase())).toList();
    }
    notifyListeners();
  }


  searchMachine(String value){
    if(value.isEmpty){
      filterMachineList=machineList;
    }
    else{
      filterMachineList=machineList!.where((element) => element['MachineName'].toLowerCase().contains(value.toLowerCase())).toList();
    }
    notifyListeners();
  }


  searchIssuedBy(String value){
    if(value.isEmpty){
      filterIssuedByList=issuedByList;
    }
    else{
      filterIssuedByList=issuedByList!.where((element) => element['EmployeeName'].toLowerCase().contains(value.toLowerCase())).toList();
    }
    notifyListeners();
  }

  //diesel purchase search fields
  searchFuelPurchaser(String value){
    if(value.isEmpty){
      filterFuelPurchaserList=fuelPurchaserList;
    }
    else{
      filterFuelPurchaserList=fuelPurchaserList!.where((element) => element['EmployeeName'].toLowerCase().contains(value.toLowerCase())).toList();
    }
    notifyListeners();
  }

  searchFuelSupplier(String value){
    if(value.isEmpty){
      filterFuelSupplierList=fuelSupplierList;
    }
    else{
      filterFuelSupplierList=fuelSupplierList!.where((element) => element['SupplierName'].toLowerCase().contains(value.toLowerCase())).toList();
    }
    notifyListeners();
  }


  //Insert Diesel Purchase

  int? DP_PlantId=null;
  String? DP_PlantName=null;

  DateTime? DP_currentTime;
  DateTime? DP_billDate;
  int? DP_supplierId=null;
  dynamic DP_supplierName=null;
  int? DP_purchaserId=null;
  dynamic DP_purchaserName=null;
  int? DP_vehicleId=null;
  dynamic DP_vehicleName=null;
  bool DP_isVehicle=false;
  TextEditingController DP_billno=new TextEditingController();
  TextEditingController DP_location=new TextEditingController();
  TextEditingController DP_contactNo=new TextEditingController();

  TextEditingController DP_dieselQTY=new TextEditingController();
  TextEditingController DP_dieselPrice=new TextEditingController();
double? totalAmount=0.0;

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


 int? EditDieselPurchaseId=null;

  InsertDieselPurchaseDbHit(BuildContext context)  async{
    updateDieselLoader(true);
    parameters=[
      ParameterModel(Key: "SpName", Type: "String", Value: isDieselEdit?"${Sp.updateDieselDetail}": "${Sp.insertDieselDetail}"),
      ParameterModel(Key: "LoginUserId", Type: "int", Value: Provider.of<QuarryNotifier>(context,listen: false).UserId),
      ParameterModel(Key: "PlantId", Type: "int", Value: DP_PlantId),
      ParameterModel(Key: "BillNumber", Type: "String", Value:DP_billno.text),
      ParameterModel(Key: "BillDate", Type: "String", Value:DateFormat("yyyy-MM-dd").format(DP_billDate!).toString()),
      ParameterModel(Key: "SupplierId", Type: "int", Value: DP_supplierId),
      ParameterModel(Key: "EmployeeId", Type: "int", Value: DP_purchaserId),
      ParameterModel(Key: "DieselBunkLocation", Type: "String", Value: DP_location.text),
      ParameterModel(Key: "DieselBunkContactNumber", Type: "String", Value: DP_contactNo.text),
      ParameterModel(Key: "IsVehicle", Type: "int", Value: DP_isVehicle?1:0),
      ParameterModel(Key: "VehicleId", Type: "int", Value: DP_vehicleId),
      ParameterModel(Key: "DieselQuantity", Type: "String", Value: DP_dieselQTY.text.isNotEmpty?double.parse(DP_dieselQTY.text):0.0),
      ParameterModel(Key: "DieselRate", Type: "String", Value: DP_dieselPrice.text.isNotEmpty?double.parse(DP_dieselPrice.text):0.0),
      ParameterModel(Key: "TotalAmount", Type: "String", Value: totalAmount),
     // ParameterModel(Key: "UnitId", Type: "int", Value: null),
      ParameterModel(Key: "database", Type: "String", Value:Provider.of<QuarryNotifier>(context,listen: false).DataBaseName),
    ];
    if(isDieselEdit){
      parameters.insert(2,   ParameterModel(Key: "DieselPurchaseId", Type: "int", Value: EditDieselPurchaseId));
    }
    log("${parameters.map((e) => e.toJson()).toList()}");
    var body={
      "Fields": parameters.map((e) => e.toJson()).toList()
    };

    try{
      await call.ApiCallGetInvoke(body,context).then((value) {
        log(value);
        if(value!="null"){
          var parsed=json.decode(value);
          GetDieselPurchaseDbHit(context, null);
          Navigator.pop(context);

          clearDP_Form();

          //
        }
        else{
          updateDieselLoader(false);
        }


      });
    }catch(e){
      updateDieselLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.insertDieselDetail}" , e.toString());
    }


  }

  clearDP_Form(){
    DP_supplierId=null;
    DP_supplierName=null;
    DP_purchaserId=null;
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
    DP_billDate=null;
    notifyListeners();
  }



  List<DateTime?> picked=[];
  List<ManageUserPlantModel> filterUsersPlantList=[];


  List<String> dieselPurchaseGridCol=["Bill Number","Purchaser Name","Location","Contact Number","Diesel Quantity","Diesel Rate","Amount","Date"];
  List<DieselPurchaseGridModel> dieselPurchaseGridList=[];
  List<DieselPurchaseGridModel> filterDieselPurchaseGridList=[];
  var dieselPurchaseGridOverAllHeader={};
  List<dynamic>? dbCounterValues=[];

  GetDieselPurchaseDbHit(BuildContext context,int? dieselPurchaseId)  async{

    updateDieselLoader(true);
    String? fromDate,toDate;

    if(picked.isEmpty){
      fromDate=DateFormat("yyyy-MM-dd").format(DateTime.now()).toString();
      toDate=DateFormat("yyyy-MM-dd").format(DateTime.now()).toString();
    }
    else if(picked.length==1){
      fromDate=DateFormat("yyyy-MM-dd").format(picked[0]!).toString();
      toDate=DateFormat("yyyy-MM-dd").format(picked[0]!).toString();
    }
    else if(picked.length==2){
      fromDate=DateFormat("yyyy-MM-dd").format(picked[0]!).toString();
      toDate=DateFormat("yyyy-MM-dd").format(picked[1]!).toString();
    }

    parameters=[
      ParameterModel(Key: "SpName", Type: "String", Value: "${Sp.getDieselDetail}"),
      ParameterModel(Key: "LoginUserId", Type: "int", Value: Provider.of<QuarryNotifier>(context,listen: false).UserId),
      ParameterModel(Key: "DieselPurchaseId", Type: "int", Value: dieselPurchaseId),
      ParameterModel(Key: "FromDate", Type: "String", Value:fromDate),
      ParameterModel(Key: "ToDate", Type: "String", Value:toDate),
      ParameterModel(Key: "database", Type: "String", Value:Provider.of<QuarryNotifier>(context,listen: false).DataBaseName),
    ];

    var body={
      "Fields": parameters.map((e) => e.toJson()).toList()
    };

    try{
      await call.ApiCallGetInvoke(body,context).then((value) {
        if(value!="null"){
          log(value);
          if(filterUsersPlantList.isEmpty){

            Provider.of<ProfileNotifier>(context, listen: false).usersPlantList.forEach((element) {
              filterUsersPlantList.add(ManageUserPlantModel(
                plantId: element.plantId,
                plantName: element.plantName,
                isActive: element.isActive,
              ));
            });

          }
          else if(filterUsersPlantList.length!=Provider.of<ProfileNotifier>(context, listen: false).usersPlantList.length){
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
          var t=parsed['Table'] as List?;
          if(dieselPurchaseId!=null ){

            EditDieselPurchaseId=t![0]['DieselPurchaseId'];
            DP_PlantId=t[0]['PlantId'];
            DP_PlantName=t[0]['PlantName'];
            DP_billno.text=t[0]['BillNumber'];
            DP_billDate=DateFormat("yyyy-MM-dd").parse(t[0]['BillDate']);

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
            totalAmount=t[0]['TotalAmount'].toDouble();
          }
          else{

            if(parsed['Table1']!=null){
              dbCounterValues=parsed['Table1'] as List?;
              filterDieselPurchaseGridList=t!.map((e) => DieselPurchaseGridModel.fromJson(e)).toList();
              filterDieselPurchaseGrid();
            }

          }
        }

        updateDieselLoader(false);
      });
    }catch(e){
      updateDieselLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.getDieselDetail}" , e.toString());
    }
  }
  filterDieselPurchaseGrid(){

    double totalPurchase=0.0;
    double totalIssue=0.0;
    double totalBalance=0.0;

    dieselPurchaseGridList.clear();
    dieselPurchaseGridOverAllHeader.clear();

    filterUsersPlantList.forEach((element) {
      if(element.isActive!){
        dieselPurchaseGridList=dieselPurchaseGridList+filterDieselPurchaseGridList.where((ele) => ele.PlantId==element.plantId).toList();

        dbCounterValues!.forEach((element2) {
          if(element2['PlantId']==element.plantId){
            totalPurchase=Calculation().add(totalPurchase, element2['TotalPurchaseDiesel']);
            totalIssue=Calculation().add(totalIssue, element2['TotalIssueDiesel']);
          }
        });

      }
    });


      totalBalance=Calculation().sub(totalPurchase, totalIssue);

    dieselPurchaseGridOverAllHeader["Total Purchase Diesel"]="$totalPurchase Ltr";
    dieselPurchaseGridOverAllHeader["Total Issue Diesel"]="$totalIssue Ltr";
    dieselPurchaseGridOverAllHeader["Total Balance Diesel"]="$totalBalance Ltr";

    notifyListeners();
  }






  /**************************************  Diesel Issue   **************************************/

  DateTime? DI_currentTime;
  int? DI_plantID=null;
  String? DI_plantName=null;
  int? DI_machineID=null;
  String? DI_machineName=null;
  int? DI_issueID=null;
  String? DI_issueName=null;
  TextEditingController DI_machineRunningMeter=new TextEditingController();
  TextEditingController DI_dieselQty=new TextEditingController();

  String? DI_MachinType=null;
  bool? isVehicle=false;
  bool? isMachine=false;


  int? EditDieselIssueId=null;

  InsertDieselIssueDbHit(BuildContext context)  async{
    updateDieselLoader(true);
    parameters=[
      ParameterModel(Key: "SpName", Type: "String", Value: isDieselIssueEdit?"${Sp.updateDieselIssueDetail}": "${Sp.insertDieselIssueDetail}"),
      ParameterModel(Key: "LoginUserId", Type: "int", Value: Provider.of<QuarryNotifier>(context,listen: false).UserId),
      ParameterModel(Key: "PlantId", Type: "int", Value: DI_plantID),
      ParameterModel(Key: "IsMachine", Type: "int", Value:isMachine!?1:0),
      ParameterModel(Key: "IsVehicle", Type: "int", Value:isVehicle!?1:0),
      ParameterModel(Key: "MachineId", Type: "int", Value:isMachine!? DI_machineID:null),
      ParameterModel(Key: "VehicleId", Type: "int", Value:isVehicle!? DI_machineID:null),
      ParameterModel(Key: "IssuedBy", Type: "int", Value:DI_issueID),
      ParameterModel(Key: "DieselIssuedQuantity", Type: "String", Value:DI_dieselQty.text.isNotEmpty?double.parse(DI_dieselQty.text):0.0),
      ParameterModel(Key: "MachineFuelReadingQuantity", Type: "String", Value:DI_machineRunningMeter.text.isNotEmpty?double.parse(DI_machineRunningMeter.text):0.0),
      ParameterModel(Key: "DieselIssueId", Type: "int", Value:EditDieselIssueId),
      ParameterModel(Key: "database", Type: "String", Value:Provider.of<QuarryNotifier>(context,listen: false).DataBaseName),
    ];
    var body={
      "Fields": parameters.map((e) => e.toJson()).toList()
    };

    try{
      await call.ApiCallGetInvoke(body,context).then((value) {

        if(value!=null){
          var parsed=json.decode(value);
          GetDieselIssueDbHit(context, null);
          Navigator.pop(context);

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
  List<DieselIssueGridModel> filterDieselIssueGridList=[];
  List<String> dieselIssueGridCol=["Date","Type","Machine/Vehicle","Fuel Reading","Issued By","Diesel Quantity"];
  var dieselIssueGridOverAllHeader={};
  List<dynamic>? dbIssueCounterValues=[];

  GetDieselIssueDbHit(BuildContext context,int? dieselIssueId)  async{

    updateDieselLoader(true);
    String? fromDate,toDate;

    if(picked.isEmpty){
      fromDate=DateFormat("yyyy-MM-dd").format(DateTime.now()).toString();
      toDate=DateFormat("yyyy-MM-dd").format(DateTime.now()).toString();
    }
    else if(picked.length==1){
      fromDate=DateFormat("yyyy-MM-dd").format(picked[0]!).toString();
      toDate=DateFormat("yyyy-MM-dd").format(picked[0]!).toString();
    }
    else if(picked.length==2){
      fromDate=DateFormat("yyyy-MM-dd").format(picked[0]!).toString();
      toDate=DateFormat("yyyy-MM-dd").format(picked[1]!).toString();
    }
    parameters=[
      ParameterModel(Key: "SpName", Type: "String", Value: "${Sp.getDieselIssueDetail}"),
      ParameterModel(Key: "LoginUserId", Type: "int", Value: Provider.of<QuarryNotifier>(context,listen: false).UserId),
      ParameterModel(Key: "DieselIssueId", Type: "int", Value: dieselIssueId),
      ParameterModel(Key: "FromDate", Type: "String", Value:fromDate),
      ParameterModel(Key: "ToDate", Type: "String", Value:toDate),
      ParameterModel(Key: "database", Type: "String", Value:Provider.of<QuarryNotifier>(context,listen: false).DataBaseName),
    ];

    var body={
      "Fields": parameters.map((e) => e.toJson()).toList()
    };


 try{
      await call.ApiCallGetInvoke(body,context).then((value) {
        if(value!=null){
          var parsed=json.decode(value);
          var t=parsed['Table'] as List?;

          if(dieselIssueId!=null ){
            EditDieselIssueId=t![0]['DieselIssueId'];
            DI_plantID=t[0]['PlantId'];
            DI_plantName=t[0]['PlantName'];
            DI_MachinType=t[0]['Type'];

            DI_machineRunningMeter.text=t[0]['MachineFuelReadingQuantity']==null?"":t[0]['MachineFuelReadingQuantity'].toString();
            DI_dieselQty.text=t[0]['DieselIssuedQuantity'].toString();
            DI_issueID=t[0]['IssuedBy'];
            DI_issueName=t[0]['IssuedName'];
            isMachine=t[0]['IsMachine'];
            isVehicle=t[0]['IsVehicle'];
            if(isMachine!){
              DI_machineID=t[0]['MachineId'];
              DI_machineName=t[0]['MachineName'];
            }
            else if(isVehicle!){
              DI_machineID=t[0]['VehicleId'];
              DI_machineName=t[0]['VehicleNumber'];
            }


          }
          else{
            if(parsed['Table1']!=null){
              dbIssueCounterValues=parsed['Table1'] as List?;

              filterDieselIssueGridList=t!.map((e) => DieselIssueGridModel.fromJson(e)).toList();
              filterDieselIssueGrid();
            }

          }
        }

        updateDieselLoader(false);
      });
    }catch(e){
      updateDieselLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.getDieselIssueDetail}" , e.toString());
    }
  }
  filterDieselIssueGrid(){

    int totalMachine=0;
    int totalVehicle=0;

    double totalMachineIssue=0.0;
    double totalVehicleIssue=0.0;
    double totalBalance=0.0;


    dieselIssueGridList.clear();
    dieselIssueGridOverAllHeader.clear();

    filterUsersPlantList.forEach((element) {
      if(element.isActive!){
        dieselIssueGridList=dieselIssueGridList+filterDieselIssueGridList.where((ele) => ele.plantId==element.plantId).toList();

        dbIssueCounterValues!.forEach((element2) {
          if(element2['PlantId']==element.plantId){
            totalBalance=Calculation().add(totalBalance, element2['Total Balance Diesel']);
          }
        });

      }
    });

    dieselIssueGridList.forEach((element) {
      if(element.Type=='Machine'){
        totalMachine=totalMachine+1;
        totalMachineIssue=Calculation().add(totalMachineIssue, element.dieselIssuedQuantity);
      }else if(element.Type=='Vehicle'){
        totalVehicle=totalVehicle+1;
        totalVehicleIssue=Calculation().add(totalVehicleIssue, element.dieselIssuedQuantity);
      }
    });




    dieselIssueGridOverAllHeader["Total Machine/Vehicle"]="$totalMachine / $totalVehicle";
    dieselIssueGridOverAllHeader["Issue Diesel Machine/Vehicle"]="$totalMachineIssue / $totalVehicleIssue Ltr";
    dieselIssueGridOverAllHeader["Total Balance Diesel"]="$totalBalance Ltr";

    notifyListeners();
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


  clearAll(){
    clearDI_form();
    clearDP_Form();
     fuelSupplierList=[];
     filterFuelSupplierList=[];

     fuelPurchaserList=[];
     filterFuelPurchaserList=[];

     issuedByList=[];
     filterIssuedByList=[];
     machineTypeList=[];

     vehicleList=[];
     filterVehicleList=[];

     machineList=[];
     filterMachineList=[];

     dieselPurchaseGridList=[];
     filterDieselPurchaseGridList=[];
     dieselIssueGridList=[];
     filterDieselIssueGridList=[];
  }

}


