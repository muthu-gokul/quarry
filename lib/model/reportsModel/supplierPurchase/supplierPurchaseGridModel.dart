import 'package:intl/intl.dart';

class SupplierPurchaseReportGridModel {
  SupplierPurchaseReportGridModel({
    this.plantId,
    this.plantName,
    this.createdDate,
    this.purchaseOrderId,
    this.purchaseOrderNumber,
    this.materialId,
    this.materialName,
    this.purchaseQuantity,
    this.amount,
    this.supplier,
    this.supplierName,
    this.location,
    this.contactNumber,
  });

  int plantId;
  String plantName;
  DateTime createdDate;
  int purchaseOrderId;
  int purchaseOrderNumber;
  int materialId;
  String materialName;
  double purchaseQuantity;
  double amount;
  int supplier;
  String supplierName;
  String location;
  String contactNumber;

  factory SupplierPurchaseReportGridModel.fromJson(Map<String, dynamic> json) => SupplierPurchaseReportGridModel(
    plantId: json["PlantId"],
    plantName: json["PlantName"],
    createdDate: DateTime.parse(json["CreatedDate"]),
    purchaseOrderId: json["PurchaseOrderId"],
    purchaseOrderNumber: json["PurchaseOrderNumber"],
    materialId: json["MaterialId"],
    materialName: json["MaterialName"],
    purchaseQuantity: json["PurchaseQuantity"],
    amount: json["Amount"],
    supplier: json["Supplier"],
    supplierName: json["SupplierName"],
    location: json["Location"],
    contactNumber: json["ContactNumber"],
  );

  Map<String, dynamic> toGridJson() => {
    "Purchase Number": purchaseOrderNumber,
    "Date": createdDate!=null?DateFormat("dd-MM-yyyy").format(createdDate):" ",
    "Supplier Name": supplierName,
    "Location": location,
    "Contact Number": contactNumber,
    "Material Name": materialName,
    "Quantity": purchaseQuantity,
    "Amount": amount,
    "Plant Name": plantName,

  };
  dynamic get(String propertyName) {
    var _mapRep = toGridJson();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('property not found');
  }
}
