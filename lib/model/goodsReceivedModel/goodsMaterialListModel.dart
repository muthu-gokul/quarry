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
    this.isDiscount,
    this.isPercentage,
    this.isAmount,
    this.discountValue,
    this.discountAmount,
    this.taxValue,
    this.taxAmount,
    this.totalAmount,
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

  int isDiscount;
  int isPercentage;
  int isAmount;
  double discountValue;
  double discountAmount;
  double taxValue;
  double taxAmount;
  double totalAmount;

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
    amount: json["Amount"],
    isDiscount: json["IsDiscount"],
    isPercentage: json["IsPercentage"],
    isAmount: json["IsAmount"],
    discountValue: json["DiscountValue"],
    discountAmount: json["DiscountAmount"],
    taxValue: json["TaxValue"],
    taxAmount: json["TaxAmount"],
    totalAmount: json["TotalAmount"],
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
    "MaterialPrice": materialPrice,
    "ExpectedQuantity": quantity,
    "ReceivedQuantity": receivedQuantity,
    "Amount": amount,
    "VehicleTypeId": vehicleTypeId,
    "VehicleNumber": vehicleNumber,
    "InwardLoadedVehicleWeight": inwardWeight,
    "OutwardEmptyVehicleWeight": 0.0,
    "IsDiscount": isDiscount,
    "IsPercentage": isPercentage,
    "IsAmount": isAmount,
    "DiscountValue": discountValue,
    "DiscountAmount": discountAmount,
    "TaxValue": taxValue,
    "TaxAmount": taxAmount,
    "TotalAmount": totalAmount,
    "IsActive": 1,
  };
}



class GoodsOtherChargesModel {
  GoodsOtherChargesModel({
    this.purchaseOrderId,
    this.GoodsReceivedOtherChargesMappingId,
    this.GoodsReceivedId,
    this.otherChargesName,
    this.otherChargesAmount,
    this.animationController,
    this.isEdit
  });

  int purchaseOrderId;
  int GoodsReceivedOtherChargesMappingId;
  int GoodsReceivedId;
  String otherChargesName;
  double otherChargesAmount;

  AnimationController animationController;
  bool isEdit;

  factory GoodsOtherChargesModel.fromJson(Map<String, dynamic> json,TickerProviderStateMixin tickerProviderStateMixin) => GoodsOtherChargesModel(
    purchaseOrderId: json["PurchaseOrderId"],
    otherChargesName: json["OtherChargesName"],
    otherChargesAmount: json["OtherChargesAmount"],
    animationController: AnimationController(duration: Duration(milliseconds: 300),vsync: tickerProviderStateMixin),
    isEdit: false
  );

  Map<String, dynamic> toJson() => {
    "GoodsReceivedOtherChargesMappingId": GoodsReceivedOtherChargesMappingId,
    "GoodsReceivedId": GoodsReceivedId,
    "OtherChargesName": otherChargesName,
    "OtherChargesAmount": otherChargesAmount,
    "IsActive": 1,
  };
}
