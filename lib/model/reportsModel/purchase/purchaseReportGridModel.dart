import 'package:intl/intl.dart';

class PurchaseReportGridModel {
  PurchaseReportGridModel({
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

  factory PurchaseReportGridModel.fromJson(Map<String, dynamic> json) => PurchaseReportGridModel(
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
  );

  Map<String, dynamic> toGridJson() => {
    "Purchase Number": purchaseOrderNumber,
    "Date": createdDate!=null?DateFormat("dd-MM-yyyy").format(createdDate):" ",
    "Material":materialName,
    "Quantity": purchaseQuantity,
    "Amount": amount,
    "Supplier Name": supplierName,
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
