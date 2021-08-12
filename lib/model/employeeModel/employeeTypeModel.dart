class EmployeeTypeModel {
  EmployeeTypeModel({
    this.employeeTypeId,
    this.employeeTypeName,
  });

  int? employeeTypeId;
  String? employeeTypeName;

  factory EmployeeTypeModel.fromJson(Map<String, dynamic> json) => EmployeeTypeModel(
    employeeTypeId: json["EmployeeTypeId"],
    employeeTypeName: json["EmployeeTypeName"],
  );

  Map<String, dynamic> toGridJson() => {
    "EmployeeTypeId": employeeTypeId,
    "EmployeeTypeName": employeeTypeName,
  };
  dynamic get(String propertyName) {
    var _mapRep = toGridJson();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('property not found');
  }

}