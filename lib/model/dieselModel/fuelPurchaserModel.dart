class FuelPurchaserModel {
  FuelPurchaserModel({
    this.employeeId,
    this.employeeName,
  });

  int employeeId;
  String employeeName;

  factory FuelPurchaserModel.fromJson(Map<String, dynamic> json) => FuelPurchaserModel(
    employeeId: json["EmployeeId"],
    employeeName: json["EmployeeName"],
  );

  Map<String, dynamic> toJson() => {
    "EmployeeId": employeeId,
    "EmployeeName": employeeName,
  };
}