class GoodsOutGateModel {
  GoodsOutGateModel({
    this.goodsReceivedId,
    this.purchaseOrderId,
    this.purchaseOrderNumber,
    this.materialId,
    this.materialName,
    this.materialPrice,
    this.unitName,
    this.taxValue,
    this.taxAmount,
    this.expectedQuantity,
    this.receivedQuantity,
    this.amount,
    this.isDiscount,
    this.isPercentage,
    this.isAmount,
    this.discountValue,
    this.discountAmount,
    this.discountedSubtotal,
    this.grandTotal,
    this.vehicleTypeId,
    this.vehicleNumber,
    this.inwardLoadedVehicleWeight,
    this.outwardEmptyVehicleWeight,
    this.GoodsReceivedMaterialMappingId,
  });

  int GoodsReceivedMaterialMappingId;
  int goodsReceivedId;
  int purchaseOrderId;
  int purchaseOrderNumber;
  int materialId;
  String materialName;
  double materialPrice;
  String unitName;
  double taxValue;
  double taxAmount;
  double expectedQuantity;
  double receivedQuantity;
  double amount;
  int isDiscount;
  int isPercentage;
  int isAmount;
  double discountValue;
  double discountAmount;
  double discountedSubtotal;
  double grandTotal;
  int vehicleTypeId;
  String vehicleNumber;
  double inwardLoadedVehicleWeight;
  double outwardEmptyVehicleWeight;

  factory GoodsOutGateModel.fromJson(Map<String, dynamic> json) => GoodsOutGateModel(
    GoodsReceivedMaterialMappingId: json["GoodsReceivedMaterialMappingId"],
    goodsReceivedId: json["GoodsReceivedId"],
    purchaseOrderId: json["PurchaseOrderId"],
    purchaseOrderNumber: json["PurchaseOrderNumber"],
    materialId: json["MaterialId"],
    materialName: json["MaterialName"],
    materialPrice: json["MaterialPrice"],
    unitName: json["UnitName"],
    taxValue: json["TaxValue"],
    expectedQuantity: json["ExpectedQuantity"].toDouble(),
    receivedQuantity: json["ReceivedQuantity"].toDouble(),
    amount: json["Amount"],
    isDiscount: json["IsDiscount"],
    isPercentage: json["IsPercentage"],
    isAmount: json["IsAmount"],
    discountValue: json["DiscountValue"],
    discountAmount: json["DiscountAmount"],
    vehicleTypeId: json["VehicleTypeId"],
    vehicleNumber: json["VehicleNumber"],
    inwardLoadedVehicleWeight: json["InwardLoadedVehicleWeight"],
    outwardEmptyVehicleWeight: json["OutwardEmptyVehicleWeight"],
  );

  Map<String, dynamic> toJson() => {
    "GoodsReceivedId": goodsReceivedId,
    "PurchaseOrderId": purchaseOrderId,
    "PurchaseOrderNumber": purchaseOrderNumber,
    "MaterialId": materialId,
    "MaterialName": materialName,
    "UnitName": unitName,
    "ExpectedQuantity": expectedQuantity,
    "ReceivedQuantity": receivedQuantity,
    "Amount": amount,
    "VehicleTypeId": vehicleTypeId,
    "VehicleNumber": vehicleNumber,
    "InwardLoadedVehicleWeight": inwardLoadedVehicleWeight,
    "OutwardEmptyVehicleWeight": outwardEmptyVehicleWeight,
  };
}
