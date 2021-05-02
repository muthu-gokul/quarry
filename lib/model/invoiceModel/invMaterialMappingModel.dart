import 'package:flutter/cupertino.dart';

class InvoiceMaterialMappingListModel{
  int InvoiceMaterialMappingId;
  int  InvoiceId;
  int MaterialId;
  String materialName;
  double  MaterialPrice;
  double  PurchaseQuantity;
  double  Subtotal;//subtotal
  int  IsDiscount;
  int  IsPercentage;
  int  IsAmount;
  double  DiscountValue;
  double  DiscountAmount;
  double  DiscountedSubTotal;
  double  TaxValue;
  double  TaxAmount;
  double  TotalAmount;
  int  IsActive;
  int materialUnitId;
  String unitName;

  TextEditingController purchaseQty;

  InvoiceMaterialMappingListModel({
    this.InvoiceMaterialMappingId,
    this.InvoiceId,
    this.MaterialId,
    this.MaterialPrice,
    this.materialName,
    this.PurchaseQuantity,
    this.Subtotal,
    this.IsDiscount,
    this.IsPercentage,
    this.IsAmount,
    this.DiscountValue,
    this.DiscountAmount,
    this.DiscountedSubTotal,
    this.TaxValue,
    this.TaxAmount,
    this.TotalAmount,
    this.IsActive,
    this.purchaseQty,
    this.materialUnitId,
    this.unitName,
  });



  factory InvoiceMaterialMappingListModel.fromJson(Map<String, dynamic> json) => InvoiceMaterialMappingListModel(
    InvoiceId: json["InvoiceId"],
    MaterialId: json["MaterialId"],
    materialName: json["MaterialName"],
    MaterialPrice: json["MaterialPrice"],
    materialUnitId: json["MaterialUnitId"],
    unitName: json["UnitName"],
   // PurchaseQuantity: json["PurchaseQuantity"],
    purchaseQty: TextEditingController()..text=json["MaterialQuantity"].toString(),
    Subtotal: json["Subtotal"],
    TaxValue: json["TaxValue"],
    TaxAmount: json["TaxAmount"],
    IsDiscount: json["IsDiscount"],
    IsPercentage: json["IsPercentage"],
    IsAmount: json["IsAmount"],
    DiscountValue: json["DiscountValue"],
    DiscountAmount: json["DiscountAmount"],
    DiscountedSubTotal: json["DiscountedSubTotal"],
    TotalAmount: json["TotalAmount"],

  );


  Map<String, dynamic> toJson() => {
    "InvoiceMaterialMappingId":InvoiceMaterialMappingId,
    "InvoiceId":InvoiceId,
    "MaterialId":MaterialId,
    "MaterialPrice":MaterialPrice,
    "MaterialQuantity":purchaseQty.text.isEmpty?0.0:double.parse(purchaseQty.text),
    "Subtotal":Subtotal,
    "IsDiscount":IsDiscount,
    "IsPercentage":IsPercentage,
    "IsAmount":IsAmount,
    'DiscountValue':DiscountValue,
    "DiscountAmount":DiscountAmount,
    "DiscountedSubTotal":DiscountedSubTotal,
    "TaxValue":TaxValue,
    "TaxAmount":TaxAmount,
    "TotalAmount":TotalAmount,
    "IsActive":IsActive,

  };





}