class EmployeeGridModel {
  EmployeeGridModel({
    this.employeeId,
    this.employeeName,
    this.employeeDesignationId,
    this.employeeDesignationName,
    this.phoneNumber,
    this.email,
  });

  int employeeId;
  String employeeName;
  int employeeDesignationId;
  String employeeDesignationName;
  String phoneNumber;
  String email;

  factory EmployeeGridModel.fromJson(Map<String, dynamic> json) => EmployeeGridModel(
    employeeId: json["EmployeeId"],
    employeeName: json["EmployeeName"],
    employeeDesignationId: json["EmployeeDesignationId"],
    employeeDesignationName: json["EmployeeDesignationName"],
    phoneNumber: json["PhoneNumber"],
    email: json["Email"],
  );

  Map<String, dynamic> toGridJson() => {
    "Employee Id": employeeId,
    "Employee Name": employeeName,
    "EmployeeDesignationId": employeeDesignationId,
    "Employee Designation": employeeDesignationName,
    "Phone Number": phoneNumber,
    "Email": email,
  };
  dynamic get(String propertyName) {
    var _mapRep = toGridJson();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('property not found');
  }

}
