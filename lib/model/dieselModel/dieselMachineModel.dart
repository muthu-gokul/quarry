
class DieselMachineModel {
  DieselMachineModel({
    this.machineId,
    this.machineName,
  });

  int? machineId;
  String? machineName;

  factory DieselMachineModel.fromJson(Map<String, dynamic> json) => DieselMachineModel(
    machineId: json["MachineId"],
    machineName: json["MachineName"],
  );

  Map<String, dynamic> toJson() => {
    "MachineId": machineId,
    "MachineName": machineName,
  };
  dynamic get(String propertyName) {
    var _mapRep = toJson();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('property not found');
  }

}
