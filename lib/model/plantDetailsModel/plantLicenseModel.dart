import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PlantLicenseModel{
  PlantLicenseModel({
    this.plantId,
    this.plantLicenseId,
    this.licenseNumber,
    this.licenseDescription,
    this.fromDate,
    this.toDate,
    this.documentFileName,
    this.documentFolderName,
    this.scaleController,
    this.isEdit,
    this.isDelete
  });

  int? plantId;
  int? plantLicenseId;
  String? licenseNumber;
  String? licenseDescription;
  DateTime? fromDate;
  DateTime? toDate;
  String? documentFileName;
  String? documentFolderName;
  AnimationController? scaleController;
  bool? isEdit;
  bool? isDelete;

  factory PlantLicenseModel.fromJson(Map<String, dynamic> json,TickerProviderStateMixin tickerProviderStateMixin) => PlantLicenseModel(
    plantId: json["PlantId"],
    plantLicenseId: json["PlantLicenseId"],
    licenseNumber: json["LicenseNumber"],
    licenseDescription: json["LicenseDescription"],
    fromDate:json["FromDate"]!=null? DateFormat("yyyy-MM-dd").parse(json["FromDate"]):null,
    toDate: json["ToDate"]!=null?DateFormat("yyyy-MM-dd").parse(json["ToDate"]):null,
    documentFileName: json["DocumentFileName"],
    documentFolderName: json["DocumentFolderName"],
      scaleController: AnimationController(duration: Duration(milliseconds: 300,),vsync: tickerProviderStateMixin),
      isEdit: true,
      isDelete: false
  );

  Map<String, dynamic> toJson() => {
    "PlantId": plantId,
    "PlantLicenseId": plantLicenseId,
    "LicenseNumber": licenseNumber,
    "LicenseDescription": licenseDescription,
    "FromDate":fromDate!=null? DateFormat("yyyy-MM-dd").format(fromDate!):"",
    "ToDate": toDate != null? DateFormat("yyyy-MM-dd").format(toDate!):"",
    "DocumentFileName": documentFileName,
    "DocumentFolderName": documentFolderName,
    'IsActice':1
  };
}

