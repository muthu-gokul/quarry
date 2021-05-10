class ProductionMachineListModel{
  int machineId;
  String machineName;
  ProductionMachineListModel({this.machineId,this.machineName});

  factory ProductionMachineListModel.fromJson(Map<String, dynamic> json) => ProductionMachineListModel(
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