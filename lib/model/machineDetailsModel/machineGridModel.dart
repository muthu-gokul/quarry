class MachineGridModel{
  int machineId;
  String machineName;
  String machineType;
  String machineModel;
  String machineCapacity;
  String machineMotorPower;
  String machineWeight;
  int companyId;

  MachineGridModel({this.machineName, this.machineType, this.machineModel,
    this.machineCapacity, this.machineMotorPower, this.machineWeight,this.companyId,this.machineId});

  factory MachineGridModel.fromJson(Map<String, dynamic> json){
    return new MachineGridModel(
      machineId:json['MachineId'],
      machineName: json['MachineName'],
      machineType: json['MachineType'],
      machineModel: json['MachineModel'],
      machineCapacity: json['Capacity'],
      machineMotorPower: json['MotorPower'],
      machineWeight: json['MachineSpecification'],
      companyId: json['CompanyId'],
    );
  }

  Map<String, dynamic> toJson() => {
    "MachineId": machineId,
    "MachineName": machineName,
    "MachineType": machineType,
    "MachineModel": machineModel,
    "Capacity": machineCapacity,
    "MotorPower": machineMotorPower,
    "MachineSpecification": machineWeight,
    "CompanyId": companyId,
  };

  dynamic get(String propertyName) {
    var _mapRep = toJson();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('Property not found');
  }

}