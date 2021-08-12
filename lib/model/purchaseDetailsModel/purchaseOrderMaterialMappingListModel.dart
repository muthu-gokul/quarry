import 'package:flutter/cupertino.dart';

class PurchaseOrderMaterialMappingListModel{
 int? PurchaseOrderMaterialMappingId;
 int?  PurchaseOrderId;
 int? MaterialId;
 String? materialName;
 double?  MaterialPrice;
 double?  PurchaseQuantity;
 double?  Amount;//subtotal
 int?  IsDiscount;
 int?  IsPercentage;
 int?  IsAmount;
 double?  DiscountValue;
 double?  DiscountAmount;
 double?  TaxValue;
 double?  TaxAmount;
 double?  TotalAmount;
 int?  IsActive;
 int? materialUnitId;
 String? unitName;

 TextEditingController? purchaseQty;

 PurchaseOrderMaterialMappingListModel({
      this.PurchaseOrderMaterialMappingId,
      this.PurchaseOrderId,
      this.MaterialId,
      this.MaterialPrice,
      this.materialName,
      this.PurchaseQuantity,
      this.Amount,
      this.IsDiscount,
      this.IsPercentage,
      this.IsAmount,
      this.DiscountValue,
      this.DiscountAmount,
      this.TaxValue,
      this.TaxAmount,
      this.TotalAmount,
      this.IsActive,
      this.purchaseQty,
   this.materialUnitId,
   this.unitName,
 });



 factory PurchaseOrderMaterialMappingListModel.fromJson(Map<String, dynamic> json) => PurchaseOrderMaterialMappingListModel(
   PurchaseOrderId: json["PurchaseOrderId"],
   MaterialId: json["MaterialId"],
   materialName: json["MaterialName"],
   MaterialPrice: json["MaterialPrice"],
   materialUnitId: json["MaterialUnitId"],
   unitName: json["UnitName"],
   PurchaseQuantity: json["PurchaseQuantity"],
   purchaseQty: TextEditingController()..text=json["PurchaseQuantity"].toString(),
   Amount: json["Amount"],
   TaxValue: json["TaxValue"],
   TaxAmount: json["TaxAmount"],
   IsDiscount: json["IsDiscount"],
   IsPercentage: json["IsPercentage"],
   IsAmount: json["IsAmount"],
   DiscountValue: json["DiscountValue"],
   DiscountAmount: json["DiscountAmount"],
   TotalAmount: json["TotalAmount"],

 );


 Map<String, dynamic> toJson() => {
   "PurchaseOrderMaterialMappingId":PurchaseOrderMaterialMappingId,
   "PurchaseOrderId":PurchaseOrderId,
   "MaterialId":MaterialId,
   "MaterialPrice":MaterialPrice,
   "PurchaseQuantity":purchaseQty!.text.isEmpty?0.0:double.parse(purchaseQty!.text),
   "Amount":Amount,
   "IsDiscount":IsDiscount,
   "IsPercentage":IsPercentage,
   "IsAmount":IsAmount,
   'DiscountValue':DiscountValue,
   "DiscountAmount":DiscountAmount,
   "TaxValue":TaxValue,
   "TaxAmount":TaxAmount,
   "TotalAmount":TotalAmount,
   "IsActive":IsActive,

 };





}