class EmployeeShiftModel {
  EmployeeShiftModel({
    this.employeeShiftId,
    this.employeeShiftName,
  });

  int employeeShiftId;
  String employeeShiftName;

  factory EmployeeShiftModel.fromJson(Map<String, dynamic> json) => EmployeeShiftModel(
    employeeShiftId: json["EmployeeShiftId"],
    employeeShiftName: json["EmployeeShiftName"],
  );

  Map<String, dynamic> toGridJson() => {
    "EmployeeShiftId": employeeShiftId,
    "EmployeeShiftName": employeeShiftName,
  };
  dynamic get(String propertyName) {
    var _mapRep = toGridJson();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('property not found');
  }

}