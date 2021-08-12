class EmployeeSalaryTypeModel {
  EmployeeSalaryTypeModel({
    this.employeeSalaryTypeId,
    this.employeeSalaryTypeName,
  });

  int? employeeSalaryTypeId;
  String? employeeSalaryTypeName;

  factory EmployeeSalaryTypeModel.fromJson(Map<String, dynamic> json) => EmployeeSalaryTypeModel(
    employeeSalaryTypeId: json["EmployeeSalaryTypeId"],
    employeeSalaryTypeName: json["EmployeeSalaryTypeName"],
  );

  Map<String, dynamic> toGridJson() => {
    "EmployeeSalaryTypeId": employeeSalaryTypeId,
    "EmployeeSalaryTypeName": employeeSalaryTypeName,
  };
  dynamic get(String propertyName) {
    var _mapRep = toGridJson();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('property not found');
  }

}