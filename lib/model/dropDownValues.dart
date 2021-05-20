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
  Map<String, dynamic> toJson() => {
    "VehicleTypeId": VehicleTypeId,
    "VehicleTypeName": VehicleTypeName,
  };
  dynamic get(String propertyName) {
    var _mapRep = toJson();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('property not found');
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
  double TaxValue;
  String MaterialHSNCode;

  MaterialTypelist({this.MaterialId,this.MaterialName,this.MaterialDescription,this.MaterialCode,this.MaterialUnitId,
 this.MaterialUnitPrice,this.MaterialHSNCode,this.MaterialUnitName,this.TaxValue});


  factory MaterialTypelist.fromJson(Map<dynamic, dynamic> json) {
    return new MaterialTypelist(
      MaterialId: json['MaterialId'],
      MaterialName: json['MaterialName'],
      MaterialDescription: json['MaterialDescription'],
      MaterialCode: json['MaterialCode'],
      MaterialUnitId: json['MaterialUnitId'],
      MaterialUnitName: json['UnitName'],
      MaterialUnitPrice: json['MaterialUnitPrice'],
      TaxValue: json['TaxValue'],
      MaterialHSNCode: json['MaterialHSNCode'],
    );
  }

  Map<String, dynamic> toJson() => {
    "MaterialId": MaterialId,
    "MaterialName": MaterialName,
  };
  dynamic get(String propertyName) {
    var _mapRep = toJson();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('property not found');
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
  Map<String, dynamic> toJson() => {
    "PaymentCategoryId": PaymentCategoryId,
    "PaymentCategoryName": PaymentCategoryName,
  };
  dynamic get(String propertyName) {
    var _mapRep = toJson();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('property not found');
  }
}

class CustomerModel {
  CustomerModel({
    this.customerId,
    this.customerName,
    this.isActive
  });

  int customerId;
  String customerName;
  bool isActive;

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
    customerId: json["CustomerId"],
    customerName: json["CustomerName"],
    isActive: true
  );

  Map<String, dynamic> toJson() => {
    "CustomerId": customerId,
    "CustomerName": customerName,
  };

  dynamic get(String propertyName) {
    var _mapRep = toJson();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('propery not found');
  }
}




class SaleDetails{
  int SaleId;
  String SaleNumber;
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
  double MaterialUnitPrice;
  double OutputQtyAmount;
  double TaxPercentage;
  double TaxAmount;
  double TotalAmount;
  int RoundedTotalAmount;
  double RoundOffAmount;
  String LoadWeightOfVehicle;
  String PaymentCategoryName;
  String CustomerName;
  String SaleStatus;
  String SaleDate;
  String UnitName;
  String AmountInWords;
  int isDiscount;
  int isPercentage;
  int isAmount;
  double discountValue;
  double discountAmount;
  double DiscountedOutputQtyAmount;
  double DiscountedRequiredQtyAmount;

  int customerId;
  String customerName;
  String customerAddress;
  String customerCity;
  String customerState;
  String customerCountry;
  String customerZipCode;
  String customerContactNumber;
  String customerEmail;
  String customerGstNumber;
  String driverName;
  String driverContactNumber;

  SaleDetails({this.SaleId,this.SaleNumber,this.VehicleNumber,this.VehicleTypeId,
  this.VehicleTypeName,this.EmptyWeightOfVehicle,this.MaterialId,this.MaterialName,
 this.RequiredMaterialQty, this.LoadWeightOfVehicle,this.Amount,this.PaymentCategoryId,this.MaterialUnitPrice,
  this.PaymentCategoryName,this.CustomerId,this.CustomerName,this.SaleStatus,this.AmountInWords,this.RoundOffAmount,
  this.SaleDate,this.UnitName,this.OutputMaterialQty,this.OutputQtyAmount,this.TaxPercentage,this.TaxAmount,this.TotalAmount,this.isDiscount,this.isAmount,this.isPercentage,
  this.discountAmount,this.discountValue,this.DiscountedOutputQtyAmount,this.DiscountedRequiredQtyAmount,
    this.customerId,
    this.customerName,
    this.customerAddress,
    this.customerCity,
    this.customerState,
    this.customerCountry,
    this.customerZipCode,
    this.customerContactNumber,
    this.customerEmail,
    this.customerGstNumber,
    this.driverName,
    this.driverContactNumber,
    this.RoundedTotalAmount
  });


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
      UnitName: json['UnitName'],
      MaterialUnitPrice: json['MaterialUnitPrice'],
      RequiredMaterialQty: json['RequiredMaterialQty'],
      Amount: json['RequiredQtyAmount'],


