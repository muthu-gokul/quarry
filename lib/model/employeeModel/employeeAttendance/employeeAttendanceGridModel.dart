class EmployeeAttendanceGridModel {
  EmployeeAttendanceGridModel({
    this.employeeId,
    this.employeePrefix,
    this.employeeCode,
    this.employeeName,
    this.employeeDesignationId,
    this.employeeDesignationName,
    this.employeeShiftId,
    this.employeeShiftName,
    this.employeeInTime,
    this.employeeOutTime,
    this.employeeOverTime,
    this.attendanceStatusId,
    this.employeeAttendanceDate,
    this.status,
    this. employeeAttendanceId,
  });

  int employeeId;
  String employeePrefix;
  String employeeCode;
  String employeeName;
  int employeeDesignationId;
  String employeeDesignationName;
  int employeeShiftId;
  String employeeShiftName;
  String employeeAttendanceDate;
  String employeeInTime;
  String employeeOutTime;
  String employeeOverTime;
  int attendanceStatusId;
  int  employeeAttendanceId;
  String status;

  factory EmployeeAttendanceGridModel.fromJson(Map<String, dynamic> json) => EmployeeAttendanceGridModel(
    employeeId: json["EmployeeId"],
    employeeAttendanceId: json["EmployeeAttendanceId"],
    employeePrefix: json["EmployeePrefix"],
    employeeCode: json["EmployeeCode"],
    employeeName: json["EmployeeName"],
    employeeDesignationId: json["EmployeeDesignationId"],
    employeeDesignationName: json["EmployeeDesignationName"],
    employeeShiftId: json["EmployeeShiftId"],
    employeeShiftName: json["EmployeeShiftName"],
    employeeAttendanceDate: json["EmployeeAttendanceDate"],
    employeeInTime: json["EmployeeInTime"],
    employeeOutTime: json["EmployeeOutTime"],
    employeeOverTime: json["EmployeeOverTime"],
    attendanceStatusId: json["AttendanceStatusId"],
    status: json["Status"],
  );

  Map<String, dynamic> toGridJson() => {

    "Employee Code": employeePrefix+employeeCode,
    "Name": employeeName,
    "Designation": employeeDesignationName,
    "Shift": employeeShiftName,
    "Date": employeeAttendanceDate,
    "In Time": employeeInTime,
    "Out Time": employeeOutTime,
    "Over Time": employeeOverTime,
    "Status": status,
  };
  dynamic get(String propertyName) {
    var _mapRep = toGridJson();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('property not found');
  }


}
