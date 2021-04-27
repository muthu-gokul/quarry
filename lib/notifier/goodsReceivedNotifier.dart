import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:quarry/api/ApiManager.dart';
import 'package:quarry/api/sp.dart';
import 'package:quarry/model/goodsReceivedModel/goodsMaterialListModel.dart';
import 'package:quarry/model/goodsReceivedModel/goodsReceivedGridModel.dart';
import 'package:quarry/model/vehicelDetailsModel/vehicleTypeModel.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/pages/goodsReceived/goodsMaterialsList.dart';
import 'package:quarry/widgets/alertDialog.dart';

class GoodsReceivedNotifier extends ChangeNotifier{

  final call=ApiManager();



  List<VehicleTypeModel> vehicleTypeList=[];
  GoodsDropDownValues(BuildContext context) async {
    updateGoodsLoader(true);
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
          "Value": "Goods"
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
          print(t);

          vehicleTypeList=t.map((e) => VehicleTypeModel.fromJson(e)).toList();
        }



        updateGoodsLoader(false);
      });
    }
    catch(e){
      updateGoodsLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.MasterdropDown}" , e.toString());
    }
  }



   // Materials List
  String ML_PorderNo=null;
  int ML_PorderId=null;
  int ML_GoodsorderId=null;
  String ML_Date=null;
  List<GoodsReceivedMaterialListModel> ML_Materials=[];

  ML_clear(){
    ML_Date=null;
    ML_Materials.clear();
    ML_PorderNo=null;
    ML_PorderId=null;
    ML_GoodsorderId=null;
  }


  //InGateForm IGF
  TextEditingController vehicleNo=new TextEditingController();
  TextEditingController loadedWeight=new TextEditingController();
  int IGF_vehicleTypeId;
  int selectedVehicleTypeId=null;
  var selectedVehicleTypeName=null;
  List<GoodsReceivedMaterialListModel> IGF_Materials=[];


  IGF_clear(){
    vehicleNo.clear();
    loadedWeight.clear();
    IGF_vehicleTypeId=null;
    selectedVehicleTypeId=null;
    selectedVehicleTypeName=null;
    IGF_Materials.clear();
  }




  InsertGoodsDbHit(BuildContext context)  async{
    updateGoodsLoader(true);
    List js=[];
    js=IGF_Materials.map((e) => e.toJsonInWard(selectedVehicleTypeId,
        vehicleNo.text,
        double.parse(loadedWeight.text))
    ).toList();
    print(js);
    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": isGoodsEdit?"${Sp.updateGoodsReceivedDetail}":"${Sp.insertGoodsReceivedDetail}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": Provider.of<QuarryNotifier>(context,listen: false).UserId
        },

        {
          "Key": "PurchaseOrderId",
          "Type": "int",
          "Value": ML_PorderId
        },
        {
          "Key": "GoodsReceivedMaterialMappingList",
          "Type": "datatable",
          "Value": js
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
          GetGoodsDbHit(context, ML_GoodsorderId,ML_PorderId);
          Navigator.pop(context);
          IGF_clear();
          print(GoodsMaterialsListState().mounted);
        //
        }

        updateGoodsLoader(false);
      });
    }catch(e){
      updateGoodsLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.insertGoodsReceivedDetail}" , e.toString());
    }


  }




  List<GoodsReceivedGridModel> goodsGridList=[];
  GetGoodsDbHit(BuildContext context,int goodsReceivedId,int purchaseOrderId)  async{
    updateGoodsLoader(true);

    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": "${Sp.getGoodsReceivedDetail}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": Provider.of<QuarryNotifier>(context,listen: false).UserId
        },
        {
          "Key": "GoodsReceivedId",
          "Type": "int",
          "Value": goodsReceivedId
        },
        {
          "Key": "PurchaseOrderId",
          "Type": "int",
          "Value": purchaseOrderId
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
          if(goodsReceivedId!=null || purchaseOrderId!=null){
            ML_PorderNo=t[0]['PurchaseOrderNumber'];
            ML_PorderId=t[0]['PurchaseOrderId'];
            ML_GoodsorderId=t[0]['GoodsReceivedId'];
            ML_Date=t[0]['Date'];
            print(ML_PorderId);
            var t1=parsed['Table1'] as List;
            ML_Materials=t1.map((e) => GoodsReceivedMaterialListModel.fromJson(e)).toList();
            notifyListeners();
          }
          else{
            goodsGridList=t.map((e) => GoodsReceivedGridModel.fromJson(e)).toList();
          }
        }

        updateGoodsLoader(false);
      });
    }catch(e){
      updateGoodsLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.getGoodsReceivedDetail}" , e.toString());
    }


  }




  bool isGoodsEdit=false;
  updateGoodsEdit(bool value){
    isGoodsEdit=value;
    notifyListeners();
  }

  bool GoodsLoader=false;
  updateGoodsLoader(bool value){
    GoodsLoader=value;
    notifyListeners();
  }
}