class MachineModel {
  MachineModel({
    this.machineId,
    this.machineName,
    this.isActive,
  });

  int machineId;
  String machineName;
  bool isActive;

  factory MachineModel.fromJson(Map<String, dynamic> json) => MachineModel(
    machineId: json["MachineId"],
    machineName: json["MachineName"],
      isActive:true
  );

  Map<String, dynamic> toGridJson() => {
    "MachineId": machineId,
    "MachineName": machineName,
  };

  dynamic get(String propertyName) {
    var _mapRep = toGridJson();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('property not found');
  }

}
