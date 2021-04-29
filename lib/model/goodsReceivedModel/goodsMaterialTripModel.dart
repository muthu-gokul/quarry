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

  int trip;
  String vehicleNumber;
  int materialId;
  String unitName;
  int receivedQuantity;
  int balanceQuantity;
  String status;

  factory GoodsMaterialTripDetailsModel.fromJson(Map<String, dynamic> json) => GoodsMaterialTripDetailsModel(
    trip: json["Trip"],
    vehicleNumber: json["VehicleNumber"],
    materialId: json["MaterialId"],
    unitName: json["UnitName"],
    receivedQuantity: json["ReceivedQuantity"],
    balanceQuantity: json["BalanceQuantity"],
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