      isDiscount: json['IsDiscount'],
      isPercentage: json['IsPercentage'],
      isAmount: json['IsAmount'],
      discountValue: json['DiscountValue'],
      discountAmount: json['DiscountAmount'],
      DiscountedOutputQtyAmount: json['DiscountedOutputQtyAmount'],
      DiscountedRequiredQtyAmount: json['DiscountedRequiredQtyAmount'],



      LoadWeightOfVehicle: json['LoadWeightOfVehicle'],

      PaymentCategoryId: json['PaymentCategoryId'],
      PaymentCategoryName: json['PaymentCategoryName'],
      CustomerId: json['CustomerId'],
      CustomerName: json['CustomerName'],
      SaleStatus: json['SaleStatus'],
      SaleDate: json['SaleDate'],

      OutputMaterialQty: json['OutputMaterialQty'],
      OutputQtyAmount: json['OutputQtyAmount'],

      TaxPercentage: json['TaxValue'],
      TaxAmount: json['TaxAmount'],
      TotalAmount: json['TotalAmount'],
      RoundedTotalAmount: json['TotalAmount'].round(),
      AmountInWords: json['AmountInWords'],
      RoundOffAmount: json['RoundOffAmount'],
      customerId: json["CustomerId"],
      customerName: json["CustomerName"],
      customerAddress: json["CustomerAddress"],
      customerCity: json["CustomerCity"],
      customerState: json["CustomerState"],
      customerCountry: json["CustomerCountry"],
      customerZipCode: json["CustomerZipCode"],
      customerContactNumber: json["CustomerContactNumber"],
      customerEmail: json["CustomerEmail"],
      customerGstNumber: json["CustomerGSTNumber"],
      driverName: json["DriverName"],
      driverContactNumber: json["DriverContactNumber"],
    );
  }
  Map<String, dynamic> toJson() => {
    "SaleDate": SaleDate,
    "SaleNumber": SaleNumber,
    "VehicleNumber": VehicleNumber,
    "MaterialName": MaterialName,
    "RoundedTotalAmount": RoundedTotalAmount,
    "CustomerName": customerName,
  };
  dynamic get(String propertyName) {
    var _mapRep = toJson();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('property not found');
  }
}

class SaleGridReport{
  double Sale;
  double PSand;
  double MSand;
  int Open;
  int Closed;
  double PSandQuantity;
  double MSandQuantity;
  double TotalSaleQuantity;
  String PSandUnit;
  String MSandUnit;

  SaleGridReport({this.Sale,this.PSand,this.MSand,this.Open,this.Closed,this.PSandQuantity,this.MSandQuantity,this.TotalSaleQuantity,
  this.PSandUnit,this.MSandUnit});

  factory SaleGridReport.fromJson(Map<dynamic,dynamic> json){
    return new SaleGridReport(
      Sale: json['Sale'],
      PSand: json['P Sand'],
      MSand: json['M Sand'],
      Open: json['Open'],
      Closed: json['Closed'],
      PSandQuantity: json['P Sand Quantity'],
      MSandQuantity: json['M Sand Quantity'],
      TotalSaleQuantity: json['Total Sale Quantity'],
      PSandUnit: json['P Sand Unit'],
      MSandUnit: json['M Sand Unit'],
    );
  }


}


class SalePrintersList{
  String PrinterName;
  String PrinterTypeName;
  String PrinterIPAddress;
  String PrinterPortNumber;

  SalePrintersList({this.PrinterName,this.PrinterTypeName,this.PrinterIPAddress,this.PrinterPortNumber});

  factory SalePrintersList.fromJson(Map<dynamic,dynamic> json){
    return new SalePrintersList(
      PrinterName: json['PrinterName'],
      PrinterTypeName: json['PrinterTypeName'],
      PrinterIPAddress: json['PrinterIPAddress'],
      PrinterPortNumber: json['PrinterPortNumber'],
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