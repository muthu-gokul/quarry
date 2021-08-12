import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';

class GoodsReceivedGridModel {
  GoodsReceivedGridModel({
    this.goodsReceivedId,
    this.grnNumber,
    this.purchaseOrderId,
    this.purchaseOrderNumber,
    this.date,
    this.plantId,
    this.plantName,
    this.status,
    this.isAnimate,
    this.controller,
    this.IsVehicleOutPending,
  });

  int? goodsReceivedId;
  String? grnNumber;
  int? purchaseOrderId;
  int? IsVehicleOutPending;
  String? purchaseOrderNumber;
  String? date;
  int? plantId;
  String? plantName;
  String? status;
  AnimationController? controller;

  bool? isAnimate;

  factory GoodsReceivedGridModel.fromJson(Map<String, dynamic> json,TickerProviderStateMixin tickerProviderStateMixin) => GoodsReceivedGridModel(
    goodsReceivedId: json["GoodsReceivedId"],
    grnNumber: json["GRNNumber"],
    purchaseOrderId: json["PurchaseOrderId"],
    purchaseOrderNumber: json["PurchaseOrderNumber"],
    date: json["Date"],
    plantId: json["PlantId"],
    plantName: json["PlantName"],
    status: json["Status"],
      IsVehicleOutPending: json["IsVehicleOutPending"],
    isAnimate: false,
    controller: AnimationController(duration: Duration(milliseconds: 300),vsync: tickerProviderStateMixin)
  );

  Map<String, dynamic> toJson() => {
    "GoodsReceivedId": goodsReceivedId,
    "GRNNumber": grnNumber,
    "PurchaseOrderId": purchaseOrderId,
    "PurchaseOrderNumber": purchaseOrderNumber,
    "Date": date,
    "PlantId": plantId,
    "PlantName": plantName,
    "Status": status,
  };
}
