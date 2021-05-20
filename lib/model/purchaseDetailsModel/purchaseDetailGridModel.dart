class PurchaseOrderGridModel {
  PurchaseOrderGridModel({
    this.purchaseOrderId,
    this.expectedDate,
    this.purchaseOrderNumber,
    this.materialId,
    this.materialName,
    this.taxAmount,
    this.purchaseQuantity,
    this.netAmount,
    this.NoOfMaterial,
    this.TotalQuantity,
    this.Subtotal,
    this.supplierName,
    this.status,
  });

  int purchaseOrderId;
  DateTime expectedDate;
  int purchaseOrderNumber;
  int materialId;
  String materialName;
  String supplierName;
  String status;
  double taxAmount;
  double Subtotal;
  double purchaseQuantity;
  double netAmount;
  double TotalQuantity;
  int NoOfMaterial;

  factory PurchaseOrderGridModel.fromJson(Map<String, dynamic> json) => PurchaseOrderGridModel(
    purchaseOrderId: json["PurchaseOrderId"],
    expectedDate:json["ExpectedDate"]!=null? DateTime.parse(json["ExpectedDate"]):null,
    purchaseOrderNumber: json["PurchaseOrderNumber"],
    materialId: json["MaterialId"],
    materialName: json["MaterialName"],
    supplierName: json["SupplierName"],
    taxAmount: json["TaxAmount"],
    purchaseQuantity: json["PurchaseQuantity"],
    netAmount: json["NetAmount"],
    NoOfMaterial: json["NoOfMaterial"],
    TotalQuantity: json["TotalQuantity"],
    Subtotal: json["Subtotal"],
    status: json["Status"],
  );

  Map<String, dynamic> toJson() => {
    "PurchaseOrderId": purchaseOrderId,
    "ExpectedDate": expectedDate.toIso8601String(),
    "PurchaseOrderNumber": purchaseOrderNumber,
    "MaterialId": materialId,
    "MaterialName": materialName,
    "TaxAmount": taxAmount,
    "PurchaseQuantity": purchaseQuantity,
    "NetAmount": netAmount,
  };
}
