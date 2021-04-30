class DieselVehicleModel {
  DieselVehicleModel({
    this.vehicleId,
    this.vehicleNumber,
  });

  int vehicleId;
  String vehicleNumber;

  factory DieselVehicleModel.fromJson(Map<String, dynamic> json) => DieselVehicleModel(
    vehicleId: json["VehicleId"],
    vehicleNumber: json["VehicleNumber"],
  );

  Map<String, dynamic> toJson() => {
    "VehicleId": vehicleId,
    "VehicleNumber": vehicleNumber,
  };
}