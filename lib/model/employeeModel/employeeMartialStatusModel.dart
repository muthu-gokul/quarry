class EmployeeMartialStatusModel {
  EmployeeMartialStatusModel({
    this.employeeMartialStatusId,
    this.employeeMartialStatusName,
  });

  int employeeMartialStatusId;
  String employeeMartialStatusName;

  factory EmployeeMartialStatusModel.fromJson(Map<String, dynamic> json) => EmployeeMartialStatusModel(
    employeeMartialStatusId: json["EmployeeMaritalStatusId"],
    employeeMartialStatusName: json["EmployeeMaritalStatus"],
  );

  Map<String, dynamic> toGridJson() => {
    "EmployeeMaritalStatusId": employeeMartialStatusId,
    "EmployeeMaritalStatus": employeeMartialStatusName,
  };
  dynamic get(String propertyName) {
    var _mapRep = toGridJson();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('property not found');
  }

}