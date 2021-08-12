class EmployeeDesignationModel {
  EmployeeDesignationModel({
    this.employeeDesginationId,
    this.employeeDesginationName,
  });

  int? employeeDesginationId;
  String? employeeDesginationName;

  factory EmployeeDesignationModel.fromJson(Map<String, dynamic> json) => EmployeeDesignationModel(
    employeeDesginationId: json["EmployeeDesignationId"],
    employeeDesginationName: json["EmployeeDesignationName"],
  );

  Map<String, dynamic> toGridJson() => {
    "EmployeeDesignationId": employeeDesginationId,
    "EmployeeDesignationName": employeeDesginationName,
  };

  dynamic get(String propertyName) {
    var _mapRep = toGridJson();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('property not found');
  }

}