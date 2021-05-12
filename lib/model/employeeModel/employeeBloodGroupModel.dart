class EmployeeBloodGroupModel {
  EmployeeBloodGroupModel({
    this.employeeBloodGroupId,
    this.employeeBloodGroupName,
  });

  int employeeBloodGroupId;
  String employeeBloodGroupName;

  factory EmployeeBloodGroupModel.fromJson(Map<String, dynamic> json) => EmployeeBloodGroupModel(
    employeeBloodGroupId: json["EmployeeBloodGroupId"],
    employeeBloodGroupName: json["EmployeeBloodGroup"],
  );

  Map<String, dynamic> toGridJson() => {
    "EmployeeBloodGroupId": employeeBloodGroupId,
    "EmployeeBloodGroup": employeeBloodGroupName,
  };
  dynamic get(String propertyName) {
    var _mapRep = toGridJson();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('property not found');
  }

}