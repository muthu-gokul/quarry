class VehicleGridModel{
  int VehicleId;
  String VehicleNo;
  String VehicleModel;
  int VehicleTypeId;
  String VehicleTypeName;

  String OwnerName;
  String TypeID;
  String RegNo;
  String EngineNo;
  String VehicleDescript;

  String EmptyWeight;


  VehicleGridModel({this.VehicleId,this.VehicleNo,this.VehicleModel,this.OwnerName,this.VehicleTypeId,this.TypeID,
    this.RegNo,this.EngineNo,this.VehicleDescript,this.EmptyWeight,this.VehicleTypeName});

  factory VehicleGridModel.fromJson(Map<String, dynamic> json){
    return new VehicleGridModel(

      VehicleId: json['VehicleId'],
      VehicleNo: json['VehicleNumber'],
      VehicleDescript: json['VehicleDescription'],
      VehicleTypeId: json['VehicleTypeId'],
      VehicleTypeName: json['VehicleTypeName'],
      VehicleModel: json['VehicleModel'],
      EmptyWeight: json['EmptyWeightOfVehicle'],
    );
  }
  Map<String, dynamic> toJson() => {
    "VehicleId": VehicleId,
    "VehicleNumber": VehicleNo,
    "VehicleDescription": VehicleDescript,
    "VehicleTypeId": VehicleTypeId,
    "VehicleTypeName": VehicleTypeName,
    "VehicleModel": VehicleModel,
    "EmptyWeightOfVehicle": "$EmptyWeight Ton",
  };

  dynamic get(String propertyName) {
    var _mapRep = toJson();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('property not found');
  }
}