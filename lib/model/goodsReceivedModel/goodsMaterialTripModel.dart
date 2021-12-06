class GoodsMaterialTripDetailsModel {
  GoodsMaterialTripDetailsModel({
    this.trip,
    this.vehicleNumber,
    this.materialId,
    this.unitName,
    this.receivedQuantity,
    this.balanceQuantity,
    this.status,
  });

  int? trip;
  String? vehicleNumber;
  int? materialId;
  String? unitName;
  double? receivedQuantity;
  double? balanceQuantity;
  String? status;

  factory GoodsMaterialTripDetailsModel.fromJson(Map<String, dynamic> json) => GoodsMaterialTripDetailsModel(
    trip: json["Trip"],
    vehicleNumber: json["VehicleNumber"],
    materialId: json["MaterialId"],
    unitName: json["UnitName"],
    receivedQuantity: json["ReceivedQuantity"].toDouble(),
    balanceQuantity: json["BalanceQuantity"].toDouble(),
    status: json["Status"],
  );

  Map<String, dynamic> toJson() => {
    "Trip": trip,
    "VehicleNumber": vehicleNumber,
    "MaterialId": materialId,
    "UnitName": unitName,
    "ReceivedQuantity": receivedQuantity,
    "BalanceQuantity": balanceQuantity,
    "Status": status,
  };
}




class GoodsMaterialExtraTripModel {
  GoodsMaterialExtraTripModel({
    this.purchaseOrderId,
    this.materialId,
    this.unitName,
    this.expectedQuantity,
    this.receivedQuantity,
    this.balanceQuantity,
    this.isExtra,
    this.Amount,
  });

  int? purchaseOrderId;
  int? materialId;
  String? unitName;
  double? expectedQuantity;
  double? receivedQuantity;
  double? balanceQuantity;
  double? Amount;
  int? isExtra;

  factory GoodsMaterialExtraTripModel.fromJson(Map<String, dynamic> json) => GoodsMaterialExtraTripModel(
    purchaseOrderId: json["PurchaseOrderId"],
    materialId: json["MaterialId"],
    unitName: json["UnitName"],
    expectedQuantity: json["ExpectedQuantity"].toDouble(),
    receivedQuantity: json["ReceivedQuantity"].toDouble(),
    balanceQuantity: json["BalanceQuantity"].toDouble(),
    Amount: json["Amount"].toDouble(),
    isExtra: json["IsExtra"],
  );

  Map<String, dynamic> toJson() => {
    "PurchaseOrderId": purchaseOrderId,
    "MaterialId": materialId,
    "UnitName": unitName,
    "ExpectedQuantity": expectedQuantity,
    "ReceivedQuantity": receivedQuantity,
    "BalanceQuantity": balanceQuantity,
    "IsExtra": isExtra,
  };
}

