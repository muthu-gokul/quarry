class GoodsOutGateModel {
  GoodsOutGateModel({
    this.goodsReceivedId,
    this.purchaseOrderId,
    this.purchaseOrderNumber,
    this.materialId,
    this.materialName,
    this.unitName,
    this.expectedQuantity,
    this.receivedQuantity,
    this.amount,
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
  String unitName;
  double expectedQuantity;
  double receivedQuantity;
  double amount;
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
    unitName: json["UnitName"],
    expectedQuantity: json["ExpectedQuantity"].toDouble(),
    receivedQuantity: json["ReceivedQuantity"].toDouble(),
    amount: json["Amount"],
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
