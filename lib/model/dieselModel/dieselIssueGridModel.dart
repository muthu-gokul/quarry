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
    this.dieselIssueId
  });

  DateTime issuedDate;
  int plantId;
  int dieselIssueId;
  String plantName;
  int machineId;
  String machineName;
  double dieselIssuedQuantity;
  double machineFuelReadingQuantity;
  int issuedBy;
  String issuedName;

  factory DieselIssueGridModel.fromJson(Map<String, dynamic> json) => DieselIssueGridModel(
    issuedDate: DateTime.parse(json["IssuedDate"]),
    plantId: json["PlantId"],
    dieselIssueId: json["DieselIssueId"],
    plantName: json["PlantName"],
    machineId: json["MachineId"],
    machineName: json["MachineName"],
    dieselIssuedQuantity: json["DieselIssuedQuantity"],
    machineFuelReadingQuantity: json["MachineFuelReadingQuantity"],
    issuedBy: json["IssuedBy"],
    issuedName: json["IssuedName"],
  );

  Map<String, dynamic> toJson() => {
    "IssuedDate": issuedDate.toIso8601String(),
    "PlantId": plantId,
    "PlantName": plantName,
    "MachineId": machineId,
    "MachineName": machineName,
    "DieselIssuedQuantity": dieselIssuedQuantity,
    "MachineFuelReadingQuantity": machineFuelReadingQuantity,
    "IssuedBy": issuedBy,
    "IssuedName": issuedName,
  };
}
