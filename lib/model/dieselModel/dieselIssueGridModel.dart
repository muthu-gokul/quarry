import 'package:intl/intl.dart';

class DieselIssueGridModel {
  DieselIssueGridModel({
    this.issuedDate,
    this.plantId,
    this.plantName,
    this.machineId,
    this.machineName,
    this.dieselIssuedQuantity,
    this.machineFuelReadingQuantity,
    this.issuedBy,
    this.issuedName,
    this.dieselIssueId,
    this.Type,
  });

  DateTime? issuedDate;
  int? plantId;
  int? dieselIssueId;
  String? plantName;
  String? Type;
  int? machineId;
  String? machineName;
  double? dieselIssuedQuantity;
  double? machineFuelReadingQuantity;
  int? issuedBy;
  String? issuedName;

  factory DieselIssueGridModel.fromJson(Map<String, dynamic> json) => DieselIssueGridModel(
    issuedDate: DateTime.parse(json["IssuedDate"]),
    plantId: json["PlantId"],
    dieselIssueId: json["DieselIssueId"],
    plantName: json["PlantName"],
    Type: json["Type"],
    machineId: json["MachineId"],
    machineName: json["Machine/Vehicle"],
    dieselIssuedQuantity: json["DieselIssuedQuantity"],
    machineFuelReadingQuantity: json["MachineFuelReadingQuantity"],
    issuedBy: json["IssuedBy"],
    issuedName: json["IssuedName"],
  );

  Map<String, dynamic> toJson() => {
    "IssuedDate": issuedDate!.toIso8601String(),
    "PlantId": plantId,
    "PlantName": plantName,
    "MachineId": machineId,
    "MachineName": machineName,
    "DieselIssuedQuantity": dieselIssuedQuantity,
    "MachineFuelReadingQuantity": machineFuelReadingQuantity,
    "IssuedBy": issuedBy,
    "IssuedName": issuedName,
  };

  Map<String, dynamic> toGridJson() => {
    "Date": issuedDate!=null?DateFormat.yMMMd().format(issuedDate!):" ",
    "Machine/Vehicle": machineName,
    "Type": Type,
    "Diesel Quantity": dieselIssuedQuantity,
    "Fuel Reading": machineFuelReadingQuantity,
    "Issued By": issuedName,
  };

  dynamic get(String propertyName) {
    var _mapRep = toGridJson();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('property not found $propertyName}');
  }

}
