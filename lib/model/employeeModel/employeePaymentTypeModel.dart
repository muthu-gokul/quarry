class EmployeePaymentTypeModel {
  EmployeePaymentTypeModel({
    this.employeePaymentTypeId,
    this.employeePaymentTypeName,
  });

  int employeePaymentTypeId;
  String employeePaymentTypeName;

  factory EmployeePaymentTypeModel.fromJson(Map<String, dynamic> json) => EmployeePaymentTypeModel(
    employeePaymentTypeId: json["EmployeeSalaryModeId"],
    employeePaymentTypeName: json["EmployeeSalaryMode"],

  );

  Map<String, dynamic> toGridJson() => {
    "EmployeeSalaryModeId": employeePaymentTypeId,
    "EmployeeSalaryMode": employeePaymentTypeName,
  };
  dynamic get(String propertyName) {
    var _mapRep = toGridJson();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('property not found');
  }

}