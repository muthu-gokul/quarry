import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';

class SupplierMaterialMappingListModel{


  int? SupplierMaterialMappingId;
  int? SupplierId;
  int? MaterialId;
  int? IsActive;
  double? MaterialPrice;
  String? MaterialName;
  String? UnitName;

  AnimationController? scaleController;
  Animation<double>? scaleAnimation;
  bool? isEdit;
  bool? isDelete;

/*  guestNoController=AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
  scaleAnimation = new Tween(begin: 0.0, end: 1.0)
      .animate(new CurvedAnimation(parent: guestNoController, curve: Curves.easeInOutBack));*/


  SupplierMaterialMappingListModel({
    this.SupplierMaterialMappingId,
    this.SupplierId,
    this.MaterialId,
    this.MaterialPrice,
    this.IsActive,
    this.MaterialName,
    this.scaleAnimation,
    this.scaleController,
    this.UnitName,
    this.isEdit,
    this.isDelete
  });

  factory SupplierMaterialMappingListModel.fromJson(Map<String, dynamic> json,TickerProviderStateMixin tickerProviderStateMixin) => SupplierMaterialMappingListModel(
    SupplierMaterialMappingId: json["SupplierMaterialMappingId"],
    SupplierId: json["SupplierId"],
    MaterialId: json["MaterialId"],
    MaterialPrice: json["MaterialPrice"].toDouble(),
    IsActive: json["IsActive"],
    MaterialName: json["MaterialName"],
    UnitName: json["UnitName"],
    scaleController: AnimationController(duration: Duration(milliseconds: 300,),vsync: tickerProviderStateMixin),
    isEdit: true,
    isDelete: false
  );

  Map<String, dynamic> toJson() => {
    "SupplierMaterialMappingId": SupplierMaterialMappingId,
    "SupplierId": SupplierId,
    "MaterialId": MaterialId,
    "MaterialPrice": MaterialPrice,
    "IsActive": IsActive,
  };
}