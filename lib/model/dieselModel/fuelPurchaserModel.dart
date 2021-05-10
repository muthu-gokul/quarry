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
  dynamic get(String propertyName) {
    var _mapRep = toJson();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('property not found');
  }

}