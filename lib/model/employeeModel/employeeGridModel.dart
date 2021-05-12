class EmployeeGridModel {
  EmployeeGridModel({
    this.employeeId,
    this.employeeName,
    this.employeeDesignationId,
    this.employeeDesignationName,
    this.phoneNumber,
    this.email,
    this.employeePrefix,
    this.employeeCode,
  });

  int employeeId;
  String employeeName;
  String employeePrefix;
  String employeeCode;
  int employeeDesignationId;
  String employeeDesignationName;
  String phoneNumber;
  String email;

  factory EmployeeGridModel.fromJson(Map<String, dynamic> json) => EmployeeGridModel(
    employeeId: json["EmployeeId"],
    employeeName: json["EmployeeName"],
    employeePrefix: json["EmployeePrefix"],
    employeeCode: json["EmployeeCode"],

    employeeDesignationId: json["EmployeeDesignationId"],
    employeeDesignationName: json["EmployeeDesignationName"],
    phoneNumber: json["PhoneNumber"],
    email: json["Email"],
  );

  Map<String, dynamic> toGridJson() => {
    "Employee Code": employeePrefix+employeeCode,
    "Name": employeeName,
    "EmployeeDesignationId": employeeDesignationId,
    "Designation": employeeDesignationName,
    "Phone Number": phoneNumber,
    "Email": email,
  };
  dynamic get(String propertyName) {
    var _mapRep = toGridJson();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('property not found $propertyName');
  }

}
