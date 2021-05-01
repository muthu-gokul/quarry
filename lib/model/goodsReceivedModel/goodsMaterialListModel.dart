import 'package:flutter/cupertino.dart';

class GoodsReceivedMaterialListModel {
  GoodsReceivedMaterialListModel({
    this.goodsReceivedId,
    this.purchaseOrderId,
    this.materialId,
    this.materialName,
    this.materialUnitId,
    this.unitName,
    this.materialPrice,
    this.quantity,
    this.receivedQuantity,
    this.balanceQuantity,
    this.amount,
    this.vehicleTypeId,
    this.vehicleNumber,
    this.inwardLoadedVehicleWeight,
    this.outwardEmptyVehicleWeight,
    this.status,
    
    this.GoodsReceivedMaterialMappingId,

  });

  int goodsReceivedId;
  int purchaseOrderId;
  int materialId;
  String materialName;
  String unitName;
  int materialUnitId;
  double materialPrice;
  double quantity;
  double receivedQuantity;
  double balanceQuantity;
  double amount;
  int vehicleTypeId;
  String vehicleNumber;
  double inwardLoadedVehicleWeight;
  double outwardEmptyVehicleWeight;
  String status;

  
  int GoodsReceivedMaterialMappingId;

  
  factory GoodsReceivedMaterialListModel.fromJson(Map<String, dynamic> json) => GoodsReceivedMaterialListModel(
    GoodsReceivedMaterialMappingId: json["GoodsReceivedMaterialMappingId"],
    goodsReceivedId: json["GoodsReceivedId"],
    purchaseOrderId: json["PurchaseOrderId"],
    materialId: json["MaterialId"],
    materialName: json["MaterialName"],
    materialUnitId: json["MaterialUnitId"],
    unitName: json["UnitName"],
    materialPrice: json["MaterialPrice"],
    quantity: json["Quantity"].toDouble(),
    receivedQuantity:json["ReceivedQuantity"]==null?0.0: json["ReceivedQuantity"].toDouble(),
    balanceQuantity: json["BalanceQuantity"]==null?0.0:json["BalanceQuantity"].toDouble(),
    amount: json["TotalAmount"],
    vehicleTypeId: json["VehicleTypeId"],
    vehicleNumber: json["VehicleNumber"],
   // inwardLoadedVehicleWeight: json["InwardLoadedVehicleWeight"].toDouble(),
   // outwardEmptyVehicleWeight: json["OutwardEmptyVehicleWeight"].toDouble(),
    status: json["Status"],
  );

  Map<String, dynamic> toJsonInWard(int vehicleTypeId,String vehicleNumber,double inwardWeight) => {
    "GoodsReceivedMaterialMappingId": GoodsReceivedMaterialMappingId,
    "GoodsReceivedId": goodsReceivedId,
    "MaterialId": materialId,
    "ExpectedQuantity": quantity,
    "ReceivedQuantity": 0.0,
    "Amount": 0.0,
    "VehicleTypeId": vehicleTypeId,
    "VehicleNumber": vehicleNumber,
    "InwardLoadedVehicleWeight": inwardWeight,
    "OutwardEmptyVehicleWeight": 0.0,
    "IsActive": 1,
  };
}
