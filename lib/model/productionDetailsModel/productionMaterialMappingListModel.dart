import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';

class ProductionMaterialMappingListModel{


  int ProductionOutputMaterialMappingId;
  int ProductionId;

  int IsActive;
  int OutputMaterialId;
  double OutputMaterialQuantity;
  String MaterialUnit;
  String MaterialName;

  int UnitId;
  AnimationController scaleController;
  Animation<double> scaleAnimation;
  bool isEdit;

/*  guestNoController=AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
  scaleAnimation = new Tween(begin: 0.0, end: 1.0)
      .animate(new CurvedAnimation(parent: guestNoController, curve: Curves.easeInOutBack));*/


  ProductionMaterialMappingListModel({
    this.ProductionOutputMaterialMappingId,
    this.ProductionId,
    this.OutputMaterialId,
    this.OutputMaterialQuantity,
    this.MaterialName,
    this.IsActive,
    this.scaleAnimation,
    this.scaleController,
    this.MaterialUnit,
    this.UnitId,
    this.isEdit

  });







  factory ProductionMaterialMappingListModel.fromJson(Map<String, dynamic> json,TickerProviderStateMixin tickerProviderStateMixin) => ProductionMaterialMappingListModel(
      ProductionOutputMaterialMappingId: json["ProductionOutputMaterialMappingId"],
      ProductionId: json["ProductionId"],
      UnitId: json["UnitId"],
      OutputMaterialQuantity: json["OutputMaterialQuantity"],
      IsActive: json["IsActive"],
      MaterialName: json["MaterialName"],
      MaterialUnit: json["MaterialUnit"],
      OutputMaterialId: json["OutputMaterialId"],
      scaleController: AnimationController(duration: Duration(milliseconds: 300,),vsync: tickerProviderStateMixin),
      isEdit: true
  );

  Map<String, dynamic> toJson() => {
    "ProductionOutputMaterialMappingId": ProductionOutputMaterialMappingId,
    "ProductionId": ProductionId,
    "UnitId": UnitId,
    "OutputMaterialId": OutputMaterialId,
    "OutputMaterialQuantity": OutputMaterialQuantity,
    "IsActive": IsActive,
  };
}