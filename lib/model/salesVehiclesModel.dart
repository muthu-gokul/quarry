class SalesVehiclesModel {
  SalesVehiclesModel({
    this.vehicleNumber,
  });

  String vehicleNumber;

  factory SalesVehiclesModel.fromJson(Map<String, dynamic> json) => SalesVehiclesModel(
    vehicleNumber: json["VehicleNumber"],
  );

  Map<String, dynamic> toJson() => {
    "VehicleNumber": vehicleNumber,
  };
}