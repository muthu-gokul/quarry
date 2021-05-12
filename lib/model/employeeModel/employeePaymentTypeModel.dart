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

  Map<String, dynamic> toJson() => {
    "EmployeeSalaryModeId": employeePaymentTypeId,
    "EmployeeSalaryMode": employeePaymentTypeName,
  };
}