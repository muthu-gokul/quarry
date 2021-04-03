import 'package:flutter/cupertino.dart';

class VehicleType{
  int VehicleTypeId;
  String VehicleTypeName;

  VehicleType({this.VehicleTypeId,this.VehicleTypeName});


  factory VehicleType.fromJson(Map<dynamic, dynamic> json) {
    return new VehicleType(
      VehicleTypeId: json['VehicleTypeId'],
      VehicleTypeName: json['VehicleTypeName'],
    );
  }

}



class MaterialTypelist{
  int MaterialId;
  String MaterialName;
  String MaterialDescription;
  String MaterialCode;
  int MaterialUnitId;
  String MaterialUnitName;
  double MaterialUnitPrice;
  String MaterialHSNCode;

  MaterialTypelist({this.MaterialId,this.MaterialName,this.MaterialDescription,this.MaterialCode,this.MaterialUnitId,
 this.MaterialUnitPrice,this.MaterialHSNCode,this.MaterialUnitName});


  factory MaterialTypelist.fromJson(Map<dynamic, dynamic> json) {
    return new MaterialTypelist(
      MaterialId: json['MaterialId'],
      MaterialName: json['MaterialName'],
      MaterialDescription: json['MaterialDescription'],
      MaterialCode: json['MaterialCode'],
      MaterialUnitId: json['MaterialUnitId'],
      MaterialUnitName: json['MaterialUnitName'],
      MaterialUnitPrice: json['MaterialUnitPrice'],
      MaterialHSNCode: json['MaterialHSNCode'],
    );
  }

}




class PaymentType{
  int PaymentCategoryId;
  String PaymentCategoryName;

  PaymentType({this.PaymentCategoryId,this.PaymentCategoryName});


  factory PaymentType.fromJson(Map<dynamic, dynamic> json) {
    return new PaymentType(
      PaymentCategoryId: json['PaymentCategoryId'],
      PaymentCategoryName: json['PaymentCategoryName'],
    );
  }

}



class SaleDetails{
  int SaleId;
  int SaleNumber;
  int VehicleTypeId;
  int MaterialId;
  int PaymentCategoryId;
  int CustomerId;
  String VehicleNumber;
  String VehicleTypeName;
  String EmptyWeightOfVehicle;
  String MaterialName;
  String RequiredMaterialQty;
  String OutputMaterialQty;
  double Amount;
  double OutputQtyAmount;
  String LoadWeightOfVehicle;
  String PaymentCategoryName;
  String CustomerName;
  String SaleStatus;
  String SaleDate;
  String UnitName;

  SaleDetails({this.SaleId,this.SaleNumber,this.VehicleNumber,this.VehicleTypeId,
  this.VehicleTypeName,this.EmptyWeightOfVehicle,this.MaterialId,this.MaterialName,
 this.RequiredMaterialQty, this.LoadWeightOfVehicle,this.Amount,this.PaymentCategoryId,
  this.PaymentCategoryName,this.CustomerId,this.CustomerName,this.SaleStatus,
  this.SaleDate,this.UnitName,this.OutputMaterialQty,this.OutputQtyAmount});


  factory SaleDetails.fromJson(Map<dynamic, dynamic> json) {
    return new SaleDetails(
      SaleId: json['SaleId'],
      SaleNumber: json['SaleNumber'],
      VehicleNumber: json['VehicleNumber'],
      VehicleTypeId: json['VehicleTypeId'],
      VehicleTypeName: json['VehicleTypeName'],
      EmptyWeightOfVehicle: json['EmptyWeightOfVehicle'],
      MaterialId: json['MaterialId'],
      MaterialName: json['MaterialName'],
      RequiredMaterialQty: json['RequiredMaterialQty'],
      LoadWeightOfVehicle: json['LoadWeightOfVehicle'],
      Amount: json['RequiredQtyAmount'],
      PaymentCategoryId: json['PaymentCategoryId'],
      PaymentCategoryName: json['PaymentCategoryName'],
      CustomerId: json['CustomerId'],
      CustomerName: json['CustomerName'],
      SaleStatus: json['SaleStatus'],
      SaleDate: json['DateTime'],
      UnitName: json['UnitName'],
      OutputMaterialQty: json['OutputMaterialQty'],
      OutputQtyAmount: json['OutputQtyAmount'],

    );
  }

}




class TaxDetails{
  int TaxId;
  String TaxName;

  int MaterialTaxMappingId;
  int MaterialId;
  double MaterialTaxValue;
  int IsActive;

  TextEditingController taxValue;

  TaxDetails({this.TaxId,this.TaxName,this.MaterialTaxMappingId,this.MaterialTaxValue,this.IsActive,this.MaterialId,this.taxValue});


  factory TaxDetails.fromJson(Map<dynamic, dynamic> json) {
    return new TaxDetails(
      TaxId: json['TaxId'],
      TaxName: json['TaxName'],
    );
  }


  Map<dynamic,dynamic> toJson(){
    if(taxValue.text.isNotEmpty ){
      var map = <dynamic, dynamic>{
        'MaterialTaxMappingId': MaterialTaxMappingId,
        'MaterialId': MaterialId,
        'TaxId':TaxId,
        'MaterialTaxValue':taxValue.text.isNotEmpty?double.parse(taxValue.text):0,
        'IsActive':IsActive,
      };
      return map;
    }
    else{
      var map = <dynamic, dynamic>{
        'MaterialTaxMappingId': null,
        'MaterialId': null,
        'TaxId':null,
        'MaterialTaxValue':null,
        'IsActive':null,
      };
      return map;
    }
  }


}


class UnitDetails{
  int UnitId;
  String UnitName;

  UnitDetails({this.UnitId,this.UnitName});

  factory UnitDetails.fromJson(Map<dynamic, dynamic> json) {
    return new UnitDetails(
      UnitId: json['UnitId'],
      UnitName: json['UnitName'],
    );
  }
}