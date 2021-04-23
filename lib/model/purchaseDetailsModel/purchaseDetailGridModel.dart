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
  });

  int purchaseOrderId;
  DateTime expectedDate;
  int purchaseOrderNumber;
  int materialId;
  String materialName;
  double taxAmount;
  double purchaseQuantity;
  double netAmount;

  factory PurchaseOrderGridModel.fromJson(Map<String, dynamic> json) => PurchaseOrderGridModel(
    purchaseOrderId: json["PurchaseOrderId"],
    expectedDate: DateTime.parse(json["ExpectedDate"]),
    purchaseOrderNumber: json["PurchaseOrderNumber"],
    materialId: json["MaterialId"],
    materialName: json["MaterialName"],
    taxAmount: json["TaxAmount"],
    purchaseQuantity: json["PurchaseQuantity"],
    netAmount: json["NetAmount"],
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
