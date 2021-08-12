class EmpLoanEmployeeModel {
  EmpLoanEmployeeModel({
    this.employeeId,
    this.employeePrefix,
    this.employeeCode,
    this.employeeName,
    this.employeeDesignationId,
    this.employeeDesignationName,
    this.workingDays,
    this.leaveDays,
    this.netPay,
  });

  int? employeeId;
  String? employeePrefix;
  String? employeeCode;
  String? employeeName;
  int? employeeDesignationId;
  String? employeeDesignationName;
  String? workingDays;
  String? leaveDays;
  double? netPay;

  factory EmpLoanEmployeeModel.fromJson(Map<String, dynamic> json) => EmpLoanEmployeeModel(
    employeeId: json["EmployeeId"],
    employeePrefix: json["EmployeePrefix"],
    employeeCode: json["EmployeeCode"],
    employeeName: json["EmployeeName"],
    employeeDesignationId: json["EmployeeDesignationId"],
    employeeDesignationName: json["EmployeeDesignationName"],
    workingDays: json["WorkingDays"],
    leaveDays: json["LeaveDays"],
    netPay: json["NetPay"],
  );

  Map<String, dynamic> toGridJson() => {
    "EmployeeId": employeeId,
    "EmployeePrefix": employeePrefix,
    "EmployeeCode": employeeCode,
    "EmployeeName": employeeName,
    "EmployeeDesignationId": employeeDesignationId,
    "EmployeeDesignationName": employeeDesignationName,
    "WorkingDays": workingDays,
    "LeaveDays": leaveDays,
    "NetPay": netPay,
  };

  dynamic get(String propertyName) {
    var _mapRep = toGridJson();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('property not found');
  }
}
