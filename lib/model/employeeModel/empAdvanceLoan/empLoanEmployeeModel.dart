class EmpLoanEmployeeModel {
  EmpLoanEmployeeModel({
    this.employeeId,
    this.employeePrefix,
    this.employeeCode,
    this.employeeName,
  });

  int employeeId;
  String employeePrefix;
  String employeeCode;
  String employeeName;

  factory EmpLoanEmployeeModel.fromJson(Map<String, dynamic> json) => EmpLoanEmployeeModel(
    employeeId: json["EmployeeId"],
    employeePrefix: json["EmployeePrefix"],
    employeeCode: json["EmployeeCode"],
    employeeName: json["EmployeeName"],
  );

  Map<String, dynamic> toGridJson() => {
    "EmployeeId": employeeId,
    "EmployeePrefix": employeePrefix,
    "EmployeeCode": employeeCode,
    "EmployeeName": employeeName,
  };

  dynamic get(String propertyName) {
    var _mapRep = toGridJson();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('property not found');
  }
}
